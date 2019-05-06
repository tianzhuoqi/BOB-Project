require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")
local ListItem = register("SkillTreeListCellItem", ListCell)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
function ListItem:OnClick()
    if self.techId ~= nil and self.level < self.maxLevel then
        if self.unlockData == nil or (self.unlockData ~= nil and self.unlockData.techStatus == 0) then
            Facade:SendNotification("ListItemChangeSelect", {
                gameObject = self.cellGo,
                cellIndex = self.cellIndex,
                index = self.dataIndex,
            })
            self:UpdateSubView()
        end
    end
end

function ListItem:Awake(gameObject)
    ListItem.super.Awake(self, gameObject)

    self.n_main = self:FindGameObject("n_main")
    self.n_Sprite_Icon = self:FindComponent("n_main/n_Sprite_Icon", "UITexture")
    self.n_Label_Level = self:FindComponent("n_main/n_Label_Level", "UILabel")
    self.n_Label_Name = self:FindComponent("n_main/n_Label_Name", "UILabel")
    self.n_Sprite_Ing = self:FindComponent("n_main/n_Sprite_Ing", "UISprite")
    self.n_timelabel = self:FindComponent("n_main/n_timelabel","UILabel")

    local cellTransform = gameObject.transform.parent
    self.cellGo = cellTransform.gameObject
    self.arrow = cellTransform:Find("SubView/n_Arrow").gameObject
    self.n_Label_CurrentLv = cellTransform:Find("SubView/GameObject_Level/GameObject_Property/n_Label_current"):GetComponent("UILabel")
    self.n_Label_NextLv = cellTransform:Find("SubView/GameObject_Level/GameObject_Property/n_Label_Next"):GetComponent("UILabel")
    local buttonObj = cellTransform:Find("SubView/n_Button_Up").gameObject
    local luaClickEvent = NLuaClickEvent.Get(buttonObj)
    luaClickEvent:AddClick(self,self.OnClickUpgradeCallback)
    buttonObj = cellTransform:Find("SubView/n_Button_Info").gameObject
    luaClickEvent = NLuaClickEvent.Get(buttonObj)
    luaClickEvent:AddClick(self,self.OnClickOpenDetailViewCallback)
    self.unlockData = nil
end

function ListItem:DrawCell(index, cellIndex, itemsCount)
    self.index = index
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.techId = planetaryProxy:GetShowSkillTreeItemIdByIndex(self.dataIndex)
    self:StopAllCoroutines()
    if self.techId == nil then
        self.n_main:SetActive(false)
    else
        self.n_main:SetActive(true)
        local data = planetaryProxy:GetUnlockSkillTreeItemData(self.techId)
        self.unlockData  = data
        if data ~= nil then
            self.techId = self.unlockData.techId
        end
        local techInfo = planetaryProxy:GetSkillTreeItemInConfig(self.techId)
        self:ShowItemInfo(techInfo)
    end

end

function ListItem:ShowItemInfo(techInfo)
    local data = techInfo.data
    local evar = techInfo.EVar
    local name = GetLanguageText("SkillTree",data[evar["tech_name_s"]])
    local iconName = data[evar["icon_name_s"]]

    self.level = 0
    if self.unlockData ~= nil then
        if self.unlockData.techStatus == 0 then
            self.level = self.techId % 100
            self.n_Sprite_Ing.gameObject:SetActive(false)
            self.n_timelabel.gameObject:SetActive(false)
        else
            self.level = self.techId % 100 - 1
            self.n_Sprite_Ing.gameObject:SetActive(true)
            self.n_timelabel.gameObject:SetActive(true)
            self:StartCoroutine(self.UpdateTime,self,self.unlockData.endTime)
        end
    else
        self.n_timelabel.gameObject:SetActive(false)
        self.n_Sprite_Ing.gameObject:SetActive(false)
    end
    self.maxLevel = planetaryProxy:GetSkillMaxLevelInConfig(self.techId)
    local str = ""
    if self.level < self.maxLevel and self:IsUnlock() then
        str = string.format("[53ff8c]%d/%d",self.level,self.maxLevel)
    else
        str = string.format("[806356]%d/%d",self.level,self.maxLevel)
    end
    self.n_Label_Level.text = str
    self.n_Label_Name.text = tostring(name)
    self.n_Sprite_Icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(iconName)
end

function ListItem:UpdateTime(self,endTime)
    while true do
        local serverTime = GetServerTimeStamp()
        local time = math.max(math.floor(endTime / 1000 - serverTime),0)
        self.n_timelabel.text = SecondToMinutes(time)
        if time <= 0 then
            break
        end
        coroutine.wait(1)
    end
end

function ListItem:IsUnlock()
    local prerequisiteIds = nil
    if self.level == 0 then
        prerequisiteIds = planetaryProxy:GetPrerequisiteTechIds(self.techId)
    end
    if prerequisiteIds ~= nil then
        for i,v in ipairs(prerequisiteIds) do
            local techItem  = planetaryProxy:GetUnlockSkillTreeItemData(v)
            if techItem == nil then
                return false
            else
                local currentLevel = techItem.techId % 100
                if currentLevel  <= 1 and techItem.techStatus == 1 then
                    return false
                end
            end
        end
    end
    return true
end

--显示二级菜单，升级界面
function ListItem:UpdateSubView()
    GameObjectUtil.SetLocalPosition(self.arrow, -200 + self.index*100, -18, 0)
    local techConfigInfo = planetaryProxy:GetSkillTreeItemInConfig(self.techId)
    local unlockData = planetaryProxy:GetUnlockSkillTreeItemData(self.techId)
    local configData = techConfigInfo.data
    local evar = techConfigInfo.EVar

    planetaryProxy:SetCurrentSelectTechId(self.techId)   

    local paramStr
    local nextTechId
    
    if self.level <= 0 then              --表中没有0级的数据，0级时取得是1级的数据，techid也是1级的id
        nextTechId = self.techId
        nexConfigData = configData
        paramStr = GetLanguageText("SkillTree","STProperty0")
    else
        paramStr = planetaryProxy:GetTechParamString(configData,evar,GetItemTypeByID(self.techId))
        nextTechId = math.floor(self.techId/100) * 100 + self.level + 1
        nexConfigData = planetaryProxy:GetSkillTreeItemInConfig(nextTechId).data
    end

    local nextParamStr = planetaryProxy:GetTechParamString(nexConfigData,evar,GetItemTypeByID(nextTechId))
   
    self.n_Label_CurrentLv.text = paramStr
    self.n_Label_NextLv.text = nextParamStr

    self.conditionCount = self:SaveTechUpgradeConditions(nextTechId,self.level)

    self:StopAllCoroutines()
    self:StartCoroutine(self.DelaySendMessage)
end

function ListItem:DelaySendMessage()
    coroutine.wait(0.2)
    Facade:SendNotification("ShowUpgradeCondition",self.conditionCount)
end

--保存升级条件
function ListItem:SaveTechUpgradeConditions(techId,level)
    local prerequisiteIds = nil
    if level <= 0 then
        prerequisiteIds = planetaryProxy:GetPrerequisiteTechIds(techId)
    end
    local costItems = planetaryProxy:GetUpgradeCostItems(techId)
    local conditions = {}
    --type = 1:前置科技要求 2：消耗物品要求 3：科技点消耗要求 4：星辰消耗要求 5：等级要求
    if prerequisiteIds ~= nil then
        for i,v in ipairs(prerequisiteIds) do
            local item = {}
            item.type = 1   
            item.data = v
            table.insert(conditions,item)
        end
    end
    if costItems ~= nil then
        for i,v in ipairs(costItems) do
            if v ~= nil and #v > 0 then
                local item = {}
                item.type = 2
                item.data = v
                table.insert(conditions,item )
            end
        end
    end
    local configData = planetaryProxy:GetSkillTreeItemInConfig(techId)
    if configData ~= nil then
        local userLevelCondition = configData.data[configData.EVar["user_lvl_req_n"]]
        table.insert(conditions,{type = 5,data = userLevelCondition})
        local starDustCondition = configData.data[configData.EVar["sd_cost_n"]]
        table.insert(conditions,{type = 4,data = starDustCondition})
        local techPointCondition = configData.data[configData.EVar["tp_cost_n"]]
        table.insert(conditions,{type = 3,data = techPointCondition})
    end
    planetaryProxy:SetCurrentTechUpgradeCondition(conditions)
    planetaryProxy:SetCurrentTechCanUpgrade(true)
    return #conditions
end

--升级 
function ListItem:OnClickUpgradeCallback()
    local isCanUpgrade = planetaryProxy:GetCurrentTechCanUpgrade()
    if not isCanUpgrade then
        local str = GetLanguageText("SkillTree", "STFail")
        OpenMessageBox(NotiConst.MessageBoxType.Tip,str)
        return
    end
    local TCSTechLevelUp = buildingTech_pb.TCSTechLevelUp()
    TCSTechLevelUp.techId = 0
    TCSTechLevelUp.techId = planetaryProxy:GetCurrentSelectTechId()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.TECHLEVELUP, TCSTechLevelUp:SerializeToString())
    
end

--技能详情 
function ListItem:OnClickOpenDetailViewCallback()
    Facade:SendNotification("OpenTechDetailView")
end
return ListItem