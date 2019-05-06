local CreateHullTempMediator = require("Game/Module/SUniverse/CreateHullTempMediator")
local CreateHullTempPanel = register("CreateHullTempPanel", PanelBase)
local CreateHullTempltPanelBinder = require("UIDef/CreateHullTempltPanelBinder")

local ModTechCfg = DATA_SHIP_MOD_TECH
local HullMatrCfg = DATA_SMT_AVAIL_HULL_LIST
local CpntCfg = DATA_SMT_AVAIL_CPNT_LIST
local HullCfg = DATA_SHIP_HULL_TECH

local AttachPartDef = NotiConst.ShipHullAttachPart
local ShipHullType = NotiConst.ShipHullType

local UnitySetPos = GameObjectUtil.SetPosition
local UnitySetScale = GameObjectUtil.SetScale
local UnityEngine_Object_Instantiate = UnityEngine.Object.Instantiate
local UnitySetUITextureMainTex=GameObjectUtil.SetUITextureMainTex
local SetLocalRotation = GameObjectUtil.SetLocalRotation
local SetLocalPosition = GameObjectUtil.SetLocalPosition
local UnityScrPickCastFloor = GameObjectUtil.ScreenPickCastFloor
local UnityInput = UnityEngine.Input
local math_floor = math.floor

function CreateHullTempPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView()

    self.mediator = CreateHullTempMediator.New("CreateHullTempMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end


function CreateHullTempPanel:OpenPanel()
    CreateHullTempPanel.super.OpenPanel(self)
    self:DoBlur()
    self.mediator:Reset()
    self:ResetView()
    
    --初始化listview
    Facade:SendNotification("CreateHullTemp_LstvNotify", 0);
end


function CreateHullTempPanel:ClosePanel()
    self:ClearModelShow()
end


function CreateHullTempPanel:DestroyPanel()
end

function CreateHullTempPanel:ResetView()
    self.uiBinder.m_txModTechName.text = ''
    self.uiBinder.m_sprProcess1_2.fillAmount = 0
    self.uiBinder.m_sprProcess2_3.fillAmount = 0
    self.uiBinder.m_btnNextStep.gameObject:SetActive(true)
    self.uiBinder.m_btnNextStep.isEnabled = false
    self.uiBinder.m_btnSwitchTech.isEnabled = true
    for i=1, #self.lstHullTypeTabs do 
        self.lstHullTypeTabs[i].isEnabled = true
    end 
    self.uiBinder.m_groupHull:SetActive(true)
    self.uiBinder.m_groupCpnt:SetActive(false)
    
    self.uiBinder.m_btnComplete.gameObject:SetActive(false)
    self:FreshSeledCpntList()

    self:InitModelShow()
end

function CreateHullTempPanel:InitView()
    self.uiBinder = CreateHullTempltPanelBinder.New(self.gameObject);

    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnSwitchTech.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonSwitchTechClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnClose.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCloseClick)
    --舰体部件tab
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_tabHullHead.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonHullHeadClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_tabHullBody.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonHullBodyClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_tabHullTail.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonHullTailClick)
    --Tab button
    self.lstHullTypeTabs = {self.uiBinder.m_tabHullHead, self.uiBinder.m_tabHullBody, self.uiBinder.m_tabHullTail}
    ---
    --配件tab
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_tabCpntAtt.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCpntAttClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_tabCpntDef.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCpntDefClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_tabCpntSubsys.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCpntSubsysClick)
    --Tab button
    self.lstCmpntTypeTabs = {self.uiBinder.m_tabCpntAtt, self.uiBinder.m_tabCpntDef, self.uiBinder.m_tabCpntSubsys}
        
    --下一步
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnNextStep.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonNextStepClick)
    --回退一步
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnStepBack.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonBackStepClick)
    
    --完成
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnComplete.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCompleteClick)
    --初始化舰体目标格子
    --self:InitHullDestSlot()

    --初始化配件目标格子
    self:InitCpntDestSlot()
    self.rtOffsetY = 0
    
end
--设置组装技术
function CreateHullTempPanel:SetModTech(itemid)
    self.nSelModTechID = itemid
    local itmCfg = ModTechCfg[itemid]
    self.uiBinder.m_txModTechName.text = itmCfg[ModTechCfg.EVar.mod_tech_name_s]
    
    self:ButtonHullHeadClick()
end

local HullModelPartDef = --定义一个拼装部件
{
    obj = nil, --模型实例
    itemid = 0, --物品id
    attachpart = {},--自身已开放附着口 HullAttacher定义的transform
    beattached_idx = {},--被附着的index,每个部位对应附着索引 多对多
    attachto_idx = 0, --附着到的index
    attachto_part = 0,--附着到的部位
}

--初始化model show
function CreateHullTempPanel:InitModelShow()
    self.lstHullModelComposed = {} --已经拼装好的部件 
    if self.ModelShow ~= nil then 
        return
    end
    g_InstancesPool:NewInst("UIPanel/SUniverse/HullTempModelShow.prefab", CreateHullTempPanel.OnResLoaded, self)
end

function CreateHullTempPanel:ClearModelShow()
    g_InstancesPool:DeleteInst(self.ModelShow)
    self.ModelShow = nil
    self.uiBinder.m_rtModel.mainTexture = nil
    local n = #self.lstHullModelComposed
    for i=1, n do 
        g_InstancesPool:DeleteInst(self.lstHullModelComposed[i].obj)
    end
    self.lstHullModelComposed = nil
end

function CreateHullTempPanel:OnResLoaded(obj)
	--LogDebug("Star:OnResLoaded:"..tostring(obj));
	if obj == nil then 
		return
    end
    if self.ModelShow ~= nil then 
        return
    end
	obj:SetActive(true);
	self.ModelShow = obj
	obj.transform.parent = nil
	UnitySetScale(obj, 1, 1, 1);
    UnitySetPos(obj, 0, 0, 0)
    self.rtOffsetY = self.uiBinder.m_rtModel.transform.localPosition.y
    self.ModelShowCam = UnitySetUITextureMainTex(self.uiBinder.m_rtModel, self.ModelShow.transform)
end

--初始化舰体目标格子
function CreateHullTempPanel:InitHullDestSlot()
    self.lstHullDstSlot = {}
    self.lstHullDstSlot[1] = {self.uiBinder.m_sprHullDestBg0, self.uiBinder.m_sprHullDestItem0}
    local parent = self.uiBinder.m_groupHull.transform
    local clonebk=self.uiBinder.m_sprHullDestBg0.gameObject
    local cloneicon=self.uiBinder.m_sprHullDestItem0.gameObject
    local pos0 = clonebk.transform.localPosition
    --复制14个  3x5
    local detal = 110
    for i=2, 15 do 
        local x = (i-1)% 5
        local y = math_floor((i-1)/5)
        local bk = UnityEngine_Object_Instantiate(clonebk)
        bk.transform.parent = parent
        UnitySetScale(bk,1,1,1)
        UnitySetPos(bk, pos0.x + x*detal, pos0.y - y*detal, 0)
        local item = UnityEngine_Object_Instantiate(cloneicon)
        item.transform.parent = parent
        UnitySetScale(item,1,1,1)
        UnitySetPos(item, pos0.x + x*detal, pos0.y - y*detal, 0)
        self.lstHullDstSlot[i]={bk:GetComponent("UISprite"), item:GetComponent("UISprite")}
    end
end

--初始化配件目标格子
function CreateHullTempPanel:InitCpntDestSlot()
    self.lstCmpntDstSlot = {}
    self.lstCmpntDstSlot[1] = {self.uiBinder.m_sprChooseCpntBk0, self.uiBinder.m_sprChooseCpntItem0}
    local parent = self.uiBinder.m_groupCpnt.transform
    local clonebk=self.uiBinder.m_sprChooseCpntBk0.gameObject
    local cloneicon=self.uiBinder.m_sprChooseCpntItem0.gameObject
    local pos0 = clonebk.transform.localPosition
    local detal = 100
    --复制9个
    for i=2, 10 do 
        local x = (i-1)% 5
        local y = (i>5 and 1) or 0
        local bk = UnityEngine_Object_Instantiate(clonebk)
        bk.transform.parent = parent
        UnitySetScale(bk,1,1,1)
        SetLocalPosition(bk, pos0.x + x*detal, pos0.y - y*detal, 0)
        local item = UnityEngine_Object_Instantiate(cloneicon)
        item.transform.parent = parent
        UnitySetScale(item,1,1,1)
        SetLocalPosition(item, pos0.x + x*detal, pos0.y - y*detal, 0)
        self.lstCmpntDstSlot[i]={bk:GetComponent("UISprite"), item:GetComponent("UISprite")}
    end
end


function CreateHullTempPanel:ButtonSwitchTechClick()
    Facade:ReplacePanel("ModTechListPanel")
end

function CreateHullTempPanel:ButtonCloseClick()
    Facade:BackPanel()
end
--筛选舰首
function CreateHullTempPanel:ButtonHullHeadClick()
    self:SelHullTypeTab(NotiConst.ShipHullType.eSHT_Head)
end
--筛选扩展
function CreateHullTempPanel:ButtonHullBodyClick()
    self:SelHullTypeTab(NotiConst.ShipHullType.eSHT_Body)
end
--筛选引擎
function CreateHullTempPanel:ButtonHullTailClick()
    self:SelHullTypeTab(NotiConst.ShipHullType.eSHT_Tail)
end
--筛选页签
function CreateHullTempPanel:SelHullTypeTab(htype)
    if self.mediator:SelectHullType(htype) then 
        for i=1, #self.lstHullTypeTabs do 
            self.lstHullTypeTabs[i].isEnabled = (i~=htype)
        end
        local lstHullType = self.mediator:GetSelectHullTypeList()

        --初始化listview
        Facade:SendNotification("CreateHullTemp_LstvNotify", #lstHullType)
    end
end

--后退一步
function CreateHullTempPanel:ButtonBackStepClick()
    if self.mediator.nSelCmpntType > 0 then 
    --撤消配件
        if self.mediator:RmvLastComposeCpnt() then 
            self:FreshSeledCpntList()
        end
    else 
    --撤消舰体
        if self:UncompseLastHull() then
            self.mediator:RmvLastComposeHull()
            --组装合理性判断
            self.uiBinder.m_btnNextStep.isEnabled = self.mediator:CheckIsHullValid()
        end
    end
end
--完成
function  CreateHullTempPanel:ButtonCompleteClick()
    if self.mediator:IsModifyStat() then
        self.mediator:ReqModifyTemplete()
    else 
        self.mediator:ReqCreateTemplete()
    end
end

function CreateHullTempPanel:UncompseLastHull()
    local countComposed = #self.lstHullModelComposed--已拼装
    if countComposed < 1 then
        return false
    end
    local composed = self.lstHullModelComposed[countComposed]
    table.remove(self.lstHullModelComposed, countComposed)
    g_InstancesPool:DeleteInst(composed.obj)
    if composed.attachto_idx > 0 then 
        local attachto = self.lstHullModelComposed[composed.attachto_idx]
        attachto.beattached_idx[composed.attachto_part]=0
    end
    return true
end
--下一步
function CreateHullTempPanel:ButtonNextStepClick()
    if self.mediator.nSelCmpntType > 0 then 
        self.uiBinder.m_btnNextStep.gameObject:SetActive(false)
        self.uiBinder.m_btnComplete.gameObject:SetActive(true)
    else 
        self.uiBinder.m_groupHull:SetActive(false)
        self.uiBinder.m_groupCpnt:SetActive(true)
        --禁止切换组装技术
        self.uiBinder.m_btnSwitchTech.isEnabled = false
        self:ButtonCpntAttClick()
        self.uiBinder.m_sprProcess2_3.fillAmount=1
    end
end

--begin 配件筛选相关
--攻击型配件
function CreateHullTempPanel:ButtonCpntAttClick()
    self:SelCpntTab(NotiConst.ShipCompntType.eSCT_Att)
end

--防御型配件
function CreateHullTempPanel:ButtonCpntDefClick()
    self:SelCpntTab(NotiConst.ShipCompntType.eSCT_Def)
end

--子系统型配件
function CreateHullTempPanel:ButtonCpntSubsysClick()
    self:SelCpntTab(NotiConst.ShipCompntType.eSCT_Subsys)
end

function CreateHullTempPanel:SelCpntTab(ctype)
    if self.mediator:SelectCompntType(ctype) then 
        for i=1, #self.lstCmpntTypeTabs do 
            self.lstCmpntTypeTabs[i].isEnabled = (i~=ctype)
        end
        local lstCmptType = self.mediator:GetSelectCmpntTypeList()

        --初始化listview
        Facade:SendNotification("CreateHullTemp_LstvNotify", #lstCmptType)
    end
end
--刷新选中的配件材料
function CreateHullTempPanel:FreshSeledCpntList()
    local lst = self.mediator.lstComposedParts
    local setn = 0
    for i=1, #lst do 
        self.lstCmpntDstSlot[i][2].spriteName = 'c1icj01'
        setn = setn + 1
    end
    for i=setn+1, 10 do 
        self.lstCmpntDstSlot[i][2].spriteName = ''
    end
end

--点击选择组件
function CreateHullTempPanel:OnItemClick(itemid)
    if self.mediator.nSelCmpntType < 1 then
        return
    end
    if self.mediator:AddComposeCpnt(itemid) then 
        self:FreshSeledCpntList()
    end
end

--end 配件筛选相关

---拖曳拼装相关
function CreateHullTempPanel:GetHullModelName(itemid)
    --测试数据, ToDo 从策划配置读取对应资源
    local hull = HullCfg[itemid]
    local hulltype = hull[HullCfg.EVar.hull_type_n]
    if hulltype == ShipHullType.eSHT_Head then
        return 'ModelFBX/ship/t_ship_00104.prefab'
    elseif hulltype == ShipHullType.eSHT_Body then
        return 'ModelFBX/ship/z_ship_00102.prefab'
    elseif hulltype == ShipHullType.eSHT_Tail then
        return  (math.random()>0.5 and 'ModelFBX/ship/w_ship_00112.prefab') or  'ModelFBX/ship/w_ship_00101.prefab'
    end
end

function CreateHullTempPanel:OnDragStart(itemid)
    --当前是选舰体还是配件
    if self.mediator.nSelCmpntType > 0 then
        return--配件
    end
    g_InstancesPool:DeleteInst(self.objDrag)
    self.objDrag = nil
    g_InstancesPool:NewInst(self:GetHullModelName(itemid), CreateHullTempPanel.OnHullModelLoaded, self)
end

function CreateHullTempPanel:OnHullModelLoaded(obj)
    if obj == nil then 
        return
    end
    g_InstancesPool:DeleteInst(self.objDrag)
    obj:SetActive(true)
    self.objDrag = obj
    obj.transform.parent = self.ModelShow.transform
    UnitySetScale(obj,1,1,1)
    SetLocalRotation(obj,0,-90,0)
    SetLocalPosition(obj,0,0,0)
end

function CreateHullTempPanel:OnDrag(delta)
    if self.objDrag == nil then
        return
    end
    local pos = UnityScrPickCastFloor(UnityInput.mousePosition.x, UnityInput.mousePosition.y-self.rtOffsetY, 0, self.ModelShowCam)
    UnitySetPos(self.objDrag, pos.x, pos.y, pos.z)
end

function CreateHullTempPanel:OnDragEnd(itemid)
    if self.objDrag == nil then 
        return
    end
    
    if (not self.mediator:CanAddComposeHull(itemid)) or  --根据组装技术判断空间
        (not self:VerifyComposeHull(itemid, self.objDrag)) then --组装部位判断
        g_InstancesPool:DeleteInst(self.objDrag)
    else
        --组装合理性判断
        self.uiBinder.m_btnNextStep.isEnabled = self.mediator:CheckIsHullValid()
    end
    
    self.objDrag = nil
end

--计算模块附着目标位置
function CreateHullTempPanel:CalDstAttchPart(attachpart)
    local ret = {}
    for k, v in pairs(attachpart) do
        if v == nil then
            ret[k] = AttachPartDef.eSHAP_Err
        else
            ret[k] = self:CalTargetHullAttchPart(k)
        end
    end
    return ret
end
--计算模块能附着的模块(能插入并且距离最短)
function CreateHullTempPanel:CalDstAttach(plugpart, attachpart)
    local countComposed = #self.lstHullModelComposed--已拼装
    local dismin = 9999999
    local attachto_part = AttachPartDef.eSHAP_Err
    local attachidx = 0
    for i=1, countComposed do
        local composed = self.lstHullModelComposed[i]
        for kk,vv in pairs(plugpart) do
            local part = vv
            local partsrc = self:CalTargetHullAttchPart(part)
            if part < AttachPartDef.eSHAP_Err then --源模块期望的附着位置
                --判断目标模块该位置有没有开放，而且没有其他模块附着
                if composed.obj ~= nil and composed.attachpart[part] ~= nil and 
                    (composed.beattached_idx == nil or composed.beattached_idx[part] == nil or composed.beattached_idx[part]<1) then
                    --table.insert(canDockIdx, i)
                    --可插入
                    local dis = CalDisSqrMWithTransf(attachpart[partsrc], composed.attachpart[part])
                    if dis < dismin then
                        dismin = dis
                        attachto_part = part
                        attachidx = i
                    end
                end
            end
        end
    end
    return attachidx, attachto_part
end

--判断放哪
function CreateHullTempPanel:VerifyComposeHull(itemid, obj)
    if obj == nil then 
        return false
    end
    if self.lstHullModelComposed == nil then 
        self.lstHullModelComposed = {}
    end

    local countComposed = #self.lstHullModelComposed--已拼装
    local modelpart = {}
    modelpart.obj = obj
    modelpart.itemid = itemid
    modelpart.attachpart = self:GetHullAttchPart(obj)
    modelpart.attachto_idx = 0
    if countComposed == 0 then --第一块，随便放
        self.lstHullModelComposed[1] = modelpart
        self.mediator:AddComposeHull(itemid, 0, 0)
        return true
    end 

    --判断附着, 原则, 比如a模块想附着b模块，b开放的附着位置为left,那只能用a的right去对应附着
    --自身模块插头位置
    local plugpart = self:CalDstAttchPart(modelpart.attachpart)
    
    --能附着的目标 lstHullModelComposed 索引
    local attchidx,attachto_part = self:CalDstAttach(plugpart, modelpart.attachpart)
    if attchidx == 0 then
        return false
    end
    --附着目标
    local dstAttach = self.lstHullModelComposed[attchidx]

    --计算位置
    local dstpos = dstAttach.attachpart[attachto_part].position
    local plugpart = self:CalTargetHullAttchPart(attachto_part)
    local tplug = modelpart.attachpart[plugpart]
    local lplugpos = tplug.position-obj.transform.position
    UnitySetPos(obj, dstpos.x-lplugpos.x, dstpos.y-lplugpos.y, dstpos.z-lplugpos.z)
    
    --加入结果
    modelpart.attachto_idx = attchidx
    modelpart.attachto_part = attachto_part
    self:AddBeattachIndex(dstAttach, attachto_part, countComposed+1)
    
    table.insert(self.lstHullModelComposed, modelpart)
    self:AddBeattachIndex(modelpart, self:CalTargetHullAttchPart(attachto_part), attchidx)
    self.mediator:AddComposeHull(itemid, attchidx, attachto_part)
    return true
end

function CreateHullTempPanel:AddBeattachIndex(def, part, idx)
    if def.beattached_idx == nil then 
        def.beattached_idx = {}
    end
    def.beattached_idx[part] = idx
end

--]]
--组件开放的附着点
function CreateHullTempPanel:GetHullAttchPart(obj)
    local scrpt = obj:GetComponent("HullAttacher")
    if scrpt == nil then
        return {}
    end
    return {scrpt.Head, scrpt.Tail, scrpt.Left, scrpt.Right, scrpt.Top, scrpt.Bottom}
    
end

--根据附着点计算目标附着点
local s_MappingTargetAttPart = {AttachPartDef.eSHAP_Tail, AttachPartDef.eSHAP_Head, AttachPartDef.eSHAP_Right, AttachPartDef.eSHAP_Left, AttachPartDef.eSHAP_Bottom, AttachPartDef.eSHAP_Top}
function CreateHullTempPanel:CalTargetHullAttchPart(part)
    if part >= 1 and part < AttachPartDef.eSHAP_Err then
        return s_MappingTargetAttPart[part]
    end

    return AttachPartDef.eSHAP_Err
end
---end 拖曳拼装相关

--通过一个现有模板初始化界面
function CreateHullTempPanel:InitByMod(mod)
    --根据配置组装hull
    local lstHull = mod.hullParts
    local n = #lstHull
    self.nLoadReq = n
    self.lstPreInst = {}
    --加载资源
    for i=1, n do
        local hull = lstHull[i] 
        g_InstancesPool:NewInst(self:GetHullModelName(hull.hullId), CreateHullTempPanel.OnHullModelLoaded2, self)
    end
end

function CreateHullTempPanel:OnHullModelLoaded2(obj)
    --如果已经不在组装状态了
    if not self.mediator:IsModifyStat() then
        return
    end
    table.insert(self.lstPreInst, obj)
    obj:SetActive(true)
    obj.transform.parent = self.ModelShow.transform
    UnitySetScale(obj,1,1,1)
    SetLocalRotation(obj,0,-90,0)
    SetLocalPosition(obj,1000,0,0)--先放到视野外
    self.nLoadReq = self.nLoadReq - 1
    if self.nLoadReq <= 0 then 
        local nm = #self.lstPreInst
        for i=1, nm do--
            self.lstPreInst[i]:SetActive(false)
        end
        --资源都加载好了，开始组装
        self.lstHullModelComposed = {}
        local mod = self.mediator:GetCurModifyMod()
        if mod == nil then
            return
        end
        local lstHull = mod.hullParts
        local n = #lstHull
        for i=1, n do
            local modelpart = {}
            local itemid = lstHull[i].hullId
            local attchidx = lstHull[i].attachIndex
            local attachto_part = lstHull[i].attachPart
            local obj = g_InstancesPool:NewInstSynch(self:GetHullModelName(itemid))
            obj:SetActive(true)
            modelpart.obj = obj
            modelpart.attachpart = self:GetHullAttchPart(modelpart.obj)
            modelpart.attachto_idx = attchidx
            modelpart.attachto_part = attachto_part
            if i == 1 then 
                self.lstHullModelComposed[i] = modelpart
                SetLocalPosition(modelpart.obj,0,0,0)
            else 
                local dstAttach = self.lstHullModelComposed[attchidx]
                --计算位置
                local dstpos = dstAttach.attachpart[attachto_part].position
                
                local plugpart = self:CalTargetHullAttchPart(attachto_part)
                local tplug = modelpart.attachpart[plugpart]
                local lplugpos = tplug.position-obj.transform.position
                UnitySetPos(obj, dstpos.x-lplugpos.x, dstpos.y-lplugpos.y, dstpos.z-lplugpos.z)
                
                local nm = #self.lstHullModelComposed
                self:AddBeattachIndex(dstAttach, attachto_part, nm+1)
    
                table.insert(self.lstHullModelComposed, modelpart)
                self:AddBeattachIndex(modelpart, self:CalTargetHullAttchPart(attachto_part), attchidx)
            end
        end
        --组件刷新
        self:FreshSeledCpntList()
        --组装合理性判断
        self.uiBinder.m_btnNextStep.isEnabled = self.mediator:CheckIsHullValid()
    end
end


return CreateHullTempPanel