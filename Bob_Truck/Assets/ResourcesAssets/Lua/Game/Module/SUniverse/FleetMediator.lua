local FleetMediator = class("FleetMediator", MediatorDynamic)

function FleetMediator:ctor(mediatorName) 
    FleetMediator.super.ctor(self, mediatorName)
end

function FleetMediator:OnRegister()
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.allFleetList = {}
end

function FleetMediator:UpdateListData()
    self.allFleetList = self.fleetProxy:GetFleetListInfoData()
    Facade:SendNotification("FleetAllListNotify",#self.allFleetList)
end

function FleetMediator:UpdateList()
    self:UpdateListData()
    self.m_viewComponent:ScrollReset()
end

function FleetMediator:RequestList()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETLIST), self.OnRequestList, self)
    local TCSFleetList = scene_pb.TCSFleetList()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.FLEETLIST, TCSFleetList:SerializeToString())
end

function FleetMediator:OnRequestList(btsData)
    if btsData then
        local data = scene_pb.TSCFleetList()
        data:MergeFromString(btsData)
        self.fleetProxy:SetFleetListInfoData(data.fleetInfo)
        self:UpdateList()
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETLIST), self.OnRequestList)
end

return FleetMediator