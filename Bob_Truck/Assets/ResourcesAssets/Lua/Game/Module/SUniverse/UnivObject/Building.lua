local Building = class("Building")

local clsBuildingObjectMod = require("Game/Module/SUniverse/UnivObject/BuildingObjectMod")  --描述将要建造的建筑
local resPath = 'ModelFBX/Solarsystem/Buildings/'
local UnityCamForwardCastFloor = GameObjectUtil.CamForwardCastFloor
local SpaceShip = require("Game/Module/SUniverse/UnivObject/SpaceShip")
-- 这里的BuildingData是node.proto里的NodeBuilding
function Building:ctor(BuildingData)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.data = BuildingData
    self.buildingConfigData = DATA_BUILDING[self.data.buildingConfigId]
    local type = self.planetaryProxy:GetBuildingType(self.data.buildingConfigId)
    self.shipTable = {}
end

function Building:SetData(BuildingData)
    self.data = BuildingData
end

-- 创建planet对象并显示，返回obj
function Building:BuildBuilding(planetContainer,gridId)
    if self.data == nil then
        LogDebug("BuildingData is nil!!")
    end

    local pathName = resPath

    pathName = pathName..DATA_BUILDING[self.data.buildingConfigId][DATA_BUILDING.EVar['prefab_name_s']]..'.prefab'

    local buildingPrefab = ManagerResourceModule.LuaLoadBundle(pathName)
    self.buildingGo = UnityEngine.GameObject.Instantiate(buildingPrefab)
    self.buildingGo.transform.parent = planetContainer.transform
    self.gridId = gridId

    local xy = self:GetBuildingCenter()
    NGameObjectUtil.SetLocalPosition(self.buildingGo, xy.x, 0, xy.y)
    NGameObjectUtil.SetScale(self.buildingGo, 0.1, 0.1, 0.1)

    local buildingSize = self:GetBldgSize() + 1
    for i = 1, buildingSize do
        for j = 1, buildingSize do
            self.planetaryProxy:AddGridsUsedByGridId(gridId - (i - 1) * 1000 - (j - 1), self.data.id)
        end
    end

    -- local NLuaClickEvent = NLuaClickEvent.Get(self.buildingGo)
    -- NLuaClickEvent:Add3DClick(self, self.OnClick)

    self:AddBuildingAnimation()

    local type = self.planetaryProxy:GetBuildingType(self.data.buildingConfigId)
    if type == common_pb.SPACESTATION or type == common_pb.POWERPLANT then -- 基地
        local powerRangePrefab = ManagerResourceModule.LuaLoadBundle('ParticleEffects/powerRange.prefab')
        self.powerRangegGo = UnityEngine.GameObject.Instantiate(powerRangePrefab)
        self.powerRangegGo.transform.parent = self.buildingGo.transform.parent
        local buildingCenter = self:GetBuildingCenter()
        local powerSupplyRange = self.planetaryProxy:GetPowerSupplyRange(self.data.buildingConfigId)

        NGameObjectUtil.SetPosition(self.powerRangegGo, buildingCenter.x, 0, buildingCenter.y)
        NGameObjectUtil.SetScale(self.powerRangegGo, powerSupplyRange, powerSupplyRange, powerSupplyRange)
        local pos = self.buildingGo.transform.position - UnityCamForwardCastFloor()
        local body = {x = pos.x, y = pos.z}
        Facade:SendNotification(NotiConst.Notify_InitCameraPos, body)
        self.powerRangegGo:SetActive(false)
    end

    return self.buildingGo
end

function Building:AddBuildingAnimation()
    if self.data.startTime > 0 then
        local size = self.buildingConfigData[DATA_BUILDING.EVar.bldg_size_n]
        local path = ''
        if size == 1 then
            path = 'ModelFBX/Solarsystem/Buildings/build_2X2/build_2X2.prefab'
        elseif size == 2 then
            path = 'ModelFBX/Solarsystem/Buildings/build_3X3/build_3X3.prefab'
        elseif size == 3 then
            path = 'ModelFBX/Solarsystem/Buildings/build_4X4/build_4X4.prefab'
        end
        local modelAnim = ManagerResourceModule.LuaLoadBundle(path)
        self.modelAnimGo = UnityEngine.GameObject.Instantiate(modelAnim)
        NGameObjectUtil.SetScale(self.modelAnimGo, 0.1, 0.1, 0.1)
        self.modelAnimGo.transform.parent = self.buildingGo.transform
        NGameObjectUtil.SetLocalPosition(self.modelAnimGo, 0, 0, 0)
        NGameObjectUtil.SetScale(self.buildingGo, 0.07, 0.07, 0.07)
        self.animator = self.modelAnimGo:GetComponent("Animator")
    end
end

function Building:PlayConstructionCompletedAnimation()
    self.animator:SetTrigger("ConstructionCompleted")
end

function Building:MovePos(gridId)
    local buildingSize = self:GetBldgSize() + 1
    for i = 1, buildingSize do
        for j = 1, buildingSize do
            self.planetaryProxy:RemoveGridsUsedByGridId(self.gridId - (i - 1) * 1000 - (j - 1))
        end
    end

    self.gridId = gridId

    local xy = self:GetBuildingCenter()
    NGameObjectUtil.SetLocalPosition(self.buildingGo, xy.x, 0, xy.y)
    NGameObjectUtil.SetScale(self.buildingGo, 0.1, 0.1, 0.1)

    for i = 1, buildingSize do
        for j = 1, buildingSize do
            self.planetaryProxy:AddGridsUsedByGridId(self.gridId - (i - 1) * 1000 - (j - 1), self.data.id)
        end
    end
end

function Building:IsShowPowerRangeg(isShow)
    if self.powerRangegGo ~= nil then
        self.powerRangegGo:SetActive(isShow)
    end
end

function Building:InitShip(shipData)
    for i = 1, #self.shipTable do
        self.shipTable[i].go:Destroy()
    end
    self.shipTable = {}
    for i = 1, #shipData do
        local shipPrefab = ManagerResourceModule.LuaLoadBundle('ModelFBX/ship/w_ship_00101.prefab')
        shipGo = UnityEngine.GameObject.Instantiate(shipPrefab)
        shipGo.transform.parent = self.buildingGo.transform
        NGameObjectUtil.SetLocalPosition(shipGo, i * 10, 0, i * 10)
        local data = {shipData = shipData, go = shipGo}
        table.insert( self.shipTable, data)
    end
end

function Building:OnClick()
    Facade:SendNotification(NotiConst.Notify_CloseEditBuildingMod)

    local isContinue = self:ReceivingJudgment()
    if not isContinue then
        return
    end
    self.planetaryProxy:SetCurBuildingOper(
        {
            uid = GetServerTimeStamp(),
            nodeId = self.planetaryProxy:GetPlanetaryId(),
            targetBuilding = self.data.id,
            configId = self.data.buildingConfigId,
            type = 0,
            building = self,
            dynamicData = {}
        }
    )

    Facade:ReplacePanel("BuildingInteractivePanel")
end

function Building:ShowBuildingObjMod()
    local body = {buildingConfigId = self.data.buildingConfigId, gridId = self.gridId, id = self.data.id}
    Facade:SendNotification(NotiConst.Notify_PlanetChooseBuilding, body)

    local buildingSize = self:GetBldgSize() + 1
    for i = 1, buildingSize do
        for j = 1, buildingSize do
            self.planetaryProxy:RemoveGridsUsedByGridId(self.gridId - (i - 1) * 1000 - (j - 1))
        end
    end
    if self.buildingGo ~= nil then
        self.buildingGo:SetActive(false)
    end
end

function Building:CloseBuildingObjMod()
    local buildingSize = self:GetBldgSize() + 1
    for i = 1, buildingSize do
        for j = 1, buildingSize do
            self.planetaryProxy:AddGridsUsedByGridId(self.gridId - (i - 1) * 1000 - (j - 1), self.data.id)
        end
    end
    if self.buildingGo ~= nil then
        self.buildingGo:SetActive(true)
    end
end

function Building:Destroy()
    if self.modelAnimGo ~= nil then
        self.modelAnimGo:Destroy()
        self.modelAnimGo = nil
    end
    --舰船模型销毁
    if self.shipsGo and #self.shipsGo > 0 then
        for i,v in ipairs(self.shipsGo) do
            v:SetViewStatus(false)
        end
    end
    if self.buildingGo ~= nil then
        local buildingSize = self:GetBldgSize() + 1
        for i = 1, buildingSize do
            for j = 1, buildingSize do
                self.planetaryProxy:RemoveGridsUsedByGridId(self.gridId - (i - 1) * 1000 - (j - 1))
            end
        end

        self.buildingGo:Destroy()
        self.buildingGo = nil
    end

    if self.powerRangegGo ~= nil then
        self.powerRangegGo:Destroy()
        self.powerRangegGo = nil
    end
end

function Building:ReceivingJudgment()
    local type = self.planetaryProxy:GetBuildingType(self.data.buildingConfigId)
    if type == common_pb.SURFCOL or type == common_pb.REFINERY or type == common_pb.HULLFACT then -- 地表采集
        local isShow = self.planetaryProxy:GetHexHudInfoState(self.data.pos)
        local nodeId = self.planetaryProxy:GetPlanetaryId()
        local isFull = self.storehouseProxy:IsStorehouseFull(nodeId)
        local isCanReceive = function(buildingId)
            local time = GetServerTimeStamp()
            local buildData = self.planetaryProxy:GetBuildingDataById(buildingId)
            if buildData ~= nil and buildData.getItemTime ~= nil and buildData.getItemTime ~= -1 and buildData.getItemTime/1000 < time then
                return true
            else
                return false
            end
        end
        if isFull and isShow then
            return false
        elseif not isFull and isShow and isCanReceive(self.data.id) then
            return false
        end
    end
    return true
end

--建筑体量
function Building:GetBldgSize()
    return self.buildingConfigData[DATA_BUILDING.EVar.bldg_side_length_n] - 1
end

--根据gridId获取建筑点
function Building:GetBuildingPosByGridId(gridId)
    local x = (gridId - gridId % 1000) / 1000 - 55
    local y = gridId % 1000 - 55
    return { x = x, y = y }
end

--获取建筑中心点
function Building:GetBuildingCenter()
    local bldgSize = self:GetBldgSize()
    local buildingPos = self:GetBuildingPosByGridId(self.gridId)
    local x = buildingPos.x - bldgSize * 0.5
    local y = buildingPos.y - bldgSize * 0.5
    return { x = x, y = y}
end

--是否在供电范围
function Building:IsInPowerSupplyRange(centerPos)
    local buildingCenter = self:GetBuildingCenter()
    local powerSupplyRange = self.planetaryProxy:GetPowerSupplyRange(self.data.buildingConfigId) * 0.5
    local distanceSq = (centerPos.x - buildingCenter.x) * (centerPos.x - buildingCenter.x) + (centerPos.y - buildingCenter.y) * (centerPos.y - buildingCenter.y) - powerSupplyRange * powerSupplyRange
    return distanceSq <= 0
end

function Building:BuildPortShip(userFleets)
    --舰船模型销毁
    if self.shipsGo and #self.shipsGo > 0 then
        for i,v in ipairs(self.shipsGo) do
            v:SetViewStatus(false)
        end
    end
    self.shipsGo = {}
    local fleetPos = {}
    local trans = self.buildingGo.transform
    for i=1,10 do
        table.insert(fleetPos,trans:Find("ship_"..i))
    end
    --构建Obj所需参数
    self.transform = trans
    self.bInView = true
    if userFleets then
        for i,v in ipairs(userFleets) do
            if i > 10 then
                break
            end
            local p = fleetPos[i].localPosition
            local shipCfg = {
                pos = {p.x,p.y,p.z},
                scale = 0.3,
                rot = {0, -90, 0},
                shipData = v.userShips[1],
            }
            local ship = SpaceShip.New();
            ship:Init(shipCfg, self, self.BuildOneShipFinished);
            ship:SetViewStatus(true)
            table.insert(self.shipsGo,ship)
        end
    end
end

function Building:BuildOneShipFinished(obj,cfg)
    GameObjectUtil.SetScale(obj,cfg.scale,cfg.scale,cfg.scale)
end

return Building