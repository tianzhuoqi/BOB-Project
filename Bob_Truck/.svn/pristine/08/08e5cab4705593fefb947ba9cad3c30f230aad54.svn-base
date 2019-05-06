local FormRefitMediator = class("FormRefitMediator", MediatorDynamic)
local ModTechCfg = DATA_SHIP_MOD_TECH
--local 

function FormRefitMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Close.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_No.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Yes.gameObject)
    NLuaClickEvent:AddClick(self, self.SendEditShip)

    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
end

function FormRefitMediator:InitData()
    Facade:SendNotification('initFormRefitNeedListCell', 0)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETALLEDITSHIP), self.GetDataCallBack, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITSHIP), self.EditShipCallBack, self)
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local TCSGetAllEditShip = buildingModFact_pb.TCSGetAllEditShip()
    TCSGetAllEditShip.nodeId = self.planetaryProxy:GetPlanetaryId()
    TCSGetAllEditShip.modId = self.curBuilding.dynamicData.modelId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETALLEDITSHIP, TCSGetAllEditShip:SerializeToString())
end

function FormRefitMediator:GetDataCallBack(stData)
    self.planetaryProxy:InitcurFormRefitEditShipTempNeedCount()
    self.m_viewComponent.uiBinder.m_Label_Skill.text = ''
    if stData == nil then
        Facade:SendNotification('initFormRefitListCell', 0)
    else
        local TSCGetAllEditShip = buildingModFact_pb.TSCGetAllEditShip()
        TSCGetAllEditShip:MergeFromString(stData)
        local dataTable = {}
        for i = 1, #TSCGetAllEditShip.userShipData do
            if self:EditShipNeedAdd(TSCGetAllEditShip.userShipData[i]) then
                table.insert( dataTable, {TSCGetAllEditShip.userShipData[i], false} )
            end
        end
        self.planetaryProxy:SetcurFormRefitEditShipData(dataTable)
        Facade:SendNotification('initFormRefitListCell', #dataTable)
        if #TSCGetAllEditShip.userShipData > 0 then
            self.m_viewComponent.uiBinder.m_Label_Skill.text = ModTechCfg[TSCGetAllEditShip.userShipData[1].userShip.techID][ModTechCfg.EVar.mod_tech_name_s]
        end
    end
end

function FormRefitMediator:EditShipNeedAdd(fleetData)
    local data = {}
    local hullParts = self.planetaryProxy:GetCurBuildingOper().dynamicData.mod.hullParts

    for i = 1, #hullParts do
        if data[hullParts[i].hullId] == nil then
            data[hullParts[i].hullId] = 1
        else
            data[hullParts[i].hullId] = data[hullParts[i].hullId] + 1
        end
    end

    for i = 1, #fleetData.userShip.hullParts do
        if data[fleetData.userShip.hullParts[i].hullId] == nil then
            return true
        else
            if data[fleetData.userShip.hullParts[i].hullId] == 0 then
                return true
            end
            data[fleetData.userShip.hullParts[i].hullId] = data[fleetData.userShip.hullParts[i].hullId] - 1
        end
    end

    for k, v in pairs(data) do
        if v > 0 then
            return true
        end
    end

    return false
end

function FormRefitMediator:Close()
    self.planetaryProxy:InitcurFormRefitEditShipTempNeedCount()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETALLEDITSHIP), self.GetDataCallBack)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITSHIP), self.EditShipCallBack)
    Facade:BackPanel()
end

function FormRefitMediator:SendEditShip()
    local TCSEditShip = buildingModFact_pb.TCSEditShip()
    local data = self.planetaryProxy:GetcurFormRefitEditShipData()
    for i = 1, #data do
        if data[i][2] then
            table.insert(TCSEditShip.shipId, data[i][1].shipId)
        end
    end
    TCSEditShip.modId = self.curBuilding.dynamicData.modelId
    TCSEditShip.nodeId = self.planetaryProxy:GetPlanetaryId()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EDITSHIP, TCSEditShip:SerializeToString())
end

function FormRefitMediator:EditShipCallBack(stData)
    self:InitData()
    Facade:SendNotification('initFormRefitNeedListCell', 0)
end

return FormRefitMediator