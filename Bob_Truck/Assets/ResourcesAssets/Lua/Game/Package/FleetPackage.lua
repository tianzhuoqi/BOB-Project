local FleetPackage = {}

FleetPackage.allFleetsData = {} --全部的舰队数据map
FleetPackage.myFleetsData = {} --自己的舰队数据map
FleetPackage.myFleetsDataByType = {} --按种类的舰队数据
FleetPackage.operationData = {} --操作
FleetPackage.completedOperData = {} --操作
FleetPackage.currentOperation = {} --当前的操作

FleetPackage.allShipsData = {} --舰队下舰船的数据

FleetPackage.fleetsVCounter = {} --数据更新计数

FleetPackage.fleetsDataPipeLine = {} --舰队操作流水线

FleetPackage.protFleetsData = {} --港口舰队数据map
FleetPackage.protShipsData = {} --港口单舰数据map
FleetPackage.fleetShipsData = {} --舰队舰船数据map
FleetPackage.fleetGoodsData = {} --舰队货物数据map
FleetPackage.curPackageGoodsData = {}
FleetPackage.fleetQueueShipsData = {} --舰队编队数据map
FleetPackage.fleetListInfoData = {} --我方舰队列表数据list
FleetPackage.currentSelectIndex = {}

FleetPackage.currentNodeMyFleetList = {}  --当前选择星系内的我方舰队数据

--[[ 操作数据结构
local operationData = 
{
    targetGalaxyId = 0, --目标星系
    targetPlanetId = 0, --目标星球
    fleetId = 0, --使用舰队
    type = 0, --操作类型 1.移动 2.探索 3.占领殖民
    path = {}, --路径
    pathLines = {}, --路径连线
    distance = 0, --总距离
    dynamicData = {} --操作数据
}
]]
return FleetPackage