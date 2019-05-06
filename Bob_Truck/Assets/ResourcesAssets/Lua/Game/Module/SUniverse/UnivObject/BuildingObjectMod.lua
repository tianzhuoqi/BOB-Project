local BuildingObjectMod = class("BuildingObjectMod")

local resFBXPath = 'ModelFBX/Solarsystem/Buildings/'

local resObjPath = 'ModelFBX/Solarsystem/PlanetaryBuildingObject.prefab'

local HullCfg = DATA_SHIP_HULL_TECH

local UpdateBeat = UpdateBeat

local UnityInput = UnityEngine.Input

local UILayer = LayerMask.NameToLayer('3DUI')

function BuildingObjectMod:ctor(BuildingData)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.data = BuildingData
    self.buildingConfigData = DATA_BUILDING[self.data.buildingConfigId]
end

-- 创建planet对象并显示，返回obj
function BuildingObjectMod:BuildBuilding(planetContainer,gridId)
    if self.data == nil then
        LogDebug("BuildingData is nil!!")
    end

    self.textureRed = ManagerResourceModule.LuaLoadBundleTexture('ModelFBX/Solarsystem/Planets/Textures/Buildgrid_red.png')
    self.textureGray = ManagerResourceModule.LuaLoadBundleTexture('ModelFBX/Solarsystem/Planets/Textures/Buildgrid_gray.png')
    self.textureYellow = ManagerResourceModule.LuaLoadBundleTexture('ModelFBX/Solarsystem/Planets/Textures/Buildgrid_yellow.png')
    self.textureGreen = ManagerResourceModule.LuaLoadBundleTexture('ModelFBX/Solarsystem/Planets/Textures/Buildgrid_green.png')

    self.gridId = gridId

    local resObjPrefab = ManagerResourceModule.LuaLoadBundle(resObjPath)
    self.resObjGo = UnityEngine.GameObject.Instantiate(resObjPrefab)
    
    local buildingGoParent = self.resObjGo.transform:Find('buildingFBX')
    
    local buildingPrefab = ManagerResourceModule.LuaLoadBundle(resFBXPath..DATA_BUILDING[self.data.buildingConfigId][DATA_BUILDING.EVar['prefab_name_s']]..'.prefab')
    local buildingGo = UnityEngine.GameObject.Instantiate(buildingPrefab)
    NGameObjectUtil.SetScale(buildingGo, 0.1, 0.1, 0.1)
    buildingGo.transform.parent = buildingGoParent
    buildingGo.layer = UILayer
    local capsuleCollider = buildingGo:GetComponent("CapsuleCollider")
    if capsuleCollider ~= nil then
        capsuleCollider.enabled = false
    end

    local NLuaClickEvent = NLuaClickEvent.Get(self.resObjGo)
    NLuaClickEvent:Add3DPress(self, self.OnPress)

    local type = self.planetaryProxy:GetBuildingType(self.data.buildingConfigId)
    if type == common_pb.SPACESTATION or type == common_pb.POWERPLANT then -- 基地电厂
        local powerRangePrefab = ManagerResourceModule.LuaLoadBundle('ParticleEffects/powerRange.prefab')
        self.powerRangegGo = UnityEngine.GameObject.Instantiate(powerRangePrefab)
        self.powerRangegGo.transform.parent = buildingGo.transform.parent
        local powerSupplyRange = self.planetaryProxy:GetPowerSupplyRange(self.data.buildingConfigId)

        NGameObjectUtil.SetPosition(self.powerRangegGo, 0, 0, 0)
        NGameObjectUtil.SetScale(self.powerRangegGo, powerSupplyRange, powerSupplyRange, powerSupplyRange)
    end
    

    local buildingSize = DATA_BUILDING[self.data.buildingConfigId][DATA_BUILDING.EVar['bldg_side_length_n']] - 1
    local GridsSize = 9

    self.Grids = {}
    local grids = self.resObjGo.transform:Find('Grids')

    --占地为奇数的建筑
    if buildingSize % 2 == 0 then
        GridsSize = GridsSize - 1
    end

    for i = 1, 64 do
        local grid = grids:Find('grid'..i).gameObject
        grid:SetActive(false)
    end
    

    local bs = GridsSize + 1
    local xy = self.planetaryProxy:GetPosByGridId(gridId)
    NGameObjectUtil.SetLocalPosition(self.resObjGo, xy.x - buildingSize * 0.5, 0, xy.y - buildingSize * 0.5)

    
    local tempX = GridsSize * 0.5
    local tempY = GridsSize * 0.5
    for i = 1, bs do
        for j = 1, bs do
            if (i == 1 and j <= 2) or (i == 1 and j >= bs -1) or (i == bs and j <= 2) or (i == bs and j >= bs -1) 
            or (j == 1 and i <= 2) or (j == 1 and i >= bs -1) or (j == bs and i <= 2) or (j == bs and i >= bs -1) then
            else
                local grid = grids:Find('grid'..((i - 1) * bs + j)).gameObject
                grid:SetActive(true)
                local isBuildGrid = false
                --被建筑覆盖的格子需要隐藏
                if bs % 2 == 0 then
                    if i >= bs * 0.5 - buildingSize * 0.5 and i <= bs * 0.5 + buildingSize * 0.5 + 1 then
                        if j >= bs * 0.5 - buildingSize * 0.5 and j <= bs * 0.5 + buildingSize * 0.5 + 1 then
                            isBuildGrid = true
                        end
                    end
                else
                    if i >= (bs + 1) * 0.5 - buildingSize * 0.5 and i <= (bs + 1) * 0.5 + buildingSize * 0.5 then
                        if j >= (bs + 1) * 0.5 - buildingSize * 0.5 and j <= (bs + 1) * 0.5 + buildingSize * 0.5 then
                            isBuildGrid = true
                        end
                    end
                end
                
                local gridMeshGameobject = grid.transform:Find('gridMeshRenderer').gameObject
                local meshRenderer = gridMeshGameobject:GetComponent("MeshRenderer")
                local materials =  NGameObjectUtil.GetMeshRendererMaterials(meshRenderer)
                local gridmaterial = meshRenderer.sharedMaterial

                local gridBreath = grid.transform:Find('gridBreathmaterial').gameObject

                local data = {grid = grid, isBuildGrid = isBuildGrid, gridmaterial = gridmaterial, gridBreath = gridBreath, gridMeshGameobject = gridMeshGameobject}
                table.insert(self.Grids, data)
                local x = tempX -  (i - 1)
                local y = tempY -  (j - 1)
                NGameObjectUtil.SetLocalPosition(grid, x, 0, y)
            end
        end
    end

    UpdateBeat:Add(self.Update, self)

    return self.resObjGo
end

function BuildingObjectMod:Destroy()
    self.resObjGo:Destroy()
end

function BuildingObjectMod:RemoveUpdate()
    UpdateBeat:Remove(self.Update, self)
end

function BuildingObjectMod:Update()
    if self.press then
        local pos = NGameObjectUtil.ScreenPickCastFloorByLayer(UnityInput.mousePosition.x, UnityInput.mousePosition.y, 'PlanetPlane')
        local x = math.floor(pos.x)
        local y = math.floor(pos.z)
        local buildingSize = DATA_BUILDING[self.data.buildingConfigId][DATA_BUILDING.EVar['bldg_side_length_n']]
        local pos = 0
        if buildingSize % 2 == 0 then
            pos = 1
        end
        NGameObjectUtil.SetLocalPosition(self.resObjGo, x + pos * 0.5, 0, y + pos * 0.5)
        
        self.gridId = (self.resObjGo.transform.position.x + (buildingSize - 1) * 0.5 + 55) * 1000 + self.resObjGo.transform.position.z + (buildingSize - 1) * 0.5 + 55
    end

    local IsAllInPowerSupplyRange = self:IsAllInPowerSupplyRange()

    for i = 1, #self.Grids do
        local position = self.Grids[i].grid.transform.position
        local gridId = (position.x + 55) * 1000 + position.z + 55
        if self.planetaryProxy:GetGridsUsedByGridId(gridId) ~= nil or not IsAllInPowerSupplyRange then
            if not IsAllInPowerSupplyRange then
                if self.Grids[i].isBuildGrid then
                    self.Grids[i].gridmaterial:SetTexture("_MainTex", self.textureRed)
                else
                    self.Grids[i].gridmaterial:SetTexture("_MainTex", self.textureGray)
                end
            end
            if self.planetaryProxy:GetGridsUsedByGridId(gridId) ~= nil then
                if not self.Grids[i].isBuildGrid then
                    self.Grids[i].gridmaterial:SetTexture("_MainTex", self.textureYellow)
                else
                    self.Grids[i].gridmaterial:SetTexture("_MainTex", self.textureRed)
                end
            end
        else
            if self.Grids[i].isBuildGrid then
                self.Grids[i].gridmaterial:SetTexture("_MainTex", self.textureGreen)
            else

                self.Grids[i].gridmaterial:SetTexture("_MainTex", self.textureGray)
            end
        end
    end
end

function BuildingObjectMod:GetGirdId()
    return self.gridId
end

function BuildingObjectMod:isGridsEnable()

    local buildingSize = DATA_BUILDING[self.data.buildingConfigId][DATA_BUILDING.EVar['bldg_side_length_n']] - 1

    for i = 1, #self.Grids do
        if self.Grids[i].isBuildGrid then
            local position = self.Grids[i].grid.transform.position
            local gridId = (position.x + 55) * 1000 + position.z + 55

            if self.planetaryProxy:GetGridsUsedByGridId(gridId) ~= nil then
                return false
            end
        end
    end
    return true
end

function BuildingObjectMod:IsAllInPowerSupplyRange()
    local buildingClassTable = self.planetaryProxy:GetbuildingClassTable()

    for i = 1, #buildingClassTable do
        if buildingClassTable[i].data.id ~= self.data.id then
            local pos = {x = self.resObjGo.transform.position.x, y = self.resObjGo.transform.position.z}
            if buildingClassTable[i]:IsInPowerSupplyRange(pos) then
                return true
            end
        end
    end

    return false
end

function BuildingObjectMod:OthenBuildingInPower()
    local type = self.planetaryProxy:GetBuildingType(self.data.buildingConfigId)
    if type == common_pb.SPACESTATION or type == common_pb.POWERPLANT then -- 基地电厂
        local powerBuildingTable = {}
        local normalBuildingTable = {}
        local buildingClassTable = self.planetaryProxy:GetbuildingClassTable()
        for i = 1, #buildingClassTable do
            local buildType = self.planetaryProxy:GetBuildingType(buildingClassTable[i].data.buildingConfigId)
            if buildType == common_pb.SPACESTATION or buildType == common_pb.POWERPLANT then -- 基地电厂
                if buildingClassTable[i].data.id == self.data.id then
                    table.insert(powerBuildingTable, self)
                else
                    table.insert(powerBuildingTable, buildingClassTable[i])
                end
            else
                table.insert(normalBuildingTable, buildingClassTable[i])
            end
        end

        for i = 1, #normalBuildingTable do
            local isInPower = false
            local pos = {x = normalBuildingTable[i].buildingGo.transform.position.x, y = normalBuildingTable[i].buildingGo.transform.position.z}
            for j = 1, #powerBuildingTable do
                if powerBuildingTable[j]:IsInPowerSupplyRange(pos) then
                    isInPower = true
                    break
                end
            end
            if not isInPower then
                return false
            end
        end

        return true
    else
        return true
    end
end

function BuildingObjectMod:CanCreateBuilding()
    if self:IsAllInPowerSupplyRange() and self:isGridsEnable() and self:OthenBuildingInPower() then
        return true
    end
    return false
end

function BuildingObjectMod:OnPress(isPress)
    self.press = isPress
    Facade:SendNotification(NotiConst.Notify_SetPlanetCameraEnable, not isPress)
end

--建筑体量
function BuildingObjectMod:GetBldgSize()
    return self.buildingConfigData[DATA_BUILDING.EVar.bldg_side_length_n] - 1
end

--根据gridId获取建筑点
function BuildingObjectMod:GetBuildingPosByGridId(gridId)
    local x = (gridId - gridId % 1000) / 1000 - 55
    local y = gridId % 1000 - 55
    return { x = x, y = y }
end

--获取建筑中心点
function BuildingObjectMod:GetBuildingCenter()
    local bldgSize = self:GetBldgSize()
    local buildingPos = self:GetBuildingPosByGridId(self.gridId)
    local x = buildingPos.x - bldgSize * 0.5
    local y = buildingPos.y - bldgSize * 0.5
    return { x = x, y = y}
end

--是否在供电范围
function BuildingObjectMod:IsInPowerSupplyRange(centerPos)
    local buildingCenter = self:GetBuildingCenter()
    local powerSupplyRange = self.planetaryProxy:GetPowerSupplyRange(self.data.buildingConfigId) * 0.5
    local distanceSq = (centerPos.x - buildingCenter.x) * (centerPos.x - buildingCenter.x) + (centerPos.y - buildingCenter.y) * (centerPos.y - buildingCenter.y) - powerSupplyRange * powerSupplyRange
    return distanceSq <= 0
end

return BuildingObjectMod