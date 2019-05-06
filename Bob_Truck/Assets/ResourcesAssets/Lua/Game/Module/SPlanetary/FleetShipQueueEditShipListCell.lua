local ListCell = require("Game/Module/UICommon/ListCell")

local FleetShipQueueEditShipListCell = register("FleetShipQueueEditShipListCell", ListCell)

function FleetShipQueueEditShipListCell:Awake(gameObject)
    FleetShipQueueEditShipListCell.super.Awake(self, gameObject)

    self.Icon = self:FindComponent("g1/Icon", "UISprite")
    self.Name = self:FindComponent("g2/Name", "UILabel")
    self.Power = self:FindComponent("g2/Power", "UILabel")
    self.Add = self:FindGameObject("g3/Add")

    local NLuaClickEvent = NLuaClickEvent.Get(self.Add)
    NLuaClickEvent:AddClick(self, FleetShipQueueEditShipListCell.Add)

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
end

function FleetShipQueueEditShipListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetProtShipDataByIndex(self.dataIndex)

    self.Name.text = self.data.shipId
    self.Power.text = self.data.fightNum
end

function FleetShipQueueEditShipListCell:Add()
    Facade:SendNotification(NotiConst.Notify_FleetShipQueueEditAdd, self.data)
end

return FleetShipQueueEditShipListCell