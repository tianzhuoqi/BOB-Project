local ManagerNetMsgProc = class("ManagerNetMsgProc");

function ManagerNetMsgProc:ctor()
    self.mapNetMsgListener = {};
end

function ManagerNetMsgProc.Instance()
	if ManagerNetMsgProc.m_instance == nil then
		ManagerNetMsgProc.m_instance = ManagerNetMsgProc.New()
	end
	return ManagerNetMsgProc.m_instance
end

--Private 接口 -------------------
--增
function ManagerNetMsgProc:FuncAddListener(nNetType, sCmdID, proc, target)
	if proc == nil or type(proc)~="function" then 
		return;
	end
	
	if self.mapNetMsgListener[nNetType] == nil then 
		self.mapNetMsgListener[nNetType] = {};
	end

	if self.mapNetMsgListener[nNetType][sCmdID] == nil then
		self.mapNetMsgListener[nNetType][sCmdID] = {};
		self.mapNetMsgListener[nNetType][sCmdID].proc = {};
		self.mapNetMsgListener[nNetType][sCmdID].target = {};
	end

	for i = 1, #self.mapNetMsgListener[nNetType][sCmdID].proc do
		if self.mapNetMsgListener[nNetType][sCmdID].proc[i] == proc and self.mapNetMsgListener[nNetType][sCmdID].target[i] == target then
			return
		end
	end

	table.insert( self.mapNetMsgListener[nNetType][sCmdID].proc, proc)
	table.insert( self.mapNetMsgListener[nNetType][sCmdID].target, target)
	--LogDebug("ManagerNetMsgProc:FuncAddListener:"..tostring(self));
end
--删
function ManagerNetMsgProc:FuncRmvListener(nNetType, sCmdID, proc)
	if self.mapNetMsgListener[nNetType] == nil or self.mapNetMsgListener[nNetType][sCmdID] == nil then 
		return;
	end
	if self.mapNetMsgListener[nNetType][sCmdID].proc ~= nil then
		for i = 1, #self.mapNetMsgListener[nNetType][sCmdID].proc do
			if self.mapNetMsgListener[nNetType][sCmdID].proc[i] == proc then
				table.remove(self.mapNetMsgListener[nNetType][sCmdID].proc, i)
				table.remove(self.mapNetMsgListener[nNetType][sCmdID].target, i)
				break
			end
		end
		if #self.mapNetMsgListener[nNetType][sCmdID].proc == 0 then
			self.mapNetMsgListener[nNetType][sCmdID] = nil;
		end
	end
end
--取
function ManagerNetMsgProc:FuncGetListener(nNetType, sCmdID)
	if self.mapNetMsgListener[nNetType] == nil then 
		return nil;
	end
	return self.mapNetMsgListener[nNetType][sCmdID];
end
--End Private

--Public 接口 --------------------
--lua内外部接口 以下proc为类成员函数 , target为对象
--添加消息处理回调
function ManagerNetMsgProc:AddS2CMsgListener(nNetType, sCmdID, proc, target)
	self:FuncAddListener(nNetType, sCmdID, proc, target);
end 

--删除push消息处理
function ManagerNetMsgProc:RmvS2CMsgListener(nNetType, sCmdID, proc)
	self:FuncRmvListener(nNetType, sCmdID, proc);
end 


--[[消息注册示例
local Test = {};
Test.ii = 90;
function Test:foo()
	print("Test:foo:"..Test.ii);
end

FuncAddPushListener(1,1001,Test.foo, Test);
--]]

--End Public


--服务器回复消息入口,C#调用
--@nNetType Rpc类型id:int
--@sCmdID resp消息标识:short
--@stData 实际数据
function LuaFunc_NetMsgProc(nNetType, sCmdID, stData)
	LogDebug("LuaFunc_NetMsgProc:"..sCmdID);
	if sCmdID == -1 then
		local error = string.byte(stData,1)
		OpenMessageBox(NotiConst.MessageBoxType.Confirm, GetLanguageText("ErrorCode", "EC" .. tostring(error)))
	else
		local listener = ManagerNetMsgProc.Instance():FuncGetListener(nNetType,sCmdID);
		if listener ~= nil then
			for i = 1, #listener.proc do
				if type(listener.proc[i])=="function" then
					listener.proc[i](listener.target[i] ,stData);
				end
			end
		end
	end
end

--exceptin消息入口C#调用
--@nNetType Rpc类型id:int
--@nExcp exception标识:int
function LuaFunc_NetExcptProc(nNetType, nExcp)
	LogDebug("LuaFunc_NetExcptProc:"..tostring(nExcp));

	if nExcp == NotiConst.NetException.OnConnectSucceed or nExcp == NotiConst.NetException.OnConnectFailed then

		if nExcp == NotiConst.NetException.OnConnectSucceed then
			ManagerNet:AddNetHeartBeat(nNetType)
		end

		local body = {Exception = nExcp, netType = nNetType}
		Facade:SendNotification(NotiConst.Net_Exception, body, nil)
	end

	if nExcp == NotiConst.NetException.Disconnect then
		NNetMgrInst:Release()
		OpenMessageBox(NotiConst.MessageBoxType.Confirm, "服务器断开连接", "Title", {
			enterCallback = function()
				ManagerScene:OpenSceneUseLoadingScene("SLogin")
			end
		})
	end
	--[[在这里判断异常,处理断线重连...
	if nExcp == 6 and (not NNetMgrInst:IsConnect(1)) then 
		NNetMgrInst:StartRpcConnect(1, "127.0.0.1", 6666);
	end ]]
end

--Mock模拟
function LuaFunc_NetMockProc(nNetType, sCmdID, msg)
	LogDebug("LuaFunc_NetMockProc:"..sCmdID);
	--如果是需要被模拟的请求,在此构造resp消息返回
	if sCmdID == 3 then 
		local TCSSceneNodeData = scene_pb.TCSSceneNodeData()
		TCSSceneNodeData:MergeFromString(msg)
		local TS2CNodeData = scene_pb.TSCSceneNodeData()
		--添加一个点数据
		local stNodeD = scene_pb.NodeData()
		stNodeD.id = TCSSceneNodeData.nodeIds[1]
		stNodeD.name = "Node9001"
		stNodeD.uid = 2
		
		--添加一艘停靠舰
		local stFleet = scene_pb.Fleet()
		stFleet.uid = 4
		stFleet.fleetId = 10
		stFleet.nodeId = TCSSceneNodeData.nodeIds[1]
		stFleet.moveSpeed = 10
		stFleet.fromNodeId = 1050629
		stFleet.toNodeId =  1050641
		stFleet.startTime = os.time()
		table.insert(stNodeD.fleet, stFleet)

		table.insert(TS2CNodeData.nodes, stNodeD)

		local resp_cmdid = RpcResponseCMDID(sCmdID);--回复的消息id
		local strMsg = TS2CNodeData:SerializeToString()
		NNetMgrInst:LuaDirectAckNetMsg(nNetType, resp_cmdid, strMsg)
		return true;	
	end
	return nil;
end


return ManagerNetMsgProc;