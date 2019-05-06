local ListCell = require("Game/Module/UICommon/ListCell")

local FleetPortPanelFleetListCell = register("FleetPortPanelFleetListCell", ListCell)

function FleetPortPanelFleetListCell:Awake(gameObject)
    FleetPortPanelFleetListCell.super.Awake(self, gameObject)

    self.n_BgInactive = self:FindComponent("g0/n_BgInactive", "UISprite")
    self.n_BgActive = self:FindComponent("g0/n_BgActive", "UISprite")
    self.n_Icon = self:FindComponent("g1/n_Icon", "UISprite")
    self.n_Name = self:FindComponent("g2/n_Name", "UILabel")
    self.n_Power = self:FindComponent("g2/Function/n_Power", "UILabel")
    self.n_Des = self:FindComponent("g3/n_Des", "UILabel")
    self.n_Count = self:FindComponent("g3/n_Count", "UILabel")
    self.n_Go = self:FindComponent("g4/n_Go", "UIButton")
    self.n_SpriteInactiveFule = self:FindComponent("g4/n_SpriteInactiveFule", "UISprite")
    self.n_SpriteInactiveCargo = self:FindComponent("g4/n_SpriteInactiveCargo", "UISprite")

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_Go.gameObject)
    NLuaClickEvent:AddClick(self, FleetPortPanelFleetListCell.GoClick)

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.selectIndexKey = "FleetPortPanelFleetListCell"
end

function FleetPortPanelFleetListCell:OnClick()
    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex == self.dataIndex then
        return
    end

    self.fleetProxy:SetCurrentSelectIndex(self.selectIndexKey, self.dataIndex)
    Facade:SendNotification(NotiConst.Notify_ProtFleetListCellChangeSelect, {key = self.selectIndexKey, index = self.dataIndex, data = self.data})
end

function FleetPortPanelFleetListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetProtFleetDataByIndex(self.dataIndex)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex == self.dataIndex then
        self.n_BgInactive.gameObject:SetActive(false)
        self.n_BgActive.gameObject:SetActive(true)
        self.n_Go.gameObject:SetActive(true)
        self.n_SpriteInactiveFule.gameObject:SetActive(false)
        self.n_SpriteInactiveCargo.gameObject:SetActive(false)
    else
        self.n_BgInactive.gameObject:SetActive(true)
        self.n_BgActive.gameObject:SetActive(false)
        self.n_Go.gameObject:SetActive(false)
        self.n_SpriteInactiveFule.gameObject:SetActive(true)
        self.n_SpriteInactiveCargo.gameObject:SetActive(true)
    end

    self.n_Name.text = self.data.fleetName
    self.n_Count.text = string.format("%d/%d" , self.data.shipCount, self.data.maxShipCount)
    self.n_Power.text = self.data.fightNum
end

function FleetPortPanelFleetListCell:GoClick()
    local fleetId = self.data.fleetId
    self.fleetProxy:SetCurrentOperation({type = 1, fleetId = fleetId})

    Facade:ReplacePanel("FleetMemberPanel")
end

return FleetPortPanelFleetListCell