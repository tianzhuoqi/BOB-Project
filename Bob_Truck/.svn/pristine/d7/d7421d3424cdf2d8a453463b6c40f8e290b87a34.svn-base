--[[
描述一个星系
--]]
local UnivBaseObject = require("Game/Module/SUniverse/UnivObject/UnivBaseObject");
local __super = UnivBaseObject;
local Galaxy = class("Galaxy", __super);
local UnityIsWorld3DPosInScreen = GameObjectUtil.IsWorld3DPosInScreen
local UnityScreen = UnityEngine.Screen;
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition;
local UnitySetScale = GameObjectUtil.SetScale;

local RendererQueueTable = {}
local RendererQueueTableLenth = 0

function Galaxy:ctor(id)
	__super.ctor(self,id);
	self.LodTable = {};
	self.lod = 1
end

function Galaxy:Init(cfg, universe)
	__super.Init(self, cfg, universe);
	for i=1, #self.cfg.stars do 
		local star = UnivBaseObject.New();
		star:Init(self.cfg.stars[i], self);
		self:AddChild(star);
	end
end

function Galaxy:InitAppearance()
	if self.transform ~= nil then 
		return;
	end
	g_InstancesPool:NewInst("EmptyGameObject", self.OnResLoaded, self);
end

function Galaxy:WaitChildLoad(self)
	while true do
		local flag = false
		for i = 1, #self.lstChilds do
			if self.lstChilds[i].transform == nil then
				flag = true
				break
			end
		end
		if not flag then
			break
		else
			WaitForFixedUpdate()
		end
	end
	
	self.LodTable = {}
	for i = 1, #self.lstChilds do
		for j = 0, 2 do
			local lod = self.lstChilds[i].transform:Find('lod'..j)
			table.insert(self.LodTable, lod.gameObject)
			if j ~= 0 then
				local mat = lod:GetComponent('Renderer').sharedMaterial
				if RendererQueueTable[mat.name] == nil then
					RendererQueueTable[mat.name] = 1
					RendererQueueTableLenth = RendererQueueTableLenth + 1
					mat.renderQueue = 3000 + RendererQueueTableLenth
				end
			end
		end
	
		if self.cfg.stars[i].scale ~= nil and self.LodTable[1] ~= nil then
			UnitySetScale(self.LodTable[1].gameObject, self.cfg.stars[i].scale, self.cfg.stars[i].scale, self.cfg.stars[i].scale);
			UnitySetScale(self.LodTable[2].gameObject, self.cfg.stars[i].scale, self.cfg.stars[i].scale, self.cfg.stars[i].scale);
		end
	end
	self:ChangeLod(self.lod)
end

function Galaxy:OnResLoaded( obj )
	__super.OnResLoaded(self, obj)
	StartCoroutine(self.WaitChildLoad, self)
end

function Galaxy:ChangeLod(lodLevel)
	self.lod = lodLevel
	for i = 1,  #self.LodTable do
		if i == lodLevel + 1 then
			UnitySetLocalPos(self.LodTable[i], 0, 0, 0)
		else
			UnitySetLocalPos(self.LodTable[i], 10000, 0, 0)
		end
	end
end

function Galaxy:ShowHud(show)
	if show then 
		self.parent.UIItemPool:PostShowHudReq(self, Galaxy.OnHudLoaded)
	else
		self.parent.UIItemPool:PostRmvHudReq(self)
	end
end

local safeLeveTable = 
{
	"A", "B", "C", "D", "E"
}

local aryFleetIconSpriteName = {"c1icj01", "c1icj02", "c1icj03", "c1icj04"}
function Galaxy:OnHudLoaded(uiBinder)
	if uiBinder == nil then 
		return
	end
	
	local UniverseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
	local FleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
	local fleetData = FleetProxy:GetFleetListInfoData()
	local isExplored = UniverseProxy:IsExploredNode(self.ID) --探索标记
	local isOcc = UniverseProxy:IsOccupiedNode(self.ID)	--占领标记

	uiBinder.owner_icon.gameObject:SetActive(isOcc)

	if isOcc or isExplored then 
		uiBinder.title.text = UniverseProxy:GetNodeName(self.ID)
		if uiBinder.title.text == '' or uiBinder.title.text == nil then
			uiBinder.title.gameObject:SetActive(false)
		else
			uiBinder.title.gameObject:SetActive(true)
		end
		uiBinder.mask1.alpha = 1
	else 
		uiBinder.title.text = '???'
		uiBinder.mask1.alpha = 0
	end

	local fleetCount = 0

	for i = 1, #fleetData do
		if fleetData[i].nodeId == self.ID and fleetData[i].fromNodeId == fleetData[i].toNodeId then
			fleetCount = fleetCount + 1
		end
	end
	if fleetCount > 0 then
		uiBinder.fleet_info:SetActive(true)
		local num = uiBinder.fleet_info.transform:Find('num'):GetComponent("UILabel")
		num.text = fleetCount
		uiBinder.fleet_info2:SetActive(true)
		local num1 = uiBinder.fleet_info2.transform:Find('num'):GetComponent("UILabel")
		num1.text = fleetCount
	else
		uiBinder.fleet_info:SetActive(false)
		uiBinder.fleet_info2:SetActive(false)
	end

	uiBinder.safe_level.text = 'Lv'..safeLeveTable[tonumber(self.cfg.slv[1]) + 1]..self.cfg.slv[2]
	for i = 1, #uiBinder.styleList do
		if #self.cfg.ResCount == i then
			for j = 1, i do
				local icon = uiBinder.styleList[i].transform:Find('item'..j):GetComponent('UISprite')
				icon.spriteName = DATA_ITEM_MIN[self.cfg.ResCount[j]][DATA_ITEM_MIN.EVar.small_icon_name_s]
				local text = icon.transform:Find('label'):GetComponent('UILabel')
				text.text = self.cfg.ResV[j]
			end
			uiBinder.styleList[i]:SetActive(true)
		else
			uiBinder.styleList[i]:SetActive(false)
		end
	end
end

--判断一个点是否在该星系
function Galaxy:IsPosIn(x, z)
	if not self.bInView then 
		return false;
	end
	local radus = self.cfg.r;--该星系的半径
	--矩形判断就ok
	local l = self.cfg.pos[1]-radus;
	local t = self.cfg.pos[2]-radus;
	local r = self.cfg.pos[1]+radus;
	local b = self.cfg.pos[2]+radus;
	return x >= l and x <= r and z >= t and z <= b;
end

return Galaxy;