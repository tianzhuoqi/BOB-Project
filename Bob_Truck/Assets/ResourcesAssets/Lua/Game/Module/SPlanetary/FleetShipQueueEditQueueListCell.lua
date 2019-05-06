local ListCell = require("Game/Module/UICommon/ListCell")

local FleetShipQueueEditQueueListCell = register("FleetShipQueueEditQueueListCell", ListCell)

function FleetShipQueueEditQueueListCell:Awake(gameObject)
    FleetShipQueueEditQueueListCell.super.Awake(self, gameObject)

    self.G4 = self:FindGameObject("g4")
    self.Icon = self:FindComponent("g4/g1/Icon", "UISprite")
    self.Name = self:FindComponent("g4/g2/Name", "UILabel")
    self.Power = self:FindComponent("g4/g2/Power", "UILabel")
    self.Delete = self:FindGameObject("g4/g3/Delete")

    local NLuaClickEvent = NLuaClickEvent.Get(self.Delete)
    NLuaClickEvent:AddClick(self, FleetShipQueueEditQueueListCell.Delete)

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
end

function FleetShipQueueEditQueueListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetFleetQueueShipDataByIndex(self.dataIndex)

    if self.data == nil then
        self.G4:SetActive(false)
    else
        self.G4:SetActive(true)

        self.Name.text = self.data.shipId
        self.Power.text = self.data.fightNum
    end
    -- self.Power.text = self.data.fightNum
end

function FleetShipQueueEditQueueListCell:Delete()
    Facade:SendNotification(NotiConst.Notify_FleetShipQueueEditDelete, self.data)
end

return FleetShipQueueEditQueueListCell