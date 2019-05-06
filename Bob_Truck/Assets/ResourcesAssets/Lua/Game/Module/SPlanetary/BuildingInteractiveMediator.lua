local BuildingInteractiveMediator = class("BuildingInteractiveMediator", MediatorDynamic)

local UnityWorld3DPos2WorldUIPos = GameObjectUtil.World3DPos2WorldUIPos

function BuildingInteractiveMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_bkgnd.gameObject)
    --NLuaClickEvent:AddClick(self, self.Close)
    NLuaClickEvent:AddPress(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveAccelerate.gameObject)
    NLuaClickEvent:AddClick(self, self.Accelerate)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveReceive.gameObject)
    NLuaClickEvent:AddClick(self, self.Receive)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveFunction.gameObject)
    NLuaClickEvent:AddClick(self, self.Function)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveCancel.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveDemolition.gameObject)
    NLuaClickEvent:AddClick(self, self.Demolition)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveUp.gameObject)
    NLuaClickEvent:AddClick(self, self.Up)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnInteractiveMove.gameObject)
    NLuaClickEvent:AddClick(self, self.Move)

    local planetMediator = Facade:RetrieveMediator("PlanetaryMediator")
    self.cameraCtrl = planetMediator.cameraCtrl
    self.cameraCtrl:AddCallback(self.Close, self, 4)
    self.cameraCtrl:AddCallback(self.Close, self, 3)
    
    
    

    self:RegisterObserver(NotiConst.Notify_BuildingInteractiveRefreshView, "RefreshView")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CANCELBUILDING), self.OnCancelBuilding, self)
end

function BuildingInteractiveMediator:RefreshView(notification)
    self.buildingId = notification:GetBody()
    self.width = 116
    self.startPos = 0
    self.btnInteractive = {}
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.status = 0 --0:创建,1:正常,2:工作,3:升级

    if self.curBuilding.targetBuilding ~= self.buildingId then
        return
    end

    local buildingData = self.planetaryProxy:GetBuildingDataById(self.curBuilding.targetBuilding)
    self.curBuilding.configId = buildingData.buildingConfigId

    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    if buildingConfigData.data == nil then
        return 
    end
    local name = buildingConfigData.data[buildingConfigData.EVar["bldg_name_s"]]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    local maxLevel = buildingConfigData.data[buildingConfigData.EVar["max_bldg_lvl_n"]]
    local actualName = self.planetaryProxy:GetBuildingActualNameByName(name)
    self.m_viewComponent.uiBinder.m_Building_Name.text = string.format( "%s Lv.%s", actualName, level)
    self.m_viewComponent.uiBinder.m_BuildingName.text = actualName
    self.m_viewComponent.uiBinder.m_BuildingLv.text = level

    local buildingPos = buildingData.building.buildingGo.transform.position
    local pos = UnityWorld3DPos2WorldUIPos(buildingPos.x, 0, buildingPos.z)
    NGameObjectUtil.SetPosition(self.m_viewComponent.uiBinder.m_BuildingInfo, pos.x, pos.y, 0)
    if buildingData.status == common_pb.NORMAL or buildingData.status == common_pb.WORKING then
        if buildingData.status == common_pb.NORMAL then
            self.status = 1
        else
            self.status = 2
        end

        if buildingData.endTime ~= nil and buildingData.endTime > 0 then
            self.status = 3
        end
    elseif buildingData.status == common_pb.CREATE then
        self.status = 0
    end

    local type = self.planetaryProxy:GetBuildingType(self.curBuilding.configId)
    if type ~= common_pb.SPACESTATION then
        table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveMove.gameObject)
        self.m_viewComponent.uiBinder.m_btnInteractiveMove.gameObject:SetActive(true)
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveMove.gameObject:SetActive(false)
    end
    

    if self.status == 0 or self.status == 3 then
        self.m_viewComponent.uiBinder.m_btnInteractiveAccelerate.gameObject:SetActive(true)
        table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveAccelerate.gameObject)
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveAccelerate.gameObject:SetActive(false)
    end

    if self.status == 0 or self.status == 3 then
        self.m_viewComponent.uiBinder.m_btnInteractiveCancel.gameObject:SetActive(true)
        table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveCancel.gameObject)
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveCancel.gameObject:SetActive(false)
    end

    if false then
        self.m_viewComponent.uiBinder.m_btnInteractiveDemolition.gameObject:SetActive(true)
        table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveDemolition.gameObject)
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveDemolition.gameObject:SetActive(false)
    end

    if self.status ~= 0 and self.status ~= 3 then
        if level < maxLevel then
            self.m_viewComponent.uiBinder.m_btnInteractiveUp.gameObject:SetActive(true)
            table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveUp.gameObject)
        else
            self.m_viewComponent.uiBinder.m_btnInteractiveUp.gameObject:SetActive(false)
        end
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveUp.gameObject:SetActive(false)
    end

    if self.status ~= 0 then
        self.m_viewComponent.uiBinder.m_btnInteractiveFunction.gameObject:SetActive(true)
        table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveFunction.gameObject)
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveFunction.gameObject:SetActive(false)
    end

    if false then
        self.m_viewComponent.uiBinder.m_btnInteractiveReceive.gameObject:SetActive(true)
        table.insert(self.btnInteractive, self.m_viewComponent.uiBinder.m_btnInteractiveReceive.gameObject)

        local bg = self.m_viewComponent.uiBinder.m_btnInteractiveReceive.transform:Find('Sprite_ButtenReceive'):GetComponent('UIEventGraySprite')
        local icon = self.m_viewComponent.uiBinder.m_btnInteractiveReceive.transform:Find('Sprite_ButtenReceive/Sprite_IconReceive'):GetComponent('UIEventGraySprite')
        if false then
            bg:SetNormal()
            icon:SetNormal()
        else
            bg:SetGray()
            icon:SetGray()
        end
    else
        self.m_viewComponent.uiBinder.m_btnInteractiveReceive.gameObject:SetActive(false)
    end

    local count = #self.btnInteractive
    self.startPos = -(count-1)*0.5*self.width
    --self.startPos = -246
    for i=1,count do
        local x = self.startPos + (i-1)*self.width
        NGameObjectUtil.SetLocalPosition(self.btnInteractive[i], x, self.btnInteractive[i].transform.localPosition.y, 0)
    end
end

--返回
function BuildingInteractiveMediator:Close()
    if Facade:TopPanelName() == "BuildingInteractivePanel" then
        Facade:BackPanel()
    end
end

--加速
function BuildingInteractiveMediator:Accelerate()
    local TCSSpeedUp = publicPart_pb.TCSSpeedUp()
    TCSSpeedUp.id = self.buildingId
    TCSSpeedUp.type = publicPart_pb.BUILDING_LEVEL_UP
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SPEEDUP, TCSSpeedUp:SerializeToString())
end

--领取
function BuildingInteractiveMediator:Receive()
    -- body
end

--功能
function BuildingInteractiveMediator:Function()
    Facade:BackPanel()

    local type = self.planetaryProxy:GetBuildingType(self.curBuilding.configId)
    if type == common_pb.REFINERY then --提炼厂
        self:OpenRefinery()
    elseif type == common_pb.SPACEPORT then -- 舰船港口
        self:OpenFleetProt()
    elseif type == common_pb.SURFCOL then -- 地表采集
        self:OpenCollect()
    elseif type == common_pb.SPACESTATION then -- 基地
        self:OpenSpaceBase()
    elseif type == common_pb.HULLFACT then -- 功能舰体厂
        self:OpenHullFact()
    elseif type == common_pb.ITEMSTG then --仓库
        self:OpenBuilding()
    elseif type == common_pb.MODFACT then --组装厂
        self:OpenFormMain()
    elseif type == common_pb.POWERPLANT then --核电厂
        self:OpenBuilding() 
    elseif type == common_pb.CPNTFACT then  --配件厂
        self:OpenFitting() 
    end
end

--取消
function BuildingInteractiveMediator:Cancel()
    Facade:ReplacePanel("BuildingCancelPanel")
end

--拆除
function BuildingInteractiveMediator:Demolition()
    Facade:ReplacePanel("BuildingDismantlePanel")
end

--升级
function BuildingInteractiveMediator:Up()
    Facade:ReplacePanel("BuildingUpgradePanel")
end

--建筑移动
function BuildingInteractiveMediator:Move()
    self.curBuilding.building:ShowBuildingObjMod()
    Facade:BackPanel()
end

--打开采集厂
function BuildingInteractiveMediator:OpenCollect()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETCOLLECTIONPLANTINFO), self.GetCollectInfoCallback, self)
    local TCSGetCollectionPlantInfo = buildingCollectionPlant_pb.TCSGetCollectionPlantInfo()
    TCSGetCollectionPlantInfo.buildingId = self.planetaryProxy:GetCurBuildingOper().targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETCOLLECTIONPLANTINFO, TCSGetCollectionPlantInfo:SerializeToString())
end

function BuildingInteractiveMediator:GetCollectInfoCallback(sData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETCOLLECTIONPLANTINFO), self.GetCollectInfoCallback)
    local buildingLeve = self.planetaryProxy:GetBuildingLevel(self.curBuilding.configId) 
    local depth = DATA_BLDG_SURF_COL[buildingLeve][DATA_BLDG_SURF_COL.EVar['mining_depth_n']]
    local canCollectMaxLeve = self.planetaryProxy:GetResMaxLevelByDepth(depth)
    local resourceId = 0
    local oldResourceId = 0
    local planetId = nil
    local collectInfo = nil
    if sData ~= nil then
        local TSCGetCollectionPlantInfo = buildingCollectionPlant_pb.TSCGetCollectionPlantInfo()
        TSCGetCollectionPlantInfo:MergeFromString(sData)
        if TSCGetCollectionPlantInfo.collectInfo.status ~= 0 then
            resourceId = TSCGetCollectionPlantInfo.resourceId
        end
        planetId = TSCGetCollectionPlantInfo.planetId
        collectInfo = TSCGetCollectionPlantInfo.collectInfo
    end
    self.curBuilding.dynamicData = {
        canCollectMaxLeve = canCollectMaxLeve,
        resourceId = resourceId,
        oldResourceId = oldResourceId,
        planetId = planetId,
        collectInfo = collectInfo,
    }
    Facade:ReplacePanel("CollectPanel")
end

--打开舰港舰队
function BuildingInteractiveMediator:OpenFleetProt()
    Facade:ReplacePanel("FleetPortPanel")
end

--打开太空基地
function BuildingInteractiveMediator:OpenSpaceBase()
    local callBack = {
        Self = self,
        Count = 1,
        Complete = 0,
        OnComplete = function(self)
            if self.Complete == self.Count then
                Facade:ReplacePanel("CreateSpaceBasePanel")
            end
        end,
        OnSpaceBaseInfo = function(struct,btsData)
            local self = struct.Self
            if btsData == nil then
                LogDebug("Building:OnSpaceBaseInfo btsData==nil")
                return
            end

            local TSCSpaceBaseInfo = building_pb.TSCSpaceBaseInfo()
            TSCSpaceBaseInfo:MergeFromString(btsData)
            local spaceBaseInfo = TSCSpaceBaseInfo.spaceBaseInfo
            
            self.curBuilding.dynamicData = { 
                owner = spaceBaseInfo.owner,
                isPrimary = spaceBaseInfo.isPrimary,
                buildingLine = spaceBaseInfo.buildingLine
            }

            struct.Complete = struct.Complete + 1
            ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPACEBASEINFO), self)
            struct:OnComplete()
        end
    }

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPACEBASEINFO), callBack.OnSpaceBaseInfo, callBack)
    local TCSSpaceBaseInfo = building_pb.TCSSpaceBaseInfo()
    TCSSpaceBaseInfo.nodeId = self.curBuilding.nodeId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SPACEBASEINFO, TCSSpaceBaseInfo:SerializeToString())
end

--打开提炼厂
function BuildingInteractiveMediator:OpenRefinery()
    local callBack = {
        Self = self,
        Count = 1,
        Complete = 0,
        OnComplete = function(self)
            if self.Complete == self.Count then
                Facade:ReplacePanel("RefineryPanel")
            end
        end,
        --注意匿名要这样用
        OnRefineryInfo = function(struct,btsData)
            local self = struct.Self
            if btsData ~= nil then
                local TSCRefineryInfor = buildingRefinery_pb.TSCRefineryInfor()
                TSCRefineryInfor:MergeFromString(btsData)
                
                --重新结构
                self.curBuilding.dynamicData = {
                    item = TSCRefineryInfor.item,
                    startTime = TSCRefineryInfor.startTime/1000,
                    endTime = TSCRefineryInfor.endTime/1000,
                }
            else
                self.curBuilding.dynamicData = {
                    item = nil,
                    startTime = 0,
                    endTime = 0,
                }
            end
            struct.Complete = struct.Complete + 1
            ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYINFOR), self)
            struct:OnComplete()
        end
    }

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYINFOR), callBack.OnRefineryInfo, callBack)
    local TCSRefineryInfor = buildingRefinery_pb.TCSRefineryInfor()
    TCSRefineryInfor.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.REFINERYINFOR, TCSRefineryInfor:SerializeToString())
end

--打开仓库
function BuildingInteractiveMediator:OpenStorehouse()
    Facade:ReplacePanel("WarehousePanel")
end

-- 打开舰体厂
function BuildingInteractiveMediator:OpenHullFact()

    if self.planetaryProxy == nil then
        self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    end

    local callBack = {
        Self = self,
        Count = 1,
        Complete = 0,
        OnComplete = function(self)
            if self.Complete == self.Count then
                Facade:ReplacePanel("ShipBodyPanel")
            end
        end,
        OnUserMods = function(struct,btsData)
            local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
            local self = struct.Self
            if btsData == nil then
                planetaryProxy:SetUserMods({})
            else
                local TSCUserMods = buildingModFact_pb.TSCUserMods()
                TSCUserMods:MergeFromString(btsData)

                planetaryProxy:SetUserMods(TSCUserMods.mods)
            end

            struct.Complete = struct.Complete + 1
            ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self)
            struct:OnComplete()
        end
    }

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), callBack.OnUserMods, callBack)
    local TCSUserMods = buildingModFact_pb.TCSUserMods()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
end

-- 打开组装厂
function BuildingInteractiveMediator:OpenFormMain()
    if self.planetaryProxy == nil then
        self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    end
    local callBack = {
        Self = self,
        Count = 1,
        Complete = 0,
        OnComplete = function(self)
            if self.Complete == self.Count then
                Facade:ReplacePanel("FormMainPanel")
            end
        end,
        OnUserMods = function(struct,btsData)
            local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
            local self = struct.Self
            if btsData == nil then
                planetaryProxy:SetUserMods({})
            else
                local TSCUserMods = buildingModFact_pb.TSCUserMods()
                TSCUserMods:MergeFromString(btsData)

                planetaryProxy:SetUserMods(TSCUserMods.mods)
            end

            struct.Complete = struct.Complete + 1
            ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self)
            struct:OnComplete()
        end
    }

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), callBack.OnUserMods, callBack)
    local TCSUserMods = buildingModFact_pb.TCSUserMods()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
end

--打开通用建筑界面
function BuildingInteractiveMediator:OpenBuilding()
    Facade:ReplacePanel("BuildingInfoPanel")
end

--打开配件厂
function BuildingInteractiveMediator:OpenFitting()
    if self.planetaryProxy == nil then
        self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    end
    local callBack = {
        Self = self,
        Count = 1,
        Complete = 0,
        OnComplete = function(self)
            if self.Complete == self.Count then
                Facade:ReplacePanel("FittingPanel")
            end
        end,
        OnUserMods = function(struct,btsData)
            local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
            local self = struct.Self
            if btsData == nil then
                planetaryProxy:SetUserMods({})
            else
                local TSCUserMods = buildingModFact_pb.TSCUserMods()
                TSCUserMods:MergeFromString(btsData)

                planetaryProxy:SetUserMods(TSCUserMods.mods)
            end

            struct.Complete = struct.Complete + 1
            ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self)
            struct:OnComplete()
        end
    }

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), callBack.OnUserMods, callBack)
    local TCSUserMods = buildingModFact_pb.TCSUserMods()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
end

return BuildingInteractiveMediator