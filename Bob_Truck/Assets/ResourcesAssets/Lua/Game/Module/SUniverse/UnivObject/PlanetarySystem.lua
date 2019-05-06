-- 描述一个恒星系内部

-- planet{
-- id, hexId, scale, mask
-- }
-- hexMap{
-- position[2]
-- } 

local PlanetarySystem = class("PlanetarySystem")

-- refs
local UnivBaseObject = require("Game/Module/SUniverse/UnivObject/UnivBaseObject");
local UnityScreen = UnityEngine.Screen;

local clsInstancePool = require("Common/InstancesPool")
local UnityCamForwardCastFloor = GameObjectUtil.CamForwardCastFloor

--utility functions
local UnityWorld3DPos2WorldUIPos = GameObjectUtil.World3DPos2WorldUIPos
local UnityIsWorld3DPosInScreen = GameObjectUtil.IsWorld3DPosInScreen
local SetPosition = GameObjectUtil.SetPosition
local SetLocalPosition = GameObjectUtil.SetLocalPosition
local SetScale = GameObjectUtil.SetScale

-- temp
local explorablePath = "UIPanel/SPlanetary/ExplorableHud.prefab"
local exploringPath = "UIPanel/SPlanetary/ExploreProgressHud.prefab"
local explorationResultPath = "UIPanel/SPlanetary/PlanetaryExploreResult.prefab"

local clsPlanet = require("Game/Module/SUniverse/UnivObject/Planet")      --描述单个星球
local clsBuilding = require("Game/Module/SUniverse/UnivObject/Building")  --描述单个建筑

function PlanetarySystem:ctor()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.planetaryProxy:LoadPlanetaryData()
    self.planetContainer = UnityEngine.GameObject.New("Planets")
    self.ringContainer = UnityEngine.GameObject.New("Rings")
    self.buildingContainer = UnityEngine.GameObject.New("Buildings")
    -- load prefab 
    self.ringPrefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Ring.prefab")
    self.beltPrefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/AsteroidBelt.prefab")
    self.nonePrefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Planets/Main/None.prefab")
    self.spaceStation01Prefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Buildings/spaceStation01.prefab")
    self.spaceStation02Prefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Buildings/spaceStation02.prefab")
    self.spaceStation03Prefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Buildings/spaceStation03.prefab")

    --self.cameraCtrl:AddCallback(self.OnMouseClick, self, 3)
    --self.cameraCtrl:AddCallback(self.OnViewChangedRealTime, self, 4)
    --self.cameraCtrl:AddCallback(self.OnViewChanged, self, 1)

    --self.instancePool = clsInstancePool.New()
    -- obj map 
    -- map 为 id -> obj的映射表
    self.gridMap = self.planetaryProxy:GetGridMapData()       -- 施工中，不做map用
    
    self.planetaryProxy:SetGrids(self.gridMap)
end


--构建行星系 (星球和grid)
function PlanetarySystem:BuildPlanetarySystem(nodeData)
    local planetaryProxy = self.planetaryProxy
    local gridMap = planetaryProxy:GetGridMapData()

    -- build suns
    local sunDataMap = planetaryProxy:GetSunDataMap()
    for idx, sunData in pairs(sunDataMap) do
        local sunPrefab = ManagerResourceModule.LuaLoadBundle(sunData.typeRes..".prefab")
        local sunGo = UnityEngine.GameObject.Instantiate(sunPrefab)
        sunGo.transform.parent = self.planetContainer.transform
        NGameObjectUtil.SetLocalPosition(sunGo,0,0,0)
        NGameObjectUtil.SetScale(sunGo, 3.5, 3.5, 3.5)
        
        local pos = sunGo.transform.position - UnityCamForwardCastFloor()
        local body = {x = pos.x, y = pos.z}
        Facade:SendNotification(NotiConst.Notify_InitCameraPos, body)

        for i = 1, 7 do
            for j = 1, 7 do
                planetaryProxy:AddGridsUsedByGridId(59059 - (i - 1) * 1000 - (j - 1))
            end
        end
    end

    local PlanetPlanePrefab = ManagerResourceModule.LuaLoadBundle('ModelFBX/Solarsystem/Planets/PlanetPlane.prefab')
    local PlanetPlaneGo = UnityEngine.GameObject.Instantiate(PlanetPlanePrefab)
    PlanetPlaneGo.transform.parent = self.planetContainer.transform
    NGameObjectUtil.SetLocalPosition(PlanetPlaneGo,0,0,0)

    -- build planet
    local planetMap = planetaryProxy:GetPlanetDataMap()
    for id, planetData in pairs(planetMap) do
        local planet = clsPlanet.New(planetData)
        planetGo = planet:BuildPlanet(self.planetContainer, self.ringContainer, planetData.gridId)
        planetData.obj = planetGo
    end
    --[[ build belt
    if belt then
        local hex = self.gridMap[belt.hexId]
        local r = math.sqrt(hex.position[1] * hex.position[1] + hex.position[2] * hex.position[2]) * 1.428
        local beltGO = UnityEngine.GameObject.Instantiate(self.beltPrefab)
        beltGO.transform.parent = self.ringContainer.transform
        NGameObjectUtil.SetScale(beltGO,r,r,r)
        --激活可采集的区域
        for i,hexId in ipairs(belt.refHexId) do
            self.hexes:LightHexById(hexId)
        end
    end
    --
    local relic = self.planetaryProxy:GetRelic()
    if relic then
        --激活文明遗迹点
        self.hexes:LightHexById(relic.hexId)
    end
    local spectacleId = self.planetaryProxy:GetSpectacleId()]]

    local buildMap = planetaryProxy:GetBuildingData()

    planetaryProxy:InitbuildingClassTable()

    for k, v in pairs(buildMap)do
        local building = clsBuilding.New(v)
        planetaryProxy:AddbuildingClassTable(building)
        local buildingGo = building:BuildBuilding(self.planetContainer, v.pos)
        v.building = building

        local type = self.planetaryProxy:GetBuildingType(v.buildingConfigId)
        if type == common_pb.SPACEPORT then
            local body = {buildingId = v.id, data = v.fleets}
            Facade:SendNotification(NotiConst.Notify_InitFleetPortShip, body)
        end
    end
end

-- 相机移动实时回调
function PlanetarySystem:OnViewChangedRealTime()
    self:UpdateAllPlanetsHud()
end

-- 根据当前的operation添加相应的hud
function PlanetarySystem:UpdateOperationHud()
    local planetaryProxy = self.planetaryProxy:GetOperationList()
end

-- 给planet添加exploringhud
function PlanetarySystem:OpenExploringHud(id)
    self:ClosePlanetHud(id, explorablePath)
    self:OpenPlanetHud(id, exploringPath)
    return self:UpdateSinglePlanetHud(id)
end

-- 给所有planet绑定对应的hud
function PlanetarySystem:SetPlanetHud()
    local planetMap = self.planetaryProxy:GetPlanetDataMap()
    for id, planetData in pairs(planetMap) do
        --TODO
    end
end

-- 更新所有planet的hud
function PlanetarySystem:UpdateAllPlanetsHud()
    local planetHudBindList = self.planetHudBindList
    local planetaryProxy = self.planetaryProxy
    
    for id, bindHuds in pairs(planetHudBindList) do
        local visible = planetaryProxy:IsPlanetVisible(id)
        self:UpdateHudInfo(id, bindHuds, visible)
    end
end

-- 立即更新单个planet的hud， 并返回obj
function PlanetarySystem:UpdateSinglePlanetHud(id)
    local visible = self.planetaryProxy:GetPlanetPosInUIWorld(id)
    local bindHuds = self.planetHudBindList[id]
    self:UpdateHudInfo(id, bindHuds, visible)
end

--更新单个planet的hud
function PlanetarySystem:UpdateHudInfo(id, BindHuds, visible)
    if visible == true then
        local pos2D = self.planetaryProxy:GetPlanetPosInUIWorld(id)
        for idx, hudInfo in pairs(BindHuds) do
            local obj = hudInfo.obj
            if obj ~= nil then          -- hud is showing , change pos
                SetPosition(hudInfo.obj, pos2D.x, pos2D.y, 0)
            else            -- hud is hide, new instance & show it
                self.instancePool:NewInst(hudInfo.name, function(this, obj)
                    obj:SetActive(true)
                    SetPosition(obj, pos2D.x, pos2D.y, 0)
                    SetScale(obj, 1, 1, 1)
                    hudInfo.obj = obj
                end, nil)
            end
        end
    else
        for idx, hudInfo in pairs(BindHuds) do
            local obj = hudInfo.obj
            if obj ~= nil then
                hudInfo.obj:SetActive(false)
                hudInfo.obj = nil
            end
        end
    end 
end

-- 添加hud测试用例
-- function PlanetarySystem:AddTestHudInfo()
--     local planetsList = self.planetsList
--     for idx, planetData in pairs(planetsList) do
--         self:OpenPlanetHud(planetData.id, "UIPanel/SPlanetary/ExplorableHud.prefab")
--     end
-- end

--给一个planet绑定hud 
function PlanetarySystem:OpenPlanetHud(id, name)
    local planetHudBindList = self.planetHudBindList
    if planetHudBindList[id] == nil then
        planetHudBindList[id] = {}
    end
    local bindHuds = planetHudBindList[id]

    local hudInfo = {}
    hudInfo.obj = nil
    hudInfo.name = name
    table.insert(bindHuds, hudInfo)
end

function PlanetarySystem:ClosePlanetHud(id, name)
    local planetHudBindList = self.planetHudBindList
    local bindHuds = planetHudBindList[id]
    if bindHuds ~= nil then
        for idx, hudInfo in pairs(bindHuds) do
            if name == hudInfo.name then
                local obj = hudInfo.obj
                if obj ~= nil then
                    obj:SetActive(false)
                end
                table.remove(bindHuds, idx)
                break
            end
        end
    end
end

function PlanetarySystem:GetPlanetHudObj(id, name)
    local bindHuds = self.planetHudBindList[id]
    for idx, hudInfo in pairs(bindHuds) do
        if hudInfo.name == name then
            return hudInfo.obj
        end
    end
    return nil
end

--设定planet的状态
function PlanetarySystem:SetPlanetStatusByPlanetId(planetId, status)
    local planet = GetPlanetByPlanetId(planetId)
    if planet ~= nil then
        planet.status = status
    else
        LogDebug("planet{id=" .. planetId "} doesnot exist")
    end
end


function PlanetarySystem:Release()
    
end

return PlanetarySystem