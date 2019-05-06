local ListCell = require("Game/Module/UICommon/ListCell")

local MapMarkListCell = register("MapMarkListCell", ListCell)

function MapMarkListCell:Awake(gameObject)
    MapMarkListCell.super.Awake(self, gameObject)
    self.icon = self:FindComponent("Icon","UISprite")
    self.name = self:FindComponent("g2/Name","UILabel")
    self.position = self:FindComponent("g2/Pos","UILabel")
    self.deleteBtn = self:FindGameObject("g3/Del")
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local NLuaClickEvent = NLuaClickEvent.Get(self.deleteBtn)
    NLuaClickEvent:AddClick(self, self.OnRemoveBtnClick)
end

function MapMarkListCell:OnClick()
    Facade:SendNotification(NotiConst.Notify_MapMarkListSelected,self.data.nodeId)
end

function MapMarkListCell:DrawCell(index)
    local panelName = Facade:TopPanelName()
    self.panelMediator = nil
    if panelName == "BigMapPanel" then
        self.panelMediator = Facade:RetrieveMediator("BigMapMediator")
    elseif panelName == "MarkListPanel" then
        self.panelMediator = Facade:RetrieveMediator("MarkListMediator")
    end
    self.dataIndex = index + 1
    self.data = self.panelMediator.markListData[self.dataIndex]
    if self.data.isSysNode then
        self.deleteBtn:SetActive(false)
    else
        self.deleteBtn:SetActive(true)
    end
    self.name.text = self.data.name
    local node = self.universeProxy:GetNode(self.data.nodeId)
    local posStr = node.position.x..","..node.position.y
    self.position.text = posStr

end

function MapMarkListCell:OnRemoveBtnClick()
    self:RequestDel(self.data.nodeId)
end

function MapMarkListCell:RequestDel(nodeId)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELMARK), self.OnRequestDel, self)
    local TCSCancelMark = scene_pb.TCSCancelMark()
    TCSCancelMark.nodeId = nodeId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CANCELMARK, TCSCancelMark:SerializeToString())
end

function MapMarkListCell:OnRequestDel(btsData)
    if btsData then
        local data = scene_pb.TSCCancelMark()
        data:MergeFromString(btsData)
        if data.result then
            self.userDataProxy:RemoveMapMarkItem(self.data.nodeId)
            Facade:SendNotification(NotiConst.Notify_MapMarkListChanged)
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"删除标记成功")
        end
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELMARK), self.OnRequestDel)
end

return MapMarkListCell