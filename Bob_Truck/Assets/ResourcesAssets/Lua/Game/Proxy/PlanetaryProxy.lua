-- planet{
-- id, hexId, scale, mask
-- }
-- hexMap{
-- position[2]
-- } 


local PlanetaryProxy = class("PlanetaryProxy",Proxy)
local UnityWorld3DPos2WorldUIPos = GameObjectUtil.World3DPos2WorldUIPos
local UnityIsWorld3DPosInScreen = GameObjectUtil.IsWorld3DPosInScreen
local SetPosition = GameObjectUtil.SetPosition

 --建造界面背包配置
 local packageConfig = {
    [0] = {1},
    [1] = {2},
    [2] = {3},
    [3] = {4},
 }

 --建筑对应的表
 local buildingConfig = {
    [common_pb.SURFCOL] = DATA_BLDG_SURF_COL
 }

 --科技对应的表
 local skillTreeConfig = {
     [31] = DATA_TECH_BLDG,
     [32] = DATA_TECH_PROD,
 }

 --建筑的生产速度系数对应的表
 local buildingProductSpeedCoefficientConfig = {
     [common_pb.HULLFACT] = DATA_BLDG_FUNC_HULL_FACT,
     [common_pb.CPNTFACT] = DATA_BLDG_CPNT_FACT,
 }

function PlanetaryProxy:OnRegister()
    self.planetMap = {}     -- key : planetId -> value : plaentData
    --UpdateBeat:Add(self.Update, self)
    self:LoadBuildingConfigDataByType()
    self:LoadShipHullConfigDataByType()
    self:LoadShipCpntConfigDataByType()
    self:LoadShipModConfigData()
end

function PlanetaryProxy:OnRemove()

end

function PlanetaryProxy:GetPlanetaryId()
    return self.m_data.palnetaryId
end

function PlanetaryProxy:SetPlanetaryId(id)
    self.m_data.palnetaryId = id
end

function PlanetaryProxy:LoadPlanetaryData()
    self:LoadPlanetaryPerformanceData()
end

function PlanetaryProxy:GetPlanetGrid(gridId)
    return self:GetHexDataBygridId(gridId)
end

function PlanetaryProxy:GetGridDataByPlanetId(planetId)
    local gridId = self.m_data.planetDataMap[planetId].gridId
    return self:GetPlanetHex(gridId)
end

-- 返回所有PlanetData的map，key为planetId
function PlanetaryProxy:GetPlanetDataMap()
    return self.m_data.planetDataMap
end

function PlanetaryProxy:GetSunDataMap()
    return self.m_data.sunDataMap
end

-- 保存可以探索planet的列表
function PlanetaryProxy:GetExplorablePlanets()
    return self.m_data.explorablePlanetsList
end

--获得planet在UI上的世界坐标
function PlanetaryProxy:GetPlanetPosInUIWorld(id)
    local posX = (id - id % 1000) / 1000 - 55
    local posZ = id % 1000 - 55
    local pos2D = UnityWorld3DPos2WorldUIPos(posX, 0, posZ)
    return pos2D
end

function PlanetaryProxy:GetHexePosInUIWorld(id)
    local posX = (id - id % 1000) / 1000 - 55
    local posZ = id % 1000 - 55
    local pos2D = UnityWorld3DPos2WorldUIPos(posX, 0, posZ)
    return pos2D
end

--planet是否可见
function PlanetaryProxy:IsPlanetVisible(id)
    local posX = (id - id % 1000) / 1000 - 55
    local posZ = id % 1000 - 55
    return UnityIsWorld3DPosInScreen(posX, 0, posZ)
end

------------ 舰队相关
-- 获得所有舰队
function PlanetaryProxy:GetAllFleetMap()
    return self.m_data.fleetDataMap
end

--获得舰队data
function PlanetaryProxy:GetFleetDataByFleetId(fleetId)
    return self.m_data.fleetDataMap[fleetId]
end

-- 获得某种类型的舰船list
function PlanetaryProxy:GetShipDataByType(fleetId, type)
    local shipList = {}
    --TODO
    return shipList
end

------------ planet相关

-- 设置当前选中的planet
function PlanetaryProxy:SetChosenPlanetId(planetId)
    self.m_data.chosenPlanetId = planetId
end

function PlanetaryProxy:ClearChosenPlanetId()
    self.m_data.chosenPlanetId = nil
end

function PlanetaryProxy:GetChosenPlanetId()
    return self.m_data.chosenPlanetId
end

--判断一个星球是否可以探索
function PlanetaryProxy:IsPlanetExplorable(planetId)
    return true
    --TODO
end

--判断一个星球是否可以采集
function PlanetaryProxy:IsPlanetMinable(planetId)
    return true
end

function PlanetaryProxy:SavePlanetBuildingList(data)
    self.m_data:SavePlanetBuildingList(data)
end


--进点时拉取的planet信息，由于本地planetMap还会创建，先缓存
function PlanetaryProxy:SavePlanetStatus(planetProtos)
    self.m_data:SavePlanetStatus(planetProtos)
end


function PlanetaryProxy:SaveBuildingList(data)
    self.m_data:SaveBuildingList(data)
end

function PlanetaryProxy:UpdateBuildingData(buildings)
    for i = 1, #buildings do
        self:AddBuildingData(buildings[i])
    end
end

function PlanetaryProxy:SaveBuildingData(building)
    self.m_data:SaveBuildingData(building)
end

function PlanetaryProxy:SaveElecMsg(elecMsg)
    self.m_data:SaveElecMsg(elecMsg)
end

function PlanetaryProxy:GetElecMsg()
    return self.m_data:GetElecMsg()
end

function PlanetaryProxy:AddBuildingData(building)
    self.m_data:AddBuildingData(building)
end

function PlanetaryProxy:RemoveBuildingData(buildingId)
    self.m_data:RemoveBuildingData(buildingId)
end

function PlanetaryProxy:GetBuildingList()
    return self.m_data.building
end

function PlanetaryProxy:GetBuildingDataById(buildingId)
    return self.m_data.buildingDataMap[buildingId]
end

function PlanetaryProxy:GetBuildingData()
    return self.m_data.buildingDataMap
end

--获取同类型建筑
function PlanetaryProxy:GetBuildingDataByType(funcType)
    local list = {}
    for i,v in pairs(self.m_data.buildingDataMap) do
        local buildingConfigData = self:GetBuildingConifData(v.buildingConfigId)
        local type = buildingConfigData.data[buildingConfigData.EVar["bldg_func_type_n"]]
        if funcType == type then
            table.insert(list, v)
        end
    end
    return list
end

function PlanetaryProxy:GetBuildingCount(funcType)
    local list = self:GetBuildingDataByType(funcType)
    if list == nil then
        return 0
    end
    return #list
end

--根据资源等级获取资源深度
function PlanetaryProxy:GetResDepthByLevel(resLevel)
    return self.m_data.ResourceConfig.resourceLevel2Depth[resLevel]
end

function  PlanetaryProxy:GetResMaxLevelByDepth(resDepth)
    return self.m_data.ResourceConfig.resourceDepth2MaxLevel[resDepth]
end

-- 加载行星系内数据和美术表现配置
function PlanetaryProxy:LoadPlanetaryPerformanceData()
    if self.m_data.palnetaryId == -1 then
        return nil
    end

    local universePackage = LoadPackage("Universe")
    local solarConfig = universePackage.SolarConfig

    local node = universePackage.allMapData[self.m_data.palnetaryId]  -- data within a planetary system
    local performance = {
        suns = {},
        planets = {}
    }
    if node then
        -- load suns
        for i, v in ipairs(node.config.suns) do
            local sunPerf = {
                id = v.id,
                gridId = 55055,
                colorRes = solarConfig.suns.color[v.cid+1].resource,
                typeRes = solarConfig.suns.type[v.tid+1].resource
            }
            table.insert(performance.suns,sunPerf)
        end

        -- load planets
        local planetRes = node.resource.planets
        local planetIndexP = (self.m_data.palnetaryId+1) % #solarConfig.planets.prefab
        for i,v in ipairs(node.config.planets) do
            local pRes = planetRes[v.id]
            local planetPref = {
                id = v.id,
                gridId = v.gridId,
                gridSize = v.gridSize,
                scale = 0,
                mask = nil,
            }
            if pRes then
                planetPref.scale = pRes.radius
                planetPref.resList = pRes.res
                planetPref.resVList = pRes.resV
                planetPref.resLList = pRes.resL
                local mainResId = pRes.mRes
                planetPref.mRes = mainResId
                local pindex = (self.m_data.palnetaryId+i+planetIndexP) % #solarConfig.planets.prefab
                planetPref.perfRes = solarConfig.planets.prefab[pindex+1]
                --[[for j,v_ in ipairs(solarConfig.planets.mask) do
                    if table.indexOf(v_.mainResIds,mainResId) then
                        planetPref.perfRes = v_
                        break
                    end
                end]]
            else
                local pindex = (self.m_data.palnetaryId+i+planetIndexP) % #solarConfig.planets.prefab
                planetPref.perfRes = solarConfig.planets.prefab[pindex+1]
            end
            table.insert(performance.planets, planetPref)
        end

        --load belt 小行星带
        if node.config.belt then
            performance.belt = node.config.belt
        end
        --文明遗迹
        if node.config.relic then
            performance.relic = node.config.relic
        end
        --宇宙奇观

        if node.config.spectacleId then
            performance.spectacleId = node.config.spectacleId
        end
    end
    self:TransformPerformanceData(performance)
end

-- 将performance转换成需要的数据结构
function PlanetaryProxy:TransformPerformanceData(performanceData)
    self.m_data.planetDataMap = {}                 -- id => planetData
    self.m_data.sunDataMap = {}                    -- id => hexData
    local planetDataMap = self.m_data.planetDataMap
    local sunDataMap = self.m_data.sunDataMap
    -- sunData map
    for idx, sunPref in pairs(performanceData.suns) do
        local sunData = {
            id = sunPref.id,
            gridId = sunPref.gridId,
            colorRes = sunPref.colorRes,
            typeRes = sunPref.typeRes,
            --obj = nil,
        }
        
        table.insert(sunDataMap, sunData.id, sunData)
    end
    -- planetData map
    for idx, planetPref in pairs(performanceData.planets) do
        local planetData = {
            id = planetPref.id,
            gridId = planetPref.gridId,
            scale = planetPref.scale,
            perfRes = planetPref.perfRes,
            gridSize = planetPref.gridSize,
            mRes = planetPref.mRes,
            obj = nil,
            depth = 0,              --目前探索到的深度，默认为0，即没有探索过
            resList = planetPref.resList,
            resVList = planetPref.resVList,
            resLList = planetPref.resLList,
        }
        table.insert(planetDataMap, planetData.id, planetData)
    end
    self.m_data.belt = performanceData.belt
    self.m_data.relic = performanceData.relic
    self.m_data.spectacleId = performanceData.spectacleId
    self:SetPlanetStatus()
end

function PlanetaryProxy:SetPlanetStatus()
    self.m_data:SetPlanetStatus()
end

-- 获得planet的数据模型
function PlanetaryProxy:GetPlanetDataByPlanetId(planetId)
    return self.m_data.planetDataMap[planetId]
end
--设置planet状态
function PlanetaryProxy:SetPlanetDataByPlanet(planet)
    self.m_data.planetDataMap[planet.id].depth = planet.depth
end

function PlanetaryProxy:GetGridMapData()
    return self.m_data.GridMapStruct
end

function PlanetaryProxy:SetGrids(grids)
    self.m_data:SetGrids(grids)
end

function PlanetaryProxy:GetGrids()
    return self.m_data:GetGrids()
end

function PlanetaryProxy:SetHexHudInfoState(gridId, isShow)
    self.m_data.GridMapStruct[gridId].showHUD = isShow
end

function PlanetaryProxy:GetHexHudInfoState( gridId )
    local hudInfo = self.m_data.GridMapStruct[gridId]
    if hudInfo ~= nil then
        return hudInfo.showHUD
    end
    return false
end

-- 获得Hex的数据模型
function PlanetaryProxy:GetHexDataBygridId(gridId)
    return self.m_data.GridMapStruct[gridId]
end

function PlanetaryProxy:GetBelt()
    return self.m_data.belt
end

function PlanetaryProxy:GetRelic()
    return self.m_data.relic
end

function PlanetaryProxy:GetSpectacleId()
    return self.m_data.spectacleId
end
--建筑操作接口------------------
--获取当前挂起操作
function PlanetaryProxy:GetCurBuildingOper()
    return self.m_data.curBuildingOper
end
--设置当前挂起操作
function PlanetaryProxy:SetCurBuildingOper(data)
    self.m_data.curBuildingOper = data
end
--添加操作
function PlanetaryProxy:AddBuindingOper(data)
    table.insert(self.m_data.buildingOperation,data)
end
--获取操作
function PlanetaryProxy:GetBuildingOperByUid(uid)
    for i,v in ipairs(self.m_data.buildingOperation) do
        if v.uid == uid then
            return v
        end
    end
    return nil
end
--获取某建筑的所有操作
function PlanetaryProxy:GetBuildingOpersByBid(buildingId)
    local list = {}
    for i,v in ipairs(self.m_data.buildingOperation) do
        if v.targetBuilding == buildingId then
            table.insert(list,v)
        end
    end
    return list
end

function PlanetaryProxy:RemoveBuildingOper(uid)
    for i,v in ipairs(self.m_data.buildingOperation) do
        if v.uid == uid then
            table.remove(self.m_data.buildingOperation,i)
            return
        end
    end
end

--舰体厂生产队列
function PlanetaryProxy:SetHullfactMSGProductLine(ProductLine)
    self.m_data:SetHullfactMSGProductLine(ProductLine)
end

function PlanetaryProxy:GetHullfactMSGProductLine()
    return self.m_data:GetHullfactMSGProductLine()
end

function PlanetaryProxy:GetHullfactMSGProductLineByIndex(index)
    local data = self.m_data:GetHullfactMSGProductLine()
    return data[index]
end

function PlanetaryProxy:SetHullfactMSGStartTime(startTime)
    self.m_data:SetHullfactMSGStartTime(startTime)
end

function PlanetaryProxy:GetHullfactMSGStartTime()
    return self.m_data:GetHullfactMSGStartTime()
end

function PlanetaryProxy:SetHullfactMSGData(protoData)
    self.m_data.HullfactMSG.protoData = {}
    self.m_data.HullfactMSG.protoData.startTime = GetServerTimeStamp()
    self.m_data.HullfactMSG.protoData.firstProductCostConfigTime = protoData.firstProductCostConfigTime and math.floor(protoData.firstProductCostConfigTime/1000) or 0
    self.m_data.HullfactMSG.protoData.personEfficiency = protoData.personEfficiency
    self.m_data.HullfactMSG.protoData.personEfficiencyEndTime = protoData.personEfficiencyEndTime and math.ceil(protoData.personEfficiencyEndTime/1000) or 0

    if protoData.personEfficiency > 0 and self.m_data.HullfactMSG.protoData.startTime > self.m_data.HullfactMSG.protoData.personEfficiencyEndTime then
        LogWarn("SetHullfactMSGData personEfficiency:{0}, startTime:{1}, personEfficiencyEndTime:{2}", protoData.personEfficiency, self.m_data.HullfactMSG.protoData.startTime, self.m_data.HullfactMSG.protoData.personEfficiencyEndTime)
    end
end

function PlanetaryProxy:GetHullfactMSGData()
    return self.m_data.HullfactMSG.protoData
end

function PlanetaryProxy:GetBuildingType(bconfigId)
    return DATA_BUILDING[bconfigId][DATA_BUILDING.EVar['bldg_func_type_n']]
end

function PlanetaryProxy:GetBuildingLevel(bconfigId)
    return DATA_BUILDING[bconfigId][DATA_BUILDING.EVar['bldg_lvl_n']]
end

function PlanetaryProxy:GetBuldingFuncTableId(configId)
    return DATA_BUILDING[configId][DATA_BUILDING.EVar['bldg_func_table_id_n']]
end

function PlanetaryProxy:GetPosByGridId(gridId)
    local x = (gridId - gridId % 1000) / 1000 - 55
    local y = gridId % 1000 - 55
    return { x = x, y = y }
end

function PlanetaryProxy:AddGridsUsedByGridId(gridId, gridData)
    self.m_data:AddGridsUsedByGridId(gridId, gridData)
end

function PlanetaryProxy:RemoveGridsUsedByGridId(gridId)
    self.m_data:RemoveGridsUsedByGridId(gridId)
end

function PlanetaryProxy:GetGridsUsedByGridId(gridId)
    return self.m_data:GetGridsUsedByGridId(gridId)
end

function PlanetaryProxy:AddbuildingClassTable(buildClass)
    self.m_data:AddbuildingClassTable(buildClass)
end

function PlanetaryProxy:InitbuildingClassTable()
    self.m_data:InitbuildingClassTable()
end

function PlanetaryProxy:GetbuildingClassTable()
    return self.m_data:GetbuildingClassTable()
end

-- 产出速度加成相关 ------------------
--根据纯度获取星球上资源的产出速度
function PlanetaryProxy:GetPlanetReourceProduceSpeed(fineness)
    local data = DATA_MINERAL_FIN[fineness]
    if data == nil then
        return 0
    end
    return data[DATA_MINERAL_FIN.EVar["produce_rate_n"]]
end

--获取功能舰体厂的生产加成
function PlanetaryProxy:GetHullFactoryProduceSpeed(configId)
    local buildingFuncType = self:GetBuildingTypeByConfigId(configId)
    local configData = buildingProductSpeedCoefficientConfig[buildingFuncType]
    local index = self:GetBuldingFuncTableId(configId)
    local data = configData[index]
    if data == nil then
        return 0
    end
    return data[configData.EVar["prod_spd_coeff_n"]]
end
-- end------------------------------

-- 采集相关接口----------------
--获取一个星球上的资源
function PlanetaryProxy:GetPlanetCollectResources(planetId)
    local planetData = self:GetPlanetDataByPlanetId(planetId)
    local resource = {}
    --local maxLevel = self:GetCurBuildingOper().dynamicData.canCollectMaxLeve 
    if planetData ~= nil then
        local resLList = planetData.resLList
        local resList = planetData.resList
        local resVList = planetData.resVList
        if resLList ~= nil then
            for i = 1,#resLList do
                --if resLList[i] <= maxLevel then
                    local resInfo = {}
                    resInfo.ID = resList[i]             --资源ID
                    local fineness = math.floor( resVList[i] / 10 )
                    resInfo.Fin = math.max(fineness,1)  --资源纯度
                    table.insert(resource,resInfo)
                --end
            end
        end
    end
    return resource
end

--获取一个星球上资源类型数量
function PlanetaryProxy:GetPlanetCollectResourcesCount(planetId)
    local resList = self:GetPlanetCollectResources(planetId)
    if resList ~= nil then
        return #resList
    else
        return 0 
    end
end

--获取采集场功能表中的数据
function PlanetaryProxy:GetCollectFuncData(configId)
    local type = self:GetBuildingTypeByConfigId(configId)
    local index = self:GetBuldingFuncTableId(configId)
    local tableDatas = self:GetBuildingFuncTable(type)
    local evar = tableDatas.EVar
    for key,value in ipairs(tableDatas) do
        if index == key then
            return {data = value,Evar = evar}
        end
    end
    return nil
end

--根据星球Id和资源Id，获取资源的纯度
function PlanetaryProxy:GetResourceFineness(planetId,resourceId)
    local resourceList = self:GetPlanetCollectResources(planetId)
    if resourceList ~= nil then
        for i = 1,#resourceList do
            if resourceList[i].ID == resourceId then
                return resourceList[i].Fin
            end
        end
    end
    return 0
end

--保存可采集的星球列表
function PlanetaryProxy:SetCollectablePlanetIds()
    local curBuildingOper = self:GetCurBuildingOper()
    local canCollectPlanetIds = {}
    local maxLevel = curBuildingOper.dynamicData.canCollectMaxLeve
    if maxLevel == nil then
        maxLevel = 1
    end
    local planetMap = self:GetPlanetDataMap()

    local IsCanCollect = function (resLList)
        if resLList ~= nil then
            for i = 1,#resLList do
                if resLList[i] <= maxLevel then
                    return true
                end
            end
        end
        return false
    end

    if planetMap ~= nil then
        for id, planetData in pairs(planetMap) do
            local resLList = planetData.resLList
            local isCollect = IsCanCollect(resLList)
            if isCollect then
                table.insert(canCollectPlanetIds,id)
            end
        end
    end
    curBuildingOper.dynamicData.canCollectPlanetIds = canCollectPlanetIds
    --没有选择采集的星球，就默认第一个
    if canCollectPlanetIds ~= nil and #canCollectPlanetIds > 0 and curBuildingOper.dynamicData.planetId == nil then
        curBuildingOper.dynamicData.planetId = canCollectPlanetIds[1]
    end
end

function PlanetaryProxy:GetCollectablePlanetIds()
    return self:GetCurBuildingOper().dynamicData.canCollectPlanetIds
end

--可采集星球的数量
function PlanetaryProxy:GetCollectablePlanetsCount()
    local planets = self:GetCollectablePlanetIds()
    if planets ~= nil then
        return #planets
    else
        return 0
    end
end

--领取后，需要同步建筑数据中的生产时间
function PlanetaryProxy:SetBuildingData_GetItemTime(building)
    local setData = function (time)
        local buildingData = self:GetBuildingDataById(building.id)
        if buildingData ~= nil then
            buildingData.getItemTime = time
        end
    end
    setData(building.getItemTime)
end

--end

--建筑建造
function PlanetaryProxy:GetBuildingListByNodeId(nodeId)
    local buildingList = self.m_data.buildingData[nodeId]
    if buildingList == nil then
        self.m_data.buildingData[nodeId] = {
            all = {},
            byType = {}
        }
    end
    return self.m_data.buildingData[nodeId]
end

function PlanetaryProxy:SetBuildingList(nodeId, buildingList)
    self.m_data.buildingData[nodeId] = {
        all = {},
        byType = {}
    }

    for i,v in ipairs(buildingList) do
        self:AddBuildingList(nodeId, v)
    end
end

function PlanetaryProxy:AddBuildingList(nodeId, building)
    local allList = self:GetAllBuildingList(nodeId)
    local bid = 0
    for i,v in ipairs(allList) do
        if v.id == building.id then
            bid = i
            break
        end
    end
    if bid == 0 then
        table.insert(allList, building)
    else
        allList[bid] = building
    end

    local configData = self:GetBuildingConifData(building.id)
    local type = configData.data[configData.EVar["bldg_type_n"]]
    local typeList = self:GetBuildingListByType(nodeId, type)
    local iid = 0
    for i,v in ipairs(typeList) do
        if v.id == building.id then
            iid = i
            break
        end
    end
    if iid == 0 then
        table.insert(typeList, building)
    else
        typeList[iid] = building
    end
end

function PlanetaryProxy:GetAllBuildingList(nodeId)
    local buildingList = self:GetBuildingListByNodeId(nodeId)
    return buildingList.all
end

function PlanetaryProxy:GetBuildingListByType(nodeId, type)
    local buildingList = self:GetBuildingListByNodeId(nodeId)
    local typeList = buildingList.byType[type]
    if typeList == nil then
        buildingList.byType[type] = {}
    end
    return buildingList.byType[type]
end

function PlanetaryProxy:InitBuildingPackageData(nodeId, index)
    local packageData = packageConfig[index]
    local list = {}
    for i,v in ipairs(packageData) do
        local buildingList = self:GetBuildingListByType(nodeId, v)
        for ii,vv in ipairs(buildingList) do
            table.insert(list,vv)
        end
    end
    table.sort(list, function (a, b)
        --return a.id < b.id
        return a[DATA_BUILDING.EVar["ui_order_n"]] < b[DATA_BUILDING.EVar["ui_order_n"]]
    end)
    self.m_data.curBuildingData = list
    return self.m_data.curBuildingData
end

function PlanetaryProxy:GetBuildingPackageData()
    return self.m_data.curBuildingData
end

function PlanetaryProxy:GetBuildingPackageDataByIndex(index)
    return self.m_data.curBuildingData[index]
end

-- 获得建筑的全名 ps.从config里获得的name是key
function PlanetaryProxy:GetBuildingActualNameByName(name)
    return GetLanguageText("BuildingAttribute", name)
end


--建筑配置数据相关操作
function PlanetaryProxy:LoadBuildingConfigDataByType()
    self.m_data.buildingConfigDataByType = {}

    local evar = DATA_BUILDING.EVar

    for i,v in pairs(DATA_BUILDING) do
        if type(i) == "number" then
            local inUse = v[evar["in_use_n"]]
            if inUse == 1 then
                local funcType = v[evar["bldg_func_type_n"]]
                local level = v[evar["bldg_lvl_n"]]
                local list = self:GetBuildingConfigDataByType(funcType)
                v.id = i
                table.insert(list, v)
            end
        end
    end
end

function PlanetaryProxy:GetBuildingConfigDataByType(funcType)
    local list = self.m_data.buildingConfigDataByType[funcType]
    if list == nil then
        self.m_data.buildingConfigDataByType[funcType] = {}
    end
    return self.m_data.buildingConfigDataByType[funcType]
end

function PlanetaryProxy:GetBuildingConfigDataByLevel(funcType, level)
    local list = self:GetBuildingConfigDataByType(funcType)
    local evar = DATA_BUILDING.EVar
    for i,v in ipairs(list) do
        local tempLevel = v[evar["bldg_lvl_n"]]
        if tempLevel == level then
            return {data = v, EVar = DATA_BUILDING.EVar}
        end
    end
    return nil
end

function PlanetaryProxy:GetBuildingConifData(configId)
    return {data = DATA_BUILDING[configId], EVar = DATA_BUILDING.EVar} 
end

function PlanetaryProxy:GetBeginBuilding()
    local list = {}
    local evar = DATA_BUILDING.EVar

    for i,v in pairs(DATA_BUILDING) do
        if type(i) == "number" then
            local inUse = v[evar["in_use_n"]]
            local level = v[evar["bldg_lvl_n"]]
            local uiOrder = v[evar["ui_order_n"]]
            if inUse == 1 and level == 1 and uiOrder > -1 then
                table.insert(list, v)
            end
        end
    end
    return list
end

function PlanetaryProxy:GetPowerSupplyRange(configId)
    local type = DATA_BUILDING[configId][DATA_BUILDING.EVar.bldg_func_type_n]
    if type == common_pb.POWERPLANT then
        return DATA_BLDG_POWER_PLANT[DATA_BUILDING[configId][DATA_BUILDING.EVar.bldg_func_table_id_n]][DATA_BLDG_POWER_PLANT.EVar.affact_rng_n] * 2
    elseif type == common_pb.SPACESTATION then
        return DATA_BLDG_SS[DATA_BUILDING[configId][DATA_BUILDING.EVar.bldg_func_table_id_n]][DATA_BLDG_SS.EVar.affact_rng_n] * 2
    end
    return 0
end
--根据configId获取建筑的类型
function PlanetaryProxy:GetBuildingTypeByConfigId(configId)
    local configData = DATA_BUILDING[configId]
    if configData == nil then
        LogError("Can not find data in table:BUILDING by configId:{0}",configId)
    end
    local type = configData[DATA_BUILDING.EVar["bldg_func_type_n"]]
    return type
end

--获取能升级到的最高建筑
function PlanetaryProxy:GetMaxBuildingConifData(funcType, level)
    local list = self:GetBuildingConfigDataByType(funcType)
    local evar = DATA_BUILDING.EVar
    local configData = nil
    local configId = 0
    for i,v in ipairs(list) do
        local tempLevel = v[evar["bldg_lvl_n"]]
        if tempLevel == (level+1) then
            configData = v
            break
        end
    end

    -- for i,v in pairs(DATA_BUILDING) do
    --     if v == configData then
    --         configId = i
    --         break
    --     end
    -- end

    return {data = configData, EVar = DATA_BUILDING.EVar, configId = configData.id} 
end

--通过建筑type获取建筑功能表数据
function PlanetaryProxy:GetBuildingFuncTable(buildingType)
    return  buildingConfig[buildingType]
end

--舰体厂配置数据相关操作
function PlanetaryProxy:LoadShipHullConfigDataByType()
    self.m_data.shipHullConfigDataByType = {}

    local evar = DATA_SHIP_HULL_TECH.EVar

    for i,v in pairs(DATA_SHIP_HULL_TECH) do
        if type(i) == "number" then
            local inUse = v[evar["in_use_n"]]
            if inUse == 1 then
                local hullType = v[evar["hull_type_n"]]
                local list = self:GetShipHullConfigDataByType(hullType)
                v.id = i
                table.insert(list, v)
                --0：对应All
                list = self:GetShipHullConfigDataByType(0)
                table.insert(list, v)
            end
        end
    end
end

function PlanetaryProxy:GetShipHullConfigDataByType(hullType)
    local list = self.m_data.shipHullConfigDataByType[hullType]
    if list == nil then
        self.m_data.shipHullConfigDataByType[hullType] = {}
    end
    return self.m_data.shipHullConfigDataByType[hullType]
end

function PlanetaryProxy:GetShipHullConfigData(hullId)
    return {data = DATA_SHIP_HULL_TECH[hullId], EVar = DATA_SHIP_HULL_TECH.EVar} 
end

function PlanetaryProxy:SetPackageShipHullData(shipHullData)
    self.curPackageShipHullData = shipHullData
end

function PlanetaryProxy:GetPackageShipHullDataByIndex(index)
    return  {data = self.curPackageShipHullData[index], EVar = DATA_SHIP_HULL_TECH.EVar}
end

--组装配置数据相关操作
function PlanetaryProxy:LoadShipModConfigData()
    self.m_data.shipModConfigData = {}

    local evar = DATA_SHIP_MOD_TECH.EVar
    for i,v in pairs(DATA_SHIP_MOD_TECH) do
        if type(i) == "number" then
            local inUse = v[evar["in_use_n"]]
            if inUse == 1 then
                v.id = i
                v.hull = DATA_SMT_AVAIL_HULL_LIST[v.id][DATA_SMT_AVAIL_HULL_LIST.EVar["hull_id_repeated100"]]
                v.cpnt = DATA_SMT_AVAIL_CPNT_LIST[v.id][DATA_SMT_AVAIL_CPNT_LIST.EVar["cpnt_id_repeated100"]]
                table.insert(self.m_data.shipModConfigData, v)
            end
        end
    end

    table.sort(self.m_data.shipModConfigData, function (a, b)
        return a[DATA_SHIP_MOD_TECH.EVar["ui_order_n"]] < b[DATA_SHIP_MOD_TECH.EVar["ui_order_n"]]
    end)
end

function PlanetaryProxy:GetShipModConfigData()
    return self.m_data.shipModConfigData
end

function PlanetaryProxy:GetShipModConfigDataById(techId)
    return {data = DATA_SHIP_MOD_TECH[techId], EVar = DATA_SHIP_MOD_TECH.EVar} 
end

function PlanetaryProxy:GetShipModConfigDataByIndex(index)
    return  {data = self.m_data.shipModConfigData[index], EVar = DATA_SHIP_MOD_TECH.EVar}
end 

function PlanetaryProxy:LoadShipModHullConfigDataByType(techId)
    self.m_data.shipModHullConfigDataByType = {}
    local modData = self:GetShipModConfigDataById(techId)
    if modData == nil or modData.data == nil then
        return
    end
    local hull = modData.data.hull
    for i=1,#hull do
        local hullData = self:GetShipHullConfigData(hull[i])
        local hullType = hullData.data[hullData.EVar["hull_type_n"]]
        local list = self:GetShipModHullConfigDataByType(hullType)
        table.insert(list, hullData.data)

        list = self:GetShipModHullConfigDataByType(0)
        table.insert(list, hullData.data)
    end
end

function PlanetaryProxy:GetShipModHullConfigDataByType(hullType)
    local list = self.m_data.shipModHullConfigDataByType[hullType]
    if list == nil then
        self.m_data.shipModHullConfigDataByType[hullType] = {}
    end
    return self.m_data.shipModHullConfigDataByType[hullType]
end

--配件数据
function PlanetaryProxy:LoadShipModCpntConfigData(techId)
    self.m_data.shipModCpntConfigData = {}
    local modData = self:GetShipModConfigDataById(techId)
    if modData == nil or modData.data == nil then
        return
    end
    local cpnt = modData.data.cpnt
    for i=1,#cpnt do
        local cpntData = self:GetShipCpntConfigDataById(cpnt[i])
        cpntData.data.id = cpnt[i]
        table.insert(self.m_data.shipModCpntConfigData, cpntData.data)
    end
end

function PlanetaryProxy:GetShipCpntConfigData()
    return self.m_data.shipModCpntConfigData
end

function PlanetaryProxy:GetShipCpntConfigDataByIndex(index)
    return {data = self.m_data.shipModCpntConfigData[index], EVar = DATA_SHIP_CPNT_TECH.EVar} 
end

function PlanetaryProxy:GetShipCpntConfigDataById(cpntId)
    return {data = DATA_SHIP_CPNT_TECH[cpntId], EVar = DATA_SHIP_CPNT_TECH.EVar} 
end

function PlanetaryProxy:LoadShipCpntConfigDataByType()
    self.m_data.shipCpntConfigDataByType = {}

    local evar = DATA_SHIP_CPNT_TECH.EVar

    for i,v in pairs(DATA_SHIP_CPNT_TECH) do
        if type(i) == "number" then
            local inUse = v[evar["in_use_n"]]
            if inUse == 1 then
                local cpntType = v[evar["cpnt_type_n"]]
                local list = self:GetShipCnptConfigDataByType(cpntType)
                v.id = i
                table.insert(list, v)
                --0：对应All
                list = self:GetShipCnptConfigDataByType(0)
                table.insert(list, v)
            end
        end
    end
end

function PlanetaryProxy:GetShipCnptConfigDataByType(cpntType)
    local list = self.m_data.shipCpntConfigDataByType[cpntType]
    if list == nil then
        self.m_data.shipCpntConfigDataByType[cpntType] = {}
    end
    return self.m_data.shipCpntConfigDataByType[cpntType]
end


function PlanetaryProxy:SetPackageShipCnptData(shipCpntData)
    self.curPackageShipCpntData = shipCpntData
end

function PlanetaryProxy:GetPackageShipCnptDataByIndex(index)
    return  {data = self.curPackageShipCpntData[index], EVar = DATA_SHIP_CPNT_TECH.EVar}
end

--根据类型获取对应表数据
function PlanetaryProxy:GetSkillTreeConfigDataByType(type)
    local configData = skillTreeConfig[type]
    if configData ~= nil then
        return configData
    else
        return nil
    end
end

--当前选择的科技类型
function PlanetaryProxy:GetCurrentSelectSkillTreeType()
    return self.m_data.curSelectShowSkillTreeType
end

function PlanetaryProxy:SetCurrentSelectSkillTreeType(type)
    self.m_data.curSelectShowSkillTreeType = type
end

function PlanetaryProxy:GetCurrentTechDetailData()
    return self.m_data.curTechDetailDatas
end
function PlanetaryProxy:SetCurrentTechDetailData(data)
    self.m_data.curTechDetailDatas = data
end

--当前选择的科技
function PlanetaryProxy:GetCurrentSelectTechId()
    return self.m_data.curSelectTechId
end
function PlanetaryProxy:SetCurrentSelectTechId(techId)
    self.m_data.curSelectTechId = techId
end

function PlanetaryProxy:GetCurrentTechUpgradeCondition()
    return self.m_data.curTechUpgradeCondition
end
function PlanetaryProxy:SetCurrentTechUpgradeCondition(data)
    self.m_data.curTechUpgradeCondition = data
end

function PlanetaryProxy:GetCurrentTechCanUpgrade()
    return self.m_data.curTechCanUpgrade
end
function PlanetaryProxy:SetCurrentTechCanUpgrade(isCanUpgrade)
    self.m_data.curTechCanUpgrade = isCanUpgrade
end

--初始化科技树数据，保存等级为1的未解锁的所有科技
function PlanetaryProxy:SaveNeedShowSkillTreeId(techType)
    local configData = self:GetSkillTreeConfigDataByType(techType)
    if configData == nil then
        self.m_data.skillTreeIds[techType] = nil
        return
    end
    local savedData = self.m_data.skillTreeIds[techType]
    if savedData ~= nil then
        return
    end
    local data = {}
    local constValue = 5
    for i,v in pairs(configData) do
        if type(i) == "number" then
            local isUse = v[configData.EVar["in_use_n"]]
            local level = v[configData.EVar["bldg_tech_lvl_n"]]
            if isUse == 1 and level == 1 then
                local pos = v[configData.EVar["tech_coord_n"]]
                local y = pos % 1000
                local x = math.floor(pos/1000)
                local index = (y - 1) * constValue + x
                data[index] = i
            end
        end
    end
    self.m_data.skillTreeIds[techType] = data
end

function PlanetaryProxy:GetNeedShowSkillTreeItemCount(type)
    local count = 0
    if self.m_data.skillTreeIds[type] ~= nil then
        for i,v in pairs(self.m_data.skillTreeIds[type]) do
            count = math.max(count,i)
        end
    end
    return count
end

--获取显示的科技树中，相应位置的科技id，没有的为nil
function PlanetaryProxy:GetShowSkillTreeItemIdByIndex(index)
    local type = self:GetCurrentSelectSkillTreeType()
    if self.m_data.skillTreeIds[type] ~= nil then
        return self.m_data.skillTreeIds[type][index]
    end
    return nil
end

--根据id获取相应表中科技数据
function PlanetaryProxy:GetSkillTreeItemInConfig(skillId)
    if skillId == nil then
        return nil
    end
    local type = GetItemTypeByID(skillId)
    local configData = self:GetSkillTreeConfigDataByType(type)
    if configData == nil or configData[skillId] == nil then
        return nil
    end
    return { data = configData[skillId], EVar = configData.EVar}
end

--获取某一项科技的最高等级
function PlanetaryProxy:GetSkillMaxLevelInConfig(techId)
    local configData = self:GetSkillTreeItemInConfig(techId)
    if configData ~= nil then
        return configData.data[configData.EVar["max_tech_lvl_n"]]
    end
    return 0
end

--获取某一项科技的各等级的所有描述参数
function PlanetaryProxy:GetSameTechAllParamStrings(techId)
    local itemType = GetItemTypeByID(techId)
    local configData = self:GetSkillTreeConfigDataByType(itemType)
    if configData == nil then
        return nil
    end
    local datas = {}
    for i,v in pairs(configData) do
        if type(i) == "number" and math.floor(i/100) == math.floor(techId/100) then
            local isUse = v[configData.EVar["in_use_n"]]
            if isUse == 1 then
                local level = v[configData.EVar["bldg_tech_lvl_n"]]
                local str = self:GetTechParamString(v,configData.EVar,itemType)
                datas[level] = str
            end
        end
    end
    return datas
end

--获取某一科技等级的描述参数
function PlanetaryProxy:GetTechParamString(configData,configEvar,skillTreeType)
    if configData == nil then
        return ""
    end
    local param = configData[configEvar["tech_desp_s"]]
    local paramValues = {}
    if skillTreeType == NotiConst.SkillTreeType.eSKILLTREE_Building then
        table.insert(paramValues,configData[configEvar["uock_bldg_lvl_n"]])
        table.insert(paramValues,configData[configEvar["uock_bldg_qty_n"]])
    elseif skillTreeType == NotiConst.SkillTreeType.eSKILLTREE_Production then
        local data = configData[configEvar["func_param_table_repeated3"]]
        for i,v in ipairs(data) do
            table.insert(paramValues,v[2])
        end
    end
    local str = ""
    if paramValues ~= nil then
        local count = #paramValues
        if count == 1 then
            str = GetLanguageText("SkillTree", param,paramValues[1])
        elseif count == 2 then
            str = GetLanguageText("SkillTree", param,paramValues[1],paramValues[2])
        elseif count == 3 then
            str = GetLanguageText("SkillTree", param,paramValues[1],paramValues[2],paramValues[3])
        end
    end
    return str
end

--获取该项科技的前置科技
function PlanetaryProxy:GetPrerequisiteTechIds(techId)
    local techId1 = math.floor(techId / 100) * 100 + 1
    local configData = self:GetSkillTreeItemInConfig(techId1)
    if configData == nil then
        return nil
    end
    return configData.data[configData.EVar["pre_tech_id_repeated3"]]
end

--获取升级到该科技需要消耗的物品
function PlanetaryProxy:GetUpgradeCostItems(techId)
    local configData = self:GetSkillTreeItemInConfig(techId)
    if configData == nil then
        return nil
    end
    return configData.data[configData.EVar["cost_table_repeated5"]]
end

--更新科技树解锁的数据
function PlanetaryProxy:SetUnlockSkillTreeData(datas)
    self.m_data.skillTreeUnlockData = {}
    for i,v in pairs(NotiConst.SkillTreeType) do
        self.m_data.skillTreeUnlockData[v] = {}
    end
    if datas ~= nil then
        for i,v in ipairs(datas) do
            local id = v.techId
            local type = GetItemTypeByID(id)
            table.insert(self.m_data.skillTreeUnlockData[type] ,v)
        end
    end
end

--更改解锁的科技数据
function PlanetaryProxy:SetUnlockTechData(technology)
    local type = GetItemTypeByID(technology.techId)
    local data = self.m_data.skillTreeUnlockData[type]
    for i,v in ipairs(data) do
        if math.floor(v.techId/100) == math.floor(technology.techId/100 ) then
            data[i] = technology
            return
        end
    end
    table.insert(data,technology)
end

--根据id获取该项科技的已解锁或正在解锁的数据
function PlanetaryProxy:GetUnlockSkillTreeItemData(skillId)
    local type = GetItemTypeByID(skillId)
    local datas = self.m_data.skillTreeUnlockData[type]
    if datas ~= nil then
        for i,v in ipairs(datas) do
            if math.floor(v.techId/100) == math.floor(skillId/100) then
                return v
            end
        end
    end
    return nil
end

--判断科技是否已解锁
function PlanetaryProxy:IsTechUnlocked(techId)
    local type = GetItemTypeByID(techId)
    local datas = self.m_data.skillTreeUnlockData[type]
    if datas ~= nil then
        for i,v in ipairs(datas) do
            if math.floor(techId/100) == math.floor(v.techId/100) then
                if techId < v.techId or (techId == v.techId and v.techStatus == 0) then
                    return true
                end
            end
        end
    end
    return false
end

--解锁进度
function PlanetaryProxy:GetTechUnlockProgress(techType)
    local totalCount = 0
    local configData = self:GetSkillTreeConfigDataByType(techType)
    if configData ~= nil then
        for i,v in pairs(configData) do
            if type(i) == "number" then
                local isUse = v[configData.EVar["in_use_n"]]
                if isUse == 1 then
                    totalCount = totalCount + 1
                end
            end
        end
    end

    local currentCount = 0
    local datas = self.m_data.skillTreeUnlockData[techType]
    if datas ~= nil then
        for i,v in ipairs(datas) do
            local status = v.techStatus
            if status == 0 then
                currentCount = currentCount + v.techId % 100
            else
                currentCount = currentCount + v.techId % 100 - 1
            end
        end
    end
    if totalCount == 0 then
        LogError("Can not find data by techType:{0}",techType)
        return 0
    else
        return currentCount/totalCount
    end
end

--得到techid
function PlanetaryProxy:GetTechIdByconfigId(configId)
    local buidlingFuncType = math.floor((configId % 10000000) / 100)
    local techBuildingConfig = self:GetSkillTreeConfigDataByType(NotiConst.SkillTreeType.eSKILLTREE_Building)
    local unlockData = self.m_data.skillTreeUnlockData[NotiConst.SkillTreeType.eSKILLTREE_Building] 
    if unlockData ~= nil then
        for i,v in ipairs(unlockData) do
            local techId = v.techId
            local status = v.techStatus
            local techLevel = techId % 100
            if techLevel > 1 or (techLevel == 1 and status == 0) then
                if math.floor((techId % 10000000) / 100) == buidlingFuncType then
                    return techId
                end
            end

        end
    end
    return nil
end

function PlanetaryProxy:GetBuildingMax(configId)
    local techId = self:GetTechIdByconfigId(configId)
    local techConfigData = self:GetSkillTreeItemInConfig(techId)
    
    if techConfigData ~= nil then
        return techConfigData.data[techConfigData.EVar["uock_bldg_qty_n"]]
    else
        return 0
    end
end

function PlanetaryProxy:IsBuildingCountMax(configId)
    local buildingConfigData = self:GetBuildingConifData(configId)
    local buildingCount = self:GetBuildingCount(buildingConfigData.data[buildingConfigData.EVar["bldg_func_type_n"]])

    local techId = self:GetTechIdByconfigId(configId)
    local techConfigData = self:GetSkillTreeItemInConfig(techId)
    
    if techConfigData ~= nil then
        local maxCount = techConfigData.data[techConfigData.EVar["uock_bldg_qty_n"]]
        if buildingCount >= maxCount then
            return true
        end
    end
    
    return false
end

--建筑是否已经被相关科技解锁
function PlanetaryProxy:IsBuildingUnlockedByTech(configId)
    local buidlingLevel = configId % 100
    local techId = self:GetTechIdByconfigId(configId)
    local configData = self:GetSkillTreeItemInConfig(techId)
    if configData ~= nil then
        local unlockLevel = configData.data[configData.EVar["uock_bldg_lvl_max_n"]]
        if buidlingLevel <= unlockLevel then
            return true
        end
    end
    return false
end
---------------------------------------------------------------------
--加成计算-------------------------------------------------------------------\
--获取加成后的最终值
function PlanetaryProxy:GetValueAfterAddition(value,configTableName,fieldName)
    if value == nil then
        return 0
    end
    local additionIds = self:GetAdditionId(configTableName,fieldName)
    local percentageValue,absoluteValue = self:GetAdditionValue(additionIds)
    value = (value + absoluteValue) * (1 + percentageValue / 100)
    return value
end
--根据表名和字段名获取该字段的加成id和type
function PlanetaryProxy:GetAdditionId(configTableName,fieldName)
    local tableData = DATA_BLDG_FUNC_PARAM
    local EVar = tableData.EVar
    for i,v in pairs(tableData) do
        if type(i) == "number" then
            local table_name = v[EVar["table_name_s"]]
            local filed_name = v[EVar["var_name_s"]]
            if table_name == configTableName and filed_name == fieldName then
                local additionData = {
                    id = i,
                    type = v[EVar["buff_mode_n"]]
                }
                return additionData
            end
        end
    end
    return nil
end

--获取加成值
function PlanetaryProxy:GetAdditionValue(additionData)
    --计算某一表中，加成值
    local tableAddition = function (additionId,searchTableName)
        local value = 0
        if searchTableName == "TECH_PROD" then
            --生产科技表的加成
            local datas = self.m_data.skillTreeUnlockData[NotiConst.SkillTreeType.eSKILLTREE_Production]
            if datas ~= nil then
                for i,v in ipairs(datas) do
                    local status = v.techStatus
                    local level = math.floor(v.techId % 100)
                    if level > 1 or (level == 1 and status == 0) then
                        local configProd = DATA_TECH_PROD[v.techId]
                        local additions = configProd[DATA_TECH_PROD.EVar["func_param_table_repeated3"]]
                        if additions ~= nil then
                            for i,v in ipairs(additions) do
                                if v[1] == additionId then
                                    value = value + v[2]
                                end
                            end
                        end
                    end
                end
            end
        end
        return value
    end
    
    local percentageValue,absoluteValue = 0,0
    if additionData ~= nil then
        local type = additionData.type
        local id = additionData.id
        local value = tableAddition(id,"TECH_PROD")
        if type == NotiConst.AdditionType.eAddition_Percentage then
            percentageValue = value
        else
            absoluteValue = value
        end
    end
    return percentageValue,absoluteValue
end

---------------------------------------------------------------------
--用户模板数据
function PlanetaryProxy:SetUserMods(mods)
    self.m_data.userModsData = mods
end

function PlanetaryProxy:GetUserMods()
    return self.m_data.userModsData
end

function PlanetaryProxy:GetUserModByIndex(index)
    return self.m_data.userModsData[index]
end

function PlanetaryProxy:GetUserModById(modId)
    local userModsData = self.m_data.userModsData
    for i=1,#userModsData do
        local temp = userModsData[i]
        if temp.id == modId then
            return temp
        end 
    end
    return nil
end

function PlanetaryProxy:AddUserMod(mod)
    table.insert(self.m_data.userModsData, mod)
end

function PlanetaryProxy:RemoveUserMod(modId)
    local userModsData = self.m_data.userModsData
    for i=1,#userModsData do
        local temp = userModsData[i]
        if temp.id == modId then
            table.remove(userModsData, i)
            break
        end 
    end
end

function PlanetaryProxy:EditUserMod(mod)
    local userModsData = self.m_data.userModsData
    for i=1,#userModsData do
        local temp = userModsData[i]
        if temp.id == mod.id then
            userModsData[i] = mod
            break
        end 
    end
end

--重置计数引用
function PlanetaryProxy:ResetModsUsedData()
    self.m_data.modsUsed = {}
end

function PlanetaryProxy:EditModsUsedCount(hullId, isAdd)
    local count = self.m_data.modsUsed[hullId]
    if count == nil then
        count = 0
        self.m_data.modsUsed[hullId] = 0
    end

    if isAdd then
        self.m_data.modsUsed[hullId] = count + 1
        return true
    elseif count > 0 then
        self.m_data.modsUsed[hullId] = count - 1
        return true
    end
    return false
end

function PlanetaryProxy:GetModsUsedCount(hullId)
    if hullId == nil then
        LogError("PlanetaryProxy:GetModsUsedCount hullId is nil")
        return 0
    end

    local count = self.m_data.modsUsed[hullId]
    if count == nil then
        count = 0
        self.m_data.modsUsed[hullId] = 0
    end
    return count
end


function PlanetaryProxy:SetcurFormRefitEditShipData(data)
    self.m_data:SetcurFormRefitEditShipData(data)
end

function PlanetaryProxy:GetcurFormRefitEditShipData()
    return self.m_data:GetcurFormRefitEditShipData()
end

function PlanetaryProxy:SetcurFormRefitEditShipSelectData(inedx, isSelect)
    self.m_data:SetcurFormRefitEditShipSelectData(inedx, isSelect)
end

function PlanetaryProxy:SetcurFormRefitEditShipTempCount(count)
    self.m_data:SetcurFormRefitEditShipTempCount(count)
end

function PlanetaryProxy:GetcurFormRefitEditShipTempCount()
    return self.m_data:GetcurFormRefitEditShipTempCount()
end

function PlanetaryProxy:InitcurFormRefitEditShipTempNeedCount()
    self.m_data:InitcurFormRefitEditShipTempNeedCount()
end

function PlanetaryProxy:SetcurFormRefitEditShipTempNeedCount(itemId, count)
    self.m_data:SetcurFormRefitEditShipTempNeedCount(itemId, count)
end

function PlanetaryProxy:GetcurFormRefitEditShipTempNeedCountAll()
    return self.m_data:GetcurFormRefitEditShipTempNeedCountAll()
end

function PlanetaryProxy:GetcurFormRefitEditShipTempNeedCount(itemId)
    return self.m_data:GetcurFormRefitEditShipTempNeedCount(itemId)
end

--设置当前过滤模板的Key
function PlanetaryProxy:SetFilterKey(filterKey)
    self.m_data.curFilterKey = filterKey
end

function PlanetaryProxy:GetFilterKey()
    return self.m_data.curFilterKey
end

function PlanetaryProxy:SetBuildingMoveMod(isMove)
    self.m_data:SetBuildingMoveMod(isMove)
end

function PlanetaryProxy:GetBuildingMoveMod()
    return self.m_data:GetBuildingMoveMod()
end

function PlanetaryProxy:SetIsPortShipNew(isNew)
    self.m_data:SetIsPortShipNew(isNew)
end

function PlanetaryProxy:SetIsPortFleetNew(isNew)
    self.m_data:SetIsPortFleetNew(isNew)
end

function PlanetaryProxy:GetIsPortShipNew()
    if self.m_data.IsPortShipNew then
        return true
    else
        return false
    end
end

function PlanetaryProxy:GetIsPortFleetNew()
    if self.m_data.IsPortFleetNew then
        return true
    else
        return false
    end
end

function PlanetaryProxy:GetCNKey(name)
    return {
        keyV = DATA_VAR_TO_TRANSL_KEY[name][1],
        keyN = DATA_VAR_TO_TRANSL_KEY[name][2],
    }
end

function PlanetaryProxy:GetBuildingFunData(configData,evar,name)
    local funcTable = _G["DATA_"..configData[evar["bldg_func_table_name_s"]]]
    local funcId = configData[evar["bldg_func_table_id_n"]]
    if funcTable then
        return funcTable[funcId][funcTable.EVar[name]]
    end
    return nil
end

-- 改变label的颜色 用于资源不足时标红的情景
function PlanetaryProxy:SetLabelColor(label, isRed)
    if isRed then
        label.color = Color.New(1, 127/255, 117/255, label.color.a)
    else
        label.color = Color.New(1, 1, 1, label.color.a)
    end
end

return PlanetaryProxy