local ListItem = require("Game/Module/UICommon/ListItem")

local ShipBodyHullListItem = register("ShipBodyHullListItem", ListItem)

function ShipBodyHullListItem:Awake(gameObject)
    ShipBodyHullListItem.super.Awake(self, gameObject)

    self.cellGo = gameObject.transform.parent.gameObject
    self.infoLabel = self.cellGo.transform:Find("SubView/n_LabelItemName"):GetComponent("UILabel")
    self.infoCreateProduct = self.cellGo.transform:Find("SubView/n_ButtonMake"):GetComponent("UIButton")
    self.infoArrow = self.cellGo.transform:Find("SubView/n_Arrow").gameObject

    self.n_Sprite_ListIcon = self:FindComponent("n_Sprite_ListIcon", "UITexture")
    self.n_Sprite_ListFrame = self:FindComponent("n_Sprite_ListFrame", "UISprite")
    self.n_Label_Num = self:FindComponent("n_Label_Num", "UILabel")
    self.LabelConsumeEt = self.cellGo.transform:Find("SubView/LabelConsumeEt/LabelEtVl"):GetComponent("UILabel")
    self.consumeView = {}
    for i=1,4 do
        table.insert(self.consumeView, self.cellGo.transform:Find("SubView/n_LabelCosItem"..i):GetComponent("UILabel"))
    end

    self.dragDropItem = gameObject.transform:GetComponent('UIDragDropItem')

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
end

function ShipBodyHullListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_ShipBodyEditHullProductClick, {
        gameObject = self.cellGo,
        cellIndex = self.cellIndex,
        index = self.dataIndex,
    })

    self:UpdateSubView()
end

function ShipBodyHullListItem:UpdateSubView()
    GameObjectUtil.SetLocalPosition(self.infoArrow, -234+self.index*156, 0, 0)
    self.infoLabel.text = GetLanguageText(self.shipHullData.data[self.shipHullData.EVar["transl_table_name_s"]], self.shipHullData.data[self.shipHullData.EVar["hull_name_s"]])
    local needElec = self.shipHullData.data[self.shipHullData.EVar["ele_cost_n"]]
    self.LabelConsumeEt.text = GetLanguageText("BuildingAttribute","ATRBCapN",needElec)
    if self.planetaryProxy:GetElecMsg().restOfElect < needElec then
        self.LabelConsumeEt.color = Color.New(1,0,0)
    else
        self.LabelConsumeEt.color = Color.New(1,1,1)
    end
    local count = 0
    for i,v in pairs(self.material) do
        count = count + 1
        local itemConfigData = self.storehouseProxy:GetItemConfigData(i)
        local name_s = itemConfigData.relation["name_s"]
        local key = itemConfigData.data[itemConfigData.EVar[name_s]]
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        local num = itemData == nil and 0 or itemData.num
        if num >= v then
            self.consumeView[count].text = string.format("%sx%d", GetLanguageText(itemConfigData.data[itemConfigData.EVar["transl_table_name_s"]], key), v)
        else
            self.consumeView[count].text = string.format("[ff4f3e]%sx%d[-]", GetLanguageText(itemConfigData.data[itemConfigData.EVar["transl_table_name_s"]], key), v)
        end
    end

    for i=(count+1),4 do
        self.consumeView[i].text = ""
    end

    NLuaClickEvent.Get(self.infoCreateProduct.gameObject):AddClick(self, self.OnClickCreate)
    GameObjectUtil.SetButtonState(self.infoCreateProduct, self.count > 0 and 0 or 3)
end

function ShipBodyHullListItem:OnClickCreate()
    if not self:IsEnoughElec() then
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"没有足够的电力")
        return
    end
    if self.count > 0 then
        Facade:SendNotification(NotiConst.Notify_ShipBodyEditHullProductLine, {
            gameObject = self.cellGo,
            index = self.dataIndex,
            type = 0,
        })
    end
end

function ShipBodyHullListItem:IsEnoughElec()
    local needElec = self.shipHullData.data[self.shipHullData.EVar["ele_cost_n"]]
    local info = self.planetaryProxy:GetElecMsg()
    if info.restOfElect >= needElec then
        return true
    else
        return false
    end
end

function ShipBodyHullListItem:DrawCell(index, cellIndex, itemsCount)
    self.index = index
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.shipHullData = self.planetaryProxy:GetPackageShipHullDataByIndex(self.dataIndex)

    self.dragDropItem.m_index = self.dataIndex

    self.n_Sprite_ListIcon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.shipHullData.data[self.shipHullData.EVar["icon_name_s"]])

    self.material = {}

    local costTable = self.shipHullData.data[self.shipHullData.EVar["cost_table_repeated5"]]
    for i,v in ipairs(costTable) do
        if v[1] ~= nil and v[1] > 0 then
            local itemConfigData = self.storehouseProxy:GetItemConfigData(v[1])
            if itemConfigData ~= nil then
                self.material[v[1]] = v[2]
            end
        end
    end

    self.nodeId = self.planetaryProxy:GetPlanetaryId()
    self.count = self:CalcCount()

    local modId = UnityEngine.PlayerPrefs.GetInt(self.planetaryProxy:GetFilterKey())
    self.modData = self.planetaryProxy:GetUserModById(modId)
    if self.modData ~= nil then
        self.n_Label_Num.gameObject:SetActive(true)

        self.materialHull = {}

        for i=1,#self.modData.hullParts do
            local hull = self.modData.hullParts[i]
            if self.materialHull[hull.hullId] == nil then
                self.materialHull[hull.hullId] = 0
            end
            self.materialHull[hull.hullId] = self.materialHull[hull.hullId] + 1
        end

        local itemData = self.storehouseProxy:GetItem(self.nodeId, self.shipHullData.data.id)
        local num = itemData == nil and 0 or itemData.num
        if num == true then
            num = 0
        end
        local needNum = self.materialHull[self.shipHullData.data.id]
        if needNum == nil then
            LogError("消耗中没有该部件 {0}", self.shipHullData.data.id)
        else
            local str = needNum > num and "[ff4f3e]%d/%d[-]" or "%d/%d"
            self.n_Label_Num.text = string.format(str, num, needNum)
        end
    else
        self.n_Label_Num.gameObject:SetActive(false)
    end
end

function ShipBodyHullListItem:CalcCount()
    local maxCount = 99999999
    for i,v in pairs(self.material) do
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        if itemData == nil and v > 0 then
            maxCount = 0
            break
        end

        local count = math.floor(itemData.num/v)
        if count < maxCount then
            maxCount = count
        end

        if maxCount == 0 then
            break
        end
    end
    return maxCount
end

return ShipBodyHullListItem