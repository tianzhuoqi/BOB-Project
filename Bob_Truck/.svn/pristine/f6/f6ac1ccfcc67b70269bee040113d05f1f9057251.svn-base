local MarkListMediator = class("MarkListMediator", MediatorDynamic)

function MarkListMediator:OnRegister()
    self.targetPosition = {0,0}
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    self.view = self:GetViewComponent()
    self.markListData = {}
    self:RegisterObserver(NotiConst.Notify_MapMarkListChanged, "UpdateListData")
    self:RegisterObserver(NotiConst.Notify_MapMarkListSelected, "ChooseMarkPos")
end


function MarkListMediator:UpdateListData()
    self.markListData = self.userDataProxy:GetMapMarkList()
    Facade:SendNotification("MarkListNotify",#self.markListData)
end

function MarkListMediator:UpdateMarkList()
    self:UpdateListData()
    self.markListData = self.userDataProxy:GetMapMarkList()

end

function MarkListMediator:ChooseMarkPos(notify)
    if Facade:TopPanelName() == "MarkListPanel" then
        local id = notify:GetBody()
        local node = self.universeProxy:GetNode(id)
        self:SendNotification(NotiConst.Notify_SetWorldPosition,node.position)
        Facade:BackPanel()
    end
end

function MarkListMediator:RequestMarkList()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MARKLIST), self.OnMapMarkList, self)
    local TCSMarkList = scene_pb.TCSMarkList()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.MARKLIST, TCSMarkList:SerializeToString())
end

function MarkListMediator:OnMapMarkList(btsData)
    if btsData then
        local data = scene_pb.TSCMarkList()
        data:MergeFromString(btsData)
        self.userDataProxy:SetMapMarkList(data.mark)
        self:UpdateMarkList()
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MARKLIST), self.OnMapMarkList)
end


return MarkListMediator