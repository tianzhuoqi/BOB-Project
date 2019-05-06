local FleetShipEditMediator = class("FleetShipEditMediator", MediatorDynamic)

function FleetShipEditMediator:OnRegister()
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    
    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Cancel.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Create.gameObject)
    NLuaClickEvent:AddClick(self, self.CreateFleet)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Edit.gameObject)
    NLuaClickEvent:AddClick(self, self.EditFleet)

    self:RegisterObserver(NotiConst.Notify_FleetShipEditRefreshView, "RefreshView")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITFLEET), self.OnEditFleet, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CREATEFLEET), self.OnCreateFleet, self)
end

function FleetShipEditMediator:InitData()
    self.totalCount = 0
    self.maxCount = 45

    local currentOperation = self.fleetProxy:GetCurrentOperation()
    if currentOperation.type == 0 then
        self.m_viewComponent.uiBinder.m_Create.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_Edit.gameObject:SetActive(false)
    elseif currentOperation.type == 1 then
        self.m_viewComponent.uiBinder.m_Create.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_Edit.gameObject:SetActive(true)
    end

    self.type = currentOperation.type
end

function FleetShipEditMediator:InitView()
    local currentOperation = self.fleetProxy:GetCurrentOperation()
    if currentOperation.type == 0 then
        self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("Spaceport", "EditFleetTitle1")
        self.m_viewComponent.uiBinder.m_Create.text = GetLanguageText("Spaceport", "EditFleetCreatBtn")
    elseif currentOperation.type == 1 then
        self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("Spaceport", "FleetMemberMergeShipBtn")
        self.m_viewComponent.uiBinder.m_Create.text = GetLanguageText("Spaceport", "EditFleetSaveBtn")
    end
    
end

function FleetShipEditMediator:RefreshView(notification)
    local fleetShipsData = self.fleetProxy:GetFleetShipsData()
    self.totalCount = #fleetShipsData

    Facade:SendNotification("FleetShipEditPanelNotify", 9)
    self.m_viewComponent.uiBinder.m_Des.text = string.format("已选择 %d/%d艘", self.totalCount, self.maxCount)
end

function FleetShipEditMediator:InputName(notification)
    self:RemoveObserver(NotiConst.Notify_FleetPortInputName)
    Facade:BackPanel()
    local fleetName = notification:GetBody()
    if fleetName == '' or fleetName == nil then
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"名称不能为空")
        return
    end

    local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    local curBuilding = planetaryProxy:GetCurBuildingOper()
    local TCSCreateFleet = buildingPort_pb.TCSCreateFleet()
    TCSCreateFleet.buildingId = curBuilding.targetBuilding
    TCSCreateFleet.nodeId = curBuilding.nodeId
    TCSCreateFleet.fleetName = fleetName
    local fleetShipsData = self.fleetProxy:GetFleetShipsData()
    for k, v in pairs(fleetShipsData) do
        if v then
            local UserShipData = buildingPort_pb.UserShipData()
            UserShipData.shipId = v.shipId
            UserShipData.pos = v.pos
            UserShipData.gridPos = v.gridPos

            table.insert(TCSCreateFleet.ships, UserShipData)
        end
    end
    if #TCSCreateFleet.ships == 0 then
        LogDebug("FleetShipEditMediator totalCount is 0")
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"舰船列表为空")
    else
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CREATEFLEET, TCSCreateFleet:SerializeToString())
    end
end

--创建舰队
function FleetShipEditMediator:CreateFleet()
    if self.totalCount == 0 then
        LogDebug("FleetShipEditMediator totalCount is 0")
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"舰船列表为空")
    else
        self:RegisterObserver(NotiConst.Notify_FleetPortInputName, "InputName")
        Facade:ReplacePanel("RenamePanel")
    end
end

function FleetShipEditMediator:OnCreateFleet(btsData)
    LogDebug("FleetShipEditMediator OnCreateFleet")
    if btsData == nil then 
        LogDebug("FleetShipEditMediator:OnCreateFleet btsData==nil")
        return
    end

    local TSCCreateFleet = buildingPort_pb.TSCCreateFleet()
    TSCCreateFleet:MergeFromString(btsData)
    if TSCCreateFleet.result then
        Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
        --Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtShipsData)

        Facade:BackPanel()
    else
        LogError("FleetShipEditMediator:OnCreateFleet Failed")
    end
end

function FleetShipEditMediator:Cancel()
    if self.type == 0 then
        local fleetShipsData = self.fleetProxy:GetFleetShipsData()
        for k, v in pairs(fleetShipsData) do
            if v then
                self.fleetProxy:AddProtShipData(v)
            end
        end
        self.fleetProxy:SetFleetShipsData({})
    else
        Facade:SendNotification(NotiConst.Notify_ProtFleetGetFleetShipsData)
    end
    Facade:BackPanel()
end

--修改阵型
function FleetShipEditMediator:EditFleet()
    local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    local curBuilding = planetaryProxy:GetCurBuildingOper()
    local currentOperation = self.fleetProxy:GetCurrentOperation()
    local TCSEditFleet = buildingPort_pb.TCSEditFleet()
    TCSEditFleet.buildingId = curBuilding.targetBuilding
    TCSEditFleet.fleetId = currentOperation.fleetId
    local fleetShipsData = self.fleetProxy:GetFleetShipsData()
    for k, v in pairs(fleetShipsData) do
        if v then
            local UserShipData = buildingPort_pb.UserShipData()
            UserShipData.shipId = v.shipId
            UserShipData.pos = v.pos
            UserShipData.gridPos = v.gridPos

            table.insert(TCSEditFleet.ships, UserShipData)
        end
    end
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EDITFLEET, TCSEditFleet:SerializeToString())
end

function FleetShipEditMediator:OnEditFleet(btsData)
    LogDebug("FleetShipEditMediator OnEditFleet")
    if btsData == nil then 
        LogDebug("FleetShipEditMediator:OnEditFleet btsData==nil")
        return
    end

    local TSCEditFleet = buildingPort_pb.TSCEditFleet()
    TSCEditFleet:MergeFromString(btsData)
    if TSCEditFleet.result then
        if TSCEditFleet.isDismiss then
            Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
            Facade:BackPanel()
        else
            --Facade:SendNotification(NotiConst.Notify_ProtFleetGetFleetShipsData)
            Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
            Facade:BackPanel()
        end
    else
        LogError("FleetShipEditMediator:OnEditFleet Failed")
    end
end

return FleetShipEditMediator