local BuildingDismantleMediator = class("BuildingDismantleMediator", MediatorDynamic)

function BuildingDismantleMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnDismantle.gameObject)
    NLuaClickEvent:AddClick(self, self.Dismantle)

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REMOVEBUILDING), self.OnDismantle, self)
end

function BuildingDismantleMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()

    local from = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local funcType = from.data[from.EVar["bldg_func_type_n"]]
    
    local name = from.data[from.EVar["bldg_name_s"]]
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = string.format("[%s] Demolition", from.data[from.EVar["bldg_name_s"]])
    self.m_viewComponent.uiBinder.m_Label_UpInquiry.text = string.format("Do you want to dismantle the %s?", name)

    local fromLevel = from.data[from.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_Label_BuildNumL.text = string.format("Lv.%d", fromLevel)

    local discount = from.data[from.EVar["refund_pct_n"]]
    self.m_viewComponent.uiBinder.m_Label_Discount.text = string.format("%d%% (discount)", discount)

    local timeCost = 0
    local resCost = {}
    for i=1,fromLevel do
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
        if itemConfigData ~= nil then
            count = count + 1
            local view = self.View[count]
            view.DzName.gameObject:SetActive(true)
            local name_s = itemConfigData.relation["name_s"]
            view.DzName.text = itemConfigData.data[itemConfigData.EVar[name_s]]..":"
            view.Num.text = v*discount*0.01
        end
    end

    count = count + 1
    for i = count,5 do
        self.View[i].DzName.gameObject:SetActive(false)
    end
end

function BuildingDismantleMediator:Close()
    Facade:BackPanel()
end

--拆除建筑
function BuildingDismantleMediator:Dismantle()
    local TCSRemoveBuilding = building_pb.TCSRemoveBuilding()
    TCSRemoveBuilding.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.REMOVEBUILDING, TCSRemoveBuilding:SerializeToString())
end

function BuildingDismantleMediator:OnDismantle(btsData)
    if btsData == nil then 
        LogDebug("BuildingDismantleMediator:OnDismantle btsData==nil")
        return
    end

    local TSCRemoveBuilding = building_pb.TSCRemoveBuilding()
    TSCRemoveBuilding:MergeFromString(btsData)
    if TSCRemoveBuilding.result then
        Facade:SendNotification(NotiConst.Notify_BuildingDismantle, TSCRemoveBuilding.buildingId)
        self:Close()
    else
        LogError("TSCBuildingLevelUp:OnDismantle Failed")
    end
end

return BuildingDismantleMediator