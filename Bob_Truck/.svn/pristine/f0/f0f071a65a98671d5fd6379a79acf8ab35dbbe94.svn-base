local ListItem = require("Game/Module/UICommon/ListItem")

local MapMarkListItem = register("MapMarkListItem", ListItem)

function MapMarkListItem:Awake(gameObject)
    MapMarkListItem.super.Awake(self, gameObject)
    self.icon = self:FindComponent("Icon","UISprite")
    self.name = self:FindComponent("g2/Name","UILabel")
    self.position = self:FindComponent("g2/Pos","UILabel")
    self.deleteBtn = self:FindGameObject("g3/Del")
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local NLuaClickEvent = NLuaClickEvent.Get(self.deleteBtn)
    NLuaClickEvent:AddClick(self, self.OnRemoveBtnClick)

    self.iconMap = {"c1ic68","c1ic73","c1ic71","c1ic74",[0] = "c1ic72"}
end

function MapMarkListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_MapMarkListSelected,self.data.nodeId)
end

function MapMarkListItem:DrawCell(index, cellIndex, itemsCount)
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.index = index
    local panelName = Facade:TopPanelName()
    self.panelMediator = nil
    if panelName == "BigMapPanel" then
        self.panelMediator = Facade:RetrieveMediator("BigMapMediator")
    elseif panelName == "MarkListPanel" then
        self.panelMediator = Facade:RetrieveMediator("MarkListMediator")
    end
    self.data = self.panelMediator.markListData[self.dataIndex]
    if self.data.isSysNode then
        self.deleteBtn:SetActive(false)
    else
        self.deleteBtn:SetActive(true)
    end
    self.name.text = self.data.name
    local node = self.universeProxy:GetNode(self.data.nodeId)
    local posStr = "x"..node.position.x..",".."y"..node.position.y
    self.position.text = posStr
    
    self.icon.spriteName = self.iconMap[self.data.type]
end

function MapMarkListItem:OnRemoveBtnClick()
    self:RequestDel(self.data.nodeId)
end

function MapMarkListItem:RequestDel(nodeId)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELMARK), self.OnRequestDel, self)
    local TCSCancelMark = scene_pb.TCSCancelMark()
    TCSCancelMark.nodeId = nodeId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CANCELMARK, TCSCancelMark:SerializeToString())
end

function MapMarkListItem:OnRequestDel(btsData)
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

return MapMarkListItem