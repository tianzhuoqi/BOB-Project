local RPCLoginCommand = class("RPCLoginCommand", SimpleCommand)

RPCLoginCommand.MODULE_NAME = NotiConst.Command_RPCLogin
function RPCLoginCommand:Execute(notice)
	data = notice:GetBody()
	UnityEngine.PlayerPrefs.SetString("lastIP", data.IP)
	UnityEngine.PlayerPrefs.SetString("lastPort", data.port)
	UnityEngine.PlayerPrefs.SetString("lastName", data.account)
	self:InitializeNet(data.IP, data.port)
end

function RPCLoginCommand:InitializeNet(IP, port)
	NNetMgrInst:CloseAll();
	NNetMgrInst:CreateRpcNet(common_pb.NETTYPELOBBY);

	NNetMgrInst:StartRpcConnect(common_pb.NETTYPELOBBY, IP, port);
end

return RPCLoginCommand