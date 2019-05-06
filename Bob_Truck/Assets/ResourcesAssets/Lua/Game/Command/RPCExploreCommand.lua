local RPCPlanetExploreCommand = class("RPCPlanetExploreCommand", SimpleCommand)
RPCPlanetExploreCommand.MODULE_NAME = NotiConst.Command_RPCExplore
local IP = "192.168.80.17"
local port = "8000"

function RPCPlanetarySystemCommand:Execute(notice)
    body = notice:GetBody()

    local TCSExplorer = scene_pb.TCSExplorer()
    TCSExplorer.id = body.id
    TCSExplorer.depth = body.depth
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(node_pb.EXPLORER), self.TCSExplorerCallback, self)
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, node_pb.GETPLANETARYDATA, TCSPlanetary:SerializeToString());
end

function RPCLoginCommand:TCSExplorerCallback(stData)
    local TSCExplorer = scene_pb.TSCExplorer()
    TSCExplorer:MergeFromString(stData)
    for key, value in pairs(TSCExplorer) do
    end
end

return RPCPlanetExploreCommand