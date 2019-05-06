local BuildingListMediator = class("BuildingListMediator", MediatorDynamic)

function BuildingListMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    self.firstOpen = true

    self.tabView = self.m_viewComponent.uiBinder.m_TabView:GetComponent("NTabView")
    self.tableView = self.m_viewComponent.uiBinder.m_SubPanel:GetComponent("NTableView")

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    self:RegisterObserver(NotiConst.Notify_BuildingListOpenTabItem, "OpenTabItem")
    self:RegisterObserver(NotiConst.Notify_BuildingListListItemSelectBuild, "ListItemSelectBuild")
    self:RegisterObserver(NotiConst.Notify_BuildingListListItemChangeSelect, "ListItemChangeSelect")
end

function BuildingListMediator:InitData()
    self.curTabIndex = 0

    if self.firstOpen == false then
        self.tabView:OpenTabItem(self.curTabIndex)
    end
    self.firstOpen = false
    self.infoOpen = {}
    self.lastSubViewCellIndex = -1
end

function BuildingListMediator:OpenTabItem(notification)
    local index = notification:GetBody()
    self.curTabIndex = index
    self.infoOpen = {}
    self.lastSubViewCellIndex = -1
    local nodeId = self.planetaryProxy:GetPlanetaryId()
    self.planetaryProxy:InitBuildingPackageData(self.planetaryProxy:GetPlanetaryId(), index)
    local buildingPackageData = self.planetaryProxy:GetBuildingPackageData()
    Facade:SendNotification("BuildingListPanelNotify", #buildingPackageData)
    self.tableView:ResetState()
    self.tableView:ScrollResetPosition()
end

function BuildingListMediator:ListItemSelectBuild(notification)
    local index = notification:GetBody()
    local buildingData = self.planetaryProxy:GetBuildingPackageDataByIndex(index)
    self:Close()

    local body = {buildingConfigId = buildingData.id}
    Facade:SendNotification(NotiConst.Notify_PlanetChooseBuilding, body)
end

function  BuildingListMediator:ListItemChangeSelect(notification)
    local body = notification:GetBody()
    if self.lastSubViewCellIndex ~= body.cellIndex then
        self.tableView:CloseSubViewAll(false)
        if self.lastSubViewDataIndex ~= body.index then
            self.tableView:ToggleSubView(body.gameObject,true,true)
            self.lastSubViewCellIndex = body.cellIndex
            self.lastSubViewDataIndex = body.index
        else
            self.lastSubViewDataIndex = 0
            self.lastSubViewCellIndex = 0
        end
    else 
        if self.lastSubViewDataIndex == body.index then
            self.tableView:CloseSubViewAll(false)
            self.lastSubViewDataIndex = 0
            self.lastSubViewCellIndex = 0
        else
            self.lastSubViewCellIndex = body.cellIndex
            self.lastSubViewDataIndex = body.index
        end
    end
end

function BuildingListMediator:Close()
    Facade:BackPanel()
end

return BuildingListMediator