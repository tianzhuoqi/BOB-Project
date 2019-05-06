local BigMapMediator = class("BigMapMediator", MediatorDynamic)

function BigMapMediator:OnRegister()
    self.targetPosition = {0,0}
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    self.view = self:GetViewComponent()
    self.markListData = {}
    local univData = self.universeProxy:GetData()
    self.view.realSize = {univData.ClusterSize*univData.WorldWidth,univData.ClusterSize*univData.WorldHeight}
    self:RegisterObserver(NotiConst.Notify_MapMarkListChanged, "UpdateListData")
    self:RegisterObserver(NotiConst.Notify_MapMarkListSelected, "ChooseMarkPos")
    self:RegisterObserver(NotiConst.Notify_MapMarkListFilter, "UpdateFilter")
    self.filterArea = {0,0,self.view.realSize[1],self.view.realSize[2]} --过滤区域大小
end

function BigMapMediator:UpdateFilter(notify)
    
    local filter = notify:GetBody()
    self.filterArea = filter
    self:UpdateMarkList()
end

function BigMapMediator:Goto()
    self:SendNotification(NotiConst.Notify_SetWorldPosition,{x=self.targetPosition[1],y=self.targetPosition[2]})
end

function BigMapMediator:UpdateListData()
    local list = self.userDataProxy:GetMapMarkList()
    self.markListData = {}
    for i,v in ipairs(list) do
        local p = self.universeProxy:GetNode(v.nodeId).position
        if p.x >= self.filterArea[1] and p.y >= self.filterArea[2] and p.x < self.filterArea[3] and p.y < self.filterArea[4] then
            table.insert( self.markListData, v)
        end
    end
    Facade:SendNotification("MarkListNotifyBig",#self.markListData)
end

function BigMapMediator:UpdateMarkList()
    self:UpdateListData()
    self.markListData = self.userDataProxy:GetMapMarkList()
    self.view.uiTableView:ScrollResetPosition()
end

function BigMapMediator:ChooseMarkPos(notify)
    if Facade:TopPanelName() == "BigMapPanel" then
        local id = notify:GetBody()
        local node = self.universeProxy:GetNode(id)

        self.targetPosition = {node.position.x,node.position.y}
        self.view:SetMarkLocation()
    end
end

function BigMapMediator:RequestMarkList()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MARKLIST), self.OnMapMarkList, self)
    local TCSMarkList = scene_pb.TCSMarkList()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.MARKLIST, TCSMarkList:SerializeToString())
end

function BigMapMediator:OnMapMarkList(btsData)
    if btsData then
        local data = scene_pb.TSCMarkList()
        data:MergeFromString(btsData)
        self.userDataProxy:SetMapMarkList(data.mark)
        self:UpdateMarkList()
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MARKLIST), self.OnMapMarkList)
end


function BigMapMediator:GetCurrentPosition()
    return self.universeProxy:GetCurrentPosition()
end

function BigMapMediator:GetHomePosition()
    local node = self.universeProxy:GetMainBaseNode()
    return {x=node.position.x,y=node.position.y}
end

return BigMapMediator