local ListCell = require("Game/Module/UICommon/ListCell")

local FleetCombineListCell = register("FleetCombineListCell", ListCell)

function FleetCombineListCell:Awake(gameObject)
    FleetCombineListCell.super.Awake(self, gameObject)

    self.BgInactive = self:FindGameObject("g0/BgInactive")
    self.BgActive = self:FindGameObject("g0/BgActive")
    self.BgDisabled = self:FindGameObject("g0/BgDisabled")
    self.Check = self:FindComponent("g1/Check", "UISprite")
    self.Icon = self:FindComponent("g1/Icon", "UISprite")
    self.Name = self:FindComponent("g2/Name", "UILabel")
    self.Site = self:FindComponent("g2/Site", "UILabel")
    self.Function = self:FindComponent("g2/Function", "UILabel")
    self.Power = self:FindComponent("g2/Power", "UILabel")
    self.Count = self:FindComponent("g3/Count", "UILabel")

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)

    self.noCheckSpriteName = "c1bg11"
    self.checkSpriteName = "c1ic01"

    self.selectIndexKey = "FleetCombineListCell"
end

function FleetCombineListCell:OnClick()
    if self.data.shipCount >= self.data.maxShipCount then
        return
    end

    Facade:SendNotification(NotiConst.Notify_FleetCombineListCellChangeSelect, {index = self.dataIndex, data = self.data})
end

function FleetCombineListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetProtFleetDataByIndex(self.dataIndex)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    if selectIndex[self.dataIndex] then
        self.BgInactive:SetActive(false)
        self.BgActive:SetActive(true)
        self.BgDisabled:SetActive(false)
        self.Check.spriteName = self.checkSpriteName
    else
        local currentOperation = self.fleetProxy:GetCurrentOperation()
        if self.data.maxShipCount > currentOperation.maxCount then
            currentOperation.maxCount = self.data.maxShipCount
        end

        if (self.data.shipCount + currentOperation.totalCount) > currentOperation.maxCount then
            self.BgInactive:SetActive(false)
            self.BgActive:SetActive(false)
            self.BgDisabled:SetActive(true)
        else
            self.BgInactive:SetActive(true)
            self.BgActive:SetActive(false)
            self.BgDisabled:SetActive(false)
        end
        self.Check.spriteName = self.noCheckSpriteName
    end

    self.Name.text = self.data.fleetName
    self.Count.text = string.format("%d/%d" , self.data.shipCount, self.data.maxShipCount)
    self.Power.text = self.data.fightNum
end

return FleetCombineListCell