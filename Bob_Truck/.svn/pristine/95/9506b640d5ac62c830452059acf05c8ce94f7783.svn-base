local LoginMediator = class("LoginMediator", MediatorDynamic)

function LoginMediator:OnRegister()
	LoginMediator.super.OnRegister(self)
	self.view = self:GetViewComponent()
	local NLuaClickEvent = NLuaClickEvent.Get(self.view.loginButton.gameObject)
	NLuaClickEvent:AddClick(self, self.LoginButtonClick)
	self:RegisterObserver(NotiConst.Net_Exception, 'ConnectCallBack')

	--注册rpc回调
	ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.LOGIN), self.LoginCallBack, self)
	ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETUSERDATA), self.GetUserDataCallBack, self)
	ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self.GetUserHullTempCallBack, self)		
end

function LoginMediator:ConnectCallBack(notify)
	local body = notify:GetBody()
	if body.netType == common_pb.NETTYPELOBBY then
		if body.Exception == NotiConst.NetException.OnConnectSucceed then
			local TCSLogin = login_pb.TCSLogin()
			local TCSGetUserData = login_pb.TCSGetUserData()
			TCSLogin.account = self.view.nameText.value
			self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
			self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
			self.globalProxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
			
			
			NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.LOGIN, TCSLogin:SerializeToString());
		elseif  body.Exception == NotiConst.NetException.OnConnectFailed then
			
		end
	end
end

function LoginMediator:LoginButtonClick()
	local data = {account = self.view.nameText.value, IP = self.view.IPText.value, port = self.view.portText.value}
	Facade:SendNotification(NotiConst.Command_RPCLogin, data)
end

function LoginMediator:LoginCallBack(stData)
	local TSCLogin = login_pb.TSCLogin()
	TSCLogin:MergeFromString(stData)
	--登陆完成对时
	local globalProxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
	globalProxy:SetSystemTimestamp(TSCLogin.systemCurrentTime/1000)

	ManagerIntro:InitServerData(TSCLogin.guide)

	self.userDataProxy:SetUserDataLogin(TSCLogin)
	
	local TCSGetUserData = login_pb.TCSGetUserData()
	NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETUSERDATA, TCSGetUserData:SerializeToString());
	--取账号拥有的模板
	local TCSUserMods = buildingModFact_pb.TCSUserMods()
	NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
end

function LoginMediator:GetUserDataCallBack(stData)
	local TSCGetUserData = login_pb.TSCGetUserData()
	TSCGetUserData:MergeFromString(stData)
	self.userDataProxy:SetUserData(TSCGetUserData)
	self.userDataProxy:SetRewardTimeLeft(math.floor(TSCGetUserData.taskOnline.rewardTimeLeft / 1000), TSCGetUserData.taskOnline.rewardCount)
	ManagerScene:OpenSceneUseLoadingScene("SUniverse")
end

function  LoginMediator:GetUserHullTempCallBack(stData)
	if stData ~= nil then 
		local TSCUserMods = buildingModFact_pb.TSCUserMods()
		TSCUserMods:MergeFromString(stData)
		self.planetaryProxy:SetUserMods(TSCUserMods.mods)
		local n = #TSCUserMods.mods
		for i=1, n do 
			self.userDataProxy:AddHullMod(TSCUserMods.mods[i])
		end
	end
end

return LoginMediator