local RPC_SCENEN_NODE_DATA_Command = class("RPC_SCENEN_NODE_DATA_Command", SimpleCommand)

RPC_SCENEN_NODE_DATA_Command.MODULE_NAME = NotiConst.Command_RPCSCENEN_NODE_DATA
function RPC_SCENEN_NODE_DATA_Command:Execute(notice)
	data = notice:GetBody()
	local TCSNodeData = scene_pb.TCSSceneNodeData()
	for i=1, #data do 
		table.insert(TCSNodeData.nodeIds, data[i])
	end
	NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SCENENODEDATA, TCSNodeData:SerializeToString());
end

return RPC_SCENEN_NODE_DATA_Command