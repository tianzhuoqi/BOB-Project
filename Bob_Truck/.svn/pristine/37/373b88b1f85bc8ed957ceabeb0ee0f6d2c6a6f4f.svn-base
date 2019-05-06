--舰队，世界中的移动主体
local UnivDynamicObj = require("Game/Module/SUniverse/UnivObject/UnivDynamicObj")
local UnivBaseObject = require("Game/Module/SUniverse/UnivObject/UnivBaseObject")
local SpaceShip = require("Game/Module/SUniverse/UnivObject/SpaceShip")
local __super = UnivDynamicObj
local SpaceFleet = class("SpaceFleet", __super)

SpaceFleet.fleetPosition = {
	{0,0},{-1.6,-2},{1.6,-2},{-1.6,-4},{1.6,-4},{-1.6,-6},{1.6,-6},{-1.6,-8},{1.6,-8},{0,-10}
} --列队



function SpaceFleet:ctor(id)
    __super.ctor(self, id);
end

function SpaceFleet:Init(cfg, parent, loadCall)
	__super.Init(self, cfg, parent, loadCall)
	self.cfg = cfg--proto数据无法用clone复制,要再赋值
	self:InitModelShow()
end

function SpaceFleet:InitModelShow()
	self:CleanChild()
	local ship = UnivBaseObject.New();
	ship:Init(self.cfg.shipIcon, self,self.BuildIconFinished);
	self:AddChild(ship);
	self.shipsGo = {}
	self.iconGo = ship
	for i,v in ipairs(self.cfg.makeData) do
		local shipCfg = {
			pos = SpaceFleet.fleetPosition[i],
			scale = 0.12,
			rot = {0, 0, 0},
			shipData = v,
		}
		local ship = SpaceShip.New();
		ship:Init(shipCfg, self, self.BuildOneShipFinished);
		self:AddChild(ship);
		table.insert(self.shipsGo,ship)
	end
	self.showFleet = false
	self.inited = true
end

function SpaceFleet:BuildOneShipFinished(obj)
	obj:SetActive(false)
	self:SetShowIn() --同步状态
end

function SpaceFleet:InitAppearance()
	if self.transform ~= nil then
		return
	end
	g_InstancesPool:NewInst("EmptyGameObject", __super.OnResLoaded, self);
end

function SpaceFleet:BuildIconFinished(obj)
	GameObjectUtil.SetScale(obj,self.cfg.shipIcon.scale,self.cfg.shipIcon.scale,self.cfg.shipIcon.scale)
	self:SetShowIn() --同步状态
	
end

function SpaceFleet:SetShowState(cameraY)
	local showFleet = (cameraY <= 60)
	self:SetShowIn(showFleet)
end

function SpaceFleet:SetShowIn(showFleet)
	if showFleet == nil then
		showFleet = false
	end
	local loaded = 0
	if self.iconGo then
		self.iconGo:SetViewStatus(not self.showFleet)
	end
	if self.shipsGo then
		for i,v in ipairs(self.shipsGo) do
			v:SetViewStatus(self.showFleet)
		end
	end
	self.showFleet = showFleet
end

function SpaceFleet:SetViewStatus(bInView)
    __super.SetViewStatus(self,bInView)
    if bInView and self.transform and not self.inited then
	    self:InitModelShow(self.transform.gameObject)
    elseif not bInView then
		self:CleanChild()
		self.shipsGo = {}
		self.iconGo = ship
		self.inited = false
    end
end

return SpaceFleet;

