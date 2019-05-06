local ListCell = require("Game/Module/UICommon/ListCell")

local FleetDisbandListCell = register("FleetDisbandListCell", ListCell)

function FleetDisbandListCell:Awake(gameObject)
    FleetDisbandListCell.super.Awake(self, gameObject)

    self.n_Label_Name = self:FindComponent("GameObject_RefitXX/n_Label_Name", "UILabel")
    self.n_Count = self:FindComponent("GameObject_RefitXX/n_Count", "UILabel")
    self.n_Label_Fight = self:FindComponent("GameObject_RefitXX/n_Label_Fight", "UILabel")
    self.n_Sprite_Yes = self:FindComponent("GameObject_RefitXX/Sprite_YesBG/n_Sprite_Yes", "UISprite")
    self.n_BgActive = self:FindComponent("GameObject_RefitXX/n_BgActive", "UISprite")

    self.selectIndexKey = "FleetDisbandListCell"
end

function FleetDisbandListCell:OnClick()
    Facade:SendNotification(NotiConst.Notify_FleetDisbandListCellChangeSelect, {index = self.dataIndex, data = self.data})
end

function FleetDisbandListCell:DrawCell(index)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.dataIndex = index + 1
    self.data = self.fleetProxy:GetProtFleetDataByIndex(self.dataIndex)

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex(self.selectIndexKey)
    self.n_BgActive.gameObject:SetActive(selectIndex[self.dataIndex])
    self.n_Sprite_Yes.gameObject:SetActive(selectIndex[self.dataIndex])
   
    self.n_Label_Name.text = self.data.fleetName
    self.n_Count.text = string.format("%d/%d" , self.data.shipCount, self.data.maxShipCount)
    self.n_Label_Fight.text = NumberToString(self.data.fightNum)
end

return FleetDisbandListCell