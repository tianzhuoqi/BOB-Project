require("Proto/scene_pb")
local RPCPlanetarySystemCommand = class("RPCPlanetarySystemCommand", SimpleCommand)
RPCPlanetarySystemCommand.MODULE_NAME = NotiConst.Command_RPCPlantarySystem

function RPCPlanetarySystemCommand:Execute(notice)
    self.rpcCount = 0
    self.rpcComplete = 2
    local body = notice:GetBody()
    self.nodeId = body.nodeId
    local TCSGetNodeData = node_pb.TCSGetNodeData()
    TCSGetNodeData.nodeId = self.nodeId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETNODEDATA, TCSGetNodeData:SerializeToString())
    --ManagerScene:OpenSceneUseLoadingScene("SPlanetarySystem")
end


return RPCPlanetarySystemCommand