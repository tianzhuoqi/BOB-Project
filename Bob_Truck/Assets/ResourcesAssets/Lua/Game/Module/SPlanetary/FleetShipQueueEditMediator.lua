local FleetShipQueueEditMediator = class("FleetShipQueueEditMediator", MediatorDynamic)

function FleetShipQueueEditMediator:OnRegister()
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, FleetShipQueueEditMediator.Cancel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Cancel.gameObject)
    NLuaClickEvent:AddClick(self, FleetShipQueueEditMediator.Cancel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Save.gameObject)
    NLuaClickEvent:AddClick(self, FleetShipQueueEditMediator.Save)
    
    self:RegisterObserver(NotiConst.Notify_FleetShipQueueEditAdd, "Add")
    self:RegisterObserver(NotiConst.Notify_FleetShipQueueEditDelete, "Delete")

    self.selectIndexKey = "FleetShipEditListItem"
end

function FleetShipQueueEditMediator:InitData()
    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex.cellIndex == 1 then
        self.m_viewComponent.uiBinder.m_Title.text = "前"..selectIndex.index.." 编制"
    elseif selectIndex.cellIndex == 2 then
        self.m_viewComponent.uiBinder.m_Title.text = "中"..selectIndex.index.." 编制"
    elseif selectIndex.cellIndex == 3 then
        self.m_viewComponent.uiBinder.m_Title.text = "后"..selectIndex.index.." 编制"
    end

    self.pos = selectIndex.dataIndex
    self.oldQueueShipsData = {}
    local queueShipsData = self.fleetProxy:GetFleetQueueShipsData(self.pos)
    for i=1,#queueShipsData do
        local shipData = {}
        local temp = queueShipsData[i]
        shipData.shipId = temp.shipId
        shipData.shipType = temp.shipType
        shipData.fightNum = temp.fightNum
        shipData.pos = temp.pos
        shipData.gridPos = temp.gridPos
    
        LogDebug("FleetShipQueueEditMediator:oldQueueShipsData {0}", shipData.shipId)
        table.insert(self.oldQueueShipsData, shipData)
    end

    local currentOperation = self.fleetProxy:GetCurrentOperation()
    self.type = currentOperation.type
end

function FleetShipQueueEditMediator:RefreshView()
    local protShipsData = self.fleetProxy:GetProtShipsData()
    Facade:SendNotification("FleetShipQueueEditPanelShipNotify", #protShipsData)
    local queueShipsData = self.fleetProxy:GetFleetQueueShipsData(self.pos)
    self.fleetProxy:SetFleetQueueShipsData(queueShipsData)
    Facade:SendNotification("FleetShipQueueEditPanelQueueNotify", 5)
end

function FleetShipQueueEditMediator:Add(notification)
    local queueShipsData = self.fleetProxy:GetFleetQueueShipsData(self.pos)
    if #queueShipsData >= 5 then
        LogDebug("每个编队舰船个数上限为5")
        return
    end

    local shipData = notification:GetBody()
    shipData.pos = self.pos
    shipData.gridPos = #self.fleetProxy:GetFleetQueueShipsData(self.pos) + 1
    self.fleetProxy:AddFleetQueueShipData(shipData)

    self:RefreshView()
end

function FleetShipQueueEditMediator:Delete(notification)
    local shipData = notification:GetBody()
    self.fleetProxy:RemoveFleetQueueShipData(shipData)

    self:RefreshView()
end

function FleetShipQueueEditMediator:Cancel()
    local queueShipsData = self.fleetProxy:GetFleetQueueShipsData(self.pos)
    local delQueueShipsData = {}
    for i=1,#queueShipsData do
        table.insert( delQueueShipsData, queueShipsData[i])
    end

    for k,v in pairs(delQueueShipsData) do
        self.fleetProxy:RemoveFleetQueueShipData(v)
    end

    for k,v in pairs(self.oldQueueShipsData) do
        self.fleetProxy:AddFleetQueueShipData(v)
    end

    Facade:SendNotification(NotiConst.Notify_FleetShipEditRefreshView)
    Facade:BackPanel()
end

function FleetShipQueueEditMediator:Save()
    Facade:SendNotification(NotiConst.Notify_FleetShipEditRefreshView)
    Facade:BackPanel()
end

return FleetShipQueueEditMediator