local UniversePackage = {}
UniversePackage.SolarConfig = require("Data/Config/SolarConfig")
UniversePackage.ResourceConfig = require("Data/Config/ResourceConfig")
UniversePackage.NameConfig = require("Data/Config/NameConfig")
UniversePackage.TNodeType = {
    None = 0,
    Node = 1,
	EdgeNode = 2,
    EdgeCenter = 3,
}

UniversePackage.EdgeType = {
    None = 0,
	Top = 1,
	Left = 2,
	Bottom= 3,
	Right= 4,
}

UniversePackage.SafeLevel = {
    None = 0,
    A = 1,
    B = 2,
    C = 3,
    D = 4,
}

UniversePackage.WorldWidth = 3
UniversePackage.WorldHeight = 3
UniversePackage.ClusterSize = 811.3013
UniversePackage.MapPath = "Data/Map/"
UniversePackage.CameraScale = 1
UniversePackage.RegionSize = {
    UniversePackage.WorldWidth * UniversePackage.ClusterSize / 5,
    UniversePackage.WorldHeight * UniversePackage.ClusterSize / 5,
}

UniversePackage.allMapData = {} --所有地图信息 
--UniversePackage.allMapData[id].dynmicData = {}--该点上的动态数据
UniversePackage.allFleetsData = {} --所有舰队数据

UniversePackage.cameraData = {} --相机所用的点信息
UniversePackage.currentPosition = nil --当前位置
UniversePackage.currentOperationNodeId = 0   --当前点击操作位置的nodeid
UniversePackage.currentOperationNodeisHaveOwner = 0   --当前点击的星系是否是无主地
UniversePackage.currentOperationNodeisCollecting = 0  --当前点击的星系是否正在被舰队采集

UniversePackage.regionData = {} --星团区域数据

function table.indexOf( t, value, iBegin )
    for i = iBegin or 1, #t do
        if t[i] == value then
            return i
        end
    end
    return false
end

function UniversePackage:BuildRegionData()
    self.regionData = {}
    local wd = UniversePackage.RegionSize[1]
    local hd = UniversePackage.RegionSize[2]
    local x = 0
    local y = 0
    local id = 1
    for i=0,4 do
        for j=0,4 do
            local data = {
                pos1 = {x,y},
                pos2 = {x+wd,y+wd},
                cn = "WPanelArea"..id--DATA_REGION_NAME[id][DATA_REGION_NAME.EVar["region_name_s"]]
            }
            table.insert(self.regionData,data)
            id = id + 1
            x = x + wd
        end
        y = y + wd
    end
end

function UniversePackage:Init()
    self.allMapData = {}
    self.allFleetsData = {}
    self.cameraData = {}
    --self:LoadTestData()
    self:BuildRegionData()
end

UniversePackage:Init()

return UniversePackage