local PlanetaryPackage = {}

-- planetData : 一个行星的数据模型
-- sunData : 一个恒星的数据模型
-- hexData ： 暂未使用

--星球操作
-- planetData.operation = {name, startTime, endTime}

PlanetaryPackage.palnetaryId = -1

PlanetaryPackage.performanceData = nil  
PlanetaryPackage.planetDataMap = {}                 -- id => planetData
PlanetaryPackage.sunDataMap = {}                    -- id => hexData
--PlanetaryPackage.sunsMap = {}                     -- id => sunData
PlanetaryPackage.fleetDataMap = {}                  -- fleetId => fleetData
PlanetaryPackage.buildingDataMap = {}               -- buildingId => buildingData
PlanetaryPackage.belt = nil
PlanetaryPackage.relic = nil
PlanetaryPackage.spectacleId = nil
PlanetaryPackage.curBuildingOper = nil --当前挂起的操作
PlanetaryPackage.buildingOperation = {} --建筑操作list
PlanetaryPackage.GridsUsed = {} --已经被占用的点
PlanetaryPackage.buildingClassTable = {}

PlanetaryPackage.buildingData = {}
PlanetaryPackage.curBuildingData = {}

PlanetaryPackage.buildingConfigDataByType = {}
PlanetaryPackage.shipHullConfigDataByType = {}
PlanetaryPackage.shipCpntConfigDataByType = {}
PlanetaryPackage.shipModConfigData = {}
PlanetaryPackage.shipModHullConfigDataByType = {}
PlanetaryPackage.shipModCpntConfigData = {}
PlanetaryPackage.userModsData = {}
PlanetaryPackage.modsUsed = {} --已经使用过的模型

PlanetaryPackage.curPackageShipHullData = {}
PlanetaryPackage.curPackageShipCpntData = {}
PlanetaryPackage.curFilterKey = ""

PlanetaryPackage.skillTreeIds = {}              --保存科技树中显示的等级为1的科技ID,{type = {index = id}}，访问方式:type,坐标计算的index
PlanetaryPackage.skillTreeUnlockData = {}       --科技树中解锁的数据
PlanetaryPackage.curSelectShowSkillTreeType = 0 --暂存当前科技界面中选择显示的科技类型
PlanetaryPackage.curSelectTechId = 0            --暂存当前选择的科技Id
PlanetaryPackage.curTechUpgradeCondition = {}   --暂存科技升级条件数据
PlanetaryPackage.curTechDetailDatas = {}        --暂存科技详情数据
PlanetaryPackage.curTechCanUpgrade = true       --暂存科技是否科技升级数据

PlanetaryPackage.curFormRefitEditShipData = {}
PlanetaryPackage.curFormRefitEditShipTempCount = 0      -- 改装界面已选择舰船回收的零件 占用仓库的体积
PlanetaryPackage.curFormRefitEditShipTempNeedCount = {} -- 改装界面已选择舰船需要消耗的个数

PlanetaryPackage.elecMsg = {}

PlanetaryPackage.IsMoveMod = false


--TODO 暂时的红点状态 chenjun
PlanetaryPackage.IsPortShipNew = false
PlanetaryPackage.IsPortFleetNew = false

--[[
    buildingOper = {
        uid = 101115,
        nodeId =1000,
        targetBuilding = 1,--id
        configId = 12121,
        type=0,--操作类型
        dynamicData = {} --其他动态数据
    }
]]

--舰体厂生产队列
PlanetaryPackage.HullfactMSG = {}

--地图数据
PlanetaryPackage.SolarConfig = require("Data/Config/SolarConfig")
PlanetaryPackage.ResourceConfig = require("Data/Config/ResourceConfig")
PlanetaryPackage.NameConfig = require("Data/Config/NameConfig")
PlanetaryPackage.GridMapStruct = {}
local dHex = 1.732
PlanetaryPackage.HexagonEdgeDirect = { --六边形边方向，1为上，逆时针
    {0,dHex},
    {-1.5,dHex/2},
    {-1.5,-dHex/2},
    {0.0,-dHex},
    {1.5,-dHex/2},
    {1.5,dHex/2},
}

PlanetaryPackage.Grids = {}

function PlanetaryPackage:SetGrids(grids)
    self.Grids = grids
end

function PlanetaryPackage:GetGrids()
    return self.Grids
end

--构建六边形地图结构,索引从1开始
function PlanetaryPackage:BuildGridMapStruct() 
    local grids = {}
    
    for i = -55, 55 do
        for j = -55, 55 do
            grids[(i + 55) * 1000 + j + 55] = {showHUD = false, gridId = (i + 55) * 1000 + j + 55,}
        end
    end

    self.GridMapStruct = grids
end

function PlanetaryPackage:GetBuildingDataTypeId(buildingId)
    return math.floor(buildingId/100)
end


function PlanetaryPackage:SaveBuildingData(building)
    self.buildingDataMap = {}
    for i = 1, #building do
        self.buildingDataMap[building[i].id] = {id = building[i].id, buildingConfigId = building[i].buildingConfigId, pos = building[i].pos, status = building[i].status, startTime = building[i].startTime, endTime = building[i].endTime,getItemTime = building[i].getItemTime, fleets = building[i].fleets}
    end
end

function PlanetaryPackage:SaveElecMsg(elecMsg)
    self.elecMsg = elecMsg
end

function PlanetaryPackage:GetElecMsg()
    return self.elecMsg
end

function PlanetaryPackage:AddBuildingData(building)
    local mapbuilding = nil
    if self.buildingDataMap[building.id] ~= nil then
        mapbuilding = self.buildingDataMap[building.id].building
    end
    self.buildingDataMap[building.id] = {id = building.id, buildingConfigId = building.buildingConfigId, pos = building.pos, status = building.status, startTime = building.startTime, endTime = building.endTime,getItemTime = building.getItemTime, fleets = building.fleets}
    self.buildingDataMap[building.id].building = mapbuilding
end

function PlanetaryPackage:RemoveBuildingData(buildingId)
    self.buildingDataMap[buildingId] = nil
end

function PlanetaryPackage:GetBuildingDataById(buildingId)
    return self.buildingDataMap[buildingId]
end

function PlanetaryPackage:GetBuildingData()
    return self.buildingDataMap
end

function PlanetaryPackage:SaveBuildingList(data)
    self.building = data
end

function PlanetaryPackage:SavePlanetStatus(planetProtos)
    self.planetProtos = planetProtos
end

function PlanetaryPackage:GetBuildingList(data)
    return self.building
end

function PlanetaryPackage:AddGridsUsedByGridId(gridId, gridData)
    if self.GridsUsed[gridId] == nil then
        if gridData then
            self.GridsUsed[gridId] = gridData
        else
            self.GridsUsed[gridId] = 1
        end
        
    end
end

function PlanetaryPackage:RemoveGridsUsedByGridId(gridId)
    self.GridsUsed[gridId] = nil
end

function PlanetaryPackage:GetGridsUsedByGridId(gridId)
    return self.GridsUsed[gridId]
end

function PlanetaryPackage:SetPlanetStatus()
    local planetProtos = self.planetProtos
    if planetProtos ~= nil then
        local planetDataMap = self.planetDataMap
        for i = 1, #planetProtos do
            local planetProto = planetProtos[i]
            if planetProto ~= nil then
                local planetData = planetDataMap[planetProto.id]
                planetData.depth = planetProto.depth
            end
        end
    end
    self.planetProtos = nil
end

function PlanetaryPackage:Init()
    self:BuildGridMapStruct()
end

PlanetaryPackage:Init()

-- 获得Hex的数据模型
function PlanetaryPackage:GetHexDataBygridId(gridId)
    return self.hexDataMap[gridId]
end

function PlanetaryPackage:SavePlanetBuildingList(data)
    self.building = data
end

-- 获得舰队的数据模型
function PlanetaryPackage:GetFleetDataByFleetId(fleetId)
    return self.fleetDataMap[fleetId]
end

function PlanetaryPackage:SetHullfactMSGProductLine(productLine)
    self.HullfactMSG.productLine = productLine
end

function PlanetaryPackage:GetHullfactMSGProductLine()
    return self.HullfactMSG.productLine
end

function PlanetaryPackage:SetHullfactMSGStartTime(startTime)
    self.HullfactMSG.startTime = startTime
end

function PlanetaryPackage:GetHullfactMSGStartTime()
    return self.HullfactMSG.startTime
end

function PlanetaryPackage:AddbuildingClassTable(buildClass)
    table.insert( self.buildingClassTable, buildClass)
end

function PlanetaryPackage:InitbuildingClassTable()
    self.buildingClassTable = {}
end

function PlanetaryPackage:GetbuildingClassTable()
    return self.buildingClassTable
end

function PlanetaryPackage:SetcurFormRefitEditShipData(data)
    self.curFormRefitEditShipData = data
end

function PlanetaryPackage:GetcurFormRefitEditShipData()
    return self.curFormRefitEditShipData
end

function PlanetaryPackage:SetcurFormRefitEditShipSelectData(inedx, isSelect)
    self.curFormRefitEditShipData[inedx][2] = isSelect
end

function PlanetaryPackage:SetcurFormRefitEditShipTempCount(count)
    self.curFormRefitEditShipTempCount = self.curFormRefitEditShipTempCount + count
end

function PlanetaryPackage:GetcurFormRefitEditShipTempCount()
    return self.curFormRefitEditShipTempCount
end

function PlanetaryPackage:InitcurFormRefitEditShipTempNeedCount()
    self.curFormRefitEditShipTempNeedCount = {}
end

function PlanetaryPackage:SetcurFormRefitEditShipTempNeedCount(itemId, count)
    if self.curFormRefitEditShipTempNeedCount[itemId] == nil then
        self.curFormRefitEditShipTempNeedCount[itemId] = 0
    end
    self.curFormRefitEditShipTempNeedCount[itemId] = self.curFormRefitEditShipTempNeedCount[itemId] + count
end

function PlanetaryPackage:GetcurFormRefitEditShipTempNeedCountAll()
    return self.curFormRefitEditShipTempNeedCount
end

function PlanetaryPackage:GetcurFormRefitEditShipTempNeedCount(itemId)
    if self.curFormRefitEditShipTempNeedCount[itemId] == nil then
        return 0
    else
        return self.curFormRefitEditShipTempNeedCount[itemId]
    end
end

function PlanetaryPackage:SetBuildingMoveMod(isMove)
    self.IsMoveMod = isMove
end

function PlanetaryPackage:GetBuildingMoveMod()
    if self.IsMoveMod then
        return true
    else
        return false
    end
end

function PlanetaryPackage:SetIsPortShipNew(isNew)
    self.IsPortShipNew = isNew
end

function PlanetaryPackage:SetIsPortFleetNew(isNew)
    self.IsPortFleetNew = isNew
end

return PlanetaryPackage