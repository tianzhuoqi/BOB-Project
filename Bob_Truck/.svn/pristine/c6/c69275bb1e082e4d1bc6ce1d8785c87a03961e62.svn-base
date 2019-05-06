local RPCGetStorehouseCommand = class("RPCGetStorehouseCommand", SimpleCommand)
RPCGetStorehouseCommand.MODULE_NAME = NotiConst.Command_RPCGetStorehouse

function RPCGetStorehouseCommand:Execute(notice)
    self.nodeId = notice:GetBody()
    self:GetStorehouseData(self.nodeId)
end

function RPCGetStorehouseCommand:GetStorehouseData(nodeId)
    local TCSGetStorehouse = building_pb.TCSGetStorehouse()
    TCSGetStorehouse.nodeId = nodeId
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETSTOREHOUSE), self.GetStorehouseDataCallback, self)
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETSTOREHOUSE, TCSGetStorehouse:SerializeToString())
end

return RPCGetStorehouseCommand