require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")
local ExploreFleetLstUIListCell = register("ExploreFleetLstUIListCell", ListCell)

function ExploreFleetLstUIListCell:OnClick()
    LogDebug('ExploreFleetLstUIListCell OnClick dataIndex:{0}', self.dataIndex)
end

function ExploreFleetLstUIListCell:Awake(gameObject)
    ExploreFleetLstUIListCell.super.Awake(self, gameObject)
    self.panelMediator = Facade:RetrieveMediator("ExploreFleetLstMediator")
    self.txtName = self:FindComponent("name", "UILabel")
    self.txtStatus = self:FindComponent("actionBtn/dis", "UILabel")
    self.txtGalaxy = self:FindComponent("galaxy", "UILabel")
    self.actionBtn = self:FindGameObject("actionBtn")
    self.txtActionBtn = self:FindComponent("actionBtn/Label", "UILabel")
    self.speedUpBtn = self:FindGameObject("speedUpBtn")
    self.univProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.dataIndex = 0
    self.data = 0
    self.actionBtnClick = NLuaClickEvent.Get(self.actionBtn)
    self.speedUpBtnClick = NLuaClickEvent.Get(self.speedUpBtn)
    --[[local NLuaClickEvent = NLuaClickEvent.Get(self.btnChangeTarget.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonChageTargetClick)

    local NLuaClickEvent = NLuaClickEvent.Get(self.btnChangeSpeed.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonChageSpeedClick)

    local NLuaClickEvent = NLuaClickEvent.Get(self.btnCollect.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonbtnCollectClick)]]

    --self.mediator = ExploreFleetLstUIListCell.New("ExploreFleetLstUIListCell")
    --self.mediator:SetViewComponent(self)
    --Facade:RegisterMediator(self.mediator)
end

function ExploreFleetLstUIListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.dataIndex
    self:FreshItem()
    
end

function ExploreFleetLstUIListCell:FreshItem()
    --由所在panel的Mediator控制
    local fleetList = self.panelMediator.listData
    local state = self.panelMediator.operType

    local GalaxyOper = self.fleetProxy:GetCurrentOperation()
    local fleet = fleetList[self.dataIndex]
    local fltStatus = self.fleetProxy:GetFleetStatus(fleet.fleetId)
    local nSelGalaxyID = GalaxyOper.targetGalaxyId
    if self.gameObject ~= nil then
        self.txtName.text = fleet.fleetName
        local galaxy = self.univProxy:GetNode(fleet.nodeId)
        self.txtGalaxy.text = "galaxy"..tostring(fleet.nodeId)
    end
    
    if state == common_pb.MOVE then
        self:CheckMoveType()
    elseif state == common_pb.EXPLORE then
        self.txtActionBtn.text = "探索"
        self.actionBtnClick:AddClick(self, self.OnClickExploreButton)
    elseif state == common_pb.COLLECT then
        self.txtActionBtn.text = "采集"
        self.actionBtnClick:AddClick(self, self.OnClickCollectButton)
    end
end



function ExploreFleetLstUIListCell:CheckMoveType()
    local GalaxyOper = self.fleetProxy:GetCurrentOperation()
    local fleetList = self.panelMediator.listData
    if not fleetList then
        return
    end
    local fleet = fleetList[self.dataIndex]
    if not fleet then
        return
    end
    local fltStatus = self.fleetProxy:GetFleetStatus(fleet.fleetId)
    local nSelGalaxyID = GalaxyOper.targetGalaxyId
    local strStatus = ''
    self.speedUpBtn:SetActive(false)
    if fltStatus == common_pb.MOVE then --正在移动，可改变航线
        self.txtActionBtn.text = "改变航线"
        local NLuaClickEvent = NLuaClickEvent.Get(self.actionBtn)
        NLuaClickEvent:AddClick(self, self.ButtonChageTargetClick)
        --以下为是否显示加速
        
        local LastGalaxyOper = self.fleetProxy:GetOperDataByFleetId(fleet.fleetId)
        if LastGalaxyOper ~= nil then
            for i,v in ipairs(LastGalaxyOper.path) do
                if v == nSelGalaxyID then
                    self.speedUpBtn:SetActive(true)
                    local NLuaClickEvent = NLuaClickEvent.Get(self.speedUpBtn)
                    NLuaClickEvent:AddClick(self, self.ButtonChageSpeedClick)
                    break
                end
            end
        end
    elseif fltStatus <= 0 then
        strStatus = string.format("%.2f Unit", self.univProxy:CalDistanceByID(fleet.nodeId, nSelGalaxyID))
        self.txtActionBtn.text = "移动"
        local NLuaClickEvent = NLuaClickEvent.Get(self.actionBtn)
        NLuaClickEvent:AddClick(self, self.ButtonGoAHeadClick)
    end
    self.txtStatus.text = strStatus
end


function ExploreFleetLstUIListCell:ButtonGoAHeadClick()
    local GalaxyOper = self.fleetProxy:GetCurrentOperation()
    local nSelGalaxyID = GalaxyOper.targetGalaxyId
    local bExpled = self.univProxy:IsExploredNode(nSelGalaxyID)
    local fleetList = self.panelMediator.listData
    local fleet = fleetList[self.dataIndex]
    
    local nodeid = 0
    
    if fleet.fromNodeId == fleet.toNodeId then
        nodeid = fleet.nodeId
    else
        nodeid = fleet.fromNodeId
    end

    local path = self.univProxy:BFS_Path_Search(nodeid,nSelGalaxyID,GalaxyOper.type)

    local distance = self.univProxy:CalDistanceByPath(path)

    self:RequestMove(fleet.fleetId,path)
end

-- 采集btn按下
function ExploreFleetLstUIListCell:OnClickCollectButton()
    local planetId = self.planetaryProxy:GetChosenPlanetId()
    
    local planetData = self.planetaryProxy:GetPlanetDataByPlanetId(planetId)

    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local fleetList = self.panelMediator.listData

    local fleetId = fleetList[self.dataIndex].fleetId

    if planetData ~= nil then
        local body = {nodeId = self.planetaryProxy:GetPlanetaryId(), planetId = planetId, fleetId = fleetId}
        Facade:SendNotification(NotiConst.Notify_PlanetaryStartMine, body)
    end
    self.fleetProxy:SetCurrentOperation(nil) --清除当前操作
    Facade:BackPanel()
end

-- 探索btn按下
function ExploreFleetLstUIListCell:OnClickExploreButton()
    local fleetMap = self.planetaryProxy:GetAllFleetMap()
    local fleetId = 0
    if fleetMap == nil then
        LogDebug("fleet empty")
        return
    end
    -- TODO
    -- TEMP GET fleetId
    
    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local fleetList = self.panelMediator.listData

    local fleetId = fleetList[self.dataIndex].fleetId
    body = {}
    body.fleetId = fleetId
    Facade:SendNotification(NotiConst.Notify_PlanetaryStartExplore, body)
    self.fleetProxy:SetCurrentOperation(nil) --清除当前操作
    Facade:BackPanel()
end   

function ExploreFleetLstUIListCell:RequestMove(fleetId,path)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETMOVE), self.OnRequestMove, self)
    Facade:SendNotification(NotiConst.Command_RPCFleetMove,{
        fleetId = fleetId,
        path = path
    })
end

function ExploreFleetLstUIListCell:OnRequestMove(btsData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETMOVE), self.OnRequestMove)
    local data = scene_pb.TSCFleetMove()
    data:MergeFromString(btsData)
    if data.res == 1 then
        self.fleetProxy:SetCurrentOperation(nil)
        self.fleetProxy:SetFleetData(data.fleet)
        Facade:SendNotification(NotiConst.Notify_SceneFleetDataUpdated, {data.fleet.fleetId})
        Facade:SendNotification(NotiConst.Command_PUniverseFleetOperUpdate,{data.fleet.fleetId})

        Facade:BackPanel()
    end
    
end


function ExploreFleetLstUIListCell:ButtonChageSpeedClick()
    local GalaxyOper = self.fleetProxy:GetCurrentOperation()
    local fleetList = self.panelMediator.listData
    local fleet = fleetList[self.dataIndex]
    local nSelGalaxyID = GalaxyOper.targetGalaxyId
    self.fleetProxy:SetCurrentOperation(nil)

    --self.fleetProxy:MockAccelerate(fleet.fleetId)
    self:RequestSpeedUp(fleet.fleetId)
end

function ExploreFleetLstUIListCell:RequestSpeedUp(fleetId)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETSPEEDUP), self.OnRequestSpeedUp, self)
    Facade:SendNotification(NotiConst.Command_RPCFleetSpeedUp,{
        fleetId = fleetId
    })
end

function ExploreFleetLstUIListCell:OnRequestSpeedUp(btsData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETSPEEDUP), self.OnRequestSpeedUp)
    local data = scene_pb.TSCFleetSpeedUp()
    data:MergeFromString(btsData)
    self.fleetProxy:SetFleetData(data.fleet)

    Facade:BackPanel()
end




function ExploreFleetLstUIListCell:ButtonChageTargetClick()
    local GalaxyOper = self.fleetProxy:GetCurrentOperation()
    local fleetList = self.panelMediator.listData
    local fleet = fleetList[self.dataIndex]
    local lastPath = self.fleetProxy:GetFleetMoveNodes(fleet.fleetId)
    if lastPath == nil then
        OpenMessageBox(NotiConst.MessageBoxType.Confirm,"舰队已完成任务，无法操作","消息")
        return
    end
    local nSelGalaxyID = GalaxyOper.targetGalaxyId
    local lockPath = {} --锁定不变的路径
    local nodeIndex = 0
    for i=1,#lastPath do
        if lastPath[#lastPath-i+1]==fleet.toNodeId then
            nodeIndex = #lastPath-i+1
            break
        end
    end
    for i=1,nodeIndex do
        table.insert(lockPath, lastPath[i])
    end

    local path = self.univProxy:BFS_Path_Search(fleet.toNodeId,nSelGalaxyID,GalaxyOper.type)
    if fleet.toNodeId == nSelGalaxyID then
        table.insert(path,fleet.toNodeId)
    end
    for i=2,#path do
        table.insert(lockPath, path[i])
    end
    npath = lockPath
    self.fleetProxy:SetCurrentOperation(nil)
    self:RequestMove(fleet.fleetId,path)
    
    Facade:SendNotification(NotiConst.Notify_FleetTargetChanged,{fleet.fleetId})
end



return ExploreFleetLstUIListCell