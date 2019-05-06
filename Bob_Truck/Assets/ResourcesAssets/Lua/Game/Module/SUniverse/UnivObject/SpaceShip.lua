--舰队，世界中的移动主体
local UnivDynamicObj = require("Game/Module/SUniverse/UnivObject/UnivDynamicObj")
local UnivBaseObject = require("Game/Module/SUniverse/UnivObject/UnivBaseObject")
local __super = UnivDynamicObj;
local SpaceShip = class("SpaceShip", __super);

function SpaceShip:ctor(id)
    __super.ctor(self, id);
end

function SpaceShip:Init(cfg, parent, loadCall)
	self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.cfg = cfg--proto数据无法用clone复制,要再赋值
    self.shipData = self.cfg.shipData
    self.inited = false
    self.instList = {}
	__super.Init(self, cfg, parent, loadCall)
end

function SpaceShip:InitAppearance()
	if self.transform ~= nil then
		return
    end
	g_InstancesPool:NewInst("EmptyGameObject", self.OnResLoaded, self);
end

function SpaceShip:OnResLoaded(obj)
    __super.OnResLoaded(self, obj)
	self:InitModelShow(obj)
end

function SpaceShip:InitModelShow(obj)
    obj:SetActive(false)
    self.inited = true
    table.insert(self.instList,obj)
    GameObjectUtil.SetScale(obj,self.cfg.scale,self.cfg.scale,self.cfg.scale)
    self.ModelParent = obj.transform
    self.gridGroup = {}
	self.hasLoaded = {}
	
    self.hullList = self.shipData.hullParts
    if self.hullList and #self.hullList > 0 then
        for i,v in ipairs(self.hullList) do
            local grid = {}
            grid.hullId = v.hullId
            grid.left = v.left
            grid.right = v.right
            grid.front = v.front
            grid.back = v.back
            grid.index = v.attachIndex

            table.insert(self.gridGroup, grid)
        end

        local grid = self.gridGroup[1]
        g_InstancesPool:NewInst(self:GetHullModelName(grid.hullId), self.OnHullModelLoaded, self, {grid = grid})
    end
    
end

function SpaceShip:GetHullModelName(hullId)
    local hullConfigData = self.planetaryProxy:GetShipHullConfigData(hullId)
    return "ModelFBX/ship/transport/"..hullConfigData.data[hullConfigData.EVar["prefab_name_s"]]..".prefab"
end

--修改模板时使用
function SpaceShip:OnHullModelLoaded(obj, data)
    if obj == nil then 
        return
    end
    table.insert(self.instList,obj)
    obj.transform.parent = self.ModelParent
    GameObjectUtil.SetScale(obj,1,1,1)
	GameObjectUtil.SetLocalRotation(obj,0,0,0)
	obj:SetActive(true)
    local grid = data.grid
    grid.modelObj = obj.transform
    local gridFrom = data.from

    GameObjectUtil.SetLocalPosition(obj,0,0,0)
    if gridFrom then
        local pos = nil
        if gridFrom.left == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("left").position - grid.modelObj:Find("right").position
        elseif  gridFrom.right == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("right").position - grid.modelObj:Find("left").position
        elseif  gridFrom.front == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("front").position - grid.modelObj:Find("back").position
        elseif  gridFrom.back == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("back").position - grid.modelObj:Find("front").position
        end
        if pos then
            GameObjectUtil.SetPosition(grid.modelObj.gameObject, pos.x, pos.y, pos.z)
        end
    end


    table.insert(self.hasLoaded, grid.index)

    if grid.left ~= nil and grid.left > 0 and not self:IsLoaded(grid.left) then
        local tempGrid = self:GetGuidByIndex(grid.left)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.right ~= nil and grid.right > 0 and not self:IsLoaded(grid.right) then
        local tempGrid = self:GetGuidByIndex(grid.right)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.front ~= nil and grid.front > 0 and not self:IsLoaded(grid.front) then
        local tempGrid = self:GetGuidByIndex(grid.front)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.back ~= nil and grid.back > 0 and not self:IsLoaded(grid.back) then
        local tempGrid = self:GetGuidByIndex(grid.back)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if #self.hasLoaded == #self.hullList then
        self:OnOneFleet3DCompleted()
    end
end

function SpaceShip:IsLoaded(index)
    for i=1,#self.hasLoaded do
        if self.hasLoaded[i] == index then
            return true
        end
    end
    return false
end 

function SpaceShip:GetGuidByIndex(index)
    if index == nil or index == 0 then
        return nil
    end

    for i=1,#self.gridGroup do
        if self.gridGroup[i].index == index then
            return self.gridGroup[i]
        end
    end
    return nil
end

function SpaceShip:OnOneFleet3DCompleted()
    if self.transform then
        self.transform.gameObject:SetActive(true)
    end
end

function SpaceShip:SetViewStatus(bInView)
    __super.SetViewStatus(self,bInView)
    if bInView and self.transform and not self.inited then
	    self:InitModelShow(self.transform.gameObject)
    elseif not bInView then
        for i,v in ipairs(self.instList) do
            g_InstancesPool:DeleteInst(v)
        end
        self.instList = {}
        self.inited = false
    end
end

return SpaceShip;
