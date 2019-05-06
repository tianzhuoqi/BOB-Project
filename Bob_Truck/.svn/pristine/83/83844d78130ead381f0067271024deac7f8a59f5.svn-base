local MapMarkMediator = class("MapMarkMediator", MediatorDynamic)

function MapMarkMediator:ctor(mediatorName) 
    MapMarkMediator.super.ctor(self, mediatorName)
end

function MapMarkMediator:OnRegister()
    self.curNodeId = 0
    self.curNodeName = ""
end

function MapMarkMediator:RequestSave(nodeId,name,type)
    if self:GetUserMarkListCount() >= 10 then
        OpenMessageBox(NotiConst.MessageBoxType.Comfirm,"超过设定上限")
        return
    end
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SETMARK), self.OnRequestSave, self)
    local TCSSetMark = scene_pb.TCSSetMark()
    TCSSetMark.nodeId = nodeId
    TCSSetMark.markName = name
    TCSSetMark.type = type
    self.curNodeId = nodeId
    self.curNodeName = markName
    self.curNodeType = type

    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SETMARK, TCSSetMark:SerializeToString())
end

function MapMarkMediator:OnRequestSave(btsData)
    if btsData then
        local data = scene_pb.TSCSetMark()
        data:MergeFromString(btsData)
        if data.result then
            local userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
            userDataProxy:AddMapMarkItem({
                nodeId = self.curNodeId,
                name = self.curNodeName,
                type = self.curNodeType

            })
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"标记成功")
            Facade:BackPanel()
        end
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SETMARK), self.OnRequestSave)
end

function  MapMarkMediator:GetUserMarkListCount()
    local userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local list = userDataProxy:GetMapMarkList()
    local count = 0
    for i,v in ipairs(list) do
        if not v.isSysNode then
            count = count + 1
        end
    end
    return count
end

return MapMarkMediator