local FittingMediator = class("FittingMediator", MediatorDynamic)

function FittingMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    self.firstOpen = true

    self.maxLineCount = 6
    self.planetaryProxy:SetHullfactMSGProductLine({})

    NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Close.gameObject):AddClick(self, self.Close)
    NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Get.gameObject):AddClick(self, self.GetPeoductLineProduct)
    NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_More.gameObject):AddClick(self, self.HullFilter)
    NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_JumHull.gameObject):AddClick(self, self.JumHull)

    self:RegisterObserver(NotiConst.Notify_FittintOpenTabItem, "OpenTabItem")
    self:RegisterObserver(NotiConst.Notify_FittintEditHullProductLine, "EditHullProductLine")
    self:RegisterObserver(NotiConst.Notify_FittintEditHullProductClick, "OnHullProductClick")
    self:RegisterObserver(NotiConst.Notify_FittintGetHullFactData, "GetHullFactData")
    self:RegisterObserver(NotiConst.Notify_FittintRefreshTime, "RefreshTime")
    self:RegisterObserver(NotiConst.Notify_FittintRefreshView, "RefreshView")
end

function FittingMediator:InitData()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.HULLFACTMSG), self.OnGetHullFactData, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITHULLPRODUCTLINE), self.OnEditHullProductLine, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPRODUCTLINEPRODUCT), self.OnGetPeoductLineProduct, self)

    GameObjectUtil.SetButtonState(self.m_viewComponent.uiBinder.m_Button_Get, 3)

    self.curTabIndex = 0
    self.receiveCount = 0
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()

    Facade:SendNotification('FittingPanelProductLineNotify', self.maxLineCount)

    self:GetHullFactData()

    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local name = buildingConfigData.data[buildingConfigData.EVar["bldg_name_s"]]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("BuildingAttribute", name)
    self.m_viewComponent.uiBinder.m_LabelLv.text = string.format("Lv.%s", level)
    self.m_viewComponent.uiBinder.m_Label_ProduceEfficiency.text = string.format( "%d%%",self.planetaryProxy:GetHullFactoryProduceSpeed(self.curBuilding.configId))

    self.planetaryProxy:SetFilterKey(NotiConst.Notify_HullFilterMakeDataKey..self.curBuilding.targetBuilding)
    local modId = UnityEngine.PlayerPrefs.GetInt(self.planetaryProxy:GetFilterKey())
    self.modData = self.planetaryProxy:GetUserModById(modId)
    if self.modData == nil then
        self.m_viewComponent.uiBinder.m_Label_MbName.text = "模板过滤器"
    else
        self.m_viewComponent.uiBinder.m_Label_MbName.text = string.format("%s过滤中", self.modData.modName)
    end

    local index = buildingConfigData.data[buildingConfigData.EVar["bldg_func_table_id_n"]]
    self.limitCount = DATA_BLDG_CPNT_FACT[index][DATA_BLDG_CPNT_FACT.EVar["temp_cap_n"]]
    local addition_limitCount = self.planetaryProxy:GetValueAfterAddition(self.limitCount,"BLDG_CPNT_FACT","temp_cap")
    self.limitCount = math.floor(addition_limitCount)

    if self.firstOpen == false then
        self.m_viewComponent.uiBinder.m_Hull_TabView:GetComponent("NTabView"):OpenTabItem(self.curTabIndex)
    end
    self.firstOpen = false
end

function FittingMediator:RefreshView(notification)
    local modId = UnityEngine.PlayerPrefs.GetInt(self.planetaryProxy:GetFilterKey())
    self.modData = self.planetaryProxy:GetUserModById(modId)
    if self.modData == nil then
        self.m_viewComponent.uiBinder.m_Label_MbName.text = "模板过滤器"
    else
        self.m_viewComponent.uiBinder.m_Label_MbName.text = string.format("%s过滤中", self.modData.modName)
    end
    
    Facade:SendNotification(NotiConst.Notify_FittintOpenTabItem, self.curTabIndex)
end

function FittingMediator:OpenTabItem(notification)
    local index = notification:GetBody()
    self.curTabIndex = index

    self:OpenTabItemNoRefresh()

    self.m_viewComponent.tableView:ScrollResetPosition()
end

function FittingMediator:OpenTabItemNoRefresh()
    local cpntType = self.curTabIndex + 1
    local shipCpntData = self.planetaryProxy:GetShipCnptConfigDataByType(cpntType)
    
    local filterData = {}
    if self.modData == nil then
        filterData = shipCpntData
    else
        for i,v in ipairs(shipCpntData) do
            for j,k in ipairs(self.modData.cpntMats) do
                if v.id == k then
                    table.insert(filterData, v)
                    break
                end
            end
        end
    end
    self.lastSubViewCellIndex = 0
    self.lastSubViewDataIndex = 0
    self.m_viewComponent.tableView:CloseSubViewAll(false)
    self.planetaryProxy:SetPackageShipCnptData(filterData)
    Facade:SendNotification("FittingPanelCpntNotify", #filterData)
end

function FittingMediator:Close()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.HULLFACTMSG), self.OnGetHullFactData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITHULLPRODUCTLINE), self.OnEditHullProductLine)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETPRODUCTLINEPRODUCT), self.OnGetPeoductLineProduct)
    Facade:BackPanel()
end

function FittingMediator:HullFilter()
    Facade:ReplacePanel("HullFilterPanel")
end

function FittingMediator:ShowAssemble(items)
    local count = 0
    if items ~= nil then
        for i,v in ipairs(items) do
            count = count + v.num
        end
    end
    self.receiveCount = count
   
    GameObjectUtil.SetButtonState(self.m_viewComponent.uiBinder.m_Button_Get, self.receiveCount > 0 and 0 or 3)
    self.m_viewComponent.uiBinder.m_Label_Get.text = string.format("%d/%d", self.receiveCount, self.limitCount)
    self.m_viewComponent.uiBinder.m_CountDown.fillAmount = self.receiveCount / self.limitCount

    local hullfactData = self.planetaryProxy:GetHullfactMSGData()
    if hullfactData.personEfficiency == nil then
        hullfactData.personEfficiency = 0
    end
    --self.m_viewComponent.uiBinder.m_Label_PeopleEfficiency.text = string.format("+%d%%", hullfactData.personEfficiency)
end

--获取舰体厂数据
function FittingMediator:GetHullFactData(notification)
    local TCSHullFactMsg = buildingHullFact_pb.TCSHullFactMsg()
    TCSHullFactMsg.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.HULLFACTMSG, TCSHullFactMsg:SerializeToString())
end

function FittingMediator:OnGetHullFactData(btsData)
    if btsData == nil then 
        LogDebug("FittingMediator:OnGetHullFactData btsData==nil")
        self.planetaryProxy:SetHullfactMSGProductLine({})
        self.planetaryProxy:SetHullfactMSGData({})

        self:ShowAssemble()
    else
        local TSCHullFactMsg = buildingHullFact_pb.TSCHullFactMsg()
        TSCHullFactMsg:MergeFromString(btsData)
        self.planetaryProxy:SetHullfactMSGProductLine(TSCHullFactMsg.hullFact.productLine)
        self.planetaryProxy:SetHullfactMSGData(TSCHullFactMsg.hullFact)

        self:ShowAssemble(TSCHullFactMsg.hullFact.item)
    end

    Facade:SendNotification('FittingPanelProductLineNotify', self.maxLineCount)
end

--建筑队列修改
function FittingMediator:EditHullProductLine(notification)
    local data = notification:GetBody()
    local index = data.index
    local type = data.type

    local editData = nil
    if type == 0 then
        local hullfactProductLineData = self.planetaryProxy:GetHullfactMSGProductLine()
        local sum = 0
        for i,v in ipairs(hullfactProductLineData) do
            sum = sum + v.productCount
        end

        if (self.receiveCount + sum) >= self.limitCount then
            LogDebug("舰船部件厂空间已经达到上限：{0}", self.limitCount)
            return
        end

        local shipCpntData = self.planetaryProxy:GetPackageShipCnptDataByIndex(index)
        for i = 1, #hullfactProductLineData do
            local tempData = hullfactProductLineData[i]
            if tempData.techId == shipCpntData.data.id then
                tempData.productCount = tempData.productCount + 1
                editData = tempData
                break
            end
        end

        if editData == nil then
            if #hullfactProductLineData >= self.maxLineCount then
                LogDebug("舰船部件厂生产队列数已经达到上限：{0}, 当前使用数量：{1}", self.maxLineCount, #hullfactProductLineData)
                return
            end

            local ProductLine = db_pb.ProductLine()
            ProductLine.techId = shipCpntData.data.id
            ProductLine.productCount = 1
            
            editData = ProductLine
        end
    else
        editData = self.planetaryProxy:GetHullfactMSGProductLineByIndex(index)
        editData.productCount = editData.productCount - 1
    end

    local TCSEditHullProductLine = buildingHullFact_pb.TCSEditHullProductLine()
    TCSEditHullProductLine.techId = editData.techId
    TCSEditHullProductLine.addType = type
    TCSEditHullProductLine.buildingId = self.curBuilding.targetBuilding
    TCSEditHullProductLine.count = 1

    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EDITHULLPRODUCTLINE, TCSEditHullProductLine:SerializeToString())
end

function FittingMediator:OnEditHullProductLine(btsData)
    LogDebug("FittingMediator:OnEditHullProductLine")
    if btsData == nil then 
        LogDebug("FittingMediator:OnEditHullProductLine btsData==nil")
        self.planetaryProxy:SetHullfactMSGProductLine({})
        self.planetaryProxy:SetHullfactMSGData({})
        self:ShowAssemble()
    else
        local TSCEditHullProductLine = buildingHullFact_pb.TSCEditHullProductLine()
        TSCEditHullProductLine:MergeFromString(btsData)
        self.planetaryProxy:SetHullfactMSGProductLine(TSCEditHullProductLine.hullFact.productLine)
        self.planetaryProxy:SetHullfactMSGData(TSCEditHullProductLine.hullFact)

        if TSCEditHullProductLine.hullFact.firstProductFinishTime ~= -1 then
            local buildingData = {id = TSCEditHullProductLine.buildingId, getItemTime = TSCEditHullProductLine.hullFact.firstProductFinishTime}
            self.planetaryProxy:SetBuildingData_GetItemTime(buildingData)
        end
        
        self:ShowAssemble(TSCEditHullProductLine.hullFact.item)

        self:OpenTabItemNoRefresh()
    end

    Facade:SendNotification('FittingPanelProductLineNotify', self.maxLineCount)
    self.lastSubViewDataIndex = 0
    self.lastSubViewCellIndex = 0
end

--刷新时间
function FittingMediator:RefreshTime(notification)
    local remainderTime = notification:GetBody()
    --self.m_viewComponent.uiBinder.m_Label_Cycle.text = remainderTime
end

--领取成品
function FittingMediator:GetPeoductLineProduct()
    --没有可以领取的成品
    if self.receiveCount <= 0 then
        LogDebug("没有可以领取的成品")
        return
    end

    local TCSGetPeoductLineProduct = buildingHullFact_pb.TCSGetPeoductLineProduct()
    TCSGetPeoductLineProduct.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETPRODUCTLINEPRODUCT, TCSGetPeoductLineProduct:SerializeToString())
end

function FittingMediator:OnGetPeoductLineProduct(btsData)
    if btsData == nil then 
        LogDebug("FittingMediator:OnGetPeoductLineProduct btsData==nil")
        return
    end

    self:ShowAssemble()

    self:OpenTabItemNoRefresh()
end

function FittingMediator:OnHullProductClick(notify)
    local body = notify:GetBody()

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

function FittingMediator:JumHull()
    local buildingDataList = self.planetaryProxy:GetBuildingDataByType(common_pb.MODFACT)
    if self.planetaryProxy == nil then
        self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    end

    if #buildingDataList > 0 then
        local buildingData = buildingDataList[1]

        self.planetaryProxy:SetCurBuildingOper(
            {
                uid = GetServerTimeStamp(),
                nodeId = self.planetaryProxy:GetPlanetaryId(),
                targetBuilding = buildingData.id,
                configId = buildingData.buildingConfigId,
                type = 0,
                dynamicData = {}
            }
        )

        local callBack = {
            Self = self,
            Count = 1,
            Complete = 0,
            OnComplete = function(self)
                if self.Complete == self.Count then
                    self.Self:Close()
                    Facade:ReplacePanel("FormMainPanel")
                end
            end,
            OnUserMods = function(struct,btsData)
                local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
                local self = struct.Self
                if btsData == nil then
                    planetaryProxy:SetUserMods({})
                else
                    local TSCUserMods = buildingModFact_pb.TSCUserMods()
                    TSCUserMods:MergeFromString(btsData)

                    planetaryProxy:SetUserMods(TSCUserMods.mods)
                end

                struct.Complete = struct.Complete + 1
                ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self)
                struct:OnComplete()
            end
        }

        ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), callBack.OnUserMods, callBack)
        local TCSUserMods = buildingModFact_pb.TCSUserMods()
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
    else
        OpenMessageBox(NotiConst.MessageBoxType.Tip, "请先建造造船厂")
    end
end

return FittingMediator