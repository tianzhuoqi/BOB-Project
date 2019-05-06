local ManagerNet = class("ManagerNet")
local Nets = {}

function ManagerNet:ctor()
    local TCSHeart = login_pb.TCSHeart()
    self.TCSHeart = TCSHeart:SerializeToString()
    StartCoroutine(self.UpdateNets, self)
end

function ManagerNet.Instance()
	if ManagerNet.m_instance == nil then
		ManagerNet.m_instance = ManagerNet.New()
	end

    return ManagerNet.m_instance
end

function ManagerNet:UpdateNets(self)
    while true do
        for k, v in pairs(Nets) do
            if NNetMgrInst:IsConnect(k) then
                self:SycnServerTimestamp()
            end
        end
        WaitForSeconds(30)
    end
end

function ManagerNet:AddNetHeartBeat(netTpye)
    local netTpyestr = tostring(netTpye)
    if Nets[netTpyestr] == nil then
        Nets[netTpyestr] = netTpye
        ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.HEART), self.HeartBeatCallBack, self)
    end
end

function ManagerNet:SycnServerTimestamp()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.HEART, self.TCSHeart)
end

function ManagerNet:RemoveNetHeartBeat(netTpye)
    local netTpyestr = tostring(netTpye)
    Nets[netTpyestr] = nil
end

function ManagerNet:HeartBeatCallBack (stData)
    local TSCHeart = login_pb.TSCHeart()
    TSCHeart:MergeFromString(stData)
    local globalProxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
    globalProxy:SetSystemTimestamp(TSCHeart.time/1000)
end

return ManagerNet