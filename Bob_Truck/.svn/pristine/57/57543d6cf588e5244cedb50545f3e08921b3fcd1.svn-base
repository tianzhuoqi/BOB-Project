local FleetCombineMediator = class("FleetCombineMediator", MediatorDynamic)

function FleetCombineMediator:OnRegister()
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.selectIndexKey = "FleetCombineListCell"

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_CheckAll.gameObject)
    NLuaClickEvent:AddClick(self, self.CheckAll)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Confirm.gameObject)
    NLuaClickEvent:AddClick(self, self.CombineFleet)

    self:RegisterObserver(NotiConst.Notify_FleetCombineListCellChangeSelect, "ListCellChangeSelect")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MERGEFLEET), self.OnCombineFleet, self)
end

function FleetCombineMediator:InitData()
    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, {})
    self.totalCount = 0
    self.checkCount = 0
    self.maxCount = 0

    self.fleetProxy:SetCurrentOperation({totalCount = self.totalCount, maxCount = self.maxCount})

    self:UpdateView()
end

function FleetCombineMediator:CheckAll()
    local protFleetsData = self.fleetProxy:GetProtFleetsData()
    local len = #protFleetsData
    local selectIndex = {}
    self.totalCount = 0
    self.checkCount = 0
    self.maxCount = 0
    for i=1, len do
        local maxCount = self.maxCount
        if protFleetsData[i].maxShipCount > maxCount then
            maxCount = protFleetsData[i].maxShipCount
        end
        if (self.totalCount + protFleetsData[i].shipCount) <= maxCount then
            selectIndex[i] = true
            self.checkCount = self.checkCount + 1
            self.totalCount = self.totalCount + protFleetsData[i].shipCount
            self.maxCount = maxCount
        end
    end
    self.fleetProxy:SetCurrentOperation({totalCount = self.totalCount, maxCount = self.maxCount})
    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, selectIndex)

    self:UpdateView()

    Facade:SendNotification("FleetCombinePanelNotify", len)
end

function FleetCombineMediator:ListCellChangeSelect(notification)
    local data = notification:GetBody()

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    local type = 0
    if selectIndex[data.index] then
        selectIndex[data.index] = false
    else
        selectIndex[data.index] = true
        type = 1
    end

    if type == 1 then
        local maxCount = self.maxCount
        if data.data.maxShipCount > self.maxCount then
            self.maxCount = data.data.maxShipCount
        end

        local sumCount = self.totalCount + data.data.shipCount
        if sumCount > self.maxCount then
            self.maxCount = maxCount
            selectIndex[data.index] = false
            return
        end 

        self.totalCount = self.totalCount + data.data.shipCount
        self.checkCount = self.checkCount + 1
    else
        local protFleetsData = self.fleetProxy:GetProtFleetsData()
        local maxCount = 0
        local totalCount = self.totalCount - data.data.shipCount
        for k, v in pairs(protFleetsData) do
            if v.maxShipCount > maxCount then
                maxCount = v.maxShipCount
            end
        end

        if totalCount > maxCount then
            selectIndex[data.index] = true
            return
        end

        self.totalCount = self.totalCount - data.data.shipCount
        self.checkCount = self.checkCount - 1
    end

    self.fleetProxy:SetCurrentOperation({totalCount = self.totalCount, maxCount = self.maxCount})

    self:UpdateView()

    local protFleetsData = self.fleetProxy:GetProtFleetsData()
    Facade:SendNotification("FleetCombinePanelNotify", #protFleetsData)
end

function FleetCombineMediator:UpdateView()
    self.m_viewComponent.uiBinder.m_Des.text = string.format("已选择 %d队", self.checkCount)
end

function FleetCombineMediator:CombineFleet()
    if self.checkCount == 0 then
        LogDebug("CombineFleet checkCount is 0")
    else
        local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
        local protFleetsData = self.fleetProxy:GetProtFleetsData()
        local TCSMergeFleet = buildingPort_pb.TCSMergeFleet()
        local curBuilding = planetaryProxy:GetCurBuildingOper()
        TCSMergeFleet.nodeId = curBuilding.nodeId
        local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
        for k, v in pairs(selectIndex) do
            if v then
                table.insert(TCSMergeFleet.fleetIds, protFleetsData[k].fleetId)
            end
        end
	    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.MERGEFLEET, TCSMergeFleet:SerializeToString())
    end
end

function FleetCombineMediator:OnCombineFleet(btsData)
    if btsData == nil then 
        LogDebug("FleetCombineMediator:OnCombineFleet btsData==nil")
        return
    end

    local TSCMergeFleet = buildingPort_pb.TSCMergeFleet()
    TSCMergeFleet:MergeFromString(btsData)
    if TSCMergeFleet.result then
        Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
        Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtShipsData)

        Facade:BackPanel()
    else
        LogError("FleetCombineMediator:OnCombineFleet Failed")
    end
end

return FleetCombineMediator