require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local RefineryListItem = register("RefineryListItem", ListCell)

function RefineryListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_RefinerySelectMine, {
        gameObject = self.cellGo,
        cellIndex = self.cellIndex,
        index = self.dataIndex,
    })
    local temp = {
        parent = self,
        id = self.dataIndex,
        num = 0,
        OnOk = function(self)
            self.parent.panelMediator:Sure()
        end,
        OnAdd = function(self)
            local valid,num = self.parent.panelMediator:AddNum(self.num)
            --if valid then
                self.num = num
                self.parent.n_refinery.value = num
                self.parent:UpdateSubViewEle(num)
            --end
            self:CheckOk()
        end,
        OnMax = function(self)
            local valid,num = self.parent.panelMediator:MaxNum(self.num)
            --if valid then
                self.num = num
                self.parent.n_refinery.value = num
                self.parent:UpdateSubViewEle(num)
            --end
            self:CheckOk()
        end,
        OnReduce = function(self)
            local valid,num = self.parent.panelMediator:CutDownNum(self.num)
            --if valid then
                self.num = num
                self.parent.n_refinery.value = num
                self.parent:UpdateSubViewEle(num)
            --end
            self:CheckOk()
        end,
        CheckOk = function(self)
            self.parent.n_OkButton.isEnabled = (self.num ~= 0)
            if self.num == 0 then
                self.parent.n_OkSprite:SetGray()
            else
                self.parent.n_OkSprite:SetNormal()
            end
        end,
        OnChange = function(self)

        end,
        OnLongPressAdd = function(self)
            self:OnAdd()
            self.parent.panelMediator:DoubleNumRatio()
        end,
        OnLongPressReduce = function(self)
            self:OnReduce()
            self.parent.panelMediator:DoubleNumRatio()
        end,
        OnPress = function(self, isPress)
            if isPress == false then
                self.parent.panelMediator:ResetNumRatio()
            end
        end,
    }
    self.n_MaxClick:AddClick(temp, temp.OnMax)
    self.n_OkClick:AddClick(temp, temp.OnOk)
    self.n_AddClick:AddClick(temp, temp.OnAdd)
    self.n_AddClick:AddPress(temp, temp.OnPress)
    self.n_AddClick:AddLongPress(temp, temp.OnLongPressAdd, 0.0625)
    self.n_ReduceClick:AddClick(temp, temp.OnReduce)
    self.n_ReduceClick:AddPress(temp, temp.OnPress)
    self.n_ReduceClick:AddLongPress(temp, temp.OnLongPressReduce, 0.0625)
    self.n_refineryNumInput:RegisterEvent(self.n_refinery.onChange, temp, temp.OnChange)
    
    --if self.panelMediator.lastSubViewDataIndex ~= self.dataIndex then
        local valid,num = self.panelMediator:OnSelectedMine(self.dataIndex)
        temp.num = num
        temp:CheckOk()
        self.n_refinery.value = num
        self.panelMediator:SetOutput()
    --end
    self:UpdateSubView(num)
end

function RefineryListItem:Awake(gameObject)
    RefineryListItem.super.Awake(self, gameObject)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.panelMediator = Facade:RetrieveMediator("RefineryMediator")
    self.n_icon = self:FindComponent("n_icon", "UITexture")
    self.n_Quality = self:FindComponent("n_Quality", "UISprite")
    self.n_Label_Purity = self:FindComponent("Purity/n_Label_Purity", "UILabel")
    self.n_CurMineName01 = self:FindComponent("n_CurMineName01", "UILabel")
    self.n_NumLabel = self:FindComponent("n_NumLabel", "UILabel")
    self.n_Select = self:FindComponent("n_Select", "UISprite")
    self.cellGo = gameObject.transform.parent.gameObject
    self.n_subView = gameObject.transform.parent:Find("SubView")
    self.n_cost = self.n_subView:Find("ItemSellNum/GameObject_Menu/Label_ConsumpNam/Label_ConsumpVal"):GetComponent("UILabel")
    self.n_refinery = self.n_subView:Find("ItemSellNum/GameObject_Menu/Label_Num"):GetComponent("UIInput")
    self.n_refineryRatio = self.n_subView:Find("ItemSellNum/GameObject_Menu/Label_RatioNam/Label_RatioVal"):GetComponent("UILabel")
    self.n_Label_Electric = self.n_subView:Find("ItemSellNum/GameObject_Menu/Label_Electric/Label_RatioVal"):GetComponent("UILabel")
    self.n_Label_ElectricCur = self.n_subView:Find("ItemSellNum/GameObject_Menu/Label_CruElect/m_Label_CurElet"):GetComponent("UILabel")
    self.n_Arrow = self.n_subView:Find("ItemSellNum/GameObject_Menu/Sprite_Arrow").gameObject
    self.n_Add = self.n_subView:Find("ItemSellNum/GameObject_Menu/MenuAdd").gameObject
    self.n_AddClick = NLuaClickEvent.Get(self.n_Add)
    self.n_Reduce = self.n_subView:Find("ItemSellNum/GameObject_Menu/MenuReduce").gameObject
    self.n_ReduceClick = NLuaClickEvent.Get(self.n_Reduce)
    self.n_Max = self.n_subView:Find("ItemSellNum/GameObject_Menu/MenuMax").gameObject
    self.n_MaxClick = NLuaClickEvent.Get(self.n_Max)
    self.n_Ok = self.n_subView:Find("ItemSellNum/GameObject_Menu/MenuOk").gameObject
    self.n_OkSprite = self.n_subView:Find("ItemSellNum/GameObject_Menu/MenuOk/Sprite_MenuOk"):GetComponent('UIEventGraySprite')
    self.n_OkButton = self.n_Ok:GetComponent("UIButton")
    self.n_OkClick = NLuaClickEvent.Get(self.n_Ok)
    
    self.n_refineryNumInput = NLuaEventRegister.Get(self.n_refinery.gameObject)
    

end

function RefineryListItem:DrawCell(index, cellIndex, itemsCount)
    self.index = index
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.data = self.storehouseProxy:GetPackageDataByIndex(self.dataIndex)
    self.configData = self.storehouseProxy:GetItemConfigData(self.data.id)
    self.refineryInfo = self.planetaryProxy:GetCurBuildingOper().dynamicData.item
    if self.refineryInfo ~= nil and  self.refineryInfo.id == self.data.id then
        self.n_Select.gameObject:SetActive(true)
    else
        self.n_Select.gameObject:SetActive(false)
    end

    self.n_Label_Purity.text = self.data.baseValue
    self.n_NumLabel.text = self.data.num
    self.n_icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.configData.data[self.configData.EVar["icon_name_s"]])
    local name_s = self.configData.relation["name_s"]
    self.n_CurMineName01.text = GetLanguageText('ItemName', self.configData.data[self.configData.EVar[name_s]])
end

function RefineryListItem:UpdateSubView(num)
    GameObjectUtil.SetLocalPosition(self.n_Arrow, -225+self.index*150, 213, 0)

    local itemData = self.storehouseProxy:GetPackageDataByIndex(self.dataIndex)
    --[[if self.refineryInfo.item ~= nil and self.refineryInfo.item.id > 0 and itemData.id ~= self.refineryInfo.item.id then
        return
    end

    if  self.refineryInfo.item ~= nil and self.refineryInfo.item.num >= self.maxCount then
        return
    end]]

    self.editItem = itemData
    local configData = self.storehouseProxy:GetItemConfigData(itemData.id)
    local ratio = configData.data[configData.EVar["cost_qty_n"]]
    local result_id = configData.data[configData.EVar["result_id_n"]]
    local resultConfigData = self.storehouseProxy:GetItemConfigData(result_id)
    local resultName = resultConfigData.data[resultConfigData.EVar[resultConfigData.relation["name_s"]]]
    self.n_refineryRatio.text = GetLanguageText("ItemName",configData.data[configData.EVar[configData.relation["name_s"]]])..'X'..ratio..'='..GetLanguageText("ItemName",resultName)..'X1'
    self.n_cost.text = GetLanguageText("ItemName",configData.data[configData.EVar[configData.relation["name_s"]]])
    self.n_Label_ElectricCur.text = GetLanguageText("BuildingAttribute","ATRBCapN",self.planetaryProxy:GetElecMsg().restOfElect)
    self:UpdateSubViewEle(num)
end

function RefineryListItem:UpdateSubViewEle(num)
    local configData = self.storehouseProxy:GetItemConfigData(self.editItem.id)
    local ratio = configData.data[configData.EVar["cost_qty_n"]]
    local needElec = configData.data[configData.EVar.ele_cost_n] * math.floor(num/ratio)
    self.n_Label_Electric.text = GetLanguageText("BuildingAttribute","ATRBCapN",needElec)
    if self.planetaryProxy:GetElecMsg().restOfElect < needElec then
        self.n_Label_Electric.color = Color.New(1,0,0)
    else
        self.n_Label_Electric.color = Color.New(1,1,1)
    end
end

return RefineryListItem