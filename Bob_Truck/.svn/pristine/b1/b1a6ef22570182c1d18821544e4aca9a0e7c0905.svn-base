local ListCell = require("Game/Module/UICommon/ListCell")

local FleetPortPanelShipListCell = register("FleetPortPanelShipListCell", ListCell)

function FleetPortPanelShipListCell:Awake(gameObject)
    FleetPortPanelShipListCell.super.Awake(self, gameObject)

    self.n_BgInactive = self:FindComponent("g0/n_BgInactive", "UISprite")
    self.n_BgActive = self:FindComponent("g0/n_BgActive", "UISprite")
    self.n_Name = self:FindComponent("g1/n_Name", "UILabel")
    self.n_Function = self:FindComponent("g1/n_Function", "UILabel")
    self.n_Power = self:FindComponent("g1/n_Function/n_Power", "UILabel")
    self.n_Delete = self:FindComponent("g2/n_Delete", "UISprite")

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_Delete.gameObject)
    NLuaClickEvent:AddClick(self, self.DeleteShip)

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.selectIndexKey = "FleetPortPanelShipListCell"
end

function FleetPortPanelShipListCell:OnClick()
    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex == self.dataIndex then
        return
    end

    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, self.dataIndex)
    Facade:SendNotification(NotiConst.Notify_ProtFleetListCellChangeSelect, {key = self.selectIndexKey, index = self.dataIndex, data = self.data})
end

function FleetPortPanelShipListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetProtShipDataByIndex(self.dataIndex)
    
    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex == self.dataIndex then
        self.n_BgInactive.gameObject:SetActive(false)
        self.n_BgActive.gameObject:SetActive(true)
    else
        self.n_BgInactive.gameObject:SetActive(true)
        self.n_BgActive.gameObject:SetActive(false)
    end

    self.n_Name.text = self.data.shipId
    self.n_Power.text = self.data.fightNum
end

function FleetPortPanelShipListCell:DeleteShip()
    Facade:SendNotification(NotiConst.Notify_ProtFleetDeleteShip, self.data)
end

return FleetPortPanelShipListCell