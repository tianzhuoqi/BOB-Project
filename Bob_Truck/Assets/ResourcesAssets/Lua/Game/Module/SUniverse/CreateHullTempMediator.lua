local CreateHullTempMediator = class("CreateHullTempMediator", MediatorDynamic)

local ModTechCfg = DATA_SHIP_MOD_TECH
local HullMatrCfg = DATA_SMT_AVAIL_HULL_LIST
local CpntMatCfg=DATA_SMT_AVAIL_CPNT_LIST
local HullCfg=DATA_SHIP_HULL_TECH
local CpntCfg=DATA_SHIP_CPNT_TECH

function CreateHullTempMediator:ctor(mediatorName) 
    CreateHullTempMediator.super.ctor(self, mediatorName)
end

function CreateHullTempMediator:Reset()
    self.nSelModTechID = 0 --当前选中的组装术
    self.nSelHullType = 0 --当前筛选的舰体部件
    self.nSelCmpntType = 0 --当前筛选的配件类型
    self.lstComposedHull = {}--已经组装的舰体
    self.lstComposedParts = {}--已经组装的配件
    self.nModifyModID = 0 --编辑标记
end

function CreateHullTempMediator:OnRegister()
    self:Reset()
    self:RegisterObserver(NotiConst.Notify_SelectModTech, "OnSelectModTech")
    self:RegisterObserver(NotiConst.Notify_BeginModifyMod, "BeginModifyMod")

    --rpc 回复
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ADDUSERMOD), self.OnS2CCreateMod, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITMOD), self.OnS2CModifyMod, self)
end
--选择组装技术
function CreateHullTempMediator:SelectModTech(itemid)
    self.nSelModTechID = itemid
    self.techcfg = ModTechCfg[itemid]
    --初始化舰部件 
    local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local hullMatCfg = HullMatrCfg[itemid]
    local lstMats = hullMatCfg[HullMatrCfg.EVar.hull_id_repeated100]
    local cpntMatCfg = CpntMatCfg[itemid]
    local lstCpntMats = cpntMatCfg[CpntMatCfg.EVar.cpnt_id_repeated100]
    
    --筛选列表
    self.lstHullType = {}
    self.lstHullType[NotiConst.ShipHullType.eSHT_Head]={}--舰首
    self.lstHullType[NotiConst.ShipHullType.eSHT_Body]={}--扩展
    self.lstHullType[NotiConst.ShipHullType.eSHT_Tail]={}--引擎
    
    self.lstCmpntType = {}
    self.lstCmpntType[NotiConst.ShipCompntType.eSCT_Att]={}--攻
    self.lstCmpntType[NotiConst.ShipCompntType.eSCT_Def]={}--防
    self.lstCmpntType[NotiConst.ShipCompntType.eSCT_Subsys]={}--子系统

    for i=1, #lstMats do
        --if UserDataProxy:GetBagItemCount(lstMats[i]) > 0 then --背包内的材料数量
            --ShipHullType
            local hull = HullCfg[lstMats[i]]
            local hulltype = hull[HullCfg.EVar.hull_type_n]
            table.insert(self.lstHullType[hulltype], lstMats[i])
        --end
    end

    for i=1, #lstCpntMats do 
        --if UserDataProxy:GetBagItemCount(lstCpntMats[i]) > 0 then --背包内的材料数量
            --ShipHullType
            local cpnt = CpntCfg[lstCpntMats[i]]
            local ctype = cpnt[CpntCfg.EVar.cpnt_type_n]
            table.insert(self.lstCmpntType[ctype], lstCpntMats[i])
        --end
    end

    self.lstComposedHull = {}--已选择的舰体材料
    self.lstComposedParts = {}--已选择的配件

    self.m_viewComponent:SetModTech(self.nSelModTechID)
end

function CreateHullTempMediator:OnSelectModTech(notify)
    local body = notify:GetBody()
    local itemid = body.itemid
    self:SelectModTech(itemid)
end



--当前筛选舰体部件类型
function CreateHullTempMediator:SelectHullType(htype)
    self.nSelHullType = htype
    return self.nSelModTechID > 0
end
--当前筛选配件类型
function CreateHullTempMediator:SelectCompntType(ctype)
    if not self:CheckIsHullValid() then 
        return false
    end
    self.nSelCmpntType = ctype
    return true
end
--当前组装技术剩余可装配的舰体模块空间
function CreateHullTempMediator:GetRemainHullSpace()
    return self.techcfg[ModTechCfg.EVar.max_hull_qty_n] - #self.lstComposedHull
end

--组装舰体预判断(主要判断总空间以及舰体总数量
function CreateHullTempMediator:CanAddComposeHull(itemid)
    local n = #self.lstComposedHull
    if n < 1 then
        return true
    end
    --舰体总数量判断
    if self:GetRemainHullSpace() < 1 then 
        return false
    end
    --总空间判断
    local nTotalCostSp = 0
    for i=1, n do 
        local cmpshull = self.lstComposedHull[i]
        local hulcfg = HullCfg[cmpshull.itemid]
        nTotalCostSp = nTotalCostSp + hulcfg[HullCfg.EVar.ssp_cost_n]
    end
    return nTotalCostSp < self.techcfg[ModTechCfg.EVar.max_ssp_n]
end

--组装一个舰体 
function CreateHullTempMediator:AddComposeHull(itemid, attidx, attpart)
    local comsrc = {}
    comsrc.itemid = itemid
    comsrc.attidx = attidx
    comsrc.attpart = attpart
    table.insert(self.lstComposedHull, comsrc)
end
--删除最后一个舰体
function CreateHullTempMediator:RmvLastComposeHull()
    local n = #self.lstComposedHull
    if n < 1 then
        return
    end
    table.remove(self.lstComposedHull, n)
    return
end
--舰体组装合理性
function CreateHullTempMediator:CheckIsHullValid()
    local n = #self.lstComposedHull
    if n < 3 then
        return false
    end
    --舰首、尾、中 都有组装的前提下，是个合理的组装
    local partvalid = {}
    for i=1, n do
        local itmcfg = HullCfg[self.lstComposedHull[i].itemid]
        partvalid[itmcfg[HullCfg.EVar.hull_type_n]] = 1
    end
    return #partvalid == 3
end

--添加预判断组件
function CreateHullTempMediator:CanAddComposeCpnt(itemid)
    local n = #self.lstComposedParts
    if n < 1 then
        return true
    end
    local cCount = {0,0,0}
    for i=1, n do 
        local cpntid = self.lstComposedParts[i]
        local cpntcfg = CpntCfg[cpntid]
        local ctype = cpntcfg[CpntCfg.EVar.cpnt_type_n]
        cCount[ctype] = cCount[ctype]+1
    end
    --组件各子类型数量限制
    local limitCount = {self.techcfg[ModTechCfg.EVar.atk_slot_qty_n], self.techcfg[ModTechCfg.EVar.def_slot_qty_n], self.techcfg[ModTechCfg.EVar.subsys_slot_qty_n]}
    local icpntcfg = CpntCfg[itemid]
    local ictype = icpntcfg[CpntCfg.EVar.cpnt_type_n]
    return cCount[ictype] < limitCount[ictype]
end
--添加组件
function CreateHullTempMediator:AddComposeCpnt(itemid)
    if not self:CanAddComposeCpnt(itemid) then
        return false
    end
    table.insert(self.lstComposedParts, itemid)
    return true
end
--删除最近添加组件
function CreateHullTempMediator:RmvLastComposeCpnt()
    local n = #self.lstComposedParts
    if n < 1 then
        return false
    end
    table.remove(self.lstComposedParts, n)
    return true
end

--当前筛选的配件类型列表
function CreateHullTempMediator:GetSelectHullTypeList()
    return self.lstHullType[self.nSelHullType]
end
--当前筛选的配件类型列表
function CreateHullTempMediator:GetSelectCmpntTypeList()
    return self.lstCmpntType[self.nSelCmpntType]
end

function CreateHullTempMediator:IsItemChoosed(itemid)
    local itype = GetItemTypeByID(itemid)
    if itype == NotiConst.ItemType.eIT_ShipHull then 
        for i=1, #self.lstComposedHull do 
            if self.lstComposedHull[i] == itemid then 
                return true
            end
        end
    elseif itype == NotiConst.ItemType.eIT_ShipCompnt then 
        for i = 1, #self.lstComposedParts do 
            if self.lstComposedParts[i] == itemid then 
                return true
            end
        end
    end
    return false
end

--rpc 请求创建模块
function CreateHullTempMediator:ReqCreateTemplete()
    local TCSAddUserMod = buildingModFact_pb.TCSAddUserMod()
    TCSAddUserMod.techID = self.nSelModTechID
    --舰体
    local n = #self.lstComposedHull
    for i=1, n do 
        local cmphull = self.lstComposedHull[i]
        local hpart = db_pb.HullPart()
        hpart.hullId = cmphull.itemid
        hpart.attachIndex = cmphull.attidx
        hpart.attachPart = cmphull.attpart
        table.insert(TCSAddUserMod.hullParts, hpart)
    end
    --配件
    local n = #self.lstComposedParts
    for i=1, n do 
        table.insert(TCSAddUserMod.cpntMats, self.lstComposedParts[i])
    end
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.ADDUSERMOD, TCSAddUserMod:SerializeToString())
end

--rpc 修改模块
function CreateHullTempMediator:ReqModifyTemplete()
    local TCSEditMod = buildingModFact_pb.TCSEditMod()

    TCSEditMod.modId = self.nModifyModID
    TCSEditMod.techID = self.nSelModTechID
    --舰体
    local n = #self.lstComposedHull
    for i=1, n do 
        local cmphull = self.lstComposedHull[i]
        local hpart = db_pb.HullPart()
        hpart.hullId = cmphull.itemid
        hpart.attachIndex = cmphull.attidx
        hpart.attachPart = cmphull.attpart
        table.insert(TCSEditMod.hullParts, hpart)
    end
    --配件
    local n = #self.lstComposedParts
    for i=1, n do 
        table.insert(TCSEditMod.cpntMats, self.lstComposedParts[i])
    end
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EDITMOD, TCSEditMod:SerializeToString())
end


--创建模块返回
function CreateHullTempMediator:OnS2CCreateMod(data)
    if data == nil then 
        return
    end
    local TSCAddUserMod = buildingModFact_pb.TSCAddUserMod()
    TSCAddUserMod:MergeFromString(data)
    local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    if 1 == TSCAddUserMod.res then
        UserDataProxy:AddHullMod(TSCAddUserMod.mod)
        Facade:BackPanel()
    else 
        OpenMessageBox(NotiConst.MessageBoxType.Confirm,"Error Code:"..TSCAddUserMod.res,"错误")
    end
end

function CreateHullTempMediator:OnS2CModifyMod(stData)
    if stData == nil then 
        return
    end
    local TSCEditMod = buildingModFact_pb.TSCEditMod()
    TSCEditMod:MergeFromString(stData)
    local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    UserDataProxy:ModifyHullMod(TSCEditMod.mod)
    Facade:BackPanel()
end


function CreateHullTempMediator:OnDestroy()
    
end
--开始编辑模板
function CreateHullTempMediator:BeginModifyMod(notify)
    local body = notify:GetBody()
    local modidx = body.modidx

    local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local mod = UserDataProxy:GetHullModByIndex(modidx)
    if mod == nil then 
        return
    end
    self.nModifyModID = mod.id
    self:SelectModTech(mod.techID)
    local lstHull = mod.hullParts
    local n = #lstHull
    for i=1, n do 
        local hull = lstHull[i]
        self:AddComposeHull(hull.hullId, hull.attachIndex, hull.attachPart)
    end

    local lstCpnt = mod.cpntMats
    n = #lstCpnt
    for i=1, n do 
        self:AddComposeCpnt(lstCpnt[i])
    end

    self.m_viewComponent:InitByMod(mod)
end

function CreateHullTempMediator:IsModifyStat()
    return self.nModifyModID >= 1
end

function CreateHullTempMediator:GetCurModifyMod()
    local UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    return UserDataProxy:GetHullMod(self.nModifyModID)
end

return CreateHullTempMediator