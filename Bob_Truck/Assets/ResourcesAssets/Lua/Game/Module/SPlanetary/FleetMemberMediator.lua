local FleetMemberMediator = class("FleetMemberMediator", MediatorDynamic)

function FleetMemberMediator:OnRegister()
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    
    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Cancel.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)
    
    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Confirm.gameObject)
    NLuaClickEvent:AddClick(self, self.Confirm)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_BtnChangeName.gameObject)
    NLuaClickEvent:AddClick(self, self.ReName)

    self:RegisterObserver(NotiConst.Notify_ProtFleetGetFleetShipsData, "GetFleetShipsData")
    self:RegisterObserver(NotiConst.Notify_FleetMemberListCellChangeSelect, "ListCellChangeSelect")
    self:RegisterObserver(NotiConst.Notify_FleetMemberDeleteShip, "DeleteShip")
    self:RegisterObserver(NotiConst.Notify_FleetPortInputName, "InputName")
    self:RegisterObserver(NotiConst.Notify_UpdateFleetName, 'UpdateFleetName')

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETSHIPBYFLEET), self.OnGetFleetShipsData, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.DELSHIP), self.OnDeleteShip, self)
end

function FleetMemberMediator:InitData()
    self.fleetProxy:SetCurrentSelectIndex("FleetMemberListCell", 1)

    self:GetFleetShipsData()

    self:UpdateFleetName()
end

function FleetMemberMediator:ListCellChangeSelect(notification)
    self:ShowShips()
end

function FleetMemberMediator:Confirm()
    Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtShipsData)

    Facade:ReplacePanel("FleetShipEditPanel")
end

function FleetMemberMediator:ReName()
    self:RegisterObserver(NotiConst.Notify_FormModelInputName, "InputName")
    Facade:ReplacePanel("RenamePanel")
end

function FleetMemberMediator:InputName(notification)
    self:RemoveObserver(NotiConst.Notify_FormModelInputName)

    local fleetName = notification:GetBody()
    local currentOperation = self.fleetProxy:GetCurrentOperation()

    local TCSEditFleetName = buildingPort_pb.TCSEditFleetName()
    TCSEditFleetName.fleetId = currentOperation.fleetId
    TCSEditFleetName.fleetName = fleetName

    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EDITFLEETNAME, TCSEditFleetName:SerializeToString())

    Facade:BackPanel()
end

--获取舰队舰船
function FleetMemberMediator:GetFleetShipsData(notification)
    local currentOperation = self.fleetProxy:GetCurrentOperation()
    local TCSGetShipByFleet = buildingPort_pb.TCSGetShipByFleet()
    TCSGetShipByFleet.fleetId = currentOperation.fleetId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETSHIPBYFLEET, TCSGetShipByFleet:SerializeToString())
end

function FleetMemberMediator:UpdateFleetName()
    local currentOperation = self.fleetProxy:GetCurrentOperation()
    local fleetData = self.fleetProxy:GetProtFleetDataById(currentOperation.fleetId)
    self.m_viewComponent.uiBinder.m_Name.text = fleetData.fleetName
end

function FleetMemberMediator:OnGetFleetShipsData(btsData)
    if btsData == nil then 
        LogDebug("FleetMemberMediator:OnGetFleetShipsData btsData==nil")
        self.fleetProxy:SetFleetShipsData({})
    else
        local TSCGetShipByFleet = buildingPort_pb.TSCGetShipByFleet()
        TSCGetShipByFleet:MergeFromString(btsData)
        self.fleetProxy:SetFleetShipsData(TSCGetShipByFleet.userShipData)
    end

    self:ShowShips()
end

function FleetMemberMediator:ShowShips()
    local fleetShipsData = self.fleetProxy:GetFleetShipsData()
    Facade:SendNotification("FleetMemberPanelNotify", #fleetShipsData)
    self.m_viewComponent.uiBinder.m_Label_Count.text = StringFormat(self.m_viewComponent.uiBinder.m_Label_Count.text, #fleetShipsData, 45)
    local selectIndex = self.fleetProxy:GetCurrentSelectIndex("FleetMemberListCell")
    local data = self.fleetProxy:GetFleetShipDataByIndex(selectIndex)
    if data ~= nil then
        self.hullList = data.userShip.hullParts
        self:InitModelShow()
    end
end

--删除单舰
function FleetMemberMediator:DeleteShip(notification)
    local data = notification:GetBody()
    local curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local currentOperation = self.fleetProxy:GetCurrentOperation()
    local TCSDelShip = buildingPort_pb.TCSDelShip()
    TCSDelShip.buildingId = curBuilding.targetBuilding
    TCSDelShip.fleetId = currentOperation.fleetId
    TCSDelShip.shipId = data.shipId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.DELSHIP, TCSDelShip:SerializeToString())
end

function FleetMemberMediator:OnDeleteShip(btsData)
    if btsData == nil then 
        LogDebug("FleetDisbandMediator:OnDeleteShip btsData==nil")
        return
    end

    local TSCDelShip = buildingPort_pb.TSCDelShip()
    TSCDelShip:MergeFromString(btsData)
    if TSCDelShip.result then
        if TSCDelShip.isDismiss then
            self:Cancel()
        else
            self:GetFleetShipsData()
        end

        self.planetaryProxy:SetIsPortShipNew(true)
        Facade:SendNotification(NotiConst.Notify_UpdatePortShipPoint)
    else
        LogError("FleetDisbandMediator:OnDeleteShip Failed")
    end
end

function FleetMemberMediator:Cancel()
    self:ClearModelShow()
    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)

    Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
    Facade:BackPanel()
end

--初始化model show
function FleetMemberMediator:InitModelShow()
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

function FleetMemberMediator:GetHullModelName(hullId)
    local hullConfigData = self.planetaryProxy:GetShipHullConfigData(hullId)
    return "ModelFBX/ship/transport/"..hullConfigData.data[hullConfigData.EVar["prefab_name_s"]]..".prefab"
end

--修改模板时使用
function FleetMemberMediator:OnHullModelLoaded(obj, data)
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

function FleetMemberMediator:GetGuidByIndex(index)
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

function FleetMemberMediator:UpdateCamPos()
    local center = GameObjectUtil.GetCenter(self.ModelParent)
    GameObjectUtil.SetLocalPosition(self.ModelParent.gameObject, self.ModelParent.localPosition.x, 0, self.ModelParent.localPosition.z)

    local bound = self:CalcGridBound()
    local newY = (bound.dist + 8)*3
    local v = Vector3(0, newY, 0)
    v = Vector3(self.ModelParent.transform.localPosition.x, 0, self.ModelParent.transform.localPosition.z) + v
    GameObjectUtil.SetLocalPosition(self.ModelShowCam.gameObject, v.x, v.y, v.z)
    GameObjectUtil.SetLocalRotation(self.ModelParent.gameObject, -40, -130, -33)
    GameObjectUtil.SetLocalPosition(self.ModelParent.gameObject, self.ModelParent.localPosition.x - 20, self.ModelParent.localPosition.y, self.ModelParent.localPosition.z + 20)
    self.ModelShowCam.targetTexture:Release()
end

--计算边界盒子
function FleetMemberMediator:CalcGridBound()
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

function FleetMemberMediator:IsLoaded(index)
    for i=1,#self.hasLoaded do
        if self.hasLoaded[i] == index then
            return true
        end
    end
    return false
end 

function FleetMemberMediator:ClearModelShow()
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

return FleetMemberMediator