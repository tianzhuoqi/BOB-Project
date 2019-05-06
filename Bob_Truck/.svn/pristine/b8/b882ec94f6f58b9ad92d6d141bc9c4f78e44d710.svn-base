local ListItem = require("Game/Module/UICommon/ListItem")

local FleetShipEditListItem = register("FleetShipEditListItem", ListItem)

function FleetShipEditListItem:Awake(gameObject)
    FleetShipEditListItem.super.Awake(self, gameObject)

    self.dragDropItem = gameObject.transform:GetComponent('UIDragDropItem')
    self.Title = self:FindComponent("Title", "UILabel")
    self.Des_C1 = self:FindComponent("c1/Des", "UILabel")
    self.Des_C2 = self:FindComponent("c2/Des", "UILabel")
    self.Des_C3 = self:FindComponent("c3/Des", "UILabel")
    self.Des_C4 = self:FindComponent("c4/Des", "UILabel")
    self.Des_C5 = self:FindComponent("c5/Des", "UILabel")

    self.View = {}
    table.insert(self.View, { Des = self.Des_C1 })
    table.insert(self.View, { Des = self.Des_C2 })
    table.insert(self.View, { Des = self.Des_C3 })
    table.insert(self.View, { Des = self.Des_C4 })
    table.insert(self.View, { Des = self.Des_C5 })

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)

    self.selectIndexKey = "FleetShipEditListItem"
end

function FleetShipEditListItem:OnClick()
    LogDebug('ListItem OnClick dataIndex:{0}', self.dataIndex)
    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, { index = self.index, cellIndex = self.cellIndex, dataIndex = self.dataIndex})
    Facade:ReplacePanel("FleetShipQueueEditPanel")
end

function FleetShipEditListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.cellIndex = cellIndex + 1
    self.index = index + 1
    self.data = self.fleetProxy:GetFleetQueueShipsData(self.dataIndex)

    self.dragDropItem.m_index = self.dataIndex

    local idx = (self.cellIndex - 1) * 3 + self.index
    self.Title.text = GetLanguageText("Spaceport", "EditGridView" .. tostring(idx))
    -- if self.cellIndex == 1 then
    --     self.Title.text = GetLanguageText("Spaceport", "EditGridView" .. self.cellIndex)
    --     self.Title.text = "前\n"..self.index,
    -- elseif self.cellIndex == 2 then
    --     self.Title.text = "中\n"..self.index
    -- elseif self.cellIndex == 3 then
    --     self.Title.text = "后\n"..self.index
    -- end

    local len = #self.data
    if len == 0 then
        self.dragDropItem.enabled = false
    else
        self.dragDropItem.enabled = true
    end

    for i=1,len do
        local shipData = self.data[i]
        self.View[i].Des.text = shipData.shipId.." "..shipData.fightNum
    end

    len = len + 1
    for i=len,5 do
        self.View[i].Des.text = ""
    end
end

function FleetShipEditListItem:OnDropUp(index, notificationKey)
    self.fleetProxy:ExchangeFleetQueueShipsPos(index, self.dataIndex)
    Facade:SendNotification(NotiConst.Notify_FleetShipEditRefreshView)
end

return FleetShipEditListItem