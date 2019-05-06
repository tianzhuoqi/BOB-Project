local FleetPortMediator = class("FleetPortMediator", MediatorDynamic)

function FleetPortMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)

    self.firstOpen = true
    self.tabItemView = {}

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    self:RegisterObserver(NotiConst.Notify_ProtFleetGetProtFleetsData, "GetProtFleetsData")
    self:RegisterObserver(NotiConst.Notify_ProtFleetGetProtShipsData, "GetProtShipsData")
    self:RegisterObserver(NotiConst.Notify_FleetProtOpenTabItem, "OpenTabItem")
    self:RegisterObserver(NotiConst.Notify_FleetProtInitTabItemView, "InitTabItemView")

    self:RegisterObserver(NotiConst.Notify_ProtFleetListCellChangeSelect, "ListCellChangeSelect")
    self:RegisterObserver(NotiConst.Notify_ProtFleetDeleteShip, "DeleteShip")
    self:RegisterObserver(NotiConst.Notify_UpdatePortShipPoint, "UpdatePortShipPoint")
end

function FleetPortMediator:InitData()
    self.curTabIndex = 0
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.buildingData = self.planetaryProxy:GetBuildingDataById(self.curBuilding.targetBuilding)

    self.fleetProxy:SetCurrentSelectIndex("FleetPortPanelFleetListCell", 1)
    self.fleetProxy:SetCurrentSelectIndex("FleetPortPanelShipListCell", 1)

    if self.firstOpen == false then
        self.m_viewComponent.uiBinder.m_TabView:GetComponent("NTabView"):OpenTabItem(self.curTabIndex)
    end
    self.firstOpen = false

    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local name = buildingConfigData.data[buildingConfigData.EVar["bldg_name_s"]]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    local actualName = self.planetaryProxy:GetBuildingActualNameByName(name)
    --self.m_viewComponent.uiBinder.m_Title.text = string.format("%s_%d", actualName, self.curBuilding.targetBuilding)
    self.m_viewComponent.uiBinder.m_Title.text = string.format("%s", actualName)
    self.m_viewComponent.uiBinder.m_LabelLv.text = string.format("Lv.%s", level)

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPORTFLEET), self.OnGetProtFleetsData, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPORTSHIP), self.OnGetProtShipsData, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPLITSHIP), self.OnDeleteShip, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITFLEETNAME), self.OnRenameCallback, self)
    self:UpdatePortShipPoint()
end

function FleetPortMediator:Close()
    self:ClearModelShow()
    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)

    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPORTFLEET), self.OnGetProtFleetsData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPORTSHIP), self.OnGetProtShipsData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SPLITSHIP), self.OnDeleteShip)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITFLEETNAME), self.OnRenameCallback)
    self:SendNotification(NotiConst.Notify_PlanetaryUpdateNodeData)
    Facade:BackPanel()
end

--切换选项卡
function FleetPortMediator:ListCellChangeSelect(notification)
    LogDebug("FleetPortMediator:ListCellChangeSelect notification:{0}", notification)
    local data = notification:GetBody()

    if data.key == "FleetPortPanelFleetListCell" then
        self:ShowProtFleets()
    elseif data.key == "FleetPortPanelShipListCell" then
        self:ShowProtShips()
    end
end

--加载TabItem上的控件
function FleetPortMediator:InitTabItemView(notification)
    local data = notification:GetBody()
    self.tabItemView[data.key] = data.view
end

--打开TabItem
function FleetPortMediator:OpenTabItem(notification)
    local index = notification:GetBody()
    self.curTabIndex = index

    self:ClearModelShow()

    if index == 0 then
        --self:ShowProtFleets()
        self.fleetProxy:SetCurrentSelectIndex("FleetPortPanelFleetListCell", 1)
        self:GetProtFleetsData()
    elseif index == 1 then
        --self:ShowProtShips()
        self.fleetProxy:SetCurrentSelectIndex("FleetPortPanelShipListCell", 1)
        self:GetProtShipsData()
    elseif index == 2 then
        local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
        local userModsData = planetaryProxy:GetUserMods()
        Facade:SendNotification("FleetPortPanelNotify", #userModsData)
    end    
end

--显示港口舰队
function FleetPortMediator:ShowProtFleets()
    local protFleetsData = self.fleetProxy:GetProtFleetsData()
    Facade:SendNotification("FleetPortPanelFleetNotify", #protFleetsData)

    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)

    local view = self.tabItemView["FleetPortTabItem0"]
    view.n_SubPanel:ScrollResetPosition()
    view.n_AttributeShipNum.text = string.format("舰队数量:%d", #protFleetsData)
    view.n_Detail:SetActive(#protFleetsData>0)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex("FleetPortPanelFleetListCell")
    local data = self.fleetProxy:GetProtFleetDataByIndex(selectIndex)
    if data ~= nil then
        view.n_AttrNum01.text = data.fightNum

        self.hullList = data.maxFightShip.userShip.hullParts
        self:InitModelShow()
    end
end

--显示港口单舰
function FleetPortMediator:ShowProtShips()
    local protShipsData = self.fleetProxy:GetProtShipsData()

    self.planetaryProxy:SetIsPortShipNew(false)
    self:UpdatePortShipPoint()

    Facade:SendNotification("FleetPortPanelShipNotify", #protShipsData)

    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)

    local view = self.tabItemView["FleetPortTabItem1"]
    view.n_SubPanel:ScrollResetPosition()
    view.n_Detail:SetActive(#protShipsData>0)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex("FleetPortPanelShipListCell")
    local data = self.fleetProxy:GetProtShipDataByIndex(selectIndex)
    local index = DATA_BUILDING[self.buildingData.buildingConfigId][DATA_BUILDING.EVar['bldg_func_table_id_n']]
    
    local SizeCount = DATA_BLDG_SPACEPORT[index][DATA_BLDG_SPACEPORT.EVar['ssp_vol_n']]
    local addition_sizeCount = self.planetaryProxy:GetValueAfterAddition(SizeCount,"BLDG_SPACEPORT","ssp_vol")
    SizeCount = math.floor(addition_sizeCount)
    if data ~= nil then
        view.n_AttrNum01.text = data.fightNum

        local count = 0
        for i = 1, #protShipsData do
            for j = 1, #protShipsData[i].userShip.hullParts do
                count = count + DATA_SHIP_HULL_TECH[protShipsData[i].userShip.hullParts[j].hullId][DATA_SHIP_HULL_TECH.EVar['ssp_cost_n']]
            end
        end
        if view ~= nil then
            view.n_Attribute.text = '舰港空间：'..AddUnit(count)..'/'..AddUnit(SizeCount)..' m3'
            view.n_bgFrp.fillAmount = count / SizeCount
        end

        self.hullList = data.userShip.hullParts
        self:InitModelShow()
    else
        if view ~= nil then
            view.n_Attribute.text = '舰港空间：'..AddUnit(0)..'/'..AddUnit(SizeCount)..' m3'
            view.n_bgFrp.fillAmount = 0
        end
    end
end

--获取港口舰队
function FleetPortMediator:GetProtFleetsData(notification)
    local curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local TCSGetPortFleet = buildingPort_pb.TCSGetPortFleet()
    TCSGetPortFleet.nodeId = curBuilding.nodeId
	NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETPORTFLEET, TCSGetPortFleet:SerializeToString())
end

function FleetPortMediator:OnGetProtFleetsData(btsData)
    if btsData == nil then 
        LogDebug("FleetPortMediator:OnGetProtFleetsData btsData==nil")
        self.fleetProxy:SetProtFleetsData({})
    else
        local TSCGetPortFleet = buildingPort_pb.TSCGetPortFleet()
        TSCGetPortFleet:MergeFromString(btsData)
        self.fleetProxy:SetProtFleetsData(TSCGetPortFleet.userFleetData)  
    end

    self:ShowProtFleets()
end

function FleetPortMediator:UpdatePortShipPoint()
    local isShow = self.planetaryProxy:GetIsPortShipNew()
    self.m_viewComponent.uiBinder.m_point02.gameObject:SetActive(isShow)
end

--获取港口单舰
function FleetPortMediator:GetProtShipsData(notification)
    LogDebug("FleetPortMediator:GetProtShipsData")
    local curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local TCSGetPortShip = buildingPort_pb.TCSGetPortShip()
    TCSGetPortShip.buildingId = curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETPORTSHIP, TCSGetPortShip:SerializeToString())
end

function FleetPortMediator:OnGetProtShipsData(btsData)
    if btsData == nil then 
        LogDebug("FleetPortMediator:OnGetProtShipsData btsData==nil")
        self.fleetProxy:SetProtShipsData({})
    else
        local TSCGetPortShip = buildingPort_pb.TSCGetPortShip()
        TSCGetPortShip:MergeFromString(btsData)
        self.fleetProxy:SetProtShipsData(TSCGetPortShip.userShipData)
    end
    self:ShowProtShips()
end

--删除单舰
function FleetPortMediator:DeleteShip(notification)
    local data = notification:GetBody()
    local curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local currentOperation = self.fleetProxy:GetCurrentOperation()
    local TCSSplitShip = buildingPort_pb.TCSSplitShip()
    TCSSplitShip.nodeId = curBuilding.nodeId
    TCSSplitShip.buildingId = curBuilding.targetBuilding
    TCSSplitShip.shipId = data.shipId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SPLITSHIP, TCSSplitShip:SerializeToString())
end

function FleetPortMediator:OnDeleteShip(btsData)
    LogDebug("FleetPortMediator:OnDeleteShip")
    if btsData == nil then 
        LogDebug("FleetPortMediator:OnDeleteShip btsData==nil")
        return
    end

    local TSCSplitShip = buildingPort_pb.TSCSplitShip()
    TSCSplitShip:MergeFromString(btsData)
    if TSCSplitShip.result then
        self:GetProtShipsData()
    else
        LogError("FleetPortMediator:OnDeleteShip Failed")
    end
end

function FleetPortMediator:OnRenameCallback(btsData)
    if btsData ~= nil then
        local TSCEditFleetName = buildingPort_pb.TSCEditFleetName()
        TSCEditFleetName:MergeFromString(btsData)
        local fleetData = self.fleetProxy:GetProtFleetDataById(TSCEditFleetName.fleetId)
        fleetData.fleetName = TSCEditFleetName.fleetName
        Facade:SendNotification(NotiConst.Notify_UpdateFleetName)
    end
end

--初始化model show
function FleetPortMediator:InitModelShow()
    self:ClearModelShow()
    local obj = self.m_viewComponent.uiBinder.m_Model_Pos
	obj:SetActive(true)
    self.ModelParent = self.m_viewComponent.uiBinder.m_Object.transform
    GameObjectUtil.SetLocalRotation(self.ModelParent.gameObject, 0, 0, 0)
    self.ModelShowCam = obj.transform:Find("Camera"):GetComponent("Camera")

    self.gridGroup = {}
    self.hasLoaded = {}

    if #self.hullList > 0 then
        for i,v in ipairs(self.hullList) do
            local grid = {}
            grid.hullId = v.hullId
            grid.left = v.left
            grid.right = v.right
            grid.front = v.front
            grid.back = v.back
            grid.index = v.attachIndex

            table.insert(self.gridGroup, grid)
        end

        local grid = self.gridGroup[1]
        g_InstancesPool:NewInst(self:GetHullModelName(grid.hullId), self.OnHullModelLoaded, self, {grid = grid})
    end
end

function FleetPortMediator:GetHullModelName(hullId)
    local hullConfigData = self.planetaryProxy:GetShipHullConfigData(hullId)
    return "ModelFBX/ship/transport/"..hullConfigData.data[hullConfigData.EVar["prefab_name_s"]]..".prefab"
end

--修改模板时使用
function FleetPortMediator:OnHullModelLoaded(obj, data)
    if obj == nil then 
        return
    end
    obj:SetActive(true)
    obj.layer = 5
    obj.transform.parent = self.ModelParent
    GameObjectUtil.SetScale(obj,8,8,8)
    GameObjectUtil.SetLocalRotation(obj,0,-90,0)

    local grid = data.grid
    grid.modelObj = obj.transform
    local gridFrom = data.from

    GameObjectUtil.SetLocalPosition(obj,0,0,0)
    if gridFrom then
        local pos = nil
        if gridFrom.left == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("left").position - grid.modelObj:Find("right").position
        elseif  gridFrom.right == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("right").position - grid.modelObj:Find("left").position
        elseif  gridFrom.front == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("front").position - grid.modelObj:Find("back").position
        elseif  gridFrom.back == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("back").position - grid.modelObj:Find("front").position
        end
        if pos then
            GameObjectUtil.SetPosition(grid.modelObj.gameObject, pos.x, pos.y, pos.z)
        end
    end

    self.ModelShowCam.targetTexture:Release()

    table.insert(self.hasLoaded, grid.index)
    if #self.hasLoaded == #self.hullList then
        self:UpdateCamPos()
    end

    if grid.left ~= nil and grid.left > 0 and not self:IsLoaded(grid.left) then
        local tempGrid = self:GetGuidByIndex(grid.left)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.right ~= nil and grid.right > 0 and not self:IsLoaded(grid.right) then
        local tempGrid = self:GetGuidByIndex(grid.right)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.front ~= nil and grid.front > 0 and not self:IsLoaded(grid.front) then
        local tempGrid = self:GetGuidByIndex(grid.front)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.back ~= nil and grid.back > 0 and not self:IsLoaded(grid.back) then
        local tempGrid = self:GetGuidByIndex(grid.back)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end
end

function FleetPortMediator:GetGuidByIndex(index)
    if index == nil or index == 0 then
        return nil
    end

    for i=1,#self.gridGroup do
        if self.gridGroup[i].index == index then
            return self.gridGroup[i]
        end
    end
    return nil
end

function FleetPortMediator:UpdateCamPos()
    local center = GameObjectUtil.GetCenter(self.ModelParent)
    GameObjectUtil.SetLocalPosition(self.ModelParent.gameObject, self.ModelParent.localPosition.x, 0, self.ModelParent.localPosition.z)

    local bound = self:CalcGridBound()
    local newY = (bound.dist + 8)*3
    local v = Vector3(0, newY, 0)
    -- local x = Quaternion.AngleAxis(30, Vector3(1, 0, 0))
    -- a = x*a
    -- x = Quaternion.AngleAxis(-60, Vector3(0, 1, 0))
    -- a = x*a
    v = Vector3(self.ModelParent.transform.localPosition.x, 0, self.ModelParent.transform.localPosition.z) + v
    GameObjectUtil.SetLocalPosition(self.ModelShowCam.gameObject, v.x, v.y, v.z)
    GameObjectUtil.SetLocalRotation(self.ModelParent.gameObject, -40, -130, -33)
    GameObjectUtil.SetLocalPosition(self.ModelParent.gameObject, self.ModelParent.localPosition.x - 20, self.ModelParent.localPosition.y, self.ModelParent.localPosition.z + 20)
    self.ModelShowCam.targetTexture:Release()
end

--计算边界盒子
function FleetPortMediator:CalcGridBound()
    local maxPoint = 0
    local minPoint = 0

    for i=1,#self.gridGroup do
        local grid = self.gridGroup[i]
        local front = grid.modelObj:Find("front")
        local back = grid.modelObj:Find("back")

        if i == 1 then
            if front then
                minPoint = front.position.x
            else
                minPoint = back.position.x
            end
            if back then
                maxPoint = back.position.x
            else
                maxPoint = front.position.x
            end
        else
            if front and front.position.x < minPoint then
                minPoint = front.position.x
            end
            if back and back.position.x > maxPoint then
                maxPoint = back.position.x
            end
        end
    end

    local dist = (maxPoint - minPoint)*math.pow(10,2)

    return {dist = dist}
end

function FleetPortMediator:IsLoaded(index)
    for i=1,#self.hasLoaded do
        if self.hasLoaded[i] == index then
            return true
        end
    end
    return false
end 

function FleetPortMediator:ClearModelShow()
    if self.gridGroup == nil then
        return
    end

    local n = #self.gridGroup
    for i=1, n do 
        g_InstancesPool:DeleteInst(self.gridGroup[i].modelObj.gameObject)
    end
    self.gridGroup = {}
    self.hasLoaded = {}
    self:UpdateCamPos()
    self.ModelShowCam.targetTexture:Release()
end

return FleetPortMediator