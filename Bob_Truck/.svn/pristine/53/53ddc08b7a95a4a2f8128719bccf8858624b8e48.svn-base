local FleetDirectiveMediator = class("FleetDirectiveMediator", MediatorDynamic)
local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)

function FleetDirectiveMediator:OnRegister()
    self.uiBinder = self:GetViewComponent().uiBinder

    local luaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnSClose.gameObject)
    luaClickEvent:AddClick(self,self.ClosePanel)
    self.tableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ENDFLEETCOLLECT), self.FleetEndCollectCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETCOLLECT), self.FleetStartCollectCallback, self)
end

function FleetDirectiveMediator:ShowUI()
    self.tableView:ScrollResetPosition() 
    self.tableView:ResetState()
    self:RefreshTableView()
end

function FleetDirectiveMediator:RefreshTableView()
    local count = self:GetFleetDirectiveKinds()
    Facade:SendNotification("ShowFleetDirective",count)
end

function FleetDirectiveMediator:GetFleetDirectiveKinds()
    local count = 0
    for i,v in pairs(NotiConst.FleetDirectiveType) do
        count = count + 1
    end
    return count
end

function FleetDirectiveMediator:ClosePanel()
    self.tableView:ResetState()
    Facade:BackPanel()
end

--舰队采集开始监听事件
function FleetDirectiveMediator:FleetStartCollectCallback(sData)
    if sData ~= nil then
        local TSCFleetCollect = node_pb.TSCFleetCollect()
        TSCFleetCollect:MergeFromString(sData)
        local fleet = fleetProxy:GetMyCurrentNodeFleetByFleetId(TSCFleetCollect.fleetId)
        fleet.startTime = GetServerTimeStamp(true)
        fleet.endTime = TSCFleetCollect.endTime/1000
        fleet.status = common_pb.COLLECT
        universeProxy:SetCurrentOperationNodeCollectStatus(1)

        self:RefreshTableView()
    end
end

--舰队采集结束监听事件
function FleetDirectiveMediator:FleetEndCollectCallback(sData)
    if sData ~= nil then
        local TSCEndFleetCollect = node_pb.TSCEndFleetCollect()
        TSCEndFleetCollect:MergeFromString(sData)
       
        if Facade:IsRunPanel("FleetDirectivePanel") then
            ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETFLEETINNODE), self.RefreshFleetDatasCallback, self)
            local TCSGetFleetInNode = node_pb.TCSGetFleetInNode()
            TCSGetFleetInNode.nodeId = TSCEndFleetCollect.nodeId
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETFLEETINNODE, TCSGetFleetInNode:SerializeToString())  
        end

        local storeHouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
        storeHouseProxy:AddItemByDatas(TSCEndFleetCollect.nodeId,TSCEndFleetCollect.item)
    end
end

--重新拉取舰队数据，刷新界面
function FleetDirectiveMediator:RefreshFleetDatasCallback(sData)
    if sData ~= nil then
        local TSCGetFleetInNode = node_pb.TSCGetFleetInNode()
        TSCGetFleetInNode:MergeFromString(sData)
        fleetProxy:SaveMyCurrentNodeFleetListData(TSCGetFleetInNode.fleet)
        universeProxy:SetCurrentOperationNodeOwner(TSCGetFleetInNode.owner)
        universeProxy:SetCurrentOperationNodeCollectStatus(TSCGetFleetInNode.fleetCollect)

        self:RefreshTableView()
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETFLEETINNODE))
end

function FleetDirectiveMediator:DestroyPanel()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ENDFLEETCOLLECT), self.FleetEndCollectCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETCOLLECT), self.FleetStartCollectCallback)
end

return FleetDirectiveMediator