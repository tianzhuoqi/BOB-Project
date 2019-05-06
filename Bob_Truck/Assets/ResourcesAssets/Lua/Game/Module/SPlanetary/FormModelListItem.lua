local ListItem = require("Game/Module/UICommon/ListItem")

local FormModelListItem = register("FormModelListItem", ListItem)

function FormModelListItem:Awake(gameObject)
    FormModelListItem.super.Awake(self, gameObject)

    self.n_Sprite_Icon = self:FindComponent("n_Sprite_Icon", "UITexture")
    self.n_Sprite_Frame = self:FindComponent("n_Sprite_Frame", "UISprite")
    self.n_Sprite_Yes = self:FindComponent("n_Sprite_Yes", "UISprite")
    self.n_Sprite_Sign = self:FindComponent("n_Sprite_Sign", "UISprite")
    self.n_Label_Name = self:FindComponent("n_Label_Name", "UILabel")

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
end

function FormModelListItem:OnClick()
    
end

function FormModelListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.shipHullData = self.planetaryProxy:GetPackageShipHullDataByIndex(self.dataIndex)

    local count = self.planetaryProxy:GetModsUsedCount(self.shipHullData.data.id)
    self.n_Sprite_Yes.gameObject:SetActive(count>0)
    self.n_Label_Name.text = GetLanguageText("ItemName",self.shipHullData.data[self.shipHullData.EVar["hull_name_s"]])
    self.n_Sprite_Icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.shipHullData.data[self.shipHullData.EVar["icon_name_s"]])
end

function FormModelListItem:OnPress(press)
    if press == false then 
        --判断拖曳结束
        if self.bPress and self.bDrag then 
            self:OnDragEnd()
        end
    end
    self.bPress = press
end

function FormModelListItem:OnDrag(delta)
    if self.bPress and not self.bDrag then 
        self:OnDragStart()
    end
    Facade:SendNotification(NotiConst.Notify_FormModelOnDrag, delta)
end

function FormModelListItem:OnDragStart()
    self.bDrag = true
    Facade:SendNotification(NotiConst.Notify_FormModelOnDragStart, self.shipHullData.data.id)
end

function FormModelListItem:OnDragEnd()
    self.bDrag = false
    Facade:SendNotification(NotiConst.Notify_FormModelOnDragEnd, self.shipHullData.data.id)
end

return FormModelListItem