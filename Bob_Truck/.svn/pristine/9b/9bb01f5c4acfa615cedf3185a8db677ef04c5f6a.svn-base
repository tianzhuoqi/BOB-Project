local RenameMediator = class("RenameMediator", MediatorDynamic)

local config = {
    [common_pb.MODFACT] = NotiConst.Notify_FormModelInputName,
    [common_pb.SPACEPORT] = NotiConst.Notify_FleetPortInputName,
}

function RenameMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonBake.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonOK.gameObject)
    NLuaClickEvent:AddClick(self, self.Sure)
end

function RenameMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    self.funcType = buildingConfigData.data[buildingConfigData.EVar["bldg_func_type_n"]]
    
    self.m_viewComponent.uiBinder.m_LabelName.value = ""
end

function RenameMediator:Close()
    Facade:BackPanel()
    Facade:SendNotification(config[self.funcType], "")
end

function RenameMediator:Sure()
    local name = self.m_viewComponent.uiBinder.m_LabelName.value
    name = string.trim(name, " ")
    if name == "" then
        self.m_viewComponent.uiBinder.m_LabelName.value = name
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"名称不能为空")
        return
    end
    Facade:SendNotification(config[self.funcType], name)
end

return RenameMediator