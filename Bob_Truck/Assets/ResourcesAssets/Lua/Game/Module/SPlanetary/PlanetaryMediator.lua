local PlanetaryMediator = class("PlanetaryMediator", MediatorDynamic)
local UnityWorld3DPos2WorldUIPos = GameObjectUtil.World3DPos2WorldUIPos
local SetPosition = GameObjectUtil.SetPosition
local clsPlanetarySystem = require("Game/Module/SUniverse/UnivObject/PlanetarySystem")  --描述整个行星系
local clsInstancePool = require("Common/InstancesPool")
local clsCameraCtrl = require("Common/CameraCtrl");
local clsBuilding = require("Game/Module/SUniverse/UnivObject/Building")  --描述单个建筑
local clsBuildingObjectMod = require("Game/Module/SUniverse/UnivObject/BuildingObjectMod")  --描述将要建造的建筑
local UnityScreen = UnityEngine.Screen

-- temp src path
local explorablePath = "UIPanel/SPlanetary/ExplorableHud.prefab"
local exploringPath = "UIPanel/SPlanetary/ExploreProgressHud.prefab"
local explorationResultPath = "UIPanel/SPlanetary/PlanetaryExploreResult.prefab"
local exclamationHudPath = "UIPanel/SPlanetary/ExclamationHud.prefab"
local canReceiveHudPath = "UIPanel/SPlanetary/CanReceiveHud.prefab"
local newHudPath = "UIPanel/SPlanetary/NewHud.prefab"

-- utility functions
local SetPosition = GameObjectUtil.SetPosition
local SetLocalPosition = GameObjectUtil.SetLocalPosition
local SetScale = GameObjectUtil.SetScale

local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local userDataProxy = Facade:RetrieveProxy(NotiConst.Package_UserData)

local normalColor = Color.New(255, 255, 255)
local greyColor = Color.New(0, 0, 0)

local chooseType = 
{
    planetary = 1,
    hexe = 2,
    building = 3,
}

-- 层次关系 
--  mediator  -> PlantarySystem  1对1
--  PlantarySystem -> Planet[]       1对多
--  PlantarySystem 表现一个行星系
--  Planet 表现一个行星

-- hudInfo 表示一个hud的信息
-- id, hudName, startTime, endTime, callback 

function PlanetaryMediator:OnRegister()
     -- hud
    self.allPlanetHudInfoList = {}          --planet绑定的hud信息
    self.view = self:GetViewComponent()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    self.nodeData = self.universeProxy:GetNode(self.planetaryProxy:GetPlanetaryId())

    self.planetContainer = UnityEngine.GameObject.New("Planets")
    self.ringContainer = UnityEngine.GameObject.New("Rings")
    self.buildingContainer = UnityEngine.GameObject.New("Buildings")

    self.exploreOperationList = {}             -- list for operation that need to update per frame

    -- camera callback
    self.cameraCtrl = clsCameraCtrl.New()
    self.cameraCtrl:SetDragRect(-200,-200,200,200)
    self.cameraCtrl.ZoomRang = {21,49}

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_BuildingButton.gameObject)
    NLuaClickEvent:AddClick(self, self.BuildingListButtonClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_EditBuildingModOKButton.gameObject)
    NLuaClickEvent:AddClick(self, self.CreateBuilding)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_EditBuildingModCancelButton.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseEditBuildingMod)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_WarehouseButton.gameObject)
    NLuaClickEvent:AddClick(self, self.OnWarehouseButtonClick)

    self.instancePool = clsInstancePool.New()

    -- get view object
    self.planetsList = {}
    self.planetarySystem = clsPlanetarySystem.New()

    self.buildingList = {}

    for k, v in pairs(DATA_BUILDING) do
        if v[DATA_BUILDING.EVar['bldg_name_s']] ~= '' and v[DATA_BUILDING.EVar['bldg_lvl_n']] == 1 then
            local data = {k, v}
            table.insert(self.buildingList, data)
        end
    end

    self.planetaryProxy:SaveBuildingList(self.buildingList)

    --click event bind
    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnClickClose.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseGroupPopup)
    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonExplore.gameObject)
    NLuaClickEvent:AddClick(self, self.OnClickExploreButton)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonMine.gameObject)
    NLuaClickEvent:AddClick(self, self.OnClickMineButton)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonCollet.gameObject)
    NLuaClickEvent:AddClick(self, self.OnClickColletButton)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonBuilding.gameObject)
    NLuaClickEvent:AddClick(self, self.OnClickBuildingButton)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_InfoBackBuntton.gameObject)
    NLuaClickEvent:AddClick(self, self.ClosePlanetaryInfo)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_CollectBackBuntton.gameObject)
    NLuaClickEvent:AddClick(self, self.ClosePlanetaryCollect)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_BuildingListBackBuntton.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseBuildingList)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonGet.gameObject)
    NLuaClickEvent:AddClick(self, self.GetTaskOnlineReward)
    
    
    self:RegisterObserver(NotiConst.Command_SPlanetarySystemDestroy,"OnDestroy")
    

    -- rpc listener
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETCOLLECT), self.MineCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ENDFLEETCOLLECT), self.EndMineCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CREATEBUILDING), self.BuildingCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITSHIP), self.StorehouseEditShip, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.BUILDFINISHED), self.BuildFinishedCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETSTOREHOUSE), self.GetStoreHouseCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPRODUCTLINEPRODUCT), self.StorehousePeoductLineProduct, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYCOLLECT), self.StorehouseRefineryCollect, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.COLLECTIONPLANTCOLLECT), self.StorehouseCollectionReceive, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYEND), self.StorehouseRefineryEnd, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITHULLPRODUCTLINE), self.StorehouseEditHullProductLine, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPLITSHIP), self.StorehouseDeleteShip, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPEEDUP), self.SpeedUpCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.TASKONLINECOLLECT), self.TaskOnLineCollectCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MOVEBUILDING), self.MoveBuildingCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERLEVELUP), self.UserLevelUpCallback, self)
   
    -- register observer
    self:RegisterObserver(NotiConst.Notify_PlanetaryChoosePlanet,"OnPlanetClick")
    self:RegisterObserver(NotiConst.Notify_PlanetaryChooseHexe,"OnHexeClick")
    self:RegisterObserver(NotiConst.Notify_PlanetaryStartExplore,"RPCSendExplore")
    self:RegisterObserver(NotiConst.Notify_PlanetaryStartMine,"RPCSendMine")
    self:RegisterObserver(NotiConst.Notify_PlanetShowExploreResult,"ShowExplorationResult")
    self:RegisterObserver(NotiConst.Notify_PlanetShowMineResult,"ShowMineResult")
    self:RegisterObserver(NotiConst.Notify_PlanetShowInfo,"PlanetShowInfo")
    self:RegisterObserver(NotiConst.Notify_PlanetShowCollect,"PlanetShowCollect")
    self:RegisterObserver(NotiConst.Notify_PlanetCloseGroupPopup,"CloseGroupPopup")
    self:RegisterObserver(NotiConst.Notify_PlanetShowBuildingList,"PlanetShowBuildingList")
    self:RegisterObserver(NotiConst.Notify_PlanetChooseBuilding,"PlanetChooseBuilding")
    self:RegisterObserver(NotiConst.Notify_SetPlanetCameraEnable,"SetPlanetCameraEnable")
    self:RegisterObserver(NotiConst.Notify_BuildingUpgrade,"BuildingUpgrade")
    self:RegisterObserver(NotiConst.Notify_BuildingCancel,"BuildingCancel")
    self:RegisterObserver(NotiConst.Notify_BuildingDismantle,"BuildingDismantle")
    self:RegisterObserver(NotiConst.Notify_InitFleetPortShip,"InitFleetPortShip")
    self:RegisterObserver(NotiConst.Notify_InitCameraPos,"InitCameraPos")
    self:RegisterObserver(NotiConst.Notify_UpdatElecInfo,"UpdatElecInfo")
    self:RegisterObserver(NotiConst.Notify_CloseEditBuildingMod,"CloseEditBuildingMod")
    self:RegisterObserver(NotiConst.Notify_PlanetaryUpdateNodeData,"UpdateNodeData")

    --获取仓库数据
    local TCSGetStorehouse = building_pb.TCSGetStorehouse()
    TCSGetStorehouse.nodeId = self.planetaryProxy:GetPlanetaryId()

    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETSTOREHOUSE, TCSGetStorehouse:SerializeToString());

    -- updatebeat
    --UpdateBeat:Add(self.Update, self)
end

function PlanetaryMediator:OnRemove()
end

function PlanetaryMediator:Update()
    self:UpdateAllPlanetHud()
    if self.selectBuildingGo ~= nil then
        self:updateSelectBuildingGo()
    end
    self:UpdateReceiveHudShow()
    self:UpdateElectricityTime()
    self:UpdateRewardTime()
end

-- 点击3D世界，先获取到点击到的gridid，再判断该格子上存在哪种建筑
function PlanetaryMediator:OnClick3DObject()
    -- get mouse pos & transform to gridid when mouse is clicked
    local pos = NGameObjectUtil.ScreenPickCastFloorByLayer(UnityEngine.Input.mousePosition.x, UnityEngine.Input.mousePosition.y, 'PlanetPlane')
    local x = math.floor(pos.x)
    local y = math.floor(pos.z)
    local gridid =  (x + 55) * 1000 + y + 55
    local gridData = self.planetaryProxy:GetGridsUsedByGridId(gridid)

    if gridData then
        local buildingData = self.planetaryProxy:GetBuildingDataById(gridData)
        if buildingData then
            if buildingData.building.OnClick then
                buildingData.building:OnClick()
            end
        end
    end
end

function PlanetaryMediator:UpdateElectricityTime()
    local info = self.planetaryProxy:GetElecMsg()
    if info.restOfElect ~= info.totalElect then
        local curTime = GetServerTimeStamp()
        local buildingDatas = self.planetaryProxy:GetBuildingDataByType(common_pb.SPACESTATION)
        local configId = buildingDatas[1].buildingConfigId
        local index = self.planetaryProxy:GetBuldingFuncTableId(configId)
        local ele_regen_intvl = DATA_BLDG_SS[index][DATA_BLDG_SS.EVar["ele_regen_intvl_n"]]
        local time = ele_regen_intvl - math.floor((curTime - info.electricityStartTime / 1000))
        if time <= 0 then
            info.electricityStartTime = info.electricityStartTime + ele_regen_intvl * 1000
            self.m_viewComponent.uiBinder.m_LabelCountDown.text = ele_regen_intvl
            info.restOfElect = info.restOfElect + math.floor(info.elecRecoverCount * ele_regen_intvl / 3600)
            if info.restOfElect > info.totalElect then
                info.restOfElect = info.totalElect
            end
            Facade:SendNotification(NotiConst.Notify_UpdatElecInfo)
        else
            self.m_viewComponent.uiBinder.m_LabelCountDown.text = SecondToMinutes(time)
        end
    else
        self.m_viewComponent.uiBinder.m_LabelCountDown.text = ''
    end
end

function PlanetaryMediator:UpdateRewardTime()
    local rewardTimeLeft = self.userDataProxy:GetRewardTimeLeft()

    if rewardTimeLeft.rewardCount <= 0 then
        return
    end

    local timeData = rewardTimeLeft.timeLeft - (GetServerTimeStamp() - rewardTimeLeft.curTime) 
    
    if timeData <= 0 then
        timeData = 0
    end
    
    if self:NeedrefreshRewardTime(timeData , rewardTimeLeft.timeLeft) then
        self.userDataProxy:SetRewardTimeLeft(timeData)
        self:RefreshRewardTimeInfo()
    else
        self.userDataProxy:SetRewardTimeLeft(timeData)
    end
end

function PlanetaryMediator:RefreshRewardTimeInfo()
    local rewardTimeLeft = self.userDataProxy:GetRewardTimeLeft()

    if rewardTimeLeft.rewardCount <= 0 then
        self.m_viewComponent.uiBinder.m_LabelAwardTime.text = '领完了'
        self.m_viewComponent.uiBinder.m_SpriteTimBak.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_ButtonGet.gameObject:SetActive(false)
        return
    end

    if rewardTimeLeft.timeLeft >= 60 * 60 * 24 then
        local day = math.floor(rewardTimeLeft.timeLeft / 86400)
        local hour = math.floor((rewardTimeLeft.timeLeft - day * 86400) / 3600)
        self.m_viewComponent.uiBinder.m_LabelAwardTime.text = string.format("%dd %dh", day, hour)
    elseif rewardTimeLeft.timeLeft >= 60 * 60 then
        local hour = math.floor(rewardTimeLeft.timeLeft / 3600)
        local minute = math.floor((rewardTimeLeft.timeLeft - hour * 3600) / 60)
        self.m_viewComponent.uiBinder.m_LabelAwardTime.text = string.format("%dd %dm", hour, minute)
    elseif rewardTimeLeft.timeLeft >= 60 then
        local minute = math.floor(rewardTimeLeft.timeLeft / 60)
        local second = rewardTimeLeft.timeLeft - minute * 60
        self.m_viewComponent.uiBinder.m_LabelAwardTime.text = string.format("%dm %ds", minute, second)
    elseif rewardTimeLeft.timeLeft > 0 then
        self.m_viewComponent.uiBinder.m_LabelAwardTime.text = string.format("%ds", rewardTimeLeft.timeLeft)
    end

    if rewardTimeLeft.timeLeft <= 0 then
        self.m_viewComponent.uiBinder.m_SpriteTimBak.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonGet.gameObject:SetActive(true)
    else
        self.m_viewComponent.uiBinder.m_SpriteTimBak.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_ButtonGet.gameObject:SetActive(false)
    end
end

function PlanetaryMediator:NeedrefreshRewardTime(lTime, rTime)
    if lTime == 0 and rTime ~= 0 then
        return true
    end

    lTime = math.floor(lTime)
    rTime = math.floor(rTime)
    if lTime >= 86400 then
        return math.floor(lTime / 3600) ~= math.floor(rTime / 3600)
    elseif lTime > 3600 then
        return math.floor(lTime / 60) ~= math.floor(rTime / 60)
    else
        return lTime ~= rTime
    end
end

function PlanetaryMediator:updateSelectBuildingGo()
    local sprite = self.m_viewComponent.uiBinder.m_EditBuildingModOKButton.transform:Find('okIcon'):GetComponent('UIEventGraySprite')
    if self.selectBuilding:CanCreateBuilding() then
        sprite:SetNormal()
    else
        sprite:SetGray()
    end
    local worldPos = self.selectBuildingGo.transform.position
    screenPos = UnityWorld3DPos2WorldUIPos(worldPos.x, worldPos.y, worldPos.z)
    GameObjectUtil.SetPosition(self.m_viewComponent.uiBinder.m_EditBuildingModButton.gameObject, screenPos.x, screenPos.y, 0)
end

function PlanetaryMediator:BuildingListButtonClick()
    Facade:SendNotification(NotiConst.Notify_PlanetShowBuildingList)
end

-- 构建行星系 sun, planet, hex
function PlanetaryMediator:BuildPlanetary()

    local PlanetarySystem = ManagerResourceModule.LuaLoadBundle('ModelFBX/Solarsystem/SPlanetarySystem.prefab')

    UnityEngine.GameObject.Instantiate(PlanetarySystem)

    self.planetaryProxy:SetBuildingMoveMod(false)
    local nodeData = self.universeProxy:GetNode(self.planetaryProxy:GetPlanetaryId())    
    self.planetarySystem:BuildPlanetarySystem(nodeData)

    self.cycleTime = 0
    -- 添加hud
    --self:SetHudInfoByPlanetStatus()
    self:SetHudInfoByFleetOperation()

    self:InitBuildingHudInfo()

    self:UpdatElecInfo()

    self:RefreshRewardTimeInfo()

    -- 给PlanetPlane添加点击事件，获得点击到的gridid
    NLuaClickEvent = NLuaClickEvent.Get(UnityEngine.GameObject.Find("Planets/PlanetPlane(Clone)"))
    NLuaClickEvent:Add3DClick(self, self.OnClick3DObject)
    -- 星系构建后再加入update
    UpdateBeat:Add(self.Update, self)
end

function PlanetaryMediator:UpdatElecInfo()
    local info = self.planetaryProxy:GetElecMsg()
    self.m_viewComponent.uiBinder.m_LabelTime.text = info.restOfElect..'/'..info.totalElect
    self.m_viewComponent.uiBinder.m_LabelRagVal.text = GetLanguageText('BuildingAttribute', 'ATRBChargeN', info.elecRecoverCount)
    self.m_viewComponent.uiBinder.m_SpriteLoadingF.fillAmount = info.restOfElect / info.totalElect
end

function PlanetaryMediator:InitBuildingHudInfo()
    local buildMap = self.planetaryProxy:GetBuildingData()
    local curTime = GetServerTimeStamp()
    for k, v in pairs(buildMap)do
        if v.endTime ~= nil and v.endTime > curTime then
            self:AddPlanetHudInfoExploring(v.pos, v.startTime / 1000, v.endTime / 1000,v.id)
        end
        self:AddPlanetHudInfoCanReceive(v.pos,v.buildingConfigId,v.id)
        self:AddPlanetHudInfoNew(v.pos,v.buildingConfigId,v.id)
    end
end

-- 单击planet
function PlanetaryMediator:OnPlanetClick(notify)
    local body = notify:GetBody()
    self.planetaryProxy:SetChosenPlanetId(body.planetId)
    local data = self.planetaryProxy:GetPlanetDataByPlanetId(body.planetId)
    self:OpenGroupPopup(chooseType.planetary, body.planetId)
end

-- 单击格子
function PlanetaryMediator:OnHexeClick(notify)
    local body = notify:GetBody()
    self.planetaryProxy:SetChosenPlanetId(body.hexeId)
    self:OpenGroupPopup(chooseType.hexe, body.hexeId)
end

-- 关闭操作圆盘
function PlanetaryMediator:CloseGroupPopup()
	self.m_viewComponent.uiBinder.m_ButtonExplore.gameObject:SetActive(false)
    self.m_viewComponent.uiBinder.m_ButtonMine.gameObject:SetActive(false)
    self.m_viewComponent.uiBinder.m_GroupPopup.gameObject:SetActive(false)
    self.m_viewComponent.uiBinder.m_ButtonCollet.gameObject:SetActive(false)
    self.m_viewComponent.uiBinder.m_ButtonBuilding.gameObject:SetActive(false)
end

function PlanetaryMediator:OpenGroupPopup(type, id)
    local planetaryProxy = self.planetaryProxy
    if type == chooseType.planetary then

        local planetData = planetaryProxy:GetPlanetDataByPlanetId(id)
        
        local pos2D = self.planetaryProxy:GetPlanetPosInUIWorld(planetData.id)

        SetPosition(self.m_viewComponent.uiBinder.m_GroupPopup, pos2D.x, pos2D.y, 0)

        -- 判断是否可以探索  TODO判断舰船是否达到条件
        if planetaryProxy:IsPlanetExplorable() then
            self.m_viewComponent.uiBinder.m_ButtonExplore.gameObject:SetActive(true)
        end

        if planetaryProxy:IsPlanetMinable() then
            self.m_viewComponent.uiBinder.m_ButtonMine.gameObject:SetActive(true)
        end

        self.m_viewComponent.uiBinder.m_ButtonCollet.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_ButtonBuilding.gameObject:SetActive(false)
    elseif type == chooseType.hexe then
        local hexMap = planetaryProxy:GetGridMapData()

        local posX = hexMap[id].position[1]
        local posZ = hexMap[id].position[2]
        local pos2D = UnityWorld3DPos2WorldUIPos(posX, 0, posZ)

        SetPosition(self.m_viewComponent.uiBinder.m_GroupPopup, pos2D.x, pos2D.y, 0)

        self.m_viewComponent.uiBinder.m_ButtonExplore.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonMine.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonCollet.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonBuilding.gameObject:SetActive(true)
    else
        self.m_viewComponent.uiBinder.m_ButtonExplore.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonMine.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonCollet.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonBuilding.gameObject:SetActive(false)
    end

    self.m_viewComponent.uiBinder.m_GroupPopup.gameObject:SetActive(true)
end

--采集btn按下
function PlanetaryMediator:OnClickColletButton()
    local planetId = self.planetaryProxy:GetChosenPlanetId()
    local planetData = self.planetaryProxy:GetPlanetDataByPlanetId(planetId)
    local resList = {}
    local planetMap = self.planetaryProxy:GetPlanetDataMap()
    if planetData.resLList ~= nil then
        for i = 1, #planetData.resLList do
            if planetData.resLList[i] <= planetMap[planetId].depth then
                table.insert(resList, planetData.resList[i])
            end
        end
    end
    local body = {resList = resList}
    Facade:SendNotification(NotiConst.Notify_PlanetShowCollect, body)

    --self:CloseGroupPopup()

    -- Facade:ReplacePanel("ExploreFleetLstPanel")
    -- Facade:SendNotification(NotiConst.Notify_ExploreFleetLstInit, common_pb.COLLECT)
end

function PlanetaryMediator:OnClickBuildingButton()
    Facade:SendNotification(NotiConst.Notify_PlanetShowBuildingList)
    self:CloseGroupPopup()
end

function PlanetaryMediator:OnWarehouseButtonClick()
    local nodeId = self.planetaryProxy:GetPlanetaryId()
    self.planetaryProxy:SetCurBuildingOper(
        {
            nodeId = nodeId,
            dynamicData = {}
        }
    )
    Facade:ReplacePanel("WarehousePanel")
end

-- 探索btn按下
function PlanetaryMediator:OnClickExploreButton()
    Facade:ReplacePanel("ExploreFleetLstPanel")
    Facade:SendNotification(NotiConst.Notify_ExploreFleetLstInit, common_pb.EXPLORE)
end

-- 查看btn按下
function PlanetaryMediator:OnClickMineButton()
    local planetId = self.planetaryProxy:GetChosenPlanetId()
    local planetData = self.planetaryProxy:GetPlanetDataByPlanetId(planetId)
    local resList = {}
    local planetMap = self.planetaryProxy:GetPlanetDataMap()
    if planetData.resLList ~= nil then
        for i = 1, #planetData.resLList do
            if planetData.resLList[i] <= planetMap[planetId].depth then
                table.insert(resList, planetData.resList[i])
            end
        end
    end
    local body = {isShow = true, resList = resList}
    Facade:SendNotification(NotiConst.Notify_PlanetShowInfo, body)
    self:CloseGroupPopup()
end

-- RPC发送探索请求
function PlanetaryMediator:RPCSendExplore(notify)
    body = notify:GetBody()
    local fleetId = body.fleetId
    
    local planetId = self.planetaryProxy:GetChosenPlanetId()
    local planetData = self.planetaryProxy:GetPlanetDataByPlanetId(planetId)

    self:CloseGroupPopup()
    self.planetaryProxy:ClearChosenPlanetId()
    -- send rpc message
    local TCSExplorer = node_pb.TCSExplorer()
    TCSExplorer.nodeId = self.planetaryProxy:GetPlanetaryId()
    TCSExplorer.planetId = planetData.id
    TCSExplorer.fleetId = fleetId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EXPLORER, TCSExplorer:SerializeToString())
    
    -- local curTime = GetServerTimeStamp(true)
    -- self:AddPlanetHudInfoExploring(id, curTime, curTime + 10)
end

--RPC发送采集请求
function PlanetaryMediator:RPCSendMine(notify)
    local body = notify:GetBody()
    local TCSCollect = node_pb.TCSCollect()
    TCSCollect.nodeId = tonumber(body.nodeId)
    TCSCollect.planetId = body.planetId
    TCSCollect.fleetId = body.fleetId

    --NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.COLLECT, TCSExplorer:SerializeToString())
end

-- S2C探索请求回调
--[[
function PlanetaryMediator:ExploreCallback(stData)
    local TSCExplorer = node_pb.TSCExplorer()
    TSCExplorer:MergeFromString(stData)
    -- 添加hud
    self:AddPlanetHudInfoExploring(self.planetaryProxy:GetGridDataByPlanetId(TSCExplorer.planetId).id , TSCExplorer.startTime / 1000, TSCExplorer.endTime / 1000)
end
]]
-- S2C采集请求回调
function PlanetaryMediator:MineCallback(stData)
    self:ClosePlanetaryCollect()
    self:CloseGroupPopup()
    self.planetaryProxy:ClearChosenPlanetId()
    local TSCCollect = node_pb.TSCCollect()
    TSCCollect:MergeFromString(stData)

    local operation ={
        planetId = TSCCollect.planetId,
        startTime = TSCCollect.startTime,
        endTime = TSCCollect.endTime,
    }

    -- table.insert(self.exploreOperationList, operation)
    -- 添加hud
    self:AddPlanetHudInfoExploring(self.planetaryProxy:GetGridDataByPlanetId(operation.planetId).id, operation.startTime / 1000, operation.endTime / 1000,operation.planetId)
end

-- S2C采集请求回调
function PlanetaryMediator:EndMineCallback(stData)
    local TSCEndCollect = node_pb.TSCEndCollect()
    TSCEndCollect:MergeFromString(stData)

    self:RemovePlanetHudInfo(self.planetaryProxy:GetGridDataByPlanetId(TSCEndCollect.planetId).id)
end

function PlanetaryMediator:BuildingCallback(stData)
    local TSCCreateBuilding = building_pb.TSCCreateBuilding()
    TSCCreateBuilding:MergeFromString(stData)

    --更新仓库数据
    self.storehouseProxy:UseItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCCreateBuilding.items)
    
    self:AddPlanetHudInfoExploring(TSCCreateBuilding.building.pos, TSCCreateBuilding.building.startTime / 1000, TSCCreateBuilding.building.endTime / 1000,TSCCreateBuilding.building.id)
    self.planetaryProxy:AddBuildingData(TSCCreateBuilding.building)

    local building = clsBuilding.New(TSCCreateBuilding.building)
    local buildingGo = building:BuildBuilding(self.planetContainer, TSCCreateBuilding.building.pos)
    local build = self.planetaryProxy:GetBuildingDataById(TSCCreateBuilding.building.id)
    build.building = building
    building:OnClick()
    self:CloseBuildingList(false)
end

function PlanetaryMediator:MoveBuildingCallback(stData)
    if stData ~= nil then
        local TSCMoveBuilding = building_pb.TSCMoveBuilding()
        TSCMoveBuilding:MergeFromString(stData)
        if TSCMoveBuilding.result then
            local build = self.planetaryProxy:GetBuildingDataById(TSCMoveBuilding.building.id)
            if self.allPlanetHudInfoList[build.building.gridId] ~= nil then
                self.allPlanetHudInfoList[TSCMoveBuilding.building.pos] = self.allPlanetHudInfoList[build.building.gridId]
                self.allPlanetHudInfoList[TSCMoveBuilding.building.pos].gridId = TSCMoveBuilding.building.pos
                self.allPlanetHudInfoList[build.building.gridId] = nil
            end
            build.building:MovePos(TSCMoveBuilding.building.pos)
            build.building.buildingGo:SetActive(true)
        else
            local build = self.planetaryProxy:GetBuildingDataById(TSCMoveBuilding.building.id)
            build.building.buildingGo:SetActive(true)
        end
    end
end

function PlanetaryMediator:BuildFinishedCallback(stData)
    local TSCBuildFinished = building_pb.TSCBuildFinished()
    TSCBuildFinished:MergeFromString(stData)

    self.planetaryProxy:AddBuildingData(TSCBuildFinished.building)
    
    local build = self.planetaryProxy:GetBuildingDataById(TSCBuildFinished.building.id)
    build.building:PlayConstructionCompletedAnimation()
    --[[
    build.building:Destroy()
    build.building = nil

    self.planetaryProxy:AddBuildingData(TSCBuildFinished.building)
    local building = clsBuilding.New(TSCBuildFinished.building)
    self.planetaryProxy:AddbuildingClassTable(building)
    local buildingGo = building:BuildBuilding(self.planetContainer, TSCBuildFinished.building.pos)
    --build需要重新赋值
    build = self.planetaryProxy:GetBuildingDataById(TSCBuildFinished.building.id)
    build.building = building
]]
    self.corId_destroyBuildAnimationModel = self.m_viewComponent:StartCoroutine(self.DestroyBuildAnimationModel,self,TSCBuildFinished)

    self:RemovePlanetHudInfo(TSCBuildFinished.building.pos)

    self:AddPlanetHudInfoCanReceive(TSCBuildFinished.building.pos,TSCBuildFinished.building.buildingConfigId,TSCBuildFinished.building.id)
    self:AddPlanetHudInfoNew(TSCBuildFinished.building.pos,TSCBuildFinished.building.buildingConfigId,TSCBuildFinished.building.id)

    local type = self.planetaryProxy:GetBuildingType(TSCBuildFinished.building.buildingConfigId)
    if type == common_pb.ITEMSTG or type == common_pb.SPACESTATION then
        --刷新仓库容量
        local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
        local configData = self.planetaryProxy:GetBuildingConifData(TSCBuildFinished.building.buildingConfigId)
        local num = self.planetaryProxy:GetBuildingFunData(configData.data,configData.EVar,"max_item_cap_n")
        num = math.floor(self.planetaryProxy:GetValueAfterAddition(num,"BUILDING","max_item_cap"))
        --如果是升级 需要减去之前的数值
        if TSCBuildFinished.buildingType == 1 then
            local beforeConfigData = self.planetaryProxy:GetBuildingConifData(TSCBuildFinished.building.buildingConfigId - 1)
            local beforeNum = self.planetaryProxy:GetBuildingFunData(beforeConfigData.data,beforeConfigData.EVar,"max_item_cap_n")
            beforeNum = math.floor(self.planetaryProxy:GetValueAfterAddition(beforeNum,"BUILDING","max_item_cap"))
            num = num - beforeNum
        end
        storehouseProxy:AddCap(self.planetaryProxy:GetPlanetaryId(), num)

        local body = {restOfCap = self.storehouseProxy:GetStorehouseRestOfCap(self.planetaryProxy:GetPlanetaryId()), totalCap = self.storehouseProxy:GetStorehouseTotalCap(self.planetaryProxy:GetPlanetaryId())}

        Facade:SendNotification(NotiConst.Notify_RefreshCap, body)
        
    elseif type == common_pb.POWERPLANT then
        local configData = self.planetaryProxy:GetBuildingConifData(TSCBuildFinished.building.buildingConfigId)
        local ElecMsg = self.planetaryProxy:GetElecMsg()
        
        local max_ele_cap1 = self.planetaryProxy:GetBuildingFunData(configData.data,configData.EVar,'max_ele_cap_n')
        max_ele_cap1 = math.floor(self.planetaryProxy:GetValueAfterAddition(max_ele_cap1,"BUILDING","max_ele_cap"))
        local ele_regen_rate1 = self.planetaryProxy:GetBuildingFunData(configData.data,configData.EVar,'ele_regen_rate_n')
        ele_regen_rate1 = math.floor(self.planetaryProxy:GetValueAfterAddition(ele_regen_rate1,"BUILDING","ele_regen_rate"))

        ElecMsg.totalElect = ElecMsg.totalElect + max_ele_cap1
        ElecMsg.elecRecoverCount = ElecMsg.elecRecoverCount + ele_regen_rate1

        if TSCBuildFinished.buildingType == 1 then
            local beforeConfigData = self.planetaryProxy:GetBuildingConifData(TSCBuildFinished.building.buildingConfigId - 1)
            local max_ele_cap2 = self.planetaryProxy:GetBuildingFunData(beforeConfigData.data,beforeConfigData.EVar,'max_ele_cap_n')
            max_ele_cap2 = math.floor(self.planetaryProxy:GetValueAfterAddition(max_ele_cap2,"BUILDING","max_ele_cap"))
            local ele_regen_rate2 = self.planetaryProxy:GetBuildingFunData(beforeConfigData.data,beforeConfigData.EVar,'ele_regen_rate_n')
            ele_regen_rate2= math.floor(self.planetaryProxy:GetValueAfterAddition(ele_regen_rate2,"BUILDING","ele_regen_rate"))
            
            ElecMsg.totalElect = ElecMsg.totalElect - max_ele_cap2
            ElecMsg.elecRecoverCount = ElecMsg.elecRecoverCount - ele_regen_rate2
        end

        ElecMsg.electricityStartTime = GetServerTimeStamp() * 1000

        Facade:SendNotification(NotiConst.Notify_UpdatElecInfo)
    end
    self:BuildingInteractiveRefreshView(TSCBuildFinished.building.id)
    
end

--延迟删除建造完成动画
function PlanetaryMediator:DestroyBuildAnimationModel(self,TSCBuildFinished)
    coroutine.wait(0.5)
    --删除带动画的模型
    local build = self.planetaryProxy:GetBuildingDataById(TSCBuildFinished.building.id)
    build.building:Destroy()
    build.building = nil

    local building = clsBuilding.New(TSCBuildFinished.building)
    self.planetaryProxy:AddbuildingClassTable(building)
    local buildingGo = building:BuildBuilding(self.planetContainer, TSCBuildFinished.building.pos)
    --build需要重新赋值
    build = self.planetaryProxy:GetBuildingDataById(TSCBuildFinished.building.id)
    build.building = building
end

function PlanetaryMediator:GetStoreHouseCallback(stData)
    if stData ~= nil then
        local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
        local TSCGetStorehouse = building_pb.TSCGetStorehouse()
        TSCGetStorehouse:MergeFromString(stData)
        storehouseProxy:SetStorehouse(self.planetaryProxy:GetPlanetaryId(), TSCGetStorehouse.item,TSCGetStorehouse.restOfCap,TSCGetStorehouse.totalCap)
    end
end

function PlanetaryMediator:StorehousePeoductLineProduct(stData)
    if stData ~= nil then
        local TSCGetPeoductLineProduct = buildingHullFact_pb.TSCGetPeoductLineProduct()
        TSCGetPeoductLineProduct:MergeFromString(stData)
        self.planetaryProxy:SetBuildingData_GetItemTime(TSCGetPeoductLineProduct.building)
        self.storehouseProxy:AddItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCGetPeoductLineProduct.items)
        if TSCGetPeoductLineProduct.items ~= nil then
            local message = ''
            for i = 1, #TSCGetPeoductLineProduct.items do
                local name,frame,icon,cnType = self.storehouseProxy:GetItemBaseData(TSCGetPeoductLineProduct.items[i].id)
                name = GetLanguageText(cnType, name)
                local str = string.format( "已领取%s %d个",name,TSCGetPeoductLineProduct.items[i].num)
                message = message..str..'\n' 
            end
            OpenMessageBox(NotiConst.MessageBoxType.Tip,message)
        end
    end
end

function PlanetaryMediator:StorehouseRefineryCollect(stData)
    if stData ~= nil then
        local TSCRefineryCollect = buildingRefinery_pb.TSCRefineryCollect()
        TSCRefineryCollect:MergeFromString(stData)
        self.planetaryProxy:SetBuildingData_GetItemTime(TSCRefineryCollect.building)
        if TSCRefineryCollect.items ~= nil then
            local message = ''
            for i = 1, #TSCRefineryCollect.items do
                local name,frame,icon,cnType = self.storehouseProxy:GetItemBaseData(TSCRefineryCollect.items[i].id)
                name = GetLanguageText(cnType, name)
                local str = string.format( "已领取%s %d个",name,TSCRefineryCollect.items[i].num)
                message = message..str..'\n' 
            end
            OpenMessageBox(NotiConst.MessageBoxType.Tip,message)
        end
        self.storehouseProxy:AddItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCRefineryCollect.items)
    end
end

function PlanetaryMediator:StorehouseCollectionReceive(stData)
    if stData ~= nil then
        local TSCCollectionPlantCollect = buildingCollectionPlant_pb.TSCCollectionPlantCollect()
        TSCCollectionPlantCollect:MergeFromString(stData)
        self.planetaryProxy:SetBuildingData_GetItemTime(TSCCollectionPlantCollect.building)
        if TSCCollectionPlantCollect.item ~= nil then
            local name,frame,icon,cnType = self.storehouseProxy:GetItemBaseData(TSCCollectionPlantCollect.item.id)
            name = GetLanguageText(cnType, name)
            local str = string.format( "已领取%s %d个",name,TSCCollectionPlantCollect.item.num)
            OpenMessageBox(NotiConst.MessageBoxType.Tip,str)
        end
        self.storehouseProxy:AddItemByData(self.planetaryProxy:GetPlanetaryId(),TSCCollectionPlantCollect.item)
    end
end

function PlanetaryMediator:StorehouseRefineryEnd(stData)
    if stData == nil then
        return
    end
    local TSCRefineryEnd = buildingRefinery_pb.TSCRefineryEnd()
    TSCRefineryEnd:MergeFromString(stData)
    if TSCRefineryEnd.item ~= nil then
        local name,frame,icon,cnType = self.storehouseProxy:GetItemBaseData(TSCRefineryEnd.item.id)
        name = GetLanguageText(cnType, name)
        local str = string.format( "已领取%s %d个",name,TSCRefineryEnd.item.num)
        OpenMessageBox(NotiConst.MessageBoxType.Tip,str)
        self.storehouseProxy:AddItemByData(self.planetaryProxy:GetPlanetaryId(), TSCRefineryEnd.item)
    end

    self.planetaryProxy:SaveElecMsg(TSCRefineryEnd.elecMsg)
    Facade:SendNotification(NotiConst.Notify_UpdatElecInfo)
end

function PlanetaryMediator:StorehouseEditHullProductLine(stData)
    if stData == nil then
        return
    end

    local TSCEditHullProductLine = buildingHullFact_pb.TSCEditHullProductLine()
    TSCEditHullProductLine:MergeFromString(stData)
    if TSCEditHullProductLine.addType == 0 then
        self.storehouseProxy:UseItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCEditHullProductLine.items)
    else
        self.storehouseProxy:AddItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCEditHullProductLine.items)
    end

    self.planetaryProxy:SaveElecMsg(TSCEditHullProductLine.elecMsg)
    Facade:SendNotification(NotiConst.Notify_UpdatElecInfo)
end

function PlanetaryMediator:StorehouseDeleteShip(stData)
    if stData == nil then
        return
    end

    local TSCSplitShip = buildingPort_pb.TSCSplitShip()
    TSCSplitShip:MergeFromString(stData)
    if TSCSplitShip.result then
        self.storehouseProxy:AddItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCSplitShip.items)
    end
end

function PlanetaryMediator:StorehouseEditShip(stData)
    if stData == nil then
        return
    end
    local TSCEditShip = buildingModFact_pb.TSCEditShip()
    TSCEditShip:MergeFromString(stData)
    self.storehouseProxy:UseItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCEditShip.costItems)
    self.storehouseProxy:AddItemByDatas(self.planetaryProxy:GetPlanetaryId(), TSCEditShip.returnItems)
end
--[[
-- 接受到服务器推送的探索结果消息，星球显示叹号，需要点击才显示探索结果
function PlanetaryMediator:GetExploreResultCallback(stData)
    local TSCGetExplorerResult = node_pb.TSCGetExplorerResult()
    TSCGetExplorerResult:MergeFromString(stData)
    local planet = TSCGetExplorerResult.planet
    self.planetaryProxy:SetPlanetDataByPlanet(planet)
    self:RemovePlanetHudInfo(hexeId)
    self:AddPlanetHudInfoExclamation(hexeId)
end
]]
--接受到采集结束消息，同上
function PlanetaryMediator:GetMineResultCallback(stData)
    --TODO
end

-- 显示探索结果
function PlanetaryMediator:ShowExplorationResult(notify)
    local body = notify:GetBody()
    Facade:ReplacePanel("ExplorationResultPanel")
end

function PlanetaryMediator:PlanetShowInfo(notify)
    local body = notify:GetBody()
    self:ShowPlanetaryInfo(body.isShow, body.resList)
end

function PlanetaryMediator:PlanetShowCollect (notify)
    local body = notify:GetBody()
    self:ShowPlanetaryCollect(true)
    Facade:SendNotification('InitCollectResourceListCell', #body.resList)
end

function PlanetaryMediator:PlanetShowBuildingList(notify)
    -- self:ShowBuildingList(true)
    -- Facade:SendNotification('InitBuildingListCell', #self.buildingList)
    self:CloseEditBuildingMod()
    local nodeId = self.planetaryProxy:GetPlanetaryId()
    self.planetaryProxy:SetBuildingList(nodeId, self.planetaryProxy:GetBeginBuilding())
    Facade:ReplacePanel("BuildingListPanel")
end

-------hud

-- 通过舰队信息绑定hud
function PlanetaryMediator:SetHudInfoByFleetOperation()
    -- 获得该星系内自己的舰队
    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local fleetList = fleetProxy:GetMyFleetsDataByNodeId(self.planetaryProxy:GetPlanetaryId())
    -- 遍历舰队
    for idx, fleetData in pairs(fleetList) do
        local operationData = fleetProxy:GetOperationDataByFleetId(fleetData.fleetId)
        if operationData ~= nil then
            local planetId = operationData.targetPlanetId
            if operationData.type == common_pb.EXPLORE then     -- 探索
                self:AddPlanetHudInfoExploring(self.planetaryProxy:GetGridDataByPlanetId(planetId).id, operationData.dynamicData.startTime, operationData.dynamicData.endTime,planetId)
            elseif operationData.type == common_pb.COLLECT then  -- 采集
                self:AddPlanetHudInfoExploring(self.planetaryProxy:GetGridDataByPlanetId(planetId).id, operationData.dynamicData.startTime, operationData.dynamicData.endTime,planetId)
            end
        end
    end
end

-- 通过星球状态绑定hud
function PlanetaryMediator:SetHudInfoByPlanetStatus()
    local HexMap = self.planetaryProxy:GetGridMapData()
    local nodeData = self.universeProxy:GetNode(self.planetaryProxy:GetPlanetaryId())    
    local maxLevel = HexMap[nodeData.config.planets[#(nodeData.config.planets)].gridId].level + 3
    for k, v in pairs(HexMap) do
        if v.level > maxLevel then
            break
        end
        local hudInfo = {}
        self:AddPlanetHudInfoExplorable(v.id)
    end

    local planetMap = self.planetaryProxy:GetPlanetDataMap()
    for id, planetData in pairs(planetMap) do
        self:SetPlanetHudInfoState(planetData.gridId, true)
    end
end

--添加可探索标记hud
function PlanetaryMediator:AddPlanetHudInfoExplorable(hexeId)
    local hudInfo = {}
    hudInfo.hexeId = hexeId
    hudInfo.hudName = explorablePath
    self:AddPlanetHudInfo(hudInfo)
end

function PlanetaryMediator:SetPlanetHudInfoState(hexeId, isShow)
    self.planetaryProxy:SetHexHudInfoState(hexeId, isShow)
end

--添加叹号hud
function PlanetaryMediator:AddPlanetHudInfoExclamation(hexeId)
    local hudInfo = {}
    hudInfo.hexeId = hexeId
    hudInfo.hudName = exclamationHudPath
    self:AddPlanetHudInfo(hudInfo)
end

--添加New标签
function PlanetaryMediator:AddPlanetHudInfoNew(gridId,configId,targetBuildingId)
    local type = self.planetaryProxy:GetBuildingType(configId)
    if type == common_pb.SPACEPORT then -- 星港
        self:RemovePlanetHudInfo(gridId)

        local isNew = self.planetaryProxy:GetIsPortShipNew()
        if isNew then
            self:SetPlanetHudInfoState(gridId, true)
        else
            self:SetPlanetHudInfoState(gridId, false)       
        end
        local hudInfo = {}
        hudInfo.configId = configId
        hudInfo.targetBuildingId = targetBuildingId
        hudInfo.gridId = gridId
        hudInfo.hudName = newHudPath
        self:AddPlanetHudInfo(hudInfo)
    end
end

--添加可领取hud
function PlanetaryMediator:AddPlanetHudInfoCanReceive(gridId,configId,targetBuildingId)
    local type = self.planetaryProxy:GetBuildingType(configId)
    if type == common_pb.SURFCOL or type == common_pb.REFINERY or type == common_pb.HULLFACT then -- 地表采集
        self:RemovePlanetHudInfo(gridId)

        local isReceive = self:IsCanReceiveProduce(targetBuildingId)
        if isReceive then
            self:SetPlanetHudInfoState(gridId, true)
        else
            self:SetPlanetHudInfoState(gridId, false)       
        end
        local hudInfo = {}
        hudInfo.configId = configId
        hudInfo.targetBuildingId = targetBuildingId
        hudInfo.gridId = gridId
        hudInfo.hudName = canReceiveHudPath
        self:AddPlanetHudInfo(hudInfo)
    end
end

--点击领取hud的回调事件
function PlanetaryMediator:OnReveiveProduceClick(data)
    local buildingId = data.id 
    local gridId = data.gridId
    local buildingConfigId = data.buildingConfigId
    local isReceive = self:IsCanReceiveProduce(buildingId)
    local nodeId = self.planetaryProxy:GetPlanetaryId()
    local isFull = self.storehouseProxy:IsStorehouseFull(nodeId)
    if isFull then
        self.planetaryProxy:SetHexHudInfoState(gridId, false)
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"仓库已满")
        return
    elseif not isFull and isReceive then
        local type = self.planetaryProxy:GetBuildingType(buildingConfigId)
        if type == common_pb.SURFCOL then
            local TCSCollectionPlantCollect = buildingCollectionPlant_pb.TCSCollectionPlantCollect()
            TCSCollectionPlantCollect.buildingId = buildingId
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.COLLECTIONPLANTCOLLECT, TCSCollectionPlantCollect:SerializeToString())
        elseif type == common_pb.REFINERY then
            ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYCOLLECT), self.RefineryCollectReceiveCallback, self)
            local TCSRefineryCollect = buildingRefinery_pb.TCSRefineryCollect()
            TCSRefineryCollect.buildingId = buildingId
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.REFINERYCOLLECT, TCSRefineryCollect:SerializeToString())
        elseif type == common_pb.HULLFACT then
            ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPRODUCTLINEPRODUCT), self.GetPeoductLineProductCallback, self)
            local TCSGetPeoductLineProduct = buildingHullFact_pb.TCSGetPeoductLineProduct()
            TCSGetPeoductLineProduct.buildingId = buildingId
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETPRODUCTLINEPRODUCT, TCSGetPeoductLineProduct:SerializeToString())
        end
    end
end

--更新领取hud的显示
function PlanetaryMediator:UpdateReceiveHudShow()
    if self.cycleTime < 1 then
        self.cycleTime = self.cycleTime + UnityEngine.Time.deltaTime
        return
    end
    self.cycleTime = 0
    local nodeId = self.planetaryProxy:GetPlanetaryId()
    local isFull = self.storehouseProxy:IsStorehouseFull(nodeId)
    local allPlanetHudInfoList = self.allPlanetHudInfoList
    for idx, hudInfo in pairs(allPlanetHudInfoList) do
        if hudInfo.targetBuildingId ~= nil then
            local type = self.planetaryProxy:GetBuildingType(hudInfo.configId)
            if type == common_pb.SURFCOL or type == common_pb.REFINERY or type == common_pb.HULLFACT then
                local isReceive = self:IsCanReceiveProduce(hudInfo.targetBuildingId)
                local isShow = self.planetaryProxy:GetHexHudInfoState(hudInfo.gridId)
                if isReceive then
                    if isFull and not isShow then
                        self:SetPlanetHudInfoState(hudInfo.gridId, false)
                    else
                        self:SetPlanetHudInfoState(hudInfo.gridId, true)
                    end
                else
                    self:SetPlanetHudInfoState(hudInfo.gridId, false)
                end
            elseif type == common_pb.SPACEPORT then
                local isNew = self.planetaryProxy:GetIsPortShipNew()
                if isNew then
                    self:SetPlanetHudInfoState(hudInfo.gridId, true)
                else
                    self:SetPlanetHudInfoState(hudInfo.gridId, false)       
                end
            end
        end
    end
end

function PlanetaryMediator:IsCanReceiveProduce(targetBuildingId)
    local buildData = self.planetaryProxy:GetBuildingDataById(targetBuildingId)
    local time = GetServerTimeStamp()
    if buildData ~= nil and buildData.getItemTime ~= nil and buildData.getItemTime ~= -1 and buildData.getItemTime/1000 < time then
        return true
    else
        return false
    end
end

-- 添加探索/采集中hud
function PlanetaryMediator:AddPlanetHudInfoExploring(gridId, startTime, endTime,id)
    if startTime == nil or endTime == nil then
        LogDebug("startTime or endTime not exist")
    end

    self:RemovePlanetHudInfo(gridId)
    self:SetPlanetHudInfoState(gridId, true)

    local hudInfo = {}
    hudInfo.hudName = exploringPath
    hudInfo.gridId = gridId
    hudInfo.startTime = startTime
    hudInfo.endTime = endTime
    --hudInfo.scale = 0.5
    hudInfo.id = id
    hudInfo.callback = function(self)
        local curTime = GetServerTimeStamp()
        local percent = (curTime - self.startTime) / (self.endTime - self.startTime)
        local remainTime = self.endTime - curTime
        
        if percent >= 1 then
            percent = 1
        end
    
        local obj = self.obj
        if obj ~= nil then
            local timeLabel = obj.transform:Find("timelabel"):GetComponent("UILabel")
            local progressObj = obj.transform:Find("timelabel"):Find("progress"):GetComponent("UISprite")
            progressObj.fillAmount = percent

            timeLabel.text = SecondFormat(remainTime)
            -- if remainTime <= 0 then
            --     timeLabel.text = SecondToMinutes(0)
            -- else    
            --     timeLabel.text = SecondToMinutes(remainTime)
            -- end
        end
    end

    self:AddPlanetHudInfo(hudInfo)
end


--给一个planet绑定hud
function PlanetaryMediator:AddPlanetHudInfo(hudInfo)
    self.allPlanetHudInfoList[hudInfo.gridId] = hudInfo
end

-- 移除hud ，如果hudName为空，则移除id下所有hud
function PlanetaryMediator:RemovePlanetHudInfo(gridId, hudName)
    local allPlanetHudInfoList = self.allPlanetHudInfoList
    local removeIdxList = {}
    self:UpdateHudInfo(allPlanetHudInfoList[gridId], false)
    allPlanetHudInfoList[gridId] = nil
end


-- 当星球发改状态改变，用此函数改动hudinfo
function PlanetaryMediator:UpdatePlanetHudInfo(gridId)
    
end

-- 更新所有planet的hud
function PlanetaryMediator:UpdateAllPlanetHud()
    local allPlanetHudInfoList = self.allPlanetHudInfoList
    local hexMap = self.planetaryProxy:GetGridMapData()
    
    for idx, hudInfo in pairs(allPlanetHudInfoList) do
        self:UpdateHudInfo(hudInfo, hexMap[hudInfo.gridId].showHUD)
    end
end

--更新单个planet的hud
function PlanetaryMediator:UpdateHudInfo(hudInfo, visible)
    if hudInfo ~= nil then
        local obj = hudInfo.obj
        if visible == true then
            local pos2D = self.planetaryProxy:GetHexePosInUIWorld(hudInfo.gridId)
            if obj ~= nil then
                SetPosition(obj, pos2D.x, pos2D.y, 0)
            else
                self.instancePool:NewInst(hudInfo.hudName, function(this, obj)
                    obj:SetActive(true)
                    SetPosition(obj, pos2D.x, pos2D.y, 0)
                    if hudInfo.scale ~= nil then
                        SetScale(obj, hudInfo.scale, hudInfo.scale, hudInfo.scale)
                    else
                        SetScale(obj, 1, 1, 1)
                    end
                    
                    hudInfo.obj = obj
                    if hudInfo.hudName == exploringPath then
                        local speedUpObj = obj.transform:Find("n_SpeedUpButton").gameObject;
                        local nLuaClickEvent = NLuaClickEvent.Get(speedUpObj)
                        local data = {["id"] = hudInfo.id,["type"] = publicPart_pb.BUILDING_LEVEL_UP}
                        nLuaClickEvent:AddClick(self, self.OnClickSpeedUp,data)
                    elseif hudInfo.hudName == canReceiveHudPath then
                        local nLuaClickEvent = NLuaClickEvent.Get(obj)
                        local data = {id = hudInfo.targetBuildingId,gridId = hudInfo.gridId,buildingConfigId = hudInfo.configId}
                        nLuaClickEvent:AddClick(self,self.OnReveiveProduceClick,data)
                    end
                end, nil)
            end
            if hudInfo.callback ~= nil then
                hudInfo:callback()
            end
        else
            if obj ~= nil then
                obj:SetActive(false)
                hudInfo.obj = nil
            end
        end 
    end
end

function PlanetaryMediator:OnDestroy()
    UpdateBeat:Remove(self.Update, self);
    self.planetarySystem:Release()
    self.cameraCtrl:Release()
    if self.selectBuilding ~= nil then
        self.selectBuilding:RemoveUpdate()
    end

    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.FLEETCOLLECT), self.MineCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ENDFLEETCOLLECT), self.EndMineCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CREATEBUILDING), self.BuildingCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.BUILDFINISHED), self.BuildFinishedCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETSTOREHOUSE), self.GetStoreHouseCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPRODUCTLINEPRODUCT), self.StorehousePeoductLineProduct)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYCOLLECT), self.StorehouseRefineryCollect)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.COLLECTIONPLANTCOLLECT), self.StorehouseCollectionReceive)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITSHIP), self.StorehouseEditShip)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYEND), self.StorehouseRefineryEnd)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITHULLPRODUCTLINE), self.StorehouseEditHullProductLine)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPEEDUP), self.SpeedUpCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.TASKONLINECOLLECT), self.TaskOnLineCollectCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.MOVEBUILDING), self.MoveBuildingCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERLEVELUP), self.UserLevelUpCallback)
   
end

function PlanetaryMediator:ShowPlanetaryInfo(isShow, resList)
    if isShow then
        self.m_viewComponent.uiBinder.m_contentText.text = ''
        for i = 1, #resList do
            --local data = storehouseProxy:GetResourceDataById(resList[i])
            local resData = storehouseProxy:GetItemConfigData(resList[i])
            self.m_viewComponent.uiBinder.m_contentText.text = self.m_viewComponent.uiBinder.m_contentText.text..resData.data[resData.EVar["desc_s"]]..','
        end
    end
    self.m_viewComponent.uiBinder.m_InfoBackBuntton.transform.parent.gameObject:SetActive(isShow)
end

function PlanetaryMediator:ClosePlanetaryInfo()
    self:ShowPlanetaryInfo(false)
    self.planetaryProxy:ClearChosenPlanetId()
end

function PlanetaryMediator:ShowPlanetaryCollect(isShow)
    self.m_viewComponent.uiBinder.m_CollectBackBuntton.transform.parent.gameObject:SetActive(isShow)
end

function PlanetaryMediator:ClosePlanetaryCollect()
    self:ShowPlanetaryCollect(false)
    self.planetaryProxy:ClearChosenPlanetId()
end

function PlanetaryMediator:ShowBuildingList(isShow)
    self.m_viewComponent.uiBinder.m_BuildingListBackBuntton.transform.parent.gameObject:SetActive(isShow)
end

function PlanetaryMediator:CloseBuildingList(isShow)
    self:ShowBuildingList(false)
    self.planetaryProxy:ClearChosenPlanetId()
end

function PlanetaryMediator:GetTaskOnlineReward()
    local TCSTaskOnlineCollect = user_pb.TCSTaskOnlineCollect()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.TASKONLINECOLLECT, TCSTaskOnlineCollect:SerializeToString())
end

function PlanetaryMediator:PlanetChooseBuilding(notification)
    self:ShowBuildingList(false)
    local body = notification:GetBody()
    self.selectBuilding = clsBuildingObjectMod.New(body)

    if body.gridId ~= nil then
        self.selectBuildingGo = self.selectBuilding:BuildBuilding(self.planetContainer, body.gridId)
        self.planetaryProxy:SetBuildingMoveMod(true)
    else
        local pos = NGameObjectUtil.ScreenPickCastFloorByLayer(UnityScreen.width * 0.5, UnityScreen.height * 0.5, 'PlanetPlane')
        local x = math.floor(pos.x)
        local y = math.floor(pos.z)
        local gridId = (x + 55) * 1000 + y + 55

        self.selectBuildingGo = self.selectBuilding:BuildBuilding(self.planetContainer, gridId)
    end
    
    local buildMap = self.planetaryProxy:GetBuildingData()
    for k, v in pairs(buildMap)do
        if v.building ~= nil and v.building.data.id ~= body.id then
            v.building:IsShowPowerRangeg(true)
        end
    end
    self.m_viewComponent.uiBinder.m_EditBuildingModButton.transform.parent.gameObject:SetActive(true)
end

function PlanetaryMediator:CreateBuilding()
    local flag = self.selectBuilding:CanCreateBuilding()
    local buildingId = self.selectBuilding.data.id
    local configId = self.selectBuilding.data.buildingConfigId
    local gridId = self.selectBuilding:GetGirdId()
    local isMoveMod = self.planetaryProxy:GetBuildingMoveMod()
    self:CloseEditBuildingMod()
    if flag then
        if isMoveMod then
            TCSMoveBuilding = building_pb.TCSMoveBuilding()
            TCSMoveBuilding.buildingId = buildingId
            TCSMoveBuilding.pos = gridId
            local build = self.planetaryProxy:GetBuildingDataById(buildingId)
            build.building.buildingGo:SetActive(false)
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.MOVEBUILDING, TCSMoveBuilding:SerializeToString())
        else
            local TCSCreateBuilding = building_pb.TCSCreateBuilding()
            TCSCreateBuilding.buildingConfigId = configId
            TCSCreateBuilding.pos = gridId
            TCSCreateBuilding.nodeId = self.planetaryProxy:GetPlanetaryId()
            TCSCreateBuilding.temporary = 0
            NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CREATEBUILDING, TCSCreateBuilding:SerializeToString())
        end
    end
end

function PlanetaryMediator:CloseEditBuildingMod()
    if self.selectBuilding ~= nil then
        self.selectBuilding:RemoveUpdate()
        self.selectBuilding:Destroy()
        self.selectBuilding = nil
        self.selectBuildingGo = nil
        self.m_viewComponent.uiBinder.m_EditBuildingModButton.transform.parent.gameObject:SetActive(false)
        self.planetaryProxy:SetBuildingMoveMod(false)
        local buildMap = self.planetaryProxy:GetBuildingData()
        for k, v in pairs(buildMap)do
            if v.building ~= nil then
                v.building:IsShowPowerRangeg(false)
                v.building:CloseBuildingObjMod()
            end
        end
    end
end

function PlanetaryMediator:SetPlanetCameraEnable(notification)
    self.cameraCtrl.enable = notification:GetBody()
end

function PlanetaryMediator:BuildingUpgrade(notification)
    local buildingData = notification:GetBody()
    self.planetaryProxy:AddBuildingData(buildingData)
    local build = self.planetaryProxy:GetBuildingDataById(buildingData.id)
    build.building:SetData(buildingData)
    self.m_viewComponent:StopCoroutine(self.corId_destroyBuildAnimationModel)
    build.building:AddBuildingAnimation()
    self:AddPlanetHudInfoExploring(buildingData.pos, buildingData.startTime / 1000, buildingData.endTime / 1000,buildingData.id)
    self:BuildingInteractiveRefreshView(buildingData.id)
end

function PlanetaryMediator:BuildingCancel(notification)
    local buildingData = notification:GetBody().building
    local type = notification:GetBody().type
    local build = self.planetaryProxy:GetBuildingDataById(buildingData.id)
    self.planetaryProxy:AddBuildingData(buildingData)
    build.building:Destroy()
    build.building = nil
    if type == 1 then
        local building = clsBuilding.New(buildingData)
        local buildingGo = building:BuildBuilding(self.planetContainer, buildingData.pos)
        self.planetaryProxy:GetBuildingDataById(buildingData.id).building = building
    end
    self:RemovePlanetHudInfo(buildingData.pos)
    self:BuildingInteractiveRefreshView(buildingData.id)
end

function PlanetaryMediator:BuildingDismantle(notification)
    local buildingId = notification:GetBody()
    local build = self.planetaryProxy:GetBuildingDataById(buildingId)
    build.building:Destroy()
    build.building = nil
    self.planetaryProxy:RemoveBuildingData(buildingId)
end

function PlanetaryMediator:BuildingInteractiveRefreshView(buildingId)
    if Facade:IsRunPanel("BuildingInteractivePanel") then
        Facade:SendNotification(NotiConst.Notify_BuildingInteractiveRefreshView, buildingId)
    end
end

function PlanetaryMediator:InitFleetPortShip(notification)
    local body = notification:GetBody()
    self:SetFleetPortShip(body.buildingId,body.data)
end

function PlanetaryMediator:SetFleetPortShip(buildingId,data)
    local build = self.planetaryProxy:GetBuildingDataById(buildingId)
    if build.building then
        build.building:BuildPortShip(data)
    end
end

function PlanetaryMediator:InitCameraPos(notification)
    local body = notification:GetBody()
    self.cameraCtrl:InitCameraPos(body.x, body.y)
end

--加速按钮事件
function PlanetaryMediator:OnClickSpeedUp(tableData)
    self:SendSpeedUpMessage(tableData.id,tableData.type)
end

function PlanetaryMediator:SendSpeedUpMessage(id,type)
    local TCSSpeedUp = publicPart_pb.TCSSpeedUp()
    TCSSpeedUp.id = id
    TCSSpeedUp.type = type
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SPEEDUP, TCSSpeedUp:SerializeToString())
end

--加速监听回调
function PlanetaryMediator:SpeedUpCallback(sData)
    if sData ~= nil then
        local TSCSpeedUp = publicPart_pb.TSCSpeedUp()
        TSCSpeedUp:MergeFromString(sData)
        local type = TSCSpeedUp.type
        if type == publicPart_pb.BUILDING_LEVEL_UP then
            local buildingData = self.planetaryProxy:GetBuildingDataById(TSCSpeedUp.id)
            local gridId = buildingData.pos
            if self.allPlanetHudInfoList[gridId] ~= nil then
                self.allPlanetHudInfoList[gridId].endTime = TSCSpeedUp.endTime
            end
        end
    end
end

--在线领取奖励回调
function PlanetaryMediator:TaskOnLineCollectCallback(sData)
    if sData ~= nil then
        local TSCTaskOnlineCollect = user_pb.TSCTaskOnlineCollect()
        TSCTaskOnlineCollect:MergeFromString(sData)
        self.userDataProxy:SetRewardTimeLeft(math.floor(TSCTaskOnlineCollect.taskOnline.rewardTimeLeft / 1000), TSCTaskOnlineCollect.taskOnline.rewardCount)
        self:RefreshRewardTimeInfo()
        self.userDataProxy:SetTechPoint(self.userDataProxy:GetTechPoint() + TSCTaskOnlineCollect.techPoint)
        self.userDataProxy:SetStarDust(self.userDataProxy:GetStarDust() + TSCTaskOnlineCollect.starDust)
        self.userDataProxy:SendNotificationUpdatePlayerInfo()
    end
end

--玩家等级推送，（临时功能）
function PlanetaryMediator:UserLevelUpCallback(sData)
    if sData ~= nil then
        local TSCUserLevelUp = user_pb.TSCUserLevelUp()
        TSCUserLevelUp:MergeFromString(sData)
        userDataProxy:SetUserLevel(TSCUserLevelUp.level)
        userDataProxy:SendNotificationUpdatePlayerInfo()
    end
end


function PlanetaryMediator:UpdateNodeData(notify)
    local body = notify:GetBody()
    local nodeId = self.planetaryProxy:GetPlanetaryId()
    local nbody ={
        nodeId = nodeId
    }
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETNODEDATA), self.OnGetNodeData, self)
    Facade:SendNotification(NotiConst.Command_RPCPlantarySystem, nbody)
end

--强制更新点内数据
function PlanetaryMediator:OnGetNodeData(stData)
    if stData ~= nil then
        local TSCGetNodeData = node_pb.TSCGetNodeData()
        TSCGetNodeData:MergeFromString(stData)
        
        -- save data to package
        local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
        -- 保存舰队信息
        --fleetProxy:AddPlanetaryFleetData(TSCGetNodeData.fleet)
        -- 保存planet的状态
        --planetaryProxy:SavePlanetStatus(TSCGetNodeData.planet)

        self.planetaryProxy:UpdateBuildingData(TSCGetNodeData.building)
        self:UpdateSpacePort() --更新舰船数据

        --planetaryProxy:SaveElecMsg(TSCGetNodeData.elecMsg)
        
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETNODEDATA), self.OnGetNodeData)
end

function PlanetaryMediator:UpdateSpacePort()
    local buildMap = self.planetaryProxy:GetBuildingData()
    for k, v in pairs(buildMap)do
        local type = self.planetaryProxy:GetBuildingType(v.buildingConfigId)
        if type == common_pb.SPACEPORT then
            self:SetFleetPortShip(v.id,v.fleets)
        end
    end
end

return PlanetaryMediator 