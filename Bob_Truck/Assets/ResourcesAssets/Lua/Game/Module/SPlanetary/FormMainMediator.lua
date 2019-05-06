local FormMainMediator = class("FormMainMediator", MediatorDynamic)

function FormMainMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Close.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_NewModel.gameObject)
    NLuaClickEvent:AddClick(self, self.NewModel)

    self:RegisterObserver(NotiConst.Notify_FormMainDelModel, "DelModel")
    self:RegisterObserver(NotiConst.Notify_FormMainEditModel, "EditModel")
    self:RegisterObserver(NotiConst.Notify_FormMainRefit, "Refit")
    self:RegisterObserver(NotiConst.Notify_FormMainMake, "Make")
    self:RegisterObserver(NotiConst.Notify_FormMainClose, "Close")

    self.m_viewComponent.tableView = self.m_viewComponent.uiBinder.m_SubPanel:GetComponent("NTableView")
end

function FormMainMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()

    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local name = buildingConfigData.data[buildingConfigData.EVar["bldg_name_s"]]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("BuildingAttribute", name)
    self.m_viewComponent.uiBinder.m_LabelLv.text = string.format("Lv.%s", level)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.DELMOD), self.OnDelModel, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CREATESHIP), self.OnMake, self)

    local userModsData = self.planetaryProxy:GetUserMods()
    Facade:SendNotification("FormMainPanelNotify", #userModsData)
    self.m_viewComponent.tableView:ScrollResetPosition()
end

function FormMainMediator:Close(notification)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.DELMOD), self.OnDelModel)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.CREATESHIP), self.OnMake)

    self.m_viewComponent.tableView:ResetState()

    Facade:BackPanel()
end

--创建模板
function FormMainMediator:NewModel()
    self.curBuilding.dynamicData.type = 0

    self.m_viewComponent.tableView:ResetState()

    Facade:ReplacePanel("FormModelPanel")
end

--删除
function FormMainMediator:DelModel(notification)
    local data = notification:GetBody()
    local index = data.index
    local userModData = self.planetaryProxy:GetUserModByIndex(index)

    self.delModelObj = data.cellObj

    local  TCSDelMod = buildingModFact_pb.TCSDelMod()
    TCSDelMod.modId = userModData.id
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.DELMOD, TCSDelMod:SerializeToString())
end

function FormMainMediator:OnDelModel(btsData)
    if btsData == nil then 
        LogDebug("FormMainMediator:OnDelModel btsData==nil")
        return
    end

    local TSCDelMod = buildingModFact_pb.TSCDelMod()
    TSCDelMod:MergeFromString(btsData)
    if TSCDelMod.result then
        self.planetaryProxy:RemoveUserMod(TSCDelMod.modId)

        self.m_viewComponent.tableView:DeleteCell(self.delModelObj)
    else
        LogError("FormMainMediator:OnDelModel Failed")
    end
end

--编辑
function FormMainMediator:EditModel(notification)
    local index = notification:GetBody()
    local userModData = self.planetaryProxy:GetUserModByIndex(index)
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.curBuilding.dynamicData.modelId = userModData.id
    self.curBuilding.dynamicData.mod = userModData
    self.curBuilding.dynamicData.type = 1

    Facade:ReplacePanel("FormModelPanel")
end

--改装
function FormMainMediator:Refit(notification)
    local index = notification:GetBody()
    local userModData = self.planetaryProxy:GetUserModByIndex(index)
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.curBuilding.dynamicData.modelId = userModData.id
    self.curBuilding.dynamicData.mod = userModData
    Facade:ReplacePanel("FormRefitPanel")
end

--组装
function FormMainMediator:Make(notification)
    LogDebug("FormMainMediator:Make")
    local index = notification:GetBody()
    local userModData = self.planetaryProxy:GetUserModByIndex(index)

    local  TCSCreateShip = buildingModFact_pb.TCSCreateShip()
    TCSCreateShip.modId = userModData.id
    TCSCreateShip.nodeId = self.curBuilding.nodeId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.CREATESHIP, TCSCreateShip:SerializeToString())
end

function FormMainMediator:OnMake(btsData)
    LogDebug("FormMainMediator:OnMake")
    if btsData == nil then 
        LogDebug("FormMainMediator:OnMake btsData==nil")
        return
    end

    local TSCCreateShip = buildingModFact_pb.TSCCreateShip()
    TSCCreateShip:MergeFromString(btsData)
    if TSCCreateShip.result then
        self.storehouseProxy:UseItemByDatas(self.curBuilding.nodeId, TSCCreateShip.items)
        self.planetaryProxy:SetIsPortShipNew(true)
        Facade:SendNotification(NotiConst.Notify_UpdatePortShipPoint)

        self.m_viewComponent.tableView:UpdateView()

        OpenMessageBox(NotiConst.MessageBoxType.Tip, "组装完成")
    else
        LogError("FormMainMediator:OnMake Failed")
    end
end

return FormMainMediator