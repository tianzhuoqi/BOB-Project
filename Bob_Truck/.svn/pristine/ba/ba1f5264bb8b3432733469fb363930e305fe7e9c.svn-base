local ListItem = require("Game/Module/UICommon/ListItem")

local WarehouseListItem = register("WarehouseListItem", ListItem)

function WarehouseListItem:Awake(gameObject)
    WarehouseListItem.super.Awake(self, gameObject)

    self.cellGo = gameObject.transform.parent.gameObject
    self.infoArrow = self.cellGo.transform:Find("SubView/n_Arrow").gameObject
    self.infoItemName = self.cellGo.transform:Find("SubView/n_LabelItemName"):GetComponent("UILabel")
    self.infoItemCube = self.cellGo.transform:Find("SubView/n_LabelItemName/n_LabelItemCube"):GetComponent("UILabel")
    self.infoItemDetail = self.cellGo.transform:Find("SubView/n_LabelItemDetail"):GetComponent("UILabel")
    self.infoButtonUse = self.cellGo.transform:Find("SubView/n_Button_Use"):GetComponent("UIButton")
    self.infoButtonSell = self.cellGo.transform:Find("SubView/n_Button_Sell"):GetComponent("UIButton")
    
    self.n_Sprite_Icon = self:FindComponent("n_Sprite_Icon", "UITexture")
    self.n_Sprite_Frame = self:FindComponent("n_Sprite_Frame", "UISprite")
    self.n_Sprite_Frame2 = self:FindGameObject("n_Label_Frame2")
    self.n_Label_Number = self:FindComponent("n_Label_Number", "UILabel")

    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.panelMediator = Facade:RetrieveMediator("WarehouseMediator")
end

function WarehouseListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_WarehouseListItemChangeSelect, {
        gameObject = self.cellGo,
        cellIndex = self.cellIndex,
        index = self.dataIndex,
    })
    
    if self.panelMediator.lastSelectItem and self.panelMediator.lastSelectItem.OnUnSelect then
        self.panelMediator.lastSelectItem:OnUnSelect()
    end
    self.panelMediator.lastSelectItem = self
    self.n_Sprite_Frame2:SetActive(true)

    self:UpdateSubView()
end

function WarehouseListItem:UpdateSubView()
    GameObjectUtil.SetLocalPosition(self.infoArrow, -230+self.index*154, -16, 0)
    local name_s = self.configData.relation["name_s"]
    local key = self.configData.data[self.configData.EVar[name_s]]
    self.itemName = GetLanguageText(self.configData.data[self.configData.EVar["transl_table_name_s"]], key)
    self.infoItemName.text = self.itemName
    self.infoItemCube.text = StringFormat(GetLanguageText("WarehouseReal", "WCRsSubCapInfo"), self.configData.data[self.configData.EVar["stor_unit_n"]])
    self.infoItemDetail.text = GetLanguageText(self.configData.data[self.configData.EVar["transl_table_name_s"]], self.configData.data[self.configData.EVar["desc_s"]])
   
    self.infoButtonUse.gameObject:SetActive(false)

    NLuaClickEvent.Get(self.infoButtonUse.gameObject):AddClick(self, self.OnClickUse)
    NLuaClickEvent.Get(self.infoButtonSell.gameObject):AddClick(self, self.OnClickSell)
end

function WarehouseListItem:OnClickUse()
    Facade:SendNotification(NotiConst.Notify_WarehouseListItemUse, {
        index = self.dataIndex,
        itemName = self.itemName
    })
end

function WarehouseListItem:OnClickSell()
    Facade:SendNotification(NotiConst.Notify_WarehouseListItemSell, {
        index = self.dataIndex,
        itemName = self.itemName
    })
end

function WarehouseListItem:DrawCell(index, cellIndex, itemsCount)
    self.index = index
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.data = self.storehouseProxy:GetPackageDataByIndex(self.dataIndex)
    self.configData = self.storehouseProxy:GetItemConfigData(self.data.id)

    self.n_Label_Number.text = NumberToString(self.data.num)
    self.n_Sprite_Icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.configData.data[self.configData.EVar["icon_name_s"]])
end

function WarehouseListItem:OnUnSelect()
    self.n_Sprite_Frame2:SetActive(false)
end

return WarehouseListItem