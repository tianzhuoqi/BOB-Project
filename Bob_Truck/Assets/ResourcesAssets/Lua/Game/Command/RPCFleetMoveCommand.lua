local RPCFleetMoveCommand = class("RPCFleetMoveCommand", SimpleCommand)
RPCFleetMoveCommand.MODULE_NAME = NotiConst.Command_RPCFleetMove

function RPCFleetMoveCommand:Execute(notice)
    body = notice:GetBody()
    local TCSFleetMove = scene_pb.TCSFleetMove()
    TCSFleetMove.fleetId = body.fleetId
    for i,v in ipairs(body.path) do
        table.insert(TCSFleetMove.moveNodeIds,v)
    end
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.FLEETMOVE, TCSFleetMove:SerializeToString())
end

return RPCFleetMoveCommand