require("Proto/scene_pb")
local WorldMediator = class("WorldMediator", MediatorDynamic)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
function WorldMediator:ctor(mediatorName) 
    WorldMediator.super.ctor(self, mediatorName)
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
end

function WorldMediator:ShowUniverse()

    local universe = ManagerResourceModule.LuaLoadBundle('ModelFBX/Universe/Universe.prefab')

    UnityEngine.GameObject.Instantiate(universe)

    local scaleK = 0.5
    
    local mainId = self.userDataProxy:GetMainBaseGalaxyId()
    local areaNodes = self.universeProxy:ReadLuaNodeDataById(mainId)
    local cameraData = self.universeProxy:BuildCameraData(areaNodes,{})
    local ClsUniverse = require("Game/Module/SUniverse/UnivObject/Universe");
    
    self.Univ = ClsUniverse.New();
    for k,v in pairs(cameraData) do 
        self.Univ:AddGalaxy(v);
    end

    self.inited = false
    local cameraFleetData = self.fleetProxy:BuildCameraData({})
    for k,v in pairs(cameraFleetData) do 
        self.Univ:AddSpaceFleet(v,k);
    end
    --加入自己拥有的舰队
    self:UpdateDynamicSpaceFleets()
    
    local lastPosition = self.universeProxy:GetCurrentPosition()
    self.Univ:LateInit()
    if lastPosition ~= nil then
        
    else
        lastPosition = self.universeProxy:GetMainBaseNode().position
    end
    self:CameraUpdateData(lastPosition)
    self.Univ:GotoPosition(lastPosition.x,lastPosition.y)
    self:RequestFleetList()
    self:RequestMarkList()

end

function WorldMediator:ShowExplorePopup(galaxyid)
    self.m_viewComponent:ShowExplorePopup(galaxyid)
end

function WorldMediator:OnRegister()
    self:RegisterObserver(NotiConst.Command_SUniverseDestroy,"OnDestroy")
    self:RegisterObserver(NotiConst.Command_PUniverseFleetOperUpdate, "FleetOperUpdate")
    self:RegisterObserver(NotiConst.Command_PUniverseCameraUpdate, "CameraUpdate")
    self:RegisterObserver(NotiConst.Notify_SetWorldPosition, "ChooseTargetPosition")
    self:RegisterObserver(NotiConst.Notify_SetWorldZoom, "ZoomWorld")
    self:RegisterObserver(NotiConst.Notify_SystemTimestampUpdated, "OnSystemTimestampUpdated")
    self:RegisterObserver(NotiConst.Notify_FleetTargetChanged, "OnFleetTargetChanged")
    self:RegisterObserver(NotiConst.Notify_FleetDataChanged, "OnFleetDataChanged")
    self:RegisterObserver(NotiConst.CloseUniversePop, "OnCloseUniversePop")
    self:RegisterObserver(NotiConst.Notify_UniverseCameraCtrlIgnoreUI, "CameraCtrlIgnoreUI")
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SCENENODEDATA), self.OnSceneDataUpdated, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETMOVESTART), self.OnFleetMoveStart, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETMOVEFINISHED), self.OnFleetMoveCompleted, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETNODEDATA), self.OnGetNodeData, self)

end

function WorldMediator:CameraCtrlIgnoreUI()
    self.Univ.camctrl.ignoreUI = true
end

--移动到大地图选择的点
function WorldMediator:ChooseTargetPosition(notify)
    local data = notify:GetBody()
    self:CameraUpdateData(data)
    self.Univ:GotoPosition(data.x,data.y)
    self.m_viewComponent:ClosePopup()
end

--缩放
function WorldMediator:ZoomWorld(notify)
    local data = notify:GetBody()
    self.Univ:SetZoom(data)
    self.m_viewComponent:ClosePopup()
end

function WorldMediator:OnFleetDataChanged(notify)
    local data = notify:GetBody()
    for k,_ in pairs(data.nids) do
        self.Univ:UpdateGalaxy(k,true)
    end
end


function WorldMediator:OnDestroy()
    self.Univ:Release()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SCENENODEDATA), self.OnSceneDataUpdated)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETMOVESTART), self.OnFleetMoveStart)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETMOVEFINISHED), self.OnFleetMoveCompleted)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETNODEDATA), self.OnGetNodeData)
end

function WorldMediator:FleetOperUpdate(notify)
    --self.m_viewComponent:FreshOperateView()
    
    local fleetList = notify:GetBody()
    if fleetList then
        --清除之前的路径
        for i,v in ipairs(fleetList) do
            self.Univ:ClearFleetPath(v)
        end
    end
    
end

function WorldMediator:CameraUpdate(data)
    local pos = data:GetBody()
    self:CameraUpdateData(pos)
end

function WorldMediator:CameraUpdateData(pos)
    self.universeProxy:SetCurrentPosition(math.floor( pos.x),math.floor(pos.y))
    self.m_viewComponent.cameraPosLabel.text = 'X:'..math.floor( pos.x)..'/'..'Y:'..math.floor( pos.y)
    local regionData = self.universeProxy:GetRegionDataByPos(pos.x,pos.y)
    self.m_viewComponent.cameraPosRegionLabel.text = GetLanguageText("BuildingCommon",regionData.cn)
end

function WorldMediator:OnSceneDataUpdated(btsData)
    if btsData == nil then
        return
    end
    local TS2CNodeData = scene_pb.TSCSceneNodeData()
    TS2CNodeData:MergeFromString(btsData)
	local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
	local userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
	local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    local uNodes = {} --更新的结点id
    local uFleets = {} --更新的舰队id
    local allFleet = {}
    for i=1, #TS2CNodeData.nodes do --点数据
        local stNodeD = TS2CNodeData.nodes[i]
        userDataProxy:AddExploredGalaxyId(stNodeD.id) --更新开图的点
        if universeProxy:UpdateNodeDynamicData(stNodeD) then 
            --点数据改变了，刷新
            table.insert(uNodes, stNodeD.id)
        end
        --LogError("node:"..stNodeD.id.."|"..stNodeD.uid.."|fleet:"..#stNodeD.fleet.."|from:"..#stNodeD.from.."|to:"..#stNodeD.to)
        
        for i,v in ipairs(stNodeD.fleet) do
            table.insert(allFleet,v)
        end
        for i,v in ipairs(stNodeD.from) do
            table.insert(allFleet,v)
        end
        for i,v in ipairs(stNodeD.to) do
            table.insert(allFleet,v)
        end
    end
    fleetProxy:SetFleetsData(allFleet,uFleets,true)
    fleetProxy:CleanFleetsData()
    if #uNodes > 0 then --点动态数据更新
        for i,id in ipairs(uNodes) do
            self.Univ:UpdateGalaxy(id,true)
        end
        self.Univ:GenerateVoronoi()
    end
    if #uFleets > 0 then --舰船动态数据更新

    end
end


--系统时间改变更新当前正在移动的
function WorldMediator:OnSystemTimestampUpdated()
    local allFleetsDataMap = self.fleetProxy:GetAllFleetsData()
    local tNow = GetServerTimeStamp(true)
    --LogError("//////////////pipeLine=>Time:"..tNow.."///////////////")
    for k,_ in pairs(allFleetsDataMap) do
        local fleetPipeLine = self.fleetProxy:GetFleetDataPipeLine(k,tNow)
        for i,v in ipairs(fleetPipeLine) do
            local fleet = nil
            if (not v.processed and fleetPipeLine[i-1] and fleetPipeLine[i-1].processed) then
                fleet = fleetPipeLine[i-1]
            end
            if i == #fleetPipeLine and v.processed then
                fleet = v
            end
            if fleet then
                local objFleet = self.Univ:GetDynamicObj(fleet.fleetId,"SpaceFleet")
                if objFleet and objFleet.bMoving then
                    local pSrcNode = self.universeProxy:GetNode(fleet.fromNodeId)
                    local pDstNode = self.universeProxy:GetNode(fleet.toNodeId)
                    local d = objFleet:GetRemainDistance()
                    objFleet.MoveV = d/(fleet.endTime-tNow)
                    --LogError("//////////////"..fleet.fleetId.."=>Biuuuuuu!|"..d.."|"..objFleet.MoveV)
                    objFleet:SetMoveTarget(pDstNode.position.x,0,pDstNode.position.y, 0)
                end
                break
            end
        end
    end
end

function WorldMediator:UpdateDynamicSpaceFleets()
    local rebuild = not self.inited
    self.inited = true
    local allFleetsDataMap = self.fleetProxy:GetAllFleetsData()
    local tNow = GetServerTimeStamp(true)
    for k,v in pairs(allFleetsDataMap) do
        local fleetPipeLine = self.fleetProxy:GetFleetDataPipeLine(k,tNow)
        --绘制舰队流水线
        local lastTime = 0
        local allPipeLine = #fleetPipeLine
        for i=1,allPipeLine do
            local id = allPipeLine - i + 1
            local fleet = fleetPipeLine[id]
            if fleet.startTime <= tNow then
                if (not fleet.processed or rebuild) and (lastTime == 0 or tNow > lastTime) then
                    
                    local objFleet = self.Univ:GetDynamicObj(fleet.fleetId,"SpaceFleet") 
                    if not fleet.isStop then
                        if objFleet == nil then 
                            objFleet = self.Univ:AddSpaceFleet(self.fleetProxy:BuildCameraDataById(fleet.fleetId), fleet.fleetId)
                        end
                    end
                    if objFleet then
                        self:UpdateSpaceFleetPos(objFleet,fleet,tNow,rebuild)
                    end
                    fleet.processed = true
                    break
                end
            end
            lastTime = fleet.endTime
        end
    end
end

function WorldMediator:UpdateSpaceFleetPos(objFleet,fleet,tNow,rebuild)
    if fleet.fromNodeId and fleet.toNodeId and fleet.fromNodeId ~= fleet.toNodeId then --移动
        local pSrcNode = self.universeProxy:GetNode(fleet.fromNodeId)
        local pDstNode = self.universeProxy:GetNode(fleet.toNodeId)
        if pSrcNode ~= nil and pDstNode ~= nil then
            local d = 0
            if fleet.reset then
                local dx = pDstNode.position.x - pSrcNode.position.x
                local dy = pDstNode.position.y - pSrcNode.position.y
                d = self.universeProxy:CalDistance(pSrcNode,pDstNode)
                local p = (tNow-fleet.startTime)/(fleet.endTime-fleet.startTime)
                if rebuild then
                    p = 0
                end
                objFleet.MoveV = d*(1-p)/(fleet.endTime-tNow)
                objFleet:SetPostion(pSrcNode.position.x+dx*p, 0, pSrcNode.position.y+dy*p)
                objFleet:SetMoveTarget(pDstNode.position.x,0,pDstNode.position.y, 0)
                --objFleet:SetMoveTarget(pDstNode.position.x,0,pDstNode.position.y, tNow-fleet.startTime)
            elseif fleet.changeSpeed then
                d = objFleet:GetRemainDistance()
                objFleet.MoveV = d/(fleet.endTime-tNow)
                objFleet:SetMoveTarget(pDstNode.position.x,0,pDstNode.position.y, 0)
            end
        end
    elseif CheckNumNoZeroValue(fleet.nodeId) and fleet.isStop then 
        self.Univ:StopSpaceFleet(fleet.fleetId, fleet.nodeId)
        --开图
        self.userDataProxy:AddExploredGalaxyId(fleet.finalMoveNodeId)
        self.Univ:UpdateGalaxy(fleet.finalMoveNodeId,true)

        --结束任务，清除路径
       
        --if self.fleetProxy:CompleteOperation(fleet.fleetId) then
            self.Univ:ClearFleetPath(fleet.fleetId)
            Facade:SendNotification(NotiConst.Command_PUniverseFleetOperUpdate)
        --end
    else 
        
    end
end

function WorldMediator:OnFleetMoveStart(btsData)
    
    local data = scene_pb.TSCFleetMoveStart()
    data:MergeFromString(btsData)
    self.fleetProxy:SetFleetData(data.fleet)
    local operation = self.fleetProxy:GetOperDataByFleetId(data.fleet.fleetId)
    if operation == nil then
        return
    end
    local dynamicData = {}
    dynamicData.startTime = data.fleet.startTime
    dynamicData.endTime = data.fleet.endTime
    dynamicData.distance = self.universeProxy:CalDistanceByID(data.fleet.fromNodeId,data.fleet.toNodeId)
    operation.dynamicData = dynamicData
    Facade:SendNotification(NotiConst.Notify_SceneFleetDataUpdated, {data.fleet.fleetId})
    Facade:SendNotification(NotiConst.Command_PUniverseFleetOperUpdate)
end

function WorldMediator:OnFleetMoveCompleted(btsData)
    local data = scene_pb.TSCFleetMoveCompleted()
    data:MergeFromString(btsData)
    
    self.fleetProxy:SetFleetData(data.fleet)
    Facade:SendNotification(NotiConst.Notify_SceneFleetDataUpdated, {data.fleet.fleetId})
end

function WorldMediator:OnFleetTargetChanged(notify)
    
    local data = notify:GetBody()
    for i,fleetId in ipairs(data) do
        self.Univ:ClearFleetPath(fleetId)
        Facade:SendNotification(NotiConst.Command_PUniverseFleetOperUpdate)
    end
end

function WorldMediator:OpenPlanetary(nodeId)
    planetaryProxy:SetPlanetaryId(nodeId)
    body ={
        nodeId = nodeId
    }
    Facade:SendNotification(NotiConst.Command_RPCPlantarySystem, body)
end

function WorldMediator:OnGetNodeData(stData)
    if stData ~= nil then
        local TSCGetNodeData = node_pb.TSCGetNodeData()
        TSCGetNodeData:MergeFromString(stData)
        
        -- save data to package
        local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
        -- 保存舰队信息
        fleetProxy:AddPlanetaryFleetData(TSCGetNodeData.fleet)
        -- 保存planet的状态
        planetaryProxy:SavePlanetStatus(TSCGetNodeData.planet)

        planetaryProxy:SaveBuildingData(TSCGetNodeData.building)

        planetaryProxy:SaveElecMsg(TSCGetNodeData.elecMsg)
    end
    ManagerScene:OpenSceneUseLoadingScene("SPlanetarySystem")
end

function WorldMediator:RequestFleetList()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETLIST), self.OnFleetList, self)
    local TCSFleetList = scene_pb.TCSFleetList()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.FLEETLIST, TCSFleetList:SerializeToString())
end

function WorldMediator:OnFleetList(btsData)
    if btsData then
        local data = scene_pb.TSCFleetList()
        data:MergeFromString(btsData)
        self.fleetProxy:CleanFleetListInfoData()
        self.fleetProxy:SetFleetListInfoData(data.fleetInfo)
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETLIST), self.OnFleetList)
end



function WorldMediator:RequestMarkList()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MARKLIST), self.OnMapMarkList, self)
    local TCSMarkList = scene_pb.TCSMarkList()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.MARKLIST, TCSMarkList:SerializeToString())
end

function WorldMediator:OnMapMarkList(btsData)
    if btsData then
        local data = scene_pb.TSCMarkList()
        data:MergeFromString(btsData)
        self.userDataProxy:SetMapMarkList(data.mark)
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MARKLIST), self.OnMapMarkList)
end

function WorldMediator:RequestDelMark(nodeId)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELMARK), self.OnRequestDelMark, self)
    local TCSCancelMark = scene_pb.TCSCancelMark()
    TCSCancelMark.nodeId = nodeId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CANCELMARK, TCSCancelMark:SerializeToString())
end

function WorldMediator:OnRequestDelMark(btsData)
    if btsData then
        local data = scene_pb.TSCCancelMark()
        data:MergeFromString(btsData)
        if data.result then
            local nodeId = self.universeProxy:GetCurrentOperationNodeId()
            self.userDataProxy:RemoveMapMarkItem(nodeId)
            Facade:SendNotification(NotiConst.Notify_MapMarkListChanged)
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"删除标记成功")
        end
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELMARK), self.OnRequestDelMark)
end

function WorldMediator:OnCloseUniversePop()
    self.m_viewComponent:ClosePopup()
end

return WorldMediator