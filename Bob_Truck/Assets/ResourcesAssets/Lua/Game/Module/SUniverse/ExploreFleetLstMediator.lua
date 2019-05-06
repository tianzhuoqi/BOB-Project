local ExploreFleetLstMediator = class("ExploreFleetLstMediator", MediatorDynamic)


function ExploreFleetLstMediator:OnRegister()
    self:RegisterObserver(NotiConst.Notify_ExploreFleetLstInit,"FleetLstInit")
    self.listData = {}
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
end

function ExploreFleetLstMediator:FleetLstInit( notify )
    local body = notify:GetBody()
    self.operType = body
    self.listData = self.fleetProxy:GetFleetListInfoData()
end

return ExploreFleetLstMediator