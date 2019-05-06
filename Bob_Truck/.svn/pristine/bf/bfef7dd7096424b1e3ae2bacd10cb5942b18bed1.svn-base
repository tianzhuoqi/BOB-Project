local RPCGmCommand = class("RPCGmCommand", SimpleCommand)
RPCGmCommand.MODULE_NAME = NotiConst.Command_RPCGm

function RPCGmCommand:Execute(notice)
    body = notice:GetBody()
    local TCSGm = gm_pb.TCSGm()
    TCSGm.gmCmd = body
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GM, TCSGm:SerializeToString())
end

return RPCGmCommand