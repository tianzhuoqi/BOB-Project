local ListItem = require("Game/Module/UICommon/ListItem")

local FleetGoodsListItem = register("FleetGoodsListItem", ListItem)

function FleetGoodsListItem:Awake(gameObject)
    FleetGoodsListItem.super.Awake(self, gameObject)

    self.dragDropItem = gameObject.transform:GetComponent('UIDragDropItem')
    self.n_Icon = self:FindComponent("n_Icon", "UITexture")
    self.n_Fram = self:FindComponent("n_Fram", "UISprite")
    self.n_Name = self:FindComponent("n_Name", "UILabel")
    self.n_Count = self:FindComponent("n_Count", "UILabel")

    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    self.isDrag = false
end

function FleetGoodsListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_FleetGoodsInstallGoods, self.data)
end

function FleetGoodsListItem:OnDrag(delta)
    self.isDrag = true
end

function FleetGoodsListItem:OnLongPress()
    if self.isDrag == false then
        Facade:SendNotification(NotiConst.Notify_FleetGoodsSetGoodsNum, { type = 1, data = self.data })
    end
    self.isDrag = false
end

function FleetGoodsListItem:OnDropUp(index, notificationKey)
    if self.dragDropItem.m_notificationKey ~= notificationKey then
        Facade:SendNotification(NotiConst.Notify_FleetGoodsDropUp, { index = index, notificationKey = notificationKey })
    end
end

function FleetGoodsListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.data = self.fleetProxy:GetPackageDataByIndex(self.dataIndex)
    self.configData = self.storehouseProxy:GetItemConfigData(self.data.id)

    self.dragDropItem.m_index = self.dataIndex

    local name_s = self.configData.relation["name_s"]
    local key = self.configData.data[self.configData.EVar[name_s]]
    self.n_Name.text = GetLanguageText(self.configData.data[self.configData.EVar["transl_table_name_s"]], key)
    self.n_Icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.configData.data[self.configData.EVar["icon_name_s"]])
    self.n_Count.text = NumberToString(self.data.num)
    if self.data.change then
        self.n_Count.color = Color.New(1,0,0,1)
    else
        self.n_Count.color = Color.New(1,1,1,1)
    end
end

return FleetGoodsListItem