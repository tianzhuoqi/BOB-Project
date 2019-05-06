local ListCell = require("Game/Module/UICommon/ListCell")

local FleetShipEditListCell = register("FleetShipEditListCell", ListCell)

function FleetShipEditListCell:Awake(gameObject)
    FleetShipEditListCell.super.Awake(self, gameObject)

    self.BgInactive = self:FindGameObject("g0/BgInactive")
    self.BgActive = self:FindGameObject("g0/BgActive")
    self.Check = self:FindComponent("g1/Check", "UISprite")
    self.Icon = self:FindComponent("g1/Icon", "UISprite")
    self.Name = self:FindComponent("g2/Name", "UILabel")
    self.Site = self:FindComponent("g2/Site", "UILabel")
    self.Power = self:FindComponent("g2/Power", "UILabel")

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)

    self.noCheckSpriteName = "c1bg11"
    self.checkSpriteName = "c1ic01"

    self.selectIndexKey = "FleetShipEditListCell"
end

function FleetShipEditListCell:OnClick()
    Facade:SendNotification(NotiConst.Notify_FleetShipEditListCellChangeSelect, {index = self.dataIndex, data = self.data})
end

function FleetShipEditListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetProtShipDataByIndex(self.dataIndex)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex[self.dataIndex] then
        self.BgInactive:SetActive(false)
        self.BgActive:SetActive(true)
        self.Check.spriteName = self.checkSpriteName
    else
        self.BgInactive:SetActive(true)
        self.BgActive:SetActive(false)
        self.Check.spriteName = self.noCheckSpriteName
    end

    self.Name.text = self.data.shipId
    self.Power.text = self.data.fightNum
end

return FleetShipEditListCell