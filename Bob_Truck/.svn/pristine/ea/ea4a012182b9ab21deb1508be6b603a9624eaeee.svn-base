local BuildingCancelMediator = class("BuildingCancelMediator", MediatorDynamic)

function BuildingCancelMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnCancel.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELBUILDING), self.OnCancel, self)
end

function BuildingCancelMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()

    local from = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local funcType = from.data[from.EVar["bldg_func_type_n"]]
    local fromLevel = from.data[from.EVar["bldg_lvl_n"]]

    local to = self.planetaryProxy:GetMaxBuildingConifData(funcType, fromLevel)
    if to.data == nil then
        to = from
    end
    
    local buildingData = self.planetaryProxy:GetBuildingDataById(self.curBuilding.targetBuilding)
    local buildingTransTableName = from.data[from.EVar["transl_table_name_s"]]
    local buildingCNName = GetLanguageText(buildingTransTableName, from.data[from.EVar["bldg_name_s"]])
    if buildingData.status == common_pb.CREATE then
        to = from
        fromLevel = 0
        self.m_viewComponent.uiBinder.m_Label_TitleKey.text = StringFormat(GetLanguageText("BuildingCancel", "BCTitle1"), buildingCNName)
        self.m_viewComponent.uiBinder.m_Label_UpInquiry.text = StringFormat(GetLanguageText("BuildingCancel", "BCVerify1"), buildingCNName)
    else
        self.m_viewComponent.uiBinder.m_Label_TitleKey.text = StringFormat(GetLanguageText("BuildingCancel", "BCTitle2"), buildingCNName)
        self.m_viewComponent.uiBinder.m_Label_UpInquiry.text = StringFormat(GetLanguageText("BuildingCancel", "BCVerify2"), buildingCNName)
    end


    local toLevel = to.data[to.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_Label_BuildNumL.text = StringFormat(self.m_viewComponent.uiBinder.m_Label_BuildNumL.text, fromLevel)
    --self.m_viewComponent.uiBinder.m_Label_BuildNumL.text = string.format("Lv.%d", fromLevel)

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

    self.m_viewComponent.uiBinder.m_Label_Timer.text = timeCost

    self.View = {}
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName01, Num = self.m_viewComponent.uiBinder.m_Label_Num01})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName02, Num = self.m_viewComponent.uiBinder.m_Label_Num02})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName03, Num = self.m_viewComponent.uiBinder.m_Label_Num03})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName04, Num = self.m_viewComponent.uiBinder.m_Label_Num04})
    table.insert(self.View, { DzName = self.m_viewComponent.uiBinder.m_Label_DzName05, Num = self.m_viewComponent.uiBinder.m_Label_Num05})


    local count = 0
    for i,v in pairs(resCost) do
        local itemConfigData = self.storehouseProxy:GetItemConfigData(i)
        local transTableName = itemConfigData.data[itemConfigData.EVar["transl_table_name_s"]]
        if itemConfigData ~= nil then
            count = count + 1
            local view = self.View[count]
            view.DzName.gameObject:SetActive(true)
            local name_s = itemConfigData.relation["name_s"]
            view.DzName.text = GetLanguageText(transTableName, itemConfigData.data[itemConfigData.EVar[name_s]]) .. ":"
            view.Num.text = v
        end
    end

    count = count + 1
    for i = count,5 do
        self.View[i].DzName.gameObject:SetActive(false)
    end
end

function BuildingCancelMediator:Close()
    Facade:BackPanel()
end

--取消建筑创建、升级
function BuildingCancelMediator:Cancel()
    local TCSCancelBuilding = building_pb.TCSCancelBuilding()
    TCSCancelBuilding.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CANCELBUILDING, TCSCancelBuilding:SerializeToString())
end

function BuildingCancelMediator:OnCancel(btsData)
    if btsData == nil then 
        LogDebug("BuildingCancelMediator:OnCancel btsData==nil")
        return
    end

    local TSCCancelBuilding = building_pb.TSCCancelBuilding()
    TSCCancelBuilding:MergeFromString(btsData)
    if TSCCancelBuilding.result then
        Facade:SendNotification(NotiConst.Notify_BuildingCancel, {building = TSCCancelBuilding.building, type = TSCCancelBuilding.type})
        --更新仓库数据
        self.storehouseProxy:AddItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCCancelBuilding.items)
        self:Close()
    else
        LogError("BuildingCancelMediator:OnCancel Failed")
    end
end

return BuildingCancelMediator