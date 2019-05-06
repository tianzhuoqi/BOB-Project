local IntroCondition = require("Core/IntroCondition")

local IntroShowType = {
    ForceHand = 1,                  --强引导手
    ForceHandTextLeft = 2,          --强引导手+文本
    ForceHandTextRight = 3,         --强引导手+文本
    ForceText = 4,                  --强引导全屏文本
    ForcePicture = 5,               --强引导只有图片的引导
    WeakHand = 11,                  --弱引导手
    ForceVirtual = 12,              --无行的手!!!
    ForceVirtualHand = 13,           --无形的手+手的表现 （游戏内)
}

local ManagerIntro = class("ManagerIntro")

function ManagerIntro:ctor()
    self.serverIntroData = nil
    self.loadedServerIntroData = false
    self.willIntroId = nil
    self.completedMap = {}
    self.introCondition = IntroCondition.Instance()

    self.guideMap = {}
    self:LoadGuideData()
end

function ManagerIntro.Instance()
	if ManagerIntro.m_instance == nil then
		ManagerIntro.m_instance = ManagerIntro.New()
	end
	return ManagerIntro.m_instance
end

function ManagerIntro:InitServerData(userGuide)
    self.serverIntroData = userGuide
    self:Decompress(self.serverIntroData)
    self.loadedServerIntroData = true
end

--加载新手引导数据
function ManagerIntro:LoadGuideData()
    local evar = DATA_GUIDE.EVar
    for i,v in pairs(DATA_GUIDE) do
        if type(i) == "number" then
            v.id = i
            
            local condition = v[evar["condition_s"]]
            local temp = string.split(condition, ";")
            for ii,vv in ipairs(temp) do
                if vv ~= "" then
                    if v.conditionData == nil then
                        v.conditionData = {}
                    end

                    local condition = string.split(vv, "#")
                    table.insert(v.conditionData, condition)
                end
            end

            v.offsetX = 0
            v.offsetY = 0
            v.mirror = 0

            local handParam = v[evar["hand_param_s"]]
            if handParam ~= "" then
                local temp = string.split(handParam, "#")
                if temp[1] then
                    v.offsetX = tonumber(temp[1])
                end
                if temp[2] then
                    v.offsetY = tonumber(temp[2])
                end
                if temp[3] then
                    v.mirror = tonumber(temp[3])
                end
            end

            local point = v[evar["intro_point_n"]]
            local list = self:GetGuideDataByPoint(point)
            table.insert(list, v)
        end
    end
end

function ManagerIntro:GetGuideDataById(introId)
    return {data = DATA_GUIDE[introId], EVar = DATA_GUIDE.EVar} 
end

function ManagerIntro:GetGuideDataByPoint(point)
    local list = self.guideMap[point]
    if list == nil then
        self.guideMap[point] = {}
    end
    return self.guideMap[point]
end

function ManagerIntro:GetGuideData()
    return self.guideMap
end

--解析数据
function ManagerIntro:Decompress(userGuide)
    if userGuide == nil or userGuide == "" then
        return
    end

    local introItems = string.split(userGuide, "#")
    for i,v in ipairs(introItems) do
        local introId = tonumber(v)
        if introId ~= nil then
            self:CompleteIntro(introId)
        end
    end
end

--压缩引导数据
function ManagerIntro:Compress()
    local result = ""
    for i,v in pairs(self.completedMap) do
        result = result.."#"..i
    end
    return result
end

--触发引导
function ManagerIntro:TriggerIntro()
    if self:IgnoreIntro() then
        return
    end

    for i,v in pairs(self.guideMap) do
        for ii,vv in pairs(v) do
            if self:IntroIsShowCondition(vv.id) then
                self:WillIntro(vv.id)
                local notification = NotiConst.Utility_IntroWidget..i
                LogDebug("TriggerIntro SendNotification {0} introId:{1}", notification, vv.id)
                Facade:SendNotification(notification, vv.id)
                break
            end
        end
    end
end

--是否忽略引导
function ManagerIntro:IgnoreIntro()
    if not self.loadedServerIntroData then
        return false
    end
    return false
end

--将要执行的引导
function ManagerIntro:WillIntro(introId)
    self.willIntroId = introId
end

--完成引导
function ManagerIntro:CompleteIntro(introId)
    self.completedMap[introId] = true
    self.willIntroId = nil

    local introInfo = self:GetGuideDataById(introId)
    if introInfo.data ~= nil then
        local completeIds = introInfo.data[introInfo.EVar["complete_ids_s"]]
        if completeIds ~= "" then
            local introItems = string.split(completeIds, "#")
            for i,v in ipairs(introItems) do
                local tempId = tonumber(v)
                if tempId ~= nil then
                    self.completedMap[tempId] = true
                end
            end

            local TCSGuide = login_pb.TCSGuide()
            TCSGuide.guide = self:Compress()
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GUIDE, TCSGuide:SerializeToString())
        end
    end

    self:TriggerIntro()
end

--取消完成
function ManagerIntro:UnCompleteIntro(introId)
    self.completedMap[introId] = false
end

--是否完成
function ManagerIntro:IsCompleted(introId)
    if self.completedMap[introId] then
        return true
    end
    return false
end

--是否满足显示条件
function ManagerIntro:IntroIsShowCondition(introId)
    if self.willIntroId ~= nil and self.willIntroId == introId then
        return false
    end

    local introInfo = self:GetGuideDataById(introId)
    if introInfo.data == nil then
        return false
    end

    --条件：已经完成
    if self:IsCompleted(introId) then
        return false
    end

    --条件：前置条件未完成
    local prevId = introInfo.data[introInfo.EVar["prev_id_n"]]
    if prevId > 0 and (not self:IsCompleted(prevId)) then
        return false
    end

    --条件：不在当前界面
    local pageName = introInfo.data[introInfo.EVar["page_name_s"]]
    local curPanelName = Facade:TopPanelName()
    if pageName ~= "" and pageName ~= curPanelName then
        return false
    end

    --条件：不满足定制的条件
    if introInfo.data.conditionData ~= nil then
        local result = true
        for i,v in pairs(introInfo.data.conditionData) do
            if not self.introCondition:CheckCondition(introId, v) then
                result = false
                break
            end
        end
        if not result then
            return false
        end
    end

    return true
end

return ManagerIntro