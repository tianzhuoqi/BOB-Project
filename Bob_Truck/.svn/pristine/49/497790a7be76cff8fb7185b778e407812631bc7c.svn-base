local BuildingUpgradeMediator = class("BuildingUpgradeMediator", MediatorDynamic)

function BuildingUpgradeMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnUpgrade.gameObject)
    NLuaClickEvent:AddClick(self, self.Upgrade)

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.BUILDINGLEVELUP), self.OnUpgrade, self)
end

function BuildingUpgradeMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()

    local from = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local funcType = from.data[from.EVar["bldg_func_type_n"]]
    local fromLevel = from.data[from.EVar["bldg_lvl_n"]]
    local to = self.planetaryProxy:GetMaxBuildingConifData(funcType, fromLevel)
    if to.data == nil then
        to = from
    end
    self.toConfigId = to.configId

    local name = from.data[from.EVar["bldg_name_s"]]
    local actualName = self.planetaryProxy:GetBuildingActualNameByName(name)
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = string.format("%s", actualName)
    self.m_viewComponent.uiBinder.m_Label_upgrade.text = StringFormat(self.m_viewComponent.uiBinder.m_Label_upgrade.text, fromLevel)

    local toLevel = to.data[to.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_Label_UpInquiry.text = StringFormat(self.m_viewComponent.uiBinder.m_Label_UpInquiry.text, toLevel)

    self.m_viewComponent.uiBinder.m_Label_BuildNumL.text = string.format("Lv.%d", fromLevel)
    self.m_viewComponent.uiBinder.m_Label_BuildNumR.text = string.format("Lv.%d", toLevel)

    local timeCost = 0
    local resCost = {}
    for i=fromLevel+1,toLevel do
        local configData = self.planetaryProxy:GetBuildingConfigDataByLevel(funcType, i)
        timeCost = timeCost + configData.data[configData.EVar["time_cost_n"]]

        local cost_table = configData.data[configData.EVar["cost_table_repeated5"]]
        for i,v in ipairs(cost_table) do
            local itemId = v[1]
            if itemId ~= nil and itemId > 0 then
                if resCost[itemId] == nil then
                    resCost[itemId] = v[2]
                else
                    resCost[itemId] = resCost[itemId] + v[2]
                end
            end
        end
    end

    self.m_viewComponent.uiBinder.m_Label_Timer.text = SecondFormat(timeCost)

    self.View = {}
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName01, Num = self.m_viewComponent.uiBinder.m_Label_Num01})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName02, Num = self.m_viewComponent.uiBinder.m_Label_Num02})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName03, Num = self.m_viewComponent.uiBinder.m_Label_Num03})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName04, Num = self.m_viewComponent.uiBinder.m_Label_Num04})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName05, Num = self.m_viewComponent.uiBinder.m_Label_Num05})

    local nodeId = self.planetaryProxy:GetPlanetaryId()
    local count = 0
    for i,v in pairs(resCost) do
        local itemConfigData = self.storehouseProxy:GetItemConfigData(i)
        if itemConfigData ~= nil and v>0 then
            count = count + 1
            local view = self.View[count]
            view.DzName.gameObject:SetActive(true)
            local name_s = itemConfigData.relation["name_s"]
            local resName = itemConfigData.data[itemConfigData.EVar[name_s]]
            local itemData = self.storehouseProxy:GetItem(nodeId, i)
            -- 如果资源不足，标红
            if itemData == nil or itemData.num < v then
                self.planetaryProxy:SetLabelColor(view.DzName, true)
                self.planetaryProxy:SetLabelColor(view.Num, true)
            else
                self.planetaryProxy:SetLabelColor(view.DzName, false)
                self.planetaryProxy:SetLabelColor(view.Num, false)
            end
            view.DzName.text = GetLanguageText("ItemName", resName)
            if itemData then
                view.Num.text = StringFormat(GetLanguageText("Upgrade", "UpCosumeN"), AddUnit(v), AddUnit(itemData.num))
            else 
                view.Num.text = StringFormat(GetLanguageText("Upgrade", "UpCosumeN"), AddUnit(v), 0)
            end
            
        end
    end

    count = count + 1
    for i = count,5 do
        self.View[i].DzName.gameObject:SetActive(false)
    end

    if self.buildingGo ~= nil then
        self.buildingGo:Destroy()
        self.buildingGo = nil
    end

    if self.buildingGoUp ~= nil then
        self.buildingGoUp:Destroy()
        self.buildingGoUp = nil
    end

    self.m_viewComponent.uiBinder.m_BuildingCamera.targetTexture:Release()
    self.m_viewComponent.uiBinder.m_BuildingCameraUp.targetTexture:Release()

    local pathName = 'ModelFBX/Solarsystem/Buildings/'

    pathName = pathName..DATA_BUILDING[self.curBuilding.configId][DATA_BUILDING.EVar['prefab_name_s']]..'.prefab'

    local buildingPrefab = ManagerResourceModule.LuaLoadBundle(pathName)
    self.buildingGo = UnityEngine.GameObject.Instantiate(buildingPrefab)
    self.buildingGo.transform.parent = self.m_viewComponent.uiBinder.m_ModelPos.transform
    NGameObjectUtil.SetLocalPosition(self.buildingGo, 0, 0, 0)
    NGameObjectUtil.SetLocalRotation(self.buildingGo, 0, -135, 0)

    local BuildLevel = self.planetaryProxy:GetBuildingLevel(self.curBuilding.configId)
    local nextConfigId = self.curBuilding.configId
    if BuildLevel + 1 <= DATA_BUILDING[self.curBuilding.configId][DATA_BUILDING.EVar['max_bldg_lvl_n']] then
        nextConfigId = nextConfigId + 1
    end

    pathName = 'ModelFBX/Solarsystem/Buildings/'
    
    pathName = pathName..DATA_BUILDING[nextConfigId][DATA_BUILDING.EVar['prefab_name_s']]..'.prefab'

    local buildingPrefabUp = ManagerResourceModule.LuaLoadBundle(pathName)
    self.buildingGoUp = UnityEngine.GameObject.Instantiate(buildingPrefab)
    self.buildingGoUp.transform.parent = self.m_viewComponent.uiBinder.m_ModelPosUp.transform
    NGameObjectUtil.SetLocalPosition(self.buildingGoUp, 0, 0, 0)
    NGameObjectUtil.SetLocalRotation(self.buildingGoUp, 0, -135, 0)

    local type = self.planetaryProxy:GetBuildingType(self.curBuilding.configId)
    self:SetUpgradeEffectsData(from,to, type)
    Facade:SendNotification("BuildingUpgradeListRefresh",#self.upgradeEffects)
end

-- 建筑升级需要显示属性的变化
-- 属性分为通用属性(baseKey)和特有属性()分别进行加载
function BuildingUpgradeMediator:SetUpgradeEffectsData(from,to, buildingType)

    local list = {}

    local buildingName = from.data[from.EVar["bldg_name_s"]]

    local tableName = to.data[to.EVar["bldg_func_table_name_s"]]
    local attributeTable = _G["DATA_" .. tableName]

    if attributeTable ~= nil then
        local levelFrom = from.data[from.EVar["bldg_lvl_n"]]
        local levelTo = to.data[to.EVar["bldg_lvl_n"]]
        for key, val in pairs(attributeTable.EVar) do
            local tempList = {
                oldValue = attributeTable[levelFrom][val],
                newValue = attributeTable[levelTo][val],
            }
            if tempList.newValue - tempList.oldValue ~= 0 then
                local CNKey = self.planetaryProxy:GetCNKey(key)
                tempList.infoTitleStr = GetLanguageText("BuildingAttribute", CNKey.keyV)
                tempList.infoValueStr = GetLanguageText("BuildingAttribute", CNKey.keyN)
                table.insert(list, tempList)
            end
            
        end
    end

    
    self.upgradeEffects = list
end

function BuildingUpgradeMediator:Close()
    Facade:BackPanel()
end

--升级建筑
function BuildingUpgradeMediator:Upgrade()
    local isCanUpgrade = self.planetaryProxy:IsBuildingUnlockedByTech(self.toConfigId)
    if isCanUpgrade == false then
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"相关科技等级不足")
        return
    end
    local TCSBuildingLevelUp = building_pb.TCSBuildingLevelUp()
    TCSBuildingLevelUp.buildingId = self.curBuilding.targetBuilding
    TCSBuildingLevelUp.temporary = 0
    TCSBuildingLevelUp.buildingConfigId = self.toConfigId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.BUILDINGLEVELUP, TCSBuildingLevelUp:SerializeToString())
end

function BuildingUpgradeMediator:OnUpgrade(btsData)
    if btsData == nil then 
        LogDebug("BuildingUpgradeMediator:OnUpgrade btsData==nil")
        return
    end

    local TSCBuildingLevelUp = building_pb.TSCBuildingLevelUp()
    TSCBuildingLevelUp:MergeFromString(btsData)
    if TSCBuildingLevelUp.result then
        Facade:SendNotification(NotiConst.Notify_BuildingUpgrade, TSCBuildingLevelUp.building)
        --更新仓库数据
        self.storehouseProxy:UseItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCBuildingLevelUp.items)
        self:Close()
    else
        LogError("TSCBuildingLevelUp:OnUpgrade Failed")
    end
end

return BuildingUpgradeMediator