local FleetGoodsMediator = class("FleetGoodsMediator", MediatorDynamic)

function FleetGoodsMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    self.firstOpen = true
    self.fleetTableView = self.m_viewComponent.uiBinder.m_Fleet_SubPanel:GetComponent("NTableView")
    self.depotTableView = self.m_viewComponent.uiBinder.m_Depot_SubPanel:GetComponent("NTableView")

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonReturnClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonReturn.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonReturnClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_CloseSetNum.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseSetNumPanel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_CutDown.gameObject)
    NLuaClickEvent:AddClick(self, self.CutDownNum)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Add.gameObject)
    NLuaClickEvent:AddClick(self, self.AddNum)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Max.gameObject)
    NLuaClickEvent:AddClick(self, self.MaxNum)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonSure.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonSureClick)

    local NLuaEventRegister = NLuaEventRegister.Get(self.m_viewComponent.uiBinder.m_Editbox.gameObject)
    NLuaEventRegister:RegisterEvent(self.m_viewComponent.uiBinder.m_Editbox.onChange, self, self.OnChange)

    self:RegisterObserver(NotiConst.Notify_FleetGoodsOpenTabItem, "OpenTabItem")
    self:RegisterObserver(NotiConst.Notify_FleetGoodsInstallGoods, "InstallGoods")
    self:RegisterObserver(NotiConst.Notify_FleetGoodsUnInstallGoods, "UninstallGoods")
    self:RegisterObserver(NotiConst.Notify_FleetGoodsSetGoodsNum, "SetGoodsNum")
    self:RegisterObserver(NotiConst.Notify_FleetGoodsDropUp, "DropUp")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.LOADGOODS), self.OnLoadGoods, self)
end

function FleetGoodsMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.installGoods = {}
    self.uninstallGoods = {}
    
    self.curTabIndex = 0
    self.loadOrUninstall = 0
    self.editItem = {}

    local selectIndex = self.fleetProxy:GetCurrentSelectIndex("FleetPortPanelFleetListCell")
    self.fleetData = self.fleetProxy:GetProtFleetDataByIndex(selectIndex)
    self.fleetProxy:SetFleetGoodsData(self.fleetData.items, self.fleetData.totalCap)

    if self.firstOpen == false then
        self.m_viewComponent.uiBinder.m_GoodsTabView:GetComponent("NTabView"):OpenTabItem(self.curTabIndex)
    end
    self.firstOpen = false
end

function FleetGoodsMediator:OpenTabItem(notification)
    local index = notification:GetBody()
    self.curTabIndex = index

    self:RefreshView()

    self.fleetTableView:ScrollResetPosition()
    self.depotTableView:ScrollResetPosition()
end

function FleetGoodsMediator:RefreshView()
    self.fleetProxy:InitPackageData(self.curTabIndex)
    local packageData = self.fleetProxy:GetPackageData()
    Facade:SendNotification("FleetGoodsPanelGoodsNotify", #packageData)

    self.storehouseProxy:InitPackageData(self.curBuilding.nodeId, self.curTabIndex)
    packageData = self.storehouseProxy:GetPackageData()
    Facade:SendNotification("FleetGoodsPanelDepotNotify", #packageData)

    self:RefreshCap()
end

function FleetGoodsMediator:RefreshCap()
    local storehouse = self.storehouseProxy:GetStorehouseByNodeId(self.curBuilding.nodeId)
    self.m_viewComponent.uiBinder.m_depot_cube.text = string.format("%d / %d m3", storehouse.totalCap - storehouse.restOfCap, storehouse.totalCap)
    self.m_viewComponent.uiBinder.m_depot_Bar.fillAmount = 1 - storehouse.restOfCap / storehouse.totalCap

    local fleetGoods = self.fleetProxy:GetFleetGoodsData()
    self.m_viewComponent.uiBinder.m_fleet_cube.text = string.format("%d / %d m3", fleetGoods.totalCap - fleetGoods.restOfCap, fleetGoods.totalCap)
    
    self.fleetTotalCap = fleetGoods.totalCap
    if fleetGoods.totalCap == 0 then
        self.m_viewComponent.uiBinder.m_fleet_Bar.fillAmount = 1
    else
        self.m_viewComponent.uiBinder.m_fleet_Bar.fillAmount = 1 - fleetGoods.restOfCap / fleetGoods.totalCap
    end
end

function FleetGoodsMediator:ButtonReturnClick()
    self:LoadGoods()
end

--设置货物数量
function FleetGoodsMediator:SetGoodsNum(notification)
    LogDebug("FleetGoodsMediator FleetGoodsMediator")
    local data = notification:GetBody()
    self.loadOrUninstall = data.type
    self.editItem = data.data

    self:OpenSetNumPanel()
end

function FleetGoodsMediator:OpenSetNumPanel()
    self.m_viewComponent.uiBinder.m_SetNum:SetActive(true)

    self:SetNum(1)
end

function FleetGoodsMediator:CloseSetNumPanel()
    self.m_viewComponent.uiBinder.m_SetNum:SetActive(false)
end

function FleetGoodsMediator:SetNum(num)
    self.m_viewComponent.uiBinder.m_Editbox.value = num
end

function FleetGoodsMediator:CutDownNum()
    local num = tonumber(self.m_viewComponent.uiBinder.m_Editbox.value)
    if num > 1 then
        num = num - 1
        self:SetNum(num)
    end
end

function FleetGoodsMediator:AddNum()
    local num = tonumber(self.m_viewComponent.uiBinder.m_Editbox.value)
    if num < self.editItem.num then
        num = num + 1
        self:SetNum(num)
    end
end

function FleetGoodsMediator:MaxNum()
    self:SetNum(self.editItem.num)
end

function FleetGoodsMediator:OnChange()
    local num = tonumber(self.m_viewComponent.uiBinder.m_Editbox.value)
    if type(num) ~= "number" then
        num = 1
    end

    if num > self.editItem.num then
        self:MaxNum()
    else
        self:SetNum(num)
    end
end

function FleetGoodsMediator:ButtonSureClick()
    self:CloseSetNumPanel()
    local item = { id = self.editItem.id, num = tonumber(self.m_viewComponent.uiBinder.m_Editbox.value) }
    local notification = Notification.New("", item)
    if self.loadOrUninstall == 1 then
        self:InstallGoods(notification)
    else
        self:UninstallGoods(notification)
    end
end

--加载货物
function FleetGoodsMediator:InstallGoods(notification)    
    local data = notification:GetBody()
    local id = data.id
    local num = data.num
    local item = { id = id, num = num }
    if self.fleetProxy:ReduceFleetGoodsData(item) then
        local result = self.storehouseProxy:AddItemByNum(self.curBuilding.nodeId, item.id, item.num)

        if result == nil then
            self.fleetProxy:IncreaseFleetGoodsData(item)
            LogDebug("仓库储存容量不够")
            OpenMessageBox(NotiConst.MessageBoxType.Tip, "仓库储存容量不够")
            return
        end

        local has = false
        for i=1,#self.installGoods do
            local temp = self.installGoods[i]
            if temp.id == item.id then
                temp.num = temp.num + item.num
                has = true
                break
            end
        end

        if has == false then
            table.insert(self.installGoods, { id = id, num = num })
        end

        self:RefreshView()
    end
end

--卸载货物
function FleetGoodsMediator:UninstallGoods(notification)
    if self.fleetTotalCap == 0 then
        LogDebug("舰队仓库储存容量不够")
        OpenMessageBox(NotiConst.MessageBoxType.Tip, "舰队仓库储存容量不够")
        return
    end

    local data = notification:GetBody()
    local id = data.id
    local num = data.num
    local item = { id = id, num = num }
    if self.storehouseProxy:UseItemByNum(self.curBuilding.nodeId, id, num) then
        local result = self.fleetProxy:IncreaseFleetGoodsData(item)

        if result == false then
            self.storehouseProxy:AddItemByNum(self.curBuilding.nodeId, id, num)
            LogDebug("舰队仓库储存容量不够")
            OpenMessageBox(NotiConst.MessageBoxType.Tip, "舰队仓库储存容量不够")
            return
        end

        local has = false
        for i=1,#self.uninstallGoods do
            local temp = self.uninstallGoods[i]
            if temp.id == item.id then
                temp.num = temp.num + item.num
                has = true
                break
            end
        end

        if has == false then
            table.insert(self.uninstallGoods, { id = id, num = num })
        end

        self:RefreshView()
    end
end

function FleetGoodsMediator:DropUp(notification)
    local data = notification:GetBody()
    if data.notificationKey == "FleetGoodsPanelGoodsNotify" then
        local item = self.fleetProxy:GetPackageDataByIndex(data.index)
        self:InstallGoods(Notification.New("", item))
    elseif data.notificationKey == "FleetGoodsPanelDepotNotify" then
        local item = self.storehouseProxy:GetPackageDataByIndex(data.index)
        LogDebug("FleetGoodsMediator GetStorehouseNodeByIndex :{0}", item.num)
        self:UninstallGoods(Notification.New("", item))
    end
end

function FleetGoodsMediator:LoadGoods()
    local TCSLoadGoods = buildingPort_pb.TCSLoadGoods()
    TCSLoadGoods.nodeId = self.curBuilding.nodeId
    TCSLoadGoods.fleetId = self.fleetData.fleetId

    for i=1,#self.installGoods do
        local install = self.installGoods[i]
        local tempUninstall = nil
        for j=1,#self.uninstallGoods do
            local uninstall = self.uninstallGoods[j]
            if install.id == uninstall.id then
                tempUninstall = uninstall
                table.remove(self.uninstallGoods, j)
                break
            end
        end

        if tempUninstall == nil then
            local LoadGoodsData = buildingPort_pb.LoadGoodsData()
            LoadGoodsData.loadOrUninstall = 1
            LoadGoodsData.item.id = install.id
            LoadGoodsData.item.num = install.num
            table.insert(TCSLoadGoods.loadGoodsData, LoadGoodsData)
            LogDebug("FleetGoodsMediator install 1:LoadGoods {0} {1}", install.id, install.num)
        else
            if install.num > tempUninstall.num then
                local LoadGoodsData = buildingPort_pb.LoadGoodsData()
                LoadGoodsData.loadOrUninstall = 1
                LoadGoodsData.item.id = install.id
                LoadGoodsData.item.num = install.num - tempUninstall.num
                table.insert(TCSLoadGoods.loadGoodsData, LoadGoodsData)
                LogDebug("FleetGoodsMediator install 2:LoadGoods {0} {1}", install.id, install.num - tempUninstall.num)
            elseif install.num < tempUninstall.num then
                local LoadGoodsData = buildingPort_pb.LoadGoodsData()
                LoadGoodsData.loadOrUninstall = 2
                LoadGoodsData.item.id = install.id
                LoadGoodsData.item.num = tempUninstall.num - install.num
                table.insert(TCSLoadGoods.loadGoodsData, LoadGoodsData)
                LogDebug("FleetGoodsMediator uninstall 3:LoadGoods {0} {1}", install.id, tempUninstall.num - install.num)
            end
        end
    end

    for i=1,#self.uninstallGoods do
        local uninstall = self.uninstallGoods[i]
        local LoadGoodsData = buildingPort_pb.LoadGoodsData()
        LoadGoodsData.loadOrUninstall = 2
        LoadGoodsData.item.id = uninstall.id
        LoadGoodsData.item.num = uninstall.num
        table.insert(TCSLoadGoods.loadGoodsData, LoadGoodsData)
        LogDebug("FleetGoodsMediator uninstall 4:LoadGoods {0} {1}", uninstall.id, uninstall.num)
    end

    if #TCSLoadGoods.loadGoodsData == 0 then
        self:Close()
    else
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.LOADGOODS, TCSLoadGoods:SerializeToString())
    end
end

function FleetGoodsMediator:OnLoadGoods(btsData)
    LogDebug("FleetGoodsMediator OnLoadGoods")
    if btsData == nil then 
        LogDebug("FleetGoodsMediator:OnLoadGoods btsData==nil")
        return
    end

    local TSCLoadGoods = buildingPort_pb.TSCLoadGoods()
    TSCLoadGoods:MergeFromString(btsData)
    if TSCLoadGoods.result then
        Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtFleetsData)
        self:Close()
    else
        LogError("FleetGoodsMediator:OnLoadGoods Failed")
    end
end

function FleetGoodsMediator:Close()
    Facade:BackPanel()
end

return FleetGoodsMediator