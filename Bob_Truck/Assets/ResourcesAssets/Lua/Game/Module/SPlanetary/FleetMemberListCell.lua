local ListCell = require("Game/Module/UICommon/ListCell")

local FleetMemberListCell = register("FleetMemberListCell", ListCell)

function FleetMemberListCell:Awake(gameObject)
    FleetMemberListCell.super.Awake(self, gameObject)

    self.BgInactive = self:FindGameObject("g0N/n_BgInactive")
    self.BgActive = self:FindGameObject("g0N/n_BgActive")
    self.Name = self:FindComponent("g2N/n_Name", "UILabel")
    self.Site = self:FindComponent("g2N/n_Site", "UILabel")
    self.Power = self:FindComponent("g2N/n_Function/n_Power", "UILabel")
    self.Delete = self:FindGameObject("g0N/n_BgActive/n_BtnDelet")

    local NLuaClickEvent = NLuaClickEvent.Get(self.Delete)
    NLuaClickEvent:AddClick(self, self.DeleteShip)

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.selectIndexKey = "FleetMemberListCell"
end

function FleetMemberListCell:OnClick()
    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex == self.dataIndex then
        return
    end

    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, self.dataIndex)
    local fleetShipsData = self.fleetProxy:GetFleetShipsData()
    Facade:SendNotification("FleetMemberPanelNotify", #fleetShipsData)
    Facade:SendNotification(NotiConst.Notify_ProtFleetListCellChangeSelect, {key = self.selectIndexKey, index = self.dataIndex, data = self.data})
end

function FleetMemberListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetFleetShipDataByIndex(self.dataIndex)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex == self.dataIndex then
        self.BgInactive:SetActive(false)
        self.BgActive:SetActive(true)
    else
        self.BgInactive:SetActive(true)
        self.BgActive:SetActive(false)
    end

    self.Name.text = self.data.shipId
    self.Power.text = self.data.fightNum
end

function FleetMemberListCell:DeleteShip()
    Facade:SendNotification(NotiConst.Notify_FleetMemberDeleteShip, self.data)
end

return FleetMemberListCell