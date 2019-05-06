local RPCFleetSpeedUpCommand = class("RPCFleetSpeedUpCommand", SimpleCommand)
RPCFleetSpeedUpCommand.MODULE_NAME = NotiConst.Command_RPCFleetSpeedUp

function RPCFleetSpeedUpCommand:Execute(notice)
    body = notice:GetBody()
    local TCSFleetSpeedUp = scene_pb.TCSFleetSpeedUp()
    TCSFleetSpeedUp.fleetId = body.fleetId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.FLEETSPEEDUP, TCSFleetSpeedUp:SerializeToString())
end

return RPCFleetSpeedUpCommand