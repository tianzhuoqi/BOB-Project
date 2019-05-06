local UserDataProxy = class("UserDataProxy",Proxy)
local math_floor = math.floor

function UserDataProxy:OnRegister()
    --添加测试物品
    self:ModifyBagItemCount(11010001, 1)
    self:ModifyBagItemCount(11020001, 1)
end

function UserDataProxy:OnRemove()

end

function UserDataProxy:SetUserDataLogin(userDataLogin)
    --self.m_data.userName = userDataLogin.userName
    self.m_data.uid = userDataLogin.uid
end

function UserDataProxy:SetUserData(userData)
    self:AddOwnedGalaxyId(userData.nodeId)
    self:SavePlayerInfo(userData.playerInfo)
end

function UserDataProxy:GetUserId()
    return self.m_data.uid
end

--通知刷新显示个人信息UIPlayerResourcePanel 的UI
function UserDataProxy:SendNotificationUpdatePlayerInfo()
    Facade:SendNotification("UpdatePlayerInfo")
end

--个人信息保存读取操作
function UserDataProxy:SavePlayerInfo(playerInfo)
    local playerInfoData = {
        name = playerInfo.name,
        level = playerInfo.level,
        starDust = playerInfo.starDust,
        techPoint = playerInfo.techPoint,
    }
    self.m_data.playerInfo = playerInfoData
    self:SendNotificationUpdatePlayerInfo()
end

function UserDataProxy:GetPlayerInfo()
    return self.m_data.playerInfo
end

--玩家等级
function UserDataProxy:SetUserLevel(level)
    self.m_data.playerInfo.level = level
end

function UserDataProxy:GetUserLevel()
    return self.m_data.playerInfo.level
end

--科技点的保存读取操作
function UserDataProxy:SetTechPoint(techPoint)
    self.m_data.playerInfo.techPoint = techPoint
end

function UserDataProxy:GetTechPoint()
    return self.m_data.playerInfo.techPoint
end

--星尘
function UserDataProxy:SetStarDust(starDust)
    self.m_data.playerInfo.starDust = starDust 
end

function UserDataProxy:GetStarDust()
    return self.m_data.playerInfo.starDust
end

function UserDataProxy:GetOwnedGalaxyIds()
    return self.m_data.ownedGalaxyIds
end

function UserDataProxy:AddOwnedGalaxyId(addGalaxyId)
    local p = table.indexOf(self.m_data.ownedGalaxyIds, addGalaxyId)
    if not p then
        table.insert(self.m_data.ownedGalaxyIds, addGalaxyId)
    end
end

function UserDataProxy:RemoveOwnedGalaxyId(removeGalaxyId)
    local p = table.indexOf(self.m_data.ownedGalaxyIds, removeGalaxyId)
    if p then
        table.remove(self.m_data.ownedGalaxyIds,p)
    end
end

function UserDataProxy:AddExploredGalaxyId(addGalaxyId)
    local p = table.indexOf(self.m_data.exploredGalaxyIds, addGalaxyId)
    if not p then
        table.insert(self.m_data.exploredGalaxyIds, addGalaxyId)
    end
end

function UserDataProxy:RemoveExploredGalaxyId(removeGalaxyId)
    local p = table.indexOf(self.m_data.exploredGalaxyIds, removeGalaxyId)
    if p then
        table.remove(self.m_data.exploredGalaxyIds,p)
    end
end

function UserDataProxy:GetMainBaseGalaxyId()
    if #self.m_data.ownedGalaxyIds < 1 then 
        return 0
    end
    return self.m_data.ownedGalaxyIds[1]
end

--背包操作
function UserDataProxy:ModifyBagItemCount(id, num)
    local items = self.m_data.Items
    local nPreNum = items[id]
    if nPreNum == nil then 
        nPreNum = 0
    end
    items[id] = math_floor(nPreNum + num)
    if items[id] < 0 then 
        items[id] = 0
    end
    if nPreNum == 0 and items[id] > 0 then 
        self:OnAddNewItem(id)
    elseif nPreNum > 0 and items[id] <= 0 then 
        self:OnDeleteItem(id)
    end
end
--某id数量
function UserDataProxy:GetBagItemCount(id)
    local nPreNum = self.m_data.Items[id]
    if nPreNum == nil then
        return 0
    end
    return nPreNum
end

function UserDataProxy:GetItemTypeList(itype)
    return self.m_data.ItemByType[itype]
end

function UserDataProxy:GetItemTypeListCount(itype)
    if nil ==  self.m_data.ItemByType[itype] then 
        return 0
    end
    return #self.m_data.ItemByType[itype]
end

--新增某个id的物品,在这分类存储
function UserDataProxy:OnAddNewItem(id)
    local itype = GetItemTypeByID(id)
    if itype < 1 then 
        return 
    end
    local lstType = self.m_data.ItemByType[itype]
    if lstType == nil then 
        self.m_data.ItemByType[itype] = {}
        lstType = self.m_data.ItemByType[itype]
    end
    table.insert(lstType, id)
end
--删除某个id的物品
function UserDataProxy:OnDeleteItem(id)
    local itype = GetItemTypeByID(id)
    if itype < 1 then 
        return 
    end
    local lstType = self.m_data.ItemByType[itype]
    if lstType == nil then 
        return
    end
    for i=1, #lstType do 
        if lstType[i] == id then 
            table.remove(lstType, i)
            break
        end
    end
end
-------------------------------------------------
---新增舰船模板
function UserDataProxy:PbToStruct(pb_Mod)
    local mod = {}
    mod.id = pb_Mod.id
    mod.techID = pb_Mod.techID
    mod.hullParts = {}
    local pn = #pb_Mod.hullParts
    for i=1, pn do 
        local hpart = {}
        local pbhpart = pb_Mod.hullParts[i]
        hpart.hullId = pbhpart.hullId
        hpart.attachIndex = pbhpart.attachIndex
        hpart.attachPart = pbhpart.attachPart
        table.insert(mod.hullParts, hpart)
    end
    local cn = #pb_Mod.cpntMats
    mod.cpntMats = {}
    for i=1, cn do 
        mod.cpntMats[i] = pb_Mod.cpntMats[i]
    end
    return mod
end

function UserDataProxy:AddHullMod(pb_Mod)
    local lst = self.m_data.ownedModList
    local mod = self:PbToStruct(pb_Mod)
    table.insert(lst, mod)

end

function UserDataProxy:ModifyHullMod(pb_Mod)
    local id = pb_Mod.id
    local mod = self:PbToStruct(pb_Mod)
    local lst = self.m_data.ownedModList
    local n = #lst
    for i=1, n do 
        if lst[i].id == id then 
            lst[i] = mod
            break
        end
    end
end

function UserDataProxy:GetHullModByIndex(idx)
    local lst = self.m_data.ownedModList
    if idx > #lst then
        return nil
    end
    return lst[idx]
end

function UserDataProxy:GetHullMod(id)
    local lst = self.m_data.ownedModList
    local n = #lst
    for i=1, n do 
        if lst[i].id == id then 
            return lst[i]
        end
    end
    return nil
end

function UserDataProxy:RmvHullMod(id)
    local lst = self.m_data.ownedModList
    local n = #lst
    for i=1, n do 
        if lst[i].id == id then 
            table.remove(lst, i)
            return true
        end
    end
    return false
end

--模板数量
function  UserDataProxy:GetHullModListCount()
    return #self.m_data.ownedModList
end


--地图标记信息
function UserDataProxy:SetMapMarkList(markList)
    self.m_data.mapMarkList = markList
end

function UserDataProxy:GetMapMarkList()
    return self.m_data.mapMarkList
end

function UserDataProxy:HasMarked(nodeId)
    local list = self:GetMapMarkList()
    local index = 0
    for i,v in ipairs(list) do
        if v.nodeId == nodeId then
            index = i
            break 
        end
    end
    return (index > 0)
end

function UserDataProxy:GetMapMarkListItem(nodeId)
    local list = self:GetMapMarkList()
    local index = 0
    for i,v in ipairs(list) do
        if v.nodeId == nodeId then
            return v
        end
    end
    return nil
end

function UserDataProxy:AddMapMarkItem(itemData)
    local list = self:GetMapMarkList()
    local index = 0
    for i,v in ipairs(list) do
        if v.nodeId == itemData.nodeId then
            index = i
            break 
        end
    end
    if index > 0 then
        list[index] = itemData
    else
        table.insert(list,itemData)
    end
end

function UserDataProxy:SetRewardTimeLeft(timeData, rewardCount)
    self.m_data.rewardTimeLeft.timeLeft = timeData
    self.m_data.rewardTimeLeft.curTime = GetServerTimeStamp()
    if rewardCount ~= nil then
        self.m_data.rewardTimeLeft.rewardCount = rewardCount
    end
end

function UserDataProxy:GetRewardTimeLeft()
    return self.m_data.rewardTimeLeft
end

function UserDataProxy:RemoveMapMarkItem(nodeId)
    local list = self:GetMapMarkList()
    local index = 0
    for i,v in ipairs(list) do
        if v.nodeId == nodeId then
            index = i
            break 
        end
    end
    if index > 0 then
        table.remove( list, index)
    end
end
return UserDataProxy