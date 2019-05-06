local HullModListMediator = class("HullModListMediator", MediatorDynamic)

function HullModListMediator:ctor(mediatorName) 
    HullModListMediator.super.ctor(self, mediatorName)
end


function HullModListMediator:OnRegister()
    --rpc 回复
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.DELMOD), self.OnS2CDelMod, self)
end

function HullModListMediator:OnS2CDelMod(btData)
    if btData ~= nil then
        local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
        local TSCDelMod = buildingModFact_pb.TSCDelMod()
        TSCDelMod:MergeFromString(btData)
        if UserDataProxy:RmvHullMod(TSCDelMod.modId) then 
            local nModCount = UserDataProxy:GetHullModListCount()+1
            Facade:SendNotification("HullModListPanelLstVNotify", nModCount)
        else 
            
        end
    else
        
    end
end

--删除某个模板
function  HullModListMediator:ReqDeleteMod(idx)
    local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local mod = UserDataProxy:GetHullModByIndex(idx)
    if mod == nil then 
        NDebug.LogError('mod == nil:'..idx)
        return
    end
    local TCSDelMod = buildingModFact_pb.TCSDelMod()
    TCSDelMod.modId = mod.id
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.DELMOD, TCSDelMod:SerializeToString())
end


function HullModListMediator:OnDestroy()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.DELMOD), self.OnS2CDelMod)
end

return HullModListMediator