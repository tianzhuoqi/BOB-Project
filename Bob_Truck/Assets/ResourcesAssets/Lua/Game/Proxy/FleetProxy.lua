local FleetProxy = class("FleetProxy",Proxy)
local UserDataPackage = LoadPackage(NotiConst.Package_UserData)
local UniversePackage = LoadPackage(NotiConst.Package_Universe)

--配置数据
local configData = {
    [22] = {data = DATA_ITEM_RES, relation = {["name_s"] = "res_name_s"}},
    [21] = {data = DATA_ITEM_MIN, relation = {["name_s"] = "min_name_s"}},
    [2] = {data = DATA_SHIP_HULL_TECH, relation = {["name_s"] = "hull_name_s"}},
    [3] = {data = DATA_SHIP_CPNT_TECH, relation = {["name_s"] = "cpnt_name_s"}}
 }

 --背包配置
 local packageConfig = {
    [0] = {21},
    [1] = {22},
    [2] = {2, 3},
    [3] = {}
 }

function FleetProxy:OnRegister()
    
end

function FleetProxy:OnRemove()

end

function FleetProxy:GetAllFleetsData()
    return self.m_data.allFleetsData
end

--[[function FleetProxy:GetMyFleetsData()
    return self.m_data.myFleetsData
end]]


function FleetProxy:CheckFleetModified(fleetId,fleetData)
    local old = self:GetFleetDataByFleetId(fleetId)
    if old == nil then
        return true
    end
    if fleetData == nil then
        return true
    end
    if old.startTime ~= fleetData.startTime then     
        return true
    end
    if old.endTime ~= fleetData.endTime then
        return true
    end
    if old.finalMoveNodeId ~= fleetData.finalMoveNodeId then
        return true
    end
    if old.toNodeId ~= fleetData.toNodeId then
        return true
    end
    if old.fromNodeId ~= fleetData.fromNodeId then
        return true
    end
    if old.moveSpeed ~= fleetData.moveSpeed then
        return true
    end
    return false
end

function FleetProxy:CopyFleetData(fleetData)
    local cpyFleet = {}
    for k,v in pairs(fleetData) do
        cpyFleet[k] = v
    end
    return cpyFleet
end
--构建Fleet数据用于处理
function FleetProxy:BuildFleetData(pfleetData)
    local old = self:GetFleetDataByFleetId(pfleetData.fleetId)
    local nfleetData = {}
    nfleetData.fleetName = pfleetData.fleetName
    nfleetData.fleetId = pfleetData.fleetId
    nfleetData.uid = pfleetData.uid
    nfleetData.moveSpeed = pfleetData.moveSpeed or 0
    nfleetData.fromNodeId = pfleetData.fromNodeId
    nfleetData.toNodeId = pfleetData.toNodeId
    if pfleetData.startTime ~= nil then
        nfleetData.startTime = pfleetData.startTime/1000
    else
        nfleetData.startTime = 0
    end

    if pfleetData.endTime ~= nil then
        nfleetData.endTime = pfleetData.endTime/1000
    else
        nfleetData.endTime = 0
    end
    nfleetData.moveNodes = pfleetData.moveNodes
    nfleetData.nodeId = pfleetData.nodeId
    nfleetData.lastNodeId = pfleetData.lastNodeId
    nfleetData.finalMoveNodeId = pfleetData.finalMoveNodeId
    nfleetData.type = pfleetData.status or 0 --状态和类型
    nfleetData.notList = true
    nfleetData.reset = false --是否需要重置位置
    nfleetData.changeSpeed = false --速度改变
    nfleetData.processed = false --PipeLine是否已经处理
    nfleetData.userShips = pfleetData.userShips --舰船数据
    local isModified = self:CheckFleetModified(nfleetData.fleetId,nfleetData)
    if old ~= nil then
        --LogError(fleetData.endTime.."=="..old.endTime)
        if nfleetData.toNodeId ~= old.toNodeId then
            nfleetData.reset = true
        elseif nfleetData.endTime ~= old.endTime then
            nfleetData.changeSpeed = true
        end
    else
        nfleetData.reset = true
        nfleetData.changeSpeed = true
    end
    nfleetData.isStop = false
    --if nfleetData.fromNodeId then --非舰队列表数据填充
        if nfleetData.fromNodeId == nfleetData.finalMoveNodeId or nfleetData.finalMoveNodeId == 0 then
            nfleetData.isStop = true
        else
            nfleetData.type = common_pb.MOVE
        end
    --end
    if nfleetData.type == common_pb.BERTH then
        nfleetData.isStop = true
    end

    return isModified,nfleetData
end
--获取舰队当前时间的操作
function FleetProxy:GetCurFleetDataOfPipeLine(fleetId,time)
    if self.m_data.fleetsDataPipeLine[fleetId] == nil then
        self.m_data.fleetsDataPipeLine[fleetId] = {}
    end
    local pipeLine = self.m_data.fleetsDataPipeLine[fleetId]
    for i=1,#pipeLine do
        local v = pipeLine[i]
        local nv = pipeLine[i+1]
        if v.startTime <= time and (nv == nil or (nv and nv.startTime>time)) then
            return v
        end
    end

    return nil
end
--获取舰队操作流水线
function FleetProxy:GetFleetDataPipeLine(fleetId,time)
    if self.m_data.fleetsDataPipeLine[fleetId] == nil then
        self.m_data.fleetsDataPipeLine[fleetId] = {}
    end
    local pipeLine = self.m_data.fleetsDataPipeLine[fleetId]
    --传入当前时间，清除已经操作过的
    if time then
        local cutP = 0
        for i,v in ipairs(pipeLine) do
            if v.processed == false then
                cutP = i - 3
                break
            end
        end
        if cutP > 0 then
            for i=1,cutP do
                table.remove(pipeLine,cutP-i+1)
            end
        end
    end

    return pipeLine
end
--加入舰队数据到流水线中
function FleetProxy:SetFleetDataPipeLine(nfleetData)
    local pipeLine = self:GetFleetDataPipeLine(nfleetData.fleetId)
    local pos = 0
    if nfleetData.startTime == 0 then
        table.insert(pipeLine,nfleetData)
        return
    end
    for i,v in ipairs(pipeLine) do
        if v.startTime == nfleetData.startTime then
            pos = i
            break
        end
    end
    if pos > 0 then
        local old = pipeLine[pos]
        pipeLine[pos] = nfleetData
    else
        table.insert(pipeLine,nfleetData)
    end
end

function FleetProxy:RemoveFleetDataPipeLine(fleetId)
    self.m_data.fleetsDataPipeLine[fleetId] = nil
end

--添加、更新舰队
function FleetProxy:SetFleetData(fleetData)
    self:SetFleetsData({fleetData})
end
function FleetProxy:SetFleetsData(fleetsData,fleetsIdsOut,recycle)
    local uid = UserDataPackage.uid
    local tempFidsOut = {}
    local tempNidsOut = {}
    if recycle then
        local validIds = {}
        
        for i,v in ipairs(fleetsData) do
            validIds[v.fleetId] = true
        end
        local needRemove = {}
        for k,v in pairs(self.m_data.allFleetsData) do
            if not validIds[k] then
                table.insert(needRemove,k)
            end
        end
        self:RemoveFleetsData(needRemove,true)
    end
    
    for i,v in ipairs(fleetsData) do
        local isModified,fleetD = self:BuildFleetData(v)
        local valid = (v.fromNodeId~=nil)

        if valid then
            if fleetD.uid == uid then
                self.m_data.myFleetsData[fleetD.fleetId] = fleetD
            end
            self.m_data.allFleetsData[fleetD.fleetId] = fleetD
    
            local typeList = self:GetMyFleetsDataByType(fleetD.type)
            local added = false
            for j,vt in ipairs(typeList) do
                if vt.fleetId == fleetD.fleetId then
                    typeList[j] = fleetD
                    added = true
                    break
                end
            end
            self:UpdateFleetListInfo(fleetD)--同步相关状态到舰队列表
            if not added then
                table.insert(typeList,fleetD)
            end
            
            if isModified then
                self:SetFleetDataPipeLine(fleetD)
                if fleetsIdsOut ~= nil then
                    table.insert(fleetsIdsOut,fleetD.fleetId)
                end
                table.insert(tempFidsOut,fleetD.fleetId)
                if fleetD.fromNodeId and fleetD.fromNodeId > 0 then
                    tempNidsOut[fleetD.fromNodeId] = true
                end
                if fleetD.toNodeId and fleetD.toNodeId > 0 then
                    tempNidsOut[fleetD.toNodeId] = true
                end
                if fleetD.nodeId and fleetD.nodeId > 0 then
                    tempNidsOut[fleetD.nodeId] = true
                end
            end
            --增加计数
            local counter = self.m_data.fleetsVCounter[fleetD.fleetId] or {count = 0,time = 0}
            counter.count = counter.count + 1
            counter.time = GetServerTimeStamp()
            self.m_data.fleetsVCounter[fleetD.fleetId] = counter
        end
    end
    Facade:SendNotification(NotiConst.Notify_FleetDataChanged,{fids=tempFidsOut,nids=tempNidsOut})
end

--  点内拉取舰队数据后,更新fleetData。只在进点拉取数据后执行一次
function FleetProxy:AddPlanetaryFleetData(fleetProtos)
    for i=0, #fleetProtos do 
        local fleetProto = fleetProtos[i]
        if fleetProto ~= nil then
            local tempfleetData = {
                fleetId = fleetProto.fleetId,
                uid = fleetProto.uid,
                nodeId = fleetProto.nodeId,
            }
            self:SetFleetData(tempfleetData)
            self:AddPlanetaryOperation(fleetProto)
        end
    end
end

--按照计数清理过期数据
function FleetProxy:CleanFleetsData()
    local tNow = GetServerTimeStamp()
    for k,v in pairs(self.m_data.fleetsVCounter) do
        --只清理非己方的舰队
        if self.m_data.myFleetsData[k] == nil then
            if tNow - v.time > 10 then
                self:RemoveFleetData(k)
            end
        end
    end
end

--移除舰队,mine是否移除自己的
function FleetProxy:RemoveFleetData(fleetId,mine)
    self:RemoveFleetsData({fleetId},mine)
end
function FleetProxy:RemoveFleetsData(fleetsDataIds,mine)
    for i,id in ipairs(fleetsDataIds) do
        if self.m_data.allFleetsData[id] then
            print("removeFleet!!!"..id)
            self.m_data.allFleetsData[id] = nil
            self.m_data.allShipsData[id] = nil
            if mine then
                self.m_data.myFleetsData[id] = nil
                for k,vc in pairs(self.m_data.myFleetsDataByType) do
                    for j,vcf in ipairs(vc) do
                        if vcf.fleetId == id then
                            table.remove(vc,j)
                            break
                        end
                    end
                end
            end
        end
    end
end
--获取自己的舰队map，如果type=nil，返回自己所有的舰队list
--请使用GetFleetListInfoData()
function FleetProxy:GetMyFleetsDataByType(type)
    if type then
        if self.m_data.myFleetsDataByType[type] == nil then
            self.m_data.myFleetsDataByType[type] = {}
        end
        return self.m_data.myFleetsDataByType[type]
    else
        local list = {}
        for k,v in pairs(self.m_data.myFleetsData) do
            table.insert(list,v)
        end
        return list
    end
end

function FleetProxy:GetFleetDataByFleetId(fleetId)
    return self.m_data.allFleetsData[fleetId]
end

function FleetProxy:GetmyFleetsDataByFleetId(fleetId)
    return self.m_data.myFleetsData[fleetId]
end

--获得对应星系中的我的舰队
function FleetProxy:GetMyFleetsDataByNodeId(nodeId)
    local myFleetsData = self:GetFleetListInfoData()
    local fleetList = {}
    for idx, fleetData in pairs(myFleetsData) do
        if fleetData.nodeId == nodeId then
            table.insert(fleetList, fleetData)
        end
    end
    return fleetList
end

--对应星系中是否已经驻有我的舰队
function FleetProxy:IsHasMyFleetByNodeId(nodeId)
    local myFleets = self:GetMyFleetsDataByNodeId(nodeId)
    if myFleets ~= nil then
        for i,v in ipairs(myFleets) do
            if v.fromNodeId == v.toNodeId then
                return true
            end
        end
    end
    return false
end

--对应星系中所有舰队
function FleetProxy:GetAllFleetsDataByNodeId(nodeId)
    local allFleets = self.m_data.allFleetsData
    local fleetList = {}
    if allFleets ~= nil then
        for i,v in pairs(allFleets) do
            if v.nodeId == nodeId then
                table.insert(fleetList,v)
            end
        end
    end
    return fleetList
end

--构建场景所需的数据结构
function FleetProxy:BuildCameraData(hasLoaded)
    local cameraData = {}
    for k,v in pairs(self.m_data.allFleetsData) do
        if hasLoaded[k] ~= nil then
            cameraData[k] = self:BuildCameraDataById(k)
        end
    end
    return cameraData
end
--构建场景所需的数据结构
function FleetProxy:BuildCameraDataById(fleetId)
    local v = self.m_data.allFleetsData[fleetId]
	local fromNode = UniversePackage.allMapData[v.fromNodeId]
	local toNode = UniversePackage.allMapData[v.toNodeId]
	--[[local dx = toNode.position.x - fromNode.position.x
	local dy = toNode.position.y - fromNode.position.y
	local length = math.floor(math.sqrt(dx * dx + dy * dy))
	local dv = {dx / length, dy / length}
	local t = GetServerTimeStamp()
	local k = 0
	if v.startTime > 0 and v.endTime > v.startTime then
		k =(t - v.startTime) /(v.endTime - v.startTime)
	end
	dv[1] = dv[1] * length * k
	dv[2] = dv[2] * length * k]]
    --local res = string.format("ModelFBX/Solarsystem/Prefabs/c1ic%02d.prefab", v.type + 1)
    local res = string.format("ModelFBX/Solarsystem/Prefabs/c1ic%02d.prefab",2)
	local data = {
		id = fleetId,
		Name = v.name,
        pos = {fromNode.position.x, fromNode.position.y},
        makeData = v.userShips,--用于构建
		shipIcon = {
            pos = {0,0},
            scale = 2,
            ResPath = res,
            rot = {0, 180, 0}
        },
    }
    return data
end
-- 添加新操作
function FleetProxy:AddOperation(targetGalaxyId,fleetId,type)
    local operationData = {
        targetGalaxyId = targetGalaxyId,
        fleetId = fleetId,
        type = type
    }
    self:AddOperationData(operationData)
end

--进点内拉取舰队数据后，更新fleet的operation data
function FleetProxy:AddPlanetaryOperation(fleetProto)
    local fleetId = fleetProto.fleetId
    local status = fleetProto.status
    local type = nil
    if status == common_pb.EXPLORE then
        type = common_pb.EXPLORE
    elseif status == common_pb.COLLECT then
        type = common_pb.COLLECT
    end

    if type == nil then
        return
    end
    
    local operationData = {
        targetPlanetId = fleetProto.planetId,
        dynamicData = {
            startTime = fleetProto.startTime / 1000,
            endTime = fleetProto.endTime / 1000,
        },
        fleetId = fleetId,
        type = type,
    }
    self:AddOperationData(operationData)
end

-- 添加操作数据
function FleetProxy:AddOperationData(operationData)
    table.insert(self.m_data.operationData,operationData)
end

-- 添加挂起的操作
function FleetProxy:SetCurrentOperation(operationData)
    self.m_data.currentOperation = operationData
end

function FleetProxy:GetCurrentOperation()
    return self.m_data.currentOperation
end


function FleetProxy:GetOperationDataList()
    return self.m_data.operationData
end

function FleetProxy:GetFleetMoveNodes(fleetId)
    local fleet = self:GetFleetDataByFleetId(fleetId)
    if fleet == nil then
        return nil
    end
    return fleet.moveNodes
end

function FleetProxy:SetFleetMoveNodes(fleetId, moveNodes)
    local fleet = self:GetFleetDataByFleetId(fleetId)
    if fleet == nil then
        return
    end
    fleet.moveNodes = moveNodes
end

function FleetProxy:GetOperationDataByFleetId(fleetId)
    local operationList = self:GetOperationDataList()
    for idx, operationData in pairs(operationList) do
        if operationData.fleetId == fleetId then
            return operationData
        end
    end
    return nil
end

function FleetProxy:CompleteOperation(fleetId,checkFunc)
    for i,v in ipairs(self.m_data.operationData) do
        if v.fleetId == fleetId then
            if checkFunc ~= nil then
                if checkFunc(v) then
                    table.insert(self.m_data.completedOperData,v)
                    table.remove(self.m_data.operationData,i)
                    return true
                end
            else
                table.insert(self.m_data.completedOperData,v)
                table.remove(self.m_data.operationData,i)
                return true
            end
            return false
        end
    end
    return true
end

function FleetProxy:GetOperDataByFleetId(fleetId)
    for i,v in ipairs(self.m_data.operationData) do
        if v.fleetId == fleetId then
            return v
        end
    end
    return nil
end

function FleetProxy:GetFleetStatus(fleetId)
    local fleet = self.m_data.allFleetsData[fleetId]
    if fleet == nil then
        return 0
    end
    local operation = nil
    if operation == nil then
        if fleet.fromNodeId ~= fleet.toNodeId then
            return common_pb.MOVE
        end
        return 0
    end
    return operation.type
end


--------------------------------舰船操作
--设置舰船数据
function FleetProxy:SetShipsData(fleetId,shipData)
    local dataSet = self:GetShipsList(fleetId)
    local p = 0
    for i,v in ipairs(dataSet) do
        if v.id == shipData.id then
            p = i
            break
        end
    end
    if p > 0 then
        dataSet[p] = shipData
    else
        table.insert(dataSet,shipData)
    end
end
--获取舰船数据
function FleetProxy:GetShipData(fleetId,shipId)
    local dataSet = self:GetShipsList(fleetId)
    local p = 0
    for i,v in ipairs(dataSet) do
        if v.id == shipId then
            return v
        end
    end
    return nil
end
--获取舰队下的舰船
function FleetProxy:GetShipsList(fleetId)
    if self.m_data.allShipsData[fleetId] == nil then
        self.m_data.allShipsData[fleetId] = {}
    end
    return self.m_data.allShipsData[fleetId]
end

--港口舰队
function FleetProxy:SetProtFleetsData(fleetsData)
    self.m_data.protFleetsData = {}
    local len = #fleetsData
    for i=1, len do
        self:AddProtFleetData(fleetsData[i])
    end
end

function FleetProxy:AddProtFleetData(pb_UserFleetData)
    local userFleetData = {}
    userFleetData.fleetId = pb_UserFleetData.fleetId
    userFleetData.shipCount = pb_UserFleetData.shipCount
    userFleetData.fightNum = pb_UserFleetData.fightNum
    userFleetData.maxShipCount = 45
    userFleetData.items = {}
    userFleetData.maxFightShip = pb_UserFleetData.maxFightShip
    userFleetData.fleetName = pb_UserFleetData.fleetName
    userFleetData.totalCap = pb_UserFleetData.totalCap

    local items = pb_UserFleetData.items
    for i=1,#items do
        local item = {}
        local temp = items[i]
        item.id = temp.id
        item.num = temp.num

        table.insert(userFleetData.items, item)
    end

    table.insert(self.m_data.protFleetsData, userFleetData)
end

function FleetProxy:RemoveProtFleetData(fleetData)
    local len = #self.m_data.protFleetsData
    for i=1, len do
        if self.m_data.protFleetsData[i].fleetId == fleetData.fleetId then
            table.remove(self.m_data.protFleetsData, i)
            break
        end
    end
end

function FleetProxy:GetProtFleetsData()
    return self.m_data.protFleetsData
end

function FleetProxy:GetProtFleetDataByIndex(index)
    return self.m_data.protFleetsData[index]
end

function FleetProxy:GetProtFleetDataById(fleetId)
    for k, v in pairs(self.m_data.protFleetsData) do
        if v.fleetId == fleetId then
            return self.m_data.protFleetsData[k]
        end
    end
    return nil
end

--港口单舰
function FleetProxy:SetProtShipsData(shipsData)
    self.m_data.protShipsData = {}
    local len = #shipsData
    for i=1, len do
        self:AddProtShipData(shipsData[i])
    end
end

function FleetProxy:AddProtShipData(pb_UserShipData)
    local userShipData = {}
    userShipData.shipId = pb_UserShipData.shipId
    userShipData.shipType = pb_UserShipData.shipType
    userShipData.fightNum = pb_UserShipData.fightNum
    userShipData.pos = pb_UserShipData.pos
    userShipData.gridPos = pb_UserShipData.gridPos
    userShipData.userShip = pb_UserShipData.userShip

    table.insert(self.m_data.protShipsData, userShipData)
end

function FleetProxy:RemoveProtShipData(shipData)
    local len = #self.m_data.protShipsData
    for i=1, len do
        if self.m_data.protShipsData[i].shipId == shipData.shipId then
            table.remove(self.m_data.protShipsData, i)
            break
        end
    end
end

function FleetProxy:GetProtShipsData()
    return self.m_data.protShipsData
end

function FleetProxy:GetProtShipDataByIndex(index)
    return self.m_data.protShipsData[index]
end

--舰队舰船
function FleetProxy:SetFleetShipsData(shipsData)
    self.m_data.fleetShipsData = {
        all = {},
        type = {}
    }
    local len = #shipsData
    for i=1, len do
        self:AddFleetShipData(shipsData[i])
    end
end

function FleetProxy:AddFleetShipData(pb_UserShipData)
    local userShipData = {}
    userShipData.shipId = pb_UserShipData.shipId
    userShipData.shipType = pb_UserShipData.shipType
    userShipData.fightNum = pb_UserShipData.fightNum
    userShipData.pos = pb_UserShipData.pos
    userShipData.gridPos = pb_UserShipData.gridPos
    userShipData.userShip = pb_UserShipData.userShip
    
    table.insert(self.m_data.fleetShipsData.all, userShipData)

    if self.m_data.fleetShipsData.type[userShipData.pos] == nil then
        self.m_data.fleetShipsData.type[userShipData.pos] = {}
    end
    table.insert(self.m_data.fleetShipsData.type[userShipData.pos], userShipData)
end

function FleetProxy:RemoveFleetShipData(shipData)
    local len = #self.m_data.fleetShipsData.all
    for i=1, len do
        if self.m_data.fleetShipsData.all[i].shipId == shipData.shipId then
            table.remove(self.m_data.fleetShipsData.all, i)
            break
        end
    end

    local queueShipsData = self.m_data.fleetShipsData.type[shipData.pos]
    len = #queueShipsData
    for i=1, len do
        if queueShipsData[i].shipId == shipData.shipId then
            table.remove(self.m_data.fleetShipsData.type[shipData.pos], i)
            break
        end
    end
end

function FleetProxy:GetFleetShipsData()
    return self.m_data.fleetShipsData.all
end

function FleetProxy:GetFleetShipDataByIndex(index)
    return self.m_data.fleetShipsData.all[index]
end

--获取编队信息
function FleetProxy:GetFleetQueueShipsData(pos)
    if self.m_data.fleetShipsData.type[pos] == nil then
        self.m_data.fleetShipsData.type[pos] = {}
    end

    return self.m_data.fleetShipsData.type[pos]
end

function FleetProxy:AddFleetQueueShipData(shipData)
    self:RemoveProtShipData(shipData)
    self:AddFleetShipData(shipData)
end

function FleetProxy:RemoveFleetQueueShipData(shipData)
    self:RemoveFleetShipData(shipData)
    self:AddProtShipData(shipData)
end

function FleetProxy:SetFleetQueueShipsData(queueShipsData)
    self.m_data.fleetQueueShipsData = queueShipsData
end

function FleetProxy:GetFleetQueueShipDataByIndex(index)
    return self.m_data.fleetQueueShipsData[index]
end

function FleetProxy:ExchangeFleetQueueShipsPos(fromPos, toPos)
    local data = self:GetFleetQueueShipsData(fromPos)
    for i=1, #data do
        data[i].pos = toPos
    end

    data = self:GetFleetQueueShipsData(toPos)
    for i=1, #data do
        data[i].pos = fromPos
    end

    self.m_data.fleetShipsData.type[toPos] = self.m_data.fleetShipsData.type[fromPos]
    self.m_data.fleetShipsData.type[fromPos] = data
end

--舰队货物
function FleetProxy:SetFleetGoodsData(fleetGoodsData, totalCap)
    self.m_data.fleetGoodsData = {
        all = {},
        byType = {},
        restOfCap = 0,
        totalCap = 0
    }

    if totalCap ~= nil then
        self.m_data.fleetGoodsData.totalCap = totalCap
        self.m_data.fleetGoodsData.restOfCap = totalCap
    end

    for i,v in ipairs(fleetGoodsData) do
        self:AddFleetGoodsData(v)
    end
end

function FleetProxy:GetItemType(itemId)
    return math.floor(itemId/10000000)
end

function FleetProxy:AddFleetGoodsData(item)
    if item == nil then
        return
    end

    local fleetGoods = self:GetFleetGoodsData()
    local type = self:GetItemType(item.id)
    local wid = 0
    for i,v in ipairs(fleetGoods.all) do
        if v.id == item.id then
            wid = i
            break
        end
    end
    if wid == 0 then
        table.insert(fleetGoods.all,item)
        wid = #fleetGoods.all
        self:SetFleetGoodsRestOfCap(item.id, 0, item.num)
    else
        self:SetFleetGoodsRestOfCap(item.id, fleetGoods.all[wid].num, item.num)
        fleetGoods.all[wid] = item
    end

    local wlist = self:GetFleetItemListByType(type)
    local iid = 0
    for i,v in ipairs(wlist) do
        if v.id == item.id then
            iid = i
            break
        end
    end
    if iid == 0 then
        table.insert(wlist, fleetGoods.all[wid])
    else
        wlist[iid] = fleetGoods.all[wid]
    end

    return fleetGoods.all[wid]
end

function FleetProxy:GetFleetItemListByType(itemType)
    local fleetGoods = self:GetFleetGoodsData()
    local list = fleetGoods.byType[itemType]
    if list == nil then
        fleetGoods.byType[itemType] = {}
    end
    return fleetGoods.byType[itemType]
end

--获取物品数据
function FleetProxy:GetFleetItem(itemId)
    local type = self:GetItemType(itemId)
    local fleetGoods = self:GetFleetItemListByType(type)
    local oldItem = nil
    for i,v in ipairs(fleetGoods) do
        if v.id == itemId then
            oldItem = v
        end
    end
    return oldItem
end

--移除item
function FleetProxy:RemoveFleetItem(itemId)
    local fleetGoods = self:GetFleetGoodsData()
    local type = math.floor(itemId/10000000)
    local wid = 0
    for i,v in ipairs(fleetGoods.all) do
        if v.id == itemId then
            self:SetFleetGoodsRestOfCap(itemId, v.num, 0)
            table.remove(fleetGoods.all,i)
            break
        end
    end
    local wlist = self:GetFleetItemListByType(type)
    for i,v in ipairs(wlist) do
        if v.id == itemId then
            table.remove(wlist,i)
            break
        end
    end
end

--获取物品在对应表中的数据
function FleetProxy:GetItemConfigData(itemId)
    local type = self:GetItemType(itemId)
    local configData = configData[type]
    if configData == nil then
        return nil
    end
    if configData.data[itemId] == nil then
        LogError("have no item data in config table by id:{0}",itemId)
        return nil
    end
    return { data = configData.data[itemId], EVar = configData.data.EVar, type = type, relation = configData.relation }
end

--读表获取物品在仓库中的体积
function FleetProxy:GetItemVolume(itemId)
    local itemConfig = self:GetItemConfigData(itemId)
    if itemConfig == nil then
        LogError("Can not find configData by item:{0}",itemId)
        return 0
    end
    local volume = itemConfig.data[itemConfig.EVar["stor_unit_n"]]
    volume = volume == nil and 1 or volume
    return volume
end

--计算物品数量改变后仓库剩余容量
function FleetProxy:SetFleetGoodsRestOfCap(itemId, oldItemCount, newItemCount)
    local volume = self:GetItemVolume(itemId)
    local fleetGoods = self:GetFleetGoodsData()
    local newCap = fleetGoods.restOfCap - (newItemCount - oldItemCount) * volume
    fleetGoods.restOfCap = math.max(newCap,0)
end

--减少货物
function FleetProxy:ReduceFleetGoodsData(item)
    local oldItem = self:GetFleetItem(item.id)
    if oldItem then
        self:SetFleetGoodsRestOfCap(item.id, oldItem.num, oldItem.num - item.num)
        oldItem.num = oldItem.num - item.num
    else
        LogError("ItemId:"..item.id.." dose not exist!")
    end
    if oldItem.num < 0 then
        LogError("FleetProxy:ReduceFleetGoodsData {0} {1}, the number in front can't be larger than that in the rear.", item.num, temp.num)
        return false
    elseif oldItem.num == 0 then
        self:RemoveFleetItem(item.id)
    else
        oldItem.change = true
    end
    return true
end

--增加货物
function FleetProxy:IncreaseFleetGoodsData(item)
    local volume = self:GetItemVolume(item.id)
    local fleetGoods = self:GetFleetGoodsData()
    local newCap = fleetGoods.restOfCap - item.num * volume
    if newCap < 0 then
        return false
    end

    local oldItem = self:GetFleetItem(item.id)
    if oldItem then
        self:SetFleetGoodsRestOfCap(item.id, oldItem.num, oldItem.num + item.num)
        oldItem.num = oldItem.num + item.num
    else
        oldItem = self:AddFleetGoodsData(item)
    end
    oldItem.change = true
    return true
end

function FleetProxy:GetFleetGoodsData()
    return self.m_data.fleetGoodsData
end

--加载仓库背包数据
function FleetProxy:InitPackageData(index)
    local packageData = packageConfig[index]
    local list = {}
    for i,v in ipairs(packageData) do
        local wlist = self:GetFleetItemListByType(v)
        for ii,vv in ipairs(wlist) do
            table.insert(list,vv)
        end
    end
    self.m_data.curPackageGoodsData = list
    return self.m_data.curPackageGoodsData
end

function FleetProxy:GetPackageData()
    return self.m_data.curPackageGoodsData
end

function FleetProxy:GetPackageDataByIndex(index)
    return self.m_data.curPackageGoodsData[index]
end

--设置选择选项
function FleetProxy:SetCurrentSelectIndex(key, index)
    self.m_data.currentSelectIndex[key] = index
end

function FleetProxy:GetCurrentSelectIndex(key)
    local selectIndex = self.m_data.currentSelectIndex[key]
    return selectIndex
end

--舰队指令相关------------------------------------------------
--保存节点内的我的舰队信息
function FleetProxy:SaveMyCurrentNodeFleetListData(fleetList)
    --self.m_data.currentNodeMyFleetList = fleetList
    for i,v in ipairs(fleetList) do
        self:SetFleetListInfoDataByCollect(v)
    end
end

function FleetProxy:GetMyCurrentNodeFleetByFleetId(fleetId)
    local fleet = self:GetFleetListInfoByFleetId(fleetId)
    return fleet
end

--获取所有可用于采集的舰队
function FleetProxy:GetMyCanCollectFleetList(nodeId)
    local list = self:GetFleetListInfoData()
    local re = {}
    for i,v in ipairs(list) do
        if v.collectSpeed > 0  and v.nodeId == nodeId and v.status == common_pb.BERTH then
            table.insert(re,v)
        end
    end
    return re
end

--获取当前星系节点正在采集的舰队
function FleetProxy:GetMyCollectingFleet(nodeId)
    local list = self:GetFleetListInfoData()
    for i,v in ipairs(list) do
        if v.status == common_pb.COLLECT and v.nodeId == nodeId then
            return v
        end
    end
    return nil
end
---end--------------------------------------------------
function FleetProxy:CleanFleetListInfoData()
    self.m_data.fleetListInfoData = {}
end
--舰队列表，整合自己所有的舰队信息
function FleetProxy:SetFleetListInfoData(listInfo)
    local list = {}
    for i,v in ipairs(listInfo) do
        local builder = {
            --scene.FleetInfo
            fleetId = v.fleetId,
            uid = v.uid,
            nodeId = v.nodeId,
            startTime = v.startTime/1000,
            endTime = v.endTime/1000,
            status = v.status, -- = fleetData.type
            toNodeId = v.toNodeId,
            fromNodeId = v.fromNodeId,
            fleetName = v.fleetName,
            userShips = v.userShips,
            --node.Fleet预留
            collectSpeed = 0,
            resourceCapacity = 0,
            fleetCapacity = 0,
            time = 0,
            --点内
            planetId = v.planetId,
        }
        table.insert(list,builder)
    end
    self.m_data.fleetListInfoData = list
end

function FleetProxy:RemoveFleetListInfoData(fleetId)
    local list = self:GetFleetListInfoData()
    for i,v in ipairs(list) do
        if v.fleetId == fleetId then
            table.remove(list, i)
            break
        end
    end
end

function FleetProxy:SetFleetListInfoDataByCollect(nodeFleet)
    local fleetInfo = self:GetFleetListInfoByFleetId(nodeFleet.fleetId)
    if fleetInfo then
        fleetInfo.time = nodeFleet.time
        fleetInfo.endTime = nodeFleet.endTime/1000
        fleetInfo.status = nodeFleet.status
        fleetInfo.fleetCapacity = nodeFleet.fleetCapacity
        fleetInfo.collectSpeed = nodeFleet.collectSpeed
        fleetInfo.resourceCapacity = nodeFleet.resourceCapacity
        fleetInfo.uid = nodeFleet.uid
        fleetInfo.fleetName = nodeFleet.fleetName
    end
end

function FleetProxy:UpdateFleetListInfo(fleetData)
    local list = self:GetFleetListInfoData()
    for i,v in ipairs(list) do
        if v.fleetId == fleetData.fleetId then
            v.uid = fleetData.uid
            v.status = fleetData.type
            v.startTime = fleetData.startTime
            v.endTime = fleetData.endTime
            v.nodeId = fleetData.nodeId
            v.toNodeId = fleetData.toNodeId
            v.fromNodeId = fleetData.fromNodeId
            v.fleetName = fleetData.fleetName
            break
        end
    end
end

function FleetProxy:GetFleetListInfoByFleetId(fleetId)
    local list = self:GetFleetListInfoData()
    for i,v in ipairs(list) do
        if v.fleetId == fleetId then
            return v
        end
    end
    return nil
end

function FleetProxy:GetFleetListInfoData()
    return self.m_data.fleetListInfoData
end

function FleetProxy:GetFleetListWorkingCount()
    local count = 0
    local tNow = GetServerTimeStamp()
    local list = self:GetFleetListInfoData()
    for i,v in ipairs(list) do
        if v.status ~= common_pb.BERTH then
            if v.endTime > tNow then
                count = count + 1
            end
        end
    end
    return count
end

-- 获得舰队数量最多的舰船的种类
function FleetProxy:GetMostShipsType(userShips)
    local curTechID = userShips[1].techID
    local curNum = 1
    for _, ships in ipairs(userShips) do
        if ships.techID ~= curTechID then
            if curNum > 1 then
                curNum = curNum -1 
            else
                curTechID = ships.techID
                curNum = 1
            end
        else
            curNum = curNum + 1
        end
    end
    return curTechID
end

return FleetProxy