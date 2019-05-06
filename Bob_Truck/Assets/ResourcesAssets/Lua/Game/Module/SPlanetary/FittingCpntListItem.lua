local ListItem = require("Game/Module/UICommon/ListItem")

local FittingCpntListItem = register("FittingCpntListItem", ListItem)

function FittingCpntListItem:Awake(gameObject)
    FittingCpntListItem.super.Awake(self, gameObject)

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

function FittingCpntListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_FittintEditHullProductClick, {
        gameObject = self.cellGo,
        cellIndex = self.cellIndex,
        index = self.dataIndex,
    })

    self:UpdateSubView()
end

function FittingCpntListItem:UpdateSubView()
    GameObjectUtil.SetLocalPosition(self.infoArrow, -234+self.index*156, 0, 0)
    self.infoLabel.text = GetLanguageText(self.shipCpntData.data[self.shipCpntData.EVar["transl_table_name_s"]], self.shipCpntData.data[self.shipCpntData.EVar["cpnt_name_s"]])
    local needElec = self.shipCpntData.data[self.shipCpntData.EVar["ele_cost_n"]]
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

function FittingCpntListItem:OnClickCreate()
    if not self:IsEnoughElec() then
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"没有足够的电力")
        return
    end
    if self.count > 0 then
        Facade:SendNotification(NotiConst.Notify_FittintEditHullProductLine, {
            gameObject = self.cellGo,
            index = self.dataIndex,
            type = 0,
        })
    end
end

function FittingCpntListItem:IsEnoughElec()
    local needElec = self.shipCpntData.data[self.shipCpntData.EVar["ele_cost_n"]]
    local info = self.planetaryProxy:GetElecMsg()
    if info.restOfElect >= needElec then
        return true
    else
        return false
    end
end

function FittingCpntListItem:DrawCell(index, cellIndex, itemsCount)
    self.index = index
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.shipCpntData = self.planetaryProxy:GetPackageShipCnptDataByIndex(self.dataIndex)

    self.dragDropItem.m_index = self.dataIndex

    self.n_Sprite_ListIcon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.shipCpntData.data[self.shipCpntData.EVar["icon_name_s"]])

    self.material = {}

    local costTable = self.shipCpntData.data[self.shipCpntData.EVar["cost_table_repeated5"]]
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

        self.materialCpnt = {}

        for i=1,#self.modData.cpntMats do
            local cpntId = self.modData.cpntMats[i]
            if self.materialCpnt[cpntId] == nil then
                self.materialCpnt[cpntId] = 0
            end
            self.materialCpnt[cpntId] = self.materialCpnt[cpntId] + 1
        end

        local itemData = self.storehouseProxy:GetItem(self.nodeId, self.shipCpntData.data.id)
        local num = itemData == nil and 0 or itemData.num
        local needNum = self.materialCpnt[self.shipCpntData.data.id]
        if needNum == nil then
            LogError("消耗中没有该部件 {0}", self.shipCpntData.data.id)
        else
            local str = needNum > num and "[ff4f3e]%d/%d[-]" or "%d/%d"
            self.n_Label_Num.text = string.format(str, needNum, num)
        end
    else
        self.n_Label_Num.gameObject:SetActive(false)
    end
end

function FittingCpntListItem:CalcCount()
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

return FittingCpntListItem