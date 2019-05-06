local ListItem = require("Game/Module/UICommon/ListItem")

local FormModelCpntListItem = register("FormModelCpntListItem", ListItem)

function FormModelCpntListItem:Awake(gameObject)
    FormModelCpntListItem.super.Awake(self, gameObject)

    self.n_Sprite_PartsIcon = self:FindComponent("n_Sprite_PartsIcon", "UITexture")
    self.n_Sprite_PartsFrame = self:FindComponent("n_Sprite_PartsIcon/n_Sprite_PartsFrame", "UISprite")

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
end

function FormModelCpntListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_FormModelAddCpnt, self.dataIndex)
end

function FormModelCpntListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.cnptData = self.planetaryProxy:GetShipCpntConfigDataByIndex(self.dataIndex)

    self.n_Sprite_PartsIcon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.cnptData.data[self.cnptData.EVar["icon_name_s"]])
end

return FormModelCpntListItem