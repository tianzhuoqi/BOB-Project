local HullFilterMediator = class("HullFilterMediator", MediatorDynamic)

local config = {
    [common_pb.CPNTFACT] = NotiConst.Notify_FittintRefreshView,
    [common_pb.HULLFACT] = NotiConst.Notify_ShipBodyRefreshView
}

function HullFilterMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Close.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_NewModel.gameObject)
    NLuaClickEvent:AddClick(self, self.Cancel)

    self:RegisterObserver(NotiConst.Notify_HullFilterMake, "Make")
end

function HullFilterMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    self.funcType = buildingConfigData.data[buildingConfigData.EVar["bldg_func_type_n"]]

    local userModsData = self.planetaryProxy:GetUserMods()
    Facade:SendNotification("HullFilterPanelNotify", #userModsData)
end

function HullFilterMediator:Close()
    Facade:BackPanel()
end

function HullFilterMediator:Make(notification)
    local modId = notification:GetBody()
    UnityEngine.PlayerPrefs.SetInt(self.planetaryProxy:GetFilterKey(), modId)
    Facade:SendNotification(config[self.funcType])

    self:Close()
end

function HullFilterMediator:Cancel()
    UnityEngine.PlayerPrefs.SetInt(self.planetaryProxy:GetFilterKey(), -1)
    Facade:SendNotification(config[self.funcType])

    self:Close()
end

return HullFilterMediator