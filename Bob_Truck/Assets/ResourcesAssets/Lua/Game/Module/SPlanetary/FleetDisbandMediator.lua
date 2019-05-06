local FleetDisbandMediator = class("FleetDisbandMediator", MediatorDynamic)

function FleetDisbandMediator:OnRegister()
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.selectIndexKey = "FleetDisbandListCell"

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Cancel.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_CheckAll.gameObject)
    NLuaClickEvent:AddClick(self, self.CheckAll)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Confirm.gameObject)
    NLuaClickEvent:AddClick(self, self.DisbandFleet)

    self:RegisterObserver(NotiConst.Notify_FleetDisbandListCellChangeSelect, "ListCellChangeSelect")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.DISMISSFLEET), self.OnDisbandFleet, self)
end

function FleetDisbandMediator:InitData()
    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, {})
    self.checkCount = 0

    self:UpdateView()
end

function FleetDisbandMediator:Close()
    Facade:BackPanel()
end

function FleetDisbandMediator:CheckAll()
    local protFleetsData = self.fleetProxy:GetProtFleetsData()
    local len = #protFleetsData
    local selectIndex = {}
    for i=1, len do
        selectIndex[i] = true
    end
    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, selectIndex)
    self.checkCount = len

    self:UpdateView()
    Facade:SendNotification("FleetDisbandPanelNotify", len)
end

function FleetDisbandMediator:ListCellChangeSelect(notification)
    LogDebug("FleetDisbandMediator:ListCellChangeSelect notification:{0}", notification)
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
        self.checkCount = self.checkCount + 1
    else
        self.checkCount = self.checkCount - 1
    end

    self:UpdateView()

    local protFleetsData = self.fleetProxy:GetProtFleetsData()
    Facade:SendNotification("FleetDisbandPanelNotify", #protFleetsData)
end

function FleetDisbandMediator:UpdateView()
    self.m_viewComponent.uiBinder.m_Des.text = string.format("已选择 %d队", self.checkCount)
end

function FleetDisbandMediator:DisbandFleet()
    if self.checkCount == 0 then
        LogDebug("DisbandFleet checkCount is 0")
    else
        local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
        local protFleetsData = self.fleetProxy:GetProtFleetsData()
        local TCSDismissFleet = buildingPort_pb.TCSDismissFleet()
        local curBuilding = planetaryProxy:GetCurBuildingOper()
        TCSDismissFleet.buildingId = curBuilding.targetBuilding
        TCSDismissFleet.nodeId = curBuilding.nodeId
        local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
        self.needDismissIds = {}
        for k, v in pairs(selectIndex) do
            if v then
                table.insert(TCSDismissFleet.fleetIds, protFleetsData[k].fleetId)
                table.insert(self.needDismissIds, protFleetsData[k].fleetId)
            end
        end
        if #TCSDismissFleet.fleetIds == 0 then
            LogDebug("DisbandFleet checkCount is 0")
        else
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.DISMISSFLEET, TCSDismissFleet:SerializeToString())
        end
    end
end

function FleetDisbandMediator:OnDisbandFleet(btsData)
    if btsData == nil then 
        LogDebug("FleetDisbandMediator:OnDisbandFleet btsData==nil")
        return
    end

    local TSCDismissFleet = buildingPort_pb.TSCDismissFleet()
    TSCDismissFleet:MergeFromString(btsData)
    if TSCDismissFleet.result then
        Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
        if self.needDismissIds then
            self.fleetProxy:RemoveFleetsData(self.needDismissIds)
            for i,id in ipairs(self.needDismissIds) do
                self.fleetProxy:RemoveFleetListInfoData(id)
            end
        end
        self:Close()
    else
        LogError("FleetDisbandMediator:OnDisbandFleet Failed")
    end
end

return FleetDisbandMediator