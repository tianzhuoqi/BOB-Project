local WarehouseMediator = class("WarehouseMediator", MediatorDynamic)

function WarehouseMediator:OnRegister()
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    self.firstOpen = true

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_MenuMax.gameObject)
    NLuaClickEvent:AddClick(self, self.MaxNum)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_MenuOk.gameObject)
    NLuaClickEvent:AddClick(self, self.SellItem)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_MenuCancel.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseSetNumPanel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_MenuAdd.gameObject)
    NLuaClickEvent:AddClick(self, self.AddNum)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_MenuReduce.gameObject)
    NLuaClickEvent:AddClick(self, self.CutDownNum)

    local NLuaEventRegister = NLuaEventRegister.Get(self.m_viewComponent.uiBinder.m_Label_Num.gameObject)
    NLuaEventRegister:RegisterEvent(self.m_viewComponent.uiBinder.m_Label_Num.onChange, self, self.OnChange)

    self:RegisterObserver(NotiConst.Notify_WarehouseOpenTabItem, "OpenTabItem")
    self:RegisterObserver(NotiConst.Notify_WarehouseListItemChangeSelect, "ListItemChangeSelect")
    self:RegisterObserver(NotiConst.Notify_WarehouseListItemUse, "Use")
    self:RegisterObserver(NotiConst.Notify_WarehouseListItemSell, "Sell")
    self:RegisterObserver(NotiConst.Notify_RefreshCap, "OnRefreshCap")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SELLITEM), self.OnSellItem, self)
end

function WarehouseMediator:InitData()
    self.curTabIndex = 0
    self.selectIndex = 1
    self.editItem = {}
    self.itemData = {}
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local restOfCap = self.storehouseProxy:GetStorehouseRestOfCap(self.curBuilding.nodeId)
    local totalCap = self.storehouseProxy:GetStorehouseTotalCap(self.curBuilding.nodeId)
    self:RefreshCap(restOfCap,totalCap)
    if self.firstOpen == false then
        self.m_viewComponent.uiBinder.m_TabView:GetComponent("NTabView"):OpenTabItem(self.curTabIndex)
    end
    self.firstOpen = false
end

function WarehouseMediator:OnRefreshCap(notification)
    local body = notification:GetBody()
    self:RefreshCap(body.restOfCap, body.totalCap)
end

function WarehouseMediator:RefreshCap(restOfCap, totalCap)
    self.m_viewComponent.uiBinder.m_Label_cube.text = string.format("%d / %d m3", totalCap - restOfCap, totalCap)
    self.m_viewComponent.uiBinder.m_Sprite_Bar.fillAmount = 1 - restOfCap / totalCap
end

function WarehouseMediator:OpenTabItem(notification)
    local index = notification:GetBody()
    self.curTabIndex = index

    self.lastSubViewCellIndex = 0
    self.lastSubViewDataIndex = 0
    self.m_viewComponent.tableView:CloseSubViewAll(false)

    self.storehouseProxy:InitPackageData(self.curBuilding.nodeId, index)
    local packageData = self.storehouseProxy:GetPackageData()
    Facade:SendNotification("WarehousePanelNotify", #packageData)
    self.m_viewComponent.tableView:ScrollResetPosition()
end

function WarehouseMediator:ListItemChangeSelect(notification)
    local body = notification:GetBody()

    if self.lastSubViewCellIndex ~= body.cellIndex then
        self.m_viewComponent.tableView:CloseSubViewAll(false)
        if self.lastSubViewDataIndex ~= body.index then
            self.m_viewComponent.tableView:ToggleSubView(body.gameObject,true,true)
            self.lastSubViewCellIndex = body.cellIndex
            self.lastSubViewDataIndex = body.index
        else
            self.lastSubViewDataIndex = 0
            self.lastSubViewCellIndex = 0
        end
    else 
        if self.lastSubViewDataIndex == body.index then
            self.m_viewComponent.tableView:CloseSubViewAll(false)
            self.lastSubViewDataIndex = 0
            self.lastSubViewCellIndex = 0
        else
            self.lastSubViewCellIndex = body.cellIndex
            self.lastSubViewDataIndex = body.index
        end
    end
end

function WarehouseMediator:Close()
    Facade:BackPanel()
end

function WarehouseMediator:Use(notification)
    local body = notification:GetBody()
end

function WarehouseMediator:Sell(notification)
    local body = notification:GetBody()
    local itemData = self.storehouseProxy:GetPackageDataByIndex(body.index)
    self.editItem = itemData
    self.itemData.name = body.itemName

    self:OpenSetNumPanel()
end

function WarehouseMediator:OpenSetNumPanel()
    self.m_viewComponent.uiBinder.m_ItemSellNum:SetActive(true)
    self.m_viewComponent.uiBinder.m_Label_NumTitle.text = self.itemData.name.." "..self.editItem.num
    self.reduceItem = {id = self.editItem.id, num = 0}
    self:SetNum(1)
end

function WarehouseMediator:CloseSetNumPanel()
    self.m_viewComponent.uiBinder.m_ItemSellNum:SetActive(false)
end

function WarehouseMediator:SetNum(num)
    self.m_viewComponent.uiBinder.m_Label_Num.value = num
    self.reduceItem.num = num
end

function WarehouseMediator:CutDownNum()
    local num = tonumber(self.m_viewComponent.uiBinder.m_Label_Num.value)
    if num > 1 then
        num = num - 1
        self:SetNum(num)
    end
end

function WarehouseMediator:AddNum()
    local num = tonumber(self.m_viewComponent.uiBinder.m_Label_Num.value)
    if num < self.editItem.num then
        num = num + 1
        self:SetNum(num)
    end
end

function WarehouseMediator:MaxNum()
    self:SetNum(self.editItem.num)
end

function WarehouseMediator:OnChange()
    local num = tonumber(self.m_viewComponent.uiBinder.m_Label_Num.value)
    if type(num) ~= "number" then
        num = 1
    end

    if num > self.editItem.num then
        self:MaxNum()
    else
        self:SetNum(num)
    end
end

function WarehouseMediator:SellItem()
    LogDebug("WarehouseMediator:SellItem num:{0}", self.reduceItem.num)
    local TCSSellItem = building_pb.TCSSellItem()
    TCSSellItem.nodeId = self.curBuilding.nodeId
    TCSSellItem.itemId = self.reduceItem.id
    TCSSellItem.count = self.reduceItem.num
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.SELLITEM, TCSSellItem:SerializeToString())

    self:CloseSetNumPanel()
end

function WarehouseMediator:OnSellItem(btsData)
    if btsData == nil then 
        LogDebug("WarehouseMediator:OnSellItem btsData==nil")
        return
    end

    local TSCSellItem = building_pb.TSCSellItem()
    TSCSellItem:MergeFromString(btsData)
    if TSCSellItem.result then
        -- if self.reduceItem.num ~= self.editItem.num then
        --     self.m_viewComponent.tableView:CloseSubViewAll(false)
        -- end
        if self.reduceItem.num ~= 0 then
            self.m_viewComponent.tableView:CloseSubViewAll(false)
            self.lastSubViewCellIndex = 0
            self.lastSubViewDataIndex = 0
        end
        if self.lastSelectItem and self.lastSelectItem.OnUnSelect then
            self.lastSelectItem:OnUnSelect()
        end

        self.storehouseProxy:UseItemByData(self.curBuilding.nodeId, self.reduceItem)

        local storehouse = self.storehouseProxy:GetStorehouseByNodeId(self.curBuilding.nodeId)
        self:RefreshCap(storehouse.restOfCap, storehouse.totalCap)

        self.storehouseProxy:InitPackageData(self.curBuilding.nodeId, self.curTabIndex)
        local packageData = self.storehouseProxy:GetPackageData()
        Facade:SendNotification("WarehousePanelNotify", #packageData)
    else
        LogError("WarehouseMediator:OnSellItem Failed")
    end
end

function WarehouseMediator:DestroyPanel()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.SELLITEM), self.OnSellItem)
end

return WarehouseMediator