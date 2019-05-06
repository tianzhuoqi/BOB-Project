require("Proto/scene_pb")
local UniverseProxy = class("UniverseProxy",Proxy)
local UserDataPackage = LoadPackage(NotiConst.Package_UserData)

local UnityTime = UnityEngine.Time
function UniverseProxy:OnRegister()

end

function UniverseProxy:OnRemove()

end


function UniverseProxy:GetEdgeUid(node1,node2)
    local uid = node1.id..","..node2.id
    if node1.id > node2.id then
        uid = node2.id..","..node1.id
    end
    return uid
end

function UniverseProxy:BuildGlobalAid(areaX,areaY)
    local id = 0
	local r_x = areaX
	local r_y = areaY
    local gid = IntMoveToLeft(r_x,20) + IntMoveToLeft(r_y,11) + id
	return IntMoveToRight(gid,11)
end

function UniverseProxy:ParseGlobalId(id)
    local gid = tonumber(id)
    local r_x = IntMoveToRight(gid,20)
    local r_y = IntMoveToRight(gid - IntMoveToLeft(r_x,20),11)
    local id_ = gid - IntMoveToLeft(r_x,20) - IntMoveToLeft(r_y,11)
    local areaX = r_x
    local areaY = r_y
    return areaX,areaY,id_
end

function UniverseProxy:BuildNodeFromData(data)
    local areaX,areaY,id_ = self:ParseGlobalId(data.id)
    local node = {
        id = tonumber(data.id),
        aid = IntMoveToRight(data.id,11),
        area = {
            x = areaX,
            y = areaY,
        },
        resource = data.res,
        position = nil,
        connect = {},
        area = data.area,
        config = data.config,
        slv = data.slv,
        name = self.m_data.NameConfig[data.config.nid+1],
    }
    node.position = {
        x = tonumber(data.x),
        y = tonumber(data.y),
    }
    return node
end

function UniverseProxy:BuildTempNode(id)
    local areaX,areaY,id_ = self:ParseGlobalId(id)
    local node = {
        id = tonumber(id),
        aid = IntMoveToRight(id,11),
        area = {
            x = areaX,
            y = areaY,
        },
        position = nil,
        connect = {},
        config = nil,
        resource = nil
    }
    return node
end

function UniverseProxy:ConnectTwoNode(node1,node2)
    local nc1 = table.indexOf(node1.connect,node2.id)
    local nc2 = table.indexOf(node2.connect,node1.id)
    if not nc1 then
        table.insert(node1.connect,node2.id)
    end
    if not nc2 then
        table.insert(node2.connect,node1.id)
    end
end

function UniverseProxy:DisconnectTwoNode(node1,node2)
    local nc1 = table.indexOf(node1.connect,node2.id)
    local nc2 = table.indexOf(node2.connect,node1.id)
    if nc1 then
        table.remove(node1.connect,nc1)
    end
    if nc2 then
        table.remove(node2.connect,nc2)
    end
end

function UniverseProxy:file_exists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end

function UniverseProxy:ReadLuaNodeDataFlat(flatName)
    local newNode = {}
    --尝试require，失败则返回
    local status, areaData = pcall(require, self.m_data.MapPath..flatName)
    if not status then
        return newNode
    end
    local nodes = areaData.nodes
    local edges = areaData.edges
    local hasNew = false
    for i,v in ipairs(nodes) do
        -- 加入新的点和更新临时点
        if self.m_data.allMapData[v.id] == nil or self.m_data.allMapData[v.id].position == nil then
            local node = self:BuildNodeFromData(v)
            self.m_data.allMapData[node.id] = node
            hasNew = true
        end
        table.insert(newNode,self.m_data.allMapData[v.id])
    end
    for i,v in ipairs(edges) do
        local node1
        local node2
        
        node1 = self.m_data.allMapData[tonumber(v.s)]
        node2 = self.m_data.allMapData[tonumber(v.t)]
        if node1 == nil then
            node1 = self:BuildTempNode(tonumber(v.s))
            self.m_data.allMapData[node1.id] = node1
        end
        if node2 == nil then
            node2 = self:BuildTempNode(tonumber(v.t))
            self.m_data.allMapData[node2.id] = node2
        end
        self:ConnectTwoNode(node1,node2)
    end
    return newNode
end


function UniverseProxy:ReadLuaNodeDataById(id)
    local newNode = {}
    local temp = self:BuildTempNode(id)
    local blockSize = 3
    local half = math.floor(blockSize/2)
    local start_x = temp.area.x-half
    local start_y = temp.area.y-half
    for i=0,blockSize-1 do
        for j=0,blockSize-1 do
            local x = start_x+i
            local y = start_y+j
            if x>=0 and x< self.m_data.WorldWidth and y>=0 and y<self.m_data.WorldHeight then
                local aid = self:BuildGlobalAid(x,y)
                local newNodeF = self:ReadLuaNodeDataFlat(aid)
                for i,v in ipairs(newNodeF) do
                    table.insert(newNode,v)
                end
            end
        end
    end
    return newNode
end

function UniverseProxy:ReplaceTwoNode(node2,nodeKeep)
    local needClean = {}
    for i,v in ipairs(node2.connect) do
        self:ConnectTwoNode(nodeKeep,v)
        table.insert(needClean,v)
    end
    for i,v in ipairs(needClean) do
        self:DisconnectTwoNode(node2,v)
    end
end

function UniverseProxy:GetNodeOwner(id)
    --[[if self:IsOccupiedNode(id) then
        return UserDataPackage.uid;
    end]]
    local node = self:GetNode(id)
    if node == nil or node.dynamicData == nil then 
        return 0
    end
    return node.dynamicData.uid
end

function UniverseProxy:GetNodeName(id)
    --[[if self:IsOccupiedNode(id) then
        return UserDataPackage.uid;
    end]]
    local node = self:GetNode(id)
    if node == nil or node.dynamicData == nil then 
        return ''
    end
    --[[
    if node.dynamicData == nil or node.dynamicData.name == "" or node.dynamicData.name == nil then
        return node.name
    end]]
    return node.dynamicData.name
end

function UniverseProxy:BuildCameraData(areaNodes,hasLoaded)
    local scaleK = self.m_data.CameraScale
    local data = self.m_data.cameraData
    local dataNew = {}
    local sunConfig = self.m_data.SolarConfig.suns
    local nameConfig = self.m_data.NameConfig
    for k,v in pairs(areaNodes) do
        local node = v
        if data[node.id] == nil then
            if node.position then
                local ResCount
                local ResV
                if node.resource ~= nil then
                    for key, value in pairs(node.resource.planets) do
                        if #value.res > 0 then
                            ResCount = value.res
                            ResV = value.resV
                            --因为只有一个星球有资源
                            break
                        end
                    end
                end

                local cdata = {
                    id = node.id,
                    pos = {(node.position.x)*scaleK,(node.position.y)*scaleK},
                    Name = nameConfig[node.config.nid+1],
                    area = node.area,
                    slv = node.slv,
                    r = 4,--node.config.rings[#(node.config.rings)].r,
                    connect = {},
                    ResCount = ResCount,
                    ResV = ResV,
                    stars={
                        {
                            ResPath = sunConfig.color[1+node.config.suns[1].cid].resource.."_"..sunConfig.type[1+node.config.suns[1].tid].crid..".prefab",
                            pos = {0,0},
                            scale = sunConfig.type[1+node.config.suns[1].tid].scale,
                        }
                    }
                }
                for i_,v_ in ipairs(node.connect) do
                    table.insert(cdata.connect,v_);
                end
                data[node.id] = cdata
            end
        end
        if hasLoaded[node.id] == nil then
            dataNew[node.id] = data[node.id]
        end
    end
    return dataNew
end

function UniverseProxy:GetNode(id)
    return self.m_data.allMapData[id]
end

function UniverseProxy:GetMainBaseNode()
    local mbaseid = UserDataPackage.ownedGalaxyIds[1]
    return self:GetNode(mbaseid)
end

--当前账号可达性
function UniverseProxy:IsNodeCanReachable(id)
    do
        return true
    end
    local lst = UserDataPackage.exploredGalaxyIds
    local n = #lst
    for i=1, n do 
        if self:IsNodeCanReachable2(lst[i], id) then 
            return true
        end
    end
    return false
end

--BFS寻路
function UniverseProxy:BFS_Path_Search(id1, id2, oper, ignore_)
    local ignore = ignore_
    if ignore == nil then
        ignore = {}
    end
    local lstPath = {} --结果
    local lstMapParent = {}--映射结点的父结点
    local lstVisited = {}
    for i,v in ipairs(ignore) do
        lstVisited[v] = true
    end
    if lstVisited[id1] or lstVisited[id2] then 
		return lstPath
	end
    if id1 == id2 then 
		return lstPath
	end
    local node1 = self:GetNode(id1)
    if node1 == nil then 
        return lstPath
    end
    if not self:IsOccupiedNode(id1) and not self:IsExploredNode(id1) then
        return lstPath
    end
    
    local lst = {}
    table.insert(lst, id1)
	local n = #lst 
    local bSearched = false
	while n > 0  do
        local id = lst[1]
		table.remove(lst, 1)
		if lstVisited[id] ~=  true then
            lstVisited[id] = true
            local nodeTemp = self:GetNode(id)
            local isOcced = self:IsOccupiedNode(id)
            if  nodeTemp ~= nil and (isOcced or self:IsExploredNode(id)) then
                local connects = nodeTemp.connect
                if connects ~= nil then 
                    for i_,v_ in ipairs(connects) do
                        local canin = true
                        if oper==common_pb.EXPLORE then --探索模式父结点必须已占领或该节点已被占领
                            canin = isOcced or self:IsOccupiedNode(v_)
                        end
                        if canin and v_ ~= lstMapParent[id] and lstMapParent[v_] == nil then 
                            lstMapParent[v_] = id
                            if v_ == id2 then 
                                bSearched = true
                                --回溯路径
                                for kk,vv in ipairs(lstMapParent) do
                                --判断死map 即两个值互为父结点
                                    if lstMapParent[vv] == kk then 
                                        return lstPath
                                    end
                                end
                                local idd = v_
                                table.insert(lstPath,1, idd)
                                while lstMapParent[idd] ~= nil do
                                    idd = lstMapParent[idd]
                                    table.insert(lstPath,1, idd)
                                end
                                break
                            end
                            table.insert(lst, v_)
                        end
                    end
                end
            end
		end
		if bSearched then 
			break
		end
		
		n = #lst
	end
	return lstPath
end

--可否从id0到达id1
function UniverseProxy:IsNodeCanReachable2(id1, id2)
    if id1 == id2 then
        return true
    end
    local node1 = self:GetNode(id1)
    if node1 == nil then
        return false
    end
    if node1.connect == nil then
        return false
    end
    for i_,v_ in ipairs(node1.connect) do
        if v_ == id2 then
            return true
        end
    end
    return false
end

--是否占领某个星系
function UniverseProxy:IsOccupiedNode(id)
    local lstOwnedGalaxyID = UserDataPackage.ownedGalaxyIds
    for i=1, #(lstOwnedGalaxyID) do
        if lstOwnedGalaxyID[i] == id then
            return true
        end
    end
    return false
end

--是否探索过某个星系
function UniverseProxy:IsExploredNode(id)
    do
        return true
    end
    --取消探索 所有星球已经被探索
    local lstReachedGalaxyID = UserDataPackage.exploredGalaxyIds
    for i=1, #(lstReachedGalaxyID) do
        if lstReachedGalaxyID[i] == id then
            return true
        end
    end
    return false
    
end

--两个星系间的距离
function UniverseProxy:CalDistance(node1, node2)
    if node1 == nil or node2 == nil then 
        return 9999999999
    end
    local scaleK = self.m_data.CameraScale
    local dtx = (node1.position.x - node2.position.x)*scaleK
    local dtz = (node1.position.y - node2.position.y)*scaleK
    return math.floor(math.sqrt(dtx*dtx + dtz*dtz)) --统一向下取整
end

function UniverseProxy:CalDistanceByID(id1, id2)
    return self:CalDistance(self:GetNode(id1), self:GetNode(id2))
end

---计算一条路径的总距离
function UniverseProxy:CalDistanceByPath(lstPath)
    if lstPath == nil or #lstPath < 2 then
        return 0
    end
    local n = #lstPath
    local dist = 0
    for i=1, n-1 do
        dist = dist + self:CalDistanceByID(lstPath[i], lstPath[i+1])
    end
    return dist
end

function UniverseProxy:GetCurrentPosition()
    return self.m_data.currentPosition
end

function UniverseProxy:SetCurrentPosition(x,y)
    self.m_data.currentPosition = {x=x,y=y}
end

function UniverseProxy:UpdateNodeDynamicData(dynamicData)
    local nNodeID = dynamicData.id
    local nodeData = self:GetNode(nNodeID)
    if nodeData == nil then 
        return false
    end
    nodeData.dynamicData = dynamicData

    return true
end

--设置和获取当前点击操作时的nodeid
function UniverseProxy:SetCurrentOperationNodeId(nodeId)
    self.m_data.currentOperationNodeId = nodeId
end

function UniverseProxy:GetCurrentOperationNodeId()
    return self.m_data.currentOperationNodeId
end

--设置和获取当前点击操作时的nodeid
function UniverseProxy:SetCurrentOperationNodeOwner(owner)
    self.m_data.currentOperationNodeisHaveOwner = owner
end

--当前点击操作的星系是否是无主的
function UniverseProxy:GetCurrentOperationNodeIsHaveOwner()
    local isHaveOwner = self.m_data.currentOperationNodeisHaveOwner ~= 0 and true or false
    return isHaveOwner
end

function UniverseProxy:SetCurrentOperationNodeCollectStatus(collectStatus)
    self.m_data.currentOperationNodeisCollecting = collectStatus
end
--当前点击操作的星系是否是正在被舰队开采的
function UniverseProxy:GetCurrentOperationNodeIsCollecting()
    local isCollecting = self.m_data.currentOperationNodeisCollecting ~= 0 and true or false
    return isCollecting
end

--获取星团区域数据
function UniverseProxy:GetRegionDataById(id)
    return self.m_data.regionData[id]
end

function UniverseProxy:GetRegionDataByPos(x,y)
    local list = self.m_data.regionData
    local px = math.floor(x/self.m_data.RegionSize[1])
    local py = math.floor(y/self.m_data.RegionSize[2])
    local id = px+py*5+1
    return self:GetRegionDataById(id)
end

return UniverseProxy