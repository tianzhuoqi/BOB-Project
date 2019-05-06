require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local UpgradeConditionListCell = register("SkillTreeUpgradeConditionListCell", ListCell)
local universeProxy = Facade:RetrieveProxy(NotiConst.Package_Universe)
local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

function UpgradeConditionListCell:Awake(gameObject)
    UpgradeConditionListCell.super.Awake(self, gameObject)

    self.n_Label_Info = self:FindComponent("n_Label_Info", "UILabel")
    self.n_Button_Ok = self:FindComponent("GameObject_State/n_Button_Ok", "UIButton")
    self.n_Button_Add = self:FindComponent("GameObject_State/n_Button_Add", "UIButton")
    self.n_Button_Accelerate = self:FindComponent("GameObject_State/n_Button_Accelerate", "UIButton")

end

function UpgradeConditionListCell:DrawCell(index)
    self.dataIndex = index + 1
   
    local condition = planetaryProxy:GetCurrentTechUpgradeCondition()[self.dataIndex]
    local conditionType = condition.type
    local conditionData = condition.data
    local userDataProxy = Facade:RetrieveProxy(NotiConst.Package_UserData)
    local playerInfo = userDataProxy:GetPlayerInfo()

    self.n_Button_Ok.gameObject:SetActive(false)
    self.n_Button_Add.gameObject:SetActive(false)
    self.n_Button_Accelerate.gameObject:SetActive(false)
    local str = ""
    local isUnlock = true
    if conditionType == 1 then
        local configData = planetaryProxy:GetSkillTreeItemInConfig(conditionData)
        local name = configData.data[configData.EVar["tech_name_s"]]
       -- local level = configData.data[configData.EVar["bldg_tech_lvl_n"]]
        str = GetLanguageText("SkillTree", "STPreSkill",name)
        local isUnlocked = planetaryProxy:IsTechUnlocked(conditionData)
        if not isUnlocked then
            str = string.format( "[fd3030]%s",str)
            isUnlock = false
        end
    elseif conditionType == 2 then
        local conditionItemId = conditionData[1]
        local conditionItemCount = conditionData[2]
        local itemName = storehouseProxy:GetItemBaseData(conditionItemId)
        itemName = itemName == nil and "" or itemName
        local nodeId = universeProxy:GetMainBaseNode()
        local item = storehouseProxy:GetItem(nodeId,conditionItemId)
        local num = 0
        if item ~= nil then
            num = item.num
        end
        str = string.format("%s:%d/%d",itemName,num,conditionItemCount)
        if num < conditionItemCount then
            str = string.format( "[fd3030]%s",str)
            isUnlock = false
        end
    elseif conditionType == 3 then
        local techPoint = playerInfo.techPoint
        str = GetLanguageText("SkillTree", "STMoney02",techPoint,conditionData)
        if techPoint < conditionData then
            str = string.format( "[fd3030]%s",str)
            isUnlock = false
        end
    elseif conditionType == 4 then
        local starDust = playerInfo.starDust 
        str = GetLanguageText("SkillTree", "STMoney01",starDust,conditionData)
        if starDust < conditionData then
            str = string.format( "[fd3030]%s",str)
            isUnlock = false
        end
    elseif conditionType == 5 then
        local userLevel = playerInfo.level
        str = GetLanguageText("SkillTree", "STReqNum",userLevel,conditionData)
        if userLevel < conditionData then
            str = string.format( "[fd3030]%s",str)
            isUnlock = false
        end
    end
    self.n_Label_Info.text = str  
    if isUnlock == false then
        planetaryProxy:SetCurrentTechCanUpgrade(false)
    end  
   
end


return UpgradeConditionListCell