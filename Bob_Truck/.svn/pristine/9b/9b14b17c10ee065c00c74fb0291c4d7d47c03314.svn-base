local RefineryMediator = class("RefineryMediator", MediatorDynamic)

function RefineryMediator:OnRegister()
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    --[[NLuaClickEvent = NLuaClickEvent.Get(self.mviewComponent.uiBinder.m_MenuCancel.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseSetNumPanel)]]

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonGetResult.gameObject)
    NLuaClickEvent:AddClick(self, self.GetRefineryResult)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonOperate.gameObject)
    NLuaClickEvent:AddClick(self, self.StartRefinery)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_ButtonCancel.gameObject)
    NLuaClickEvent:AddClick(self, self.EndRefinery)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_MineralSlot.gameObject)
    NLuaClickEvent:AddClick(self, self.ReplaceItem)


    self:RegisterObserver(NotiConst.Notify_RefinerySelectMine,"ListItemChangeSelect")
    self:RegisterObserver('FormModelOpenTabItem',"SetMineList")
    --[[self:RegisterObserver(NotiConst.Notify_RefinerySelectMineAdd,"AddNum")
    self:RegisterObserver(NotiConst.Notify_RefinerySelectMineReduce,"CutDownNum")
    self:RegisterObserver(NotiConst.Notify_RefinerySelectMineMax,"MaxNum")
    self:RegisterObserver(NotiConst.Notify_RefinerySelectMineOK,"Sure")
    self:RegisterObserver(NotiConst.Notify_RefinerySelectMineChange,"OnChange")]]
    
end

function RefineryMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.editItem = {}
    self.itemData = {}
    self.lastSubViewDataIndex = 0
    self.lastSubViewCellIndex = 0
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYSTART), self.OnRefineryStart, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYEND), self.OnRefineryEnd, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYCOLLECT), self.OnRefineryCollect, self)

    local buildingData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local level = buildingData.data[buildingData.EVar["bldg_lvl_n"]]
    local refnyData = DATA_BLDG_REFNY[level]
    self.maxCount = refnyData[DATA_BLDG_REFNY.EVar["max_refine_qty_n"]]
    self.maxCount = self.planetaryProxy:GetValueAfterAddition(self.maxCount,"BLDG_REFNY","max_refine_qty")
    self.speed = refnyData[DATA_BLDG_REFNY.EVar["refine_spd_coeff_n"]]
    self.speed = self.planetaryProxy:GetValueAfterAddition(self.speed,"BLDG_REFNY","refine_spd_coeff")

    self.refineryInfo = self.curBuilding.dynamicData
    self.refineryState = 0 --0:未生产，1：正在生产，2：生产完成, 3:正在添加原料
    self.startTime = 0
    self.endTime = 0
    self.continuedTime = 0
    self.m_viewComponent.uiBinder.m_RemainTimeNum.gameObject:SetActive(true)
    self.m_viewComponent.uiBinder.m_RemainTimeName.gameObject:SetActive(true)
    if self.refineryInfo.item ~= nil and self.refineryInfo.item.id > 0 then
        
        if self.refineryInfo.startTime > 0 and self.refineryInfo.endTime > 0 then
            self.endTime = self.refineryInfo.endTime
            self.startTime = self.refineryInfo.startTime
            self.continuedTime = self.endTime - self.startTime

            local curTime = GetServerTimeStamp()
            if curTime >= self.endTime then
                self.refineryState = 2
            else
                self.refineryState = 1

                self.updateBeat = UpdateBeat
                self.updateBeat:Remove(self.Update, self)
                self.updateBeat:Add(self.Update, self)
            end
        else
            self.refineryState = 3
        end

        --原料
        self.m_viewComponent.uiBinder.m_CurMine:SetActive(true)
        self.m_viewComponent.uiBinder.m_PutSig.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_Label_Purity.text = self.refineryInfo.item.baseValue
        local configData = self.storehouseProxy:GetItemConfigData(self.refineryInfo.item.id)
        local name_s = configData.relation["name_s"]
        self.m_viewComponent.uiBinder.m_InputName.text = configData.data[configData.EVar[name_s]]
        self.m_viewComponent.uiBinder.m_AmountNum.text = string.format("%d/%d", self.refineryInfo.item.num, self.maxCount)
        self.m_viewComponent.uiBinder.m_ProgressBar.value = self.refineryInfo.item.num / self.maxCount
        local unit = configData.data[configData.EVar["stor_unit_n"]]*self.refineryInfo.item.num
        local remainTime = unit/self.speed*60*60
        self.m_viewComponent.uiBinder.m_RemainTimeNum.text = self.refineryState == 2 and 0 or SecondFormat(remainTime)
        
        --产出
        self.m_viewComponent.uiBinder.m_CurProduct:SetActive(true)
        self.m_viewComponent.uiBinder.m_NumSprite2.fillAmount = self.refineryState == 2 and 0 or 1

        local resId = configData.data[configData.EVar["result_id_n"]]
        local resData = self.storehouseProxy:GetItemConfigData(resId)
        name_s = resData.relation["name_s"]
        self.m_viewComponent.uiBinder.m_OutName.text = GetLanguageText("ItemName",resData.data[resData.EVar[name_s]])
        local ratio = configData.data[configData.EVar["cost_qty_n"]]
        self.m_viewComponent.uiBinder.m_iconOut.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(configData.data[configData.EVar["icon_name_s"]])
        self.m_viewComponent.uiBinder.m_NumLabelOut.text = self.refineryInfo.item.num/ratio
    else
        self.refineryState = 0
        self.m_viewComponent.uiBinder.m_AmountNum.text = string.format("%d/%d", 0, self.maxCount)
        self.m_viewComponent.uiBinder.m_ProgressBar.value = 0
        self.m_viewComponent.uiBinder.m_CurMine:SetActive(false)
        self.m_viewComponent.uiBinder.m_PutSig.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_CurProduct:SetActive(false)
    end

    self:SetMineList()
    self:RefreshView()

    local name = buildingData.data[buildingData.EVar["bldg_name_s"]]
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("BuildingAttribute", name)
    self.m_viewComponent.uiBinder.m_LabelLv.text = string.format("Lv.%s", level)
end


function RefineryMediator:SetOutput(simple)
    if self.refineryState == 0  then
        local configData = self.storehouseProxy:GetItemConfigData(self.editItem.id)
        local resId = configData.data[configData.EVar["result_id_n"]]
        local resData = self.storehouseProxy:GetItemConfigData(resId)
        local ratio = configData.data[configData.EVar["cost_qty_n"]]
        local name_s = resData.relation["name_s"]
        if not simple then
            self.m_viewComponent.uiBinder.m_CurProduct:SetActive(true)
            self.m_viewComponent.uiBinder.m_RemainTimeNum.gameObject:SetActive(false)
            self.m_viewComponent.uiBinder.m_RemainTimeName.gameObject:SetActive(false)
            self.m_viewComponent.uiBinder.m_OutName.text = GetLanguageText("ItemName",resData.data[resData.EVar[name_s]])
            self.m_viewComponent.uiBinder.m_iconOut.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(configData.data[configData.EVar["icon_name_s"]])
        end
        self.m_viewComponent.uiBinder.m_NumLabelOut.text = math.floor(self.reduceItem.num / ratio)
    end
end

function RefineryMediator:Update()
    local curTime = GetServerTimeStamp()
    if curTime >= self.endTime then
        self.refineryState = 2

        self.updateBeat:Remove(self.Update, self)

        self:RefreshView()
    else
        local ramainingTime = math.floor(self.endTime - curTime)
        self.m_viewComponent.uiBinder.m_RemainTimeNum.text = SecondFormat(ramainingTime)
        self.m_viewComponent.uiBinder.m_NumSprite2.fillAmount = ramainingTime / self.continuedTime
    end
end

function RefineryMediator:SetMineList(notification)
    self.lastSubViewDataIndex = 0
    self.lastSubViewCellIndex = 0
    local mode = 0
    if notification ~= nil then
        local body = notification:GetBody()
        mode = body
    else
        mode = self.mode
    end
    self.mode = mode
    self.storehouseProxy:InitRefineryData(self.curBuilding.nodeId, mode)
    local list = self.storehouseProxy:GetPackageData()
    
    
    Facade:SendNotification("RefineryMineLstNotify",#list)
    self.m_viewComponent.uiTableView:ResetState()
    self.m_viewComponent.uiTableView:ScrollResetPosition()
end

function RefineryMediator:RefreshView()
    if self.refineryState == 0 or  self.refineryState == 3 then
        self.m_viewComponent.uiBinder.m_ButtonGetResult.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonOperate.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonCancel.gameObject:SetActive(false)
    elseif self.refineryState == 1 then
        self.m_viewComponent.uiBinder.m_ButtonGetResult.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonOperate.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonCancel.gameObject:SetActive(true)
    elseif self.refineryState == 2 then
        self.m_viewComponent.uiBinder.m_ButtonGetResult.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_ButtonOperate.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_ButtonCancel.gameObject:SetActive(false)
    end
end

function RefineryMediator:Close()
    if self.updateBeat then
        self.updateBeat:Remove(self.Update, self)
    end

    if self.refineryState == 3 then
        self.storehouseProxy:AddItemByData(self.curBuilding.nodeId, self.curBuilding.dynamicData.item)
    end

    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYSTART), self.OnRefineryStart)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYEND), self.OnRefineryEnd)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.REFINERYCOLLECT), self.OnRefineryCollect)

    Facade:BackPanel()
end

function RefineryMediator:OnSelectedMine(index)
    
    local itemData = self.storehouseProxy:GetPackageDataByIndex(index)
    
    if itemData == nil then
        return
    end

    --if self.refineryInfo.item ~= nil and self.refineryInfo.item.id > 0 and itemData.id ~= self.refineryInfo.item.id then
    --    return
    --end

    --if  self.refineryInfo.item ~= nil and self.refineryInfo.item.num >= self.maxCount then
    --    return
    --end

    self.editItem = itemData
    --local configData = self.storehouseProxy:GetItemConfigData(itemData.id)
    --local name_s = configData.relation["name_s"]
    --self.itemData.name = configData.data[configData.EVar[name_s]]

    local configData = self.storehouseProxy:GetItemConfigData(self.editItem.id)
    self.ratio = configData.data[configData.EVar["cost_qty_n"]]
    self.numRatio = self.ratio
    --local result_id = configData.data[configData.EVar["result_id_n"]]
    --local resultConfigData = self.storehouseProxy:GetItemConfigData(result_id)
    --self.resultName = resultConfigData.data[resultConfigData.EVar[resultConfigData.relation["name_s"]]]
    --self.m_viewComponent.uiBinder.m_Label_RatioVal.text = configData.data[configData.EVar[configData.relation["name_s"]]]..'X'..self.ratio..'/'..self.resultName..'X1'

    --self.m_viewComponent.uiBinder.m_Label_ConsumpVal.text = configData.data[configData.EVar[configData.relation["name_s"]]]

    return self:OpenSetNumPanel()
end

--打开设置界面
function RefineryMediator:OpenSetNumPanel()
    self.itemCount = self.editItem.num
    self.maxCreateCount = math.floor(self.itemCount / self.ratio) * self.ratio
    self.reduceItem = {id = self.editItem.id, num = 0}
    self.maxNumRatio = math.floor(self.itemCount * 0.03)
    return self:SetNum(0)
end

function RefineryMediator:CloseSetNumPanel()
    self.m_viewComponent.uiTableView:CloseSubViewAll(false)
    --self.m_viewComponent.uiBinder.m_ItemSellNum:SetActive(false)
end



function RefineryMediator:OnChange()
    --[[self.m_viewComponent.uiBinder.m_Label_ResultVal.text = self.resultName..'X'..math.floor(tonumber(self.m_viewComponent.uiBinder.m_Label_Num.value) / self.ratio)]]
end

function RefineryMediator:Sure()
    --todobycn
    if self.refineryState ~= 3 and self.refineryState ~= 0 then
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"正在熔炼")
        return
    end

    if not self:IsEnoughElec(self.reduceItem) then
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"没有足够的电力")
        return
    end
    self:CloseSetNumPanel()
    if self.curBuilding.dynamicData.item == nil or self.curBuilding.dynamicData.item.id == 0 then
        self.curBuilding.dynamicData.item = {id = self.reduceItem.id, num = self.reduceItem.num, baseValue = self.editItem.baseValue}
    else
        self.curBuilding.dynamicData.item.num = self.curBuilding.dynamicData.item.num + self.reduceItem.num
    end
    self.storehouseProxy:UseItemByNum(self.curBuilding.nodeId, self.reduceItem.id, self.reduceItem.num)
    self:InitData()
    self:StartRefinery()
end

--更换原料
function RefineryMediator:ReplaceItem()
    if self.refineryState == 3 then
        self.storehouseProxy:AddItemByData(self.curBuilding.nodeId, self.curBuilding.dynamicData.item)

        self.curBuilding.dynamicData = {
            item = nil,
            startTime = 0,
            endTime = 0,
        }
        self:InitData()
    end
end

--开始提炼
function RefineryMediator:StartRefinery()
    if self.refineryInfo.item == nil or self.refineryInfo.item.id == 0 then
        OpenMessageBox(NotiConst.MessageBoxType.Confirm,"选择啊!","信息")
        return
    end

    local TCSRefineryStart = buildingRefinery_pb.TCSRefineryStart()
    TCSRefineryStart.buildingId = self.curBuilding.targetBuilding
    TCSRefineryStart.resId = self.refineryInfo.item.id
    TCSRefineryStart.resNum = self.refineryInfo.item.num
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.REFINERYSTART, TCSRefineryStart:SerializeToString())
end

function RefineryMediator:IsEnoughElec(data)
    local configData = self.storehouseProxy:GetItemConfigData(data.id)
    local needElec = configData.data[configData.EVar.ele_cost_n] * (data.num / self.ratio)
    local info = self.planetaryProxy:GetElecMsg()
    if info.restOfElect >= needElec then
        return true
    else
        return false
    end
end

function RefineryMediator:OnRefineryStart(btsData)
    if btsData == nil then 
        LogDebug("RefineryMediator:OnStartRefinery btsData==nil")
        return
    end

    local TSCRefineryStart = buildingRefinery_pb.TSCRefineryStart()
    TSCRefineryStart:MergeFromString(btsData)

    if TSCRefineryStart.endTime ~= -1 then
        local buildingData = {id = TSCRefineryStart.buildingId, getItemTime = TSCRefineryStart.endTime}
        self.planetaryProxy:SetBuildingData_GetItemTime(buildingData)
    end

    self.planetaryProxy:SaveElecMsg(TSCRefineryStart.elecMsg)
    Facade:SendNotification(NotiConst.Notify_UpdatElecInfo)

    self.curBuilding.dynamicData = {
        item = TSCRefineryStart.item,
        startTime = TSCRefineryStart.startTime/1000,
        endTime = TSCRefineryStart.endTime/1000,
    }
    self:InitData()
end

--结束提炼
function RefineryMediator:EndRefinery()
    local TCSRefineryEnd = buildingRefinery_pb.TCSRefineryEnd()
    TCSRefineryEnd.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.REFINERYEND, TCSRefineryEnd:SerializeToString())
end

function RefineryMediator:OnRefineryEnd(btsData)
    if btsData == nil then 
        LogDebug("RefineryMediator:OnRefineryEnd btsData==nil")
        return
    end

    local TSCRefineryEnd = buildingRefinery_pb.TSCRefineryEnd()
    TSCRefineryEnd:MergeFromString(btsData)
    if TSCRefineryEnd.result == 1 then
        self.curBuilding.dynamicData = {
            item = nil,
            startTime = 0,
            endTime = 0,
        }

        if self.updateBeat then
            self.updateBeat:Remove(self.Update, self)
        end

        self:InitData()
    else
        OpenMessageBox(NotiConst.MessageBoxType.Confirm,"失败","错误")
    end
end

--领取
function RefineryMediator:GetRefineryResult()
    local TCSRefineryCollect = buildingRefinery_pb.TCSRefineryCollect()
    TCSRefineryCollect.buildingId = self.curBuilding.targetBuilding
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.REFINERYCOLLECT, TCSRefineryCollect:SerializeToString())
end

function RefineryMediator:OnRefineryCollect(btsData)
    if btsData == nil then 
        LogDebug("RefineryMediator:OnRefineryCollect btsData==nil")
        return
    end

    local TSCRefineryCollect = buildingRefinery_pb.TSCRefineryCollect()
    TSCRefineryCollect:MergeFromString(btsData)
    if TSCRefineryCollect.result == 1 then
        self.curBuilding.dynamicData = {
            item = nil,
            startTime = 0,
            endTime = 0,
        }

        self:InitData()

        OpenMessageBox(NotiConst.MessageBoxType.Confirm,"领取成功","信息")
    else
        OpenMessageBox(NotiConst.MessageBoxType.Confirm,"失败","错误")
    end
end

function RefineryMediator:ListItemChangeSelect(notification)
    self.tableView = self.m_viewComponent.uiTableView
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


function RefineryMediator:SetNum(num)
    --local sprite = self.m_viewComponent.uiBinder.m_Sprite_MenuOk.transform:GetComponent('UIEventGraySprite')
    local valid = true
    if num == 0 then
        --sprite:SetGray()
        valid = false
        --self.m_viewComponent.uiBinder.m_MenuOk.isEnabled = false
        
    else
        --sprite:SetNormal()
    end
    self.reduceItem.num = num
    self:SetOutput(true)
    return valid,num
end

function RefineryMediator:CutDownNum(num_)
    local num = num_ - self.numRatio
    if num >= 0 then
        return self:SetNum(num)
    end
    return false,0
end

function RefineryMediator:AddNum(num_)
    local num = num_ + self.numRatio
    if num <= self.maxCreateCount then
        return self:SetNum(num)
    end
    return false,self.maxCreateCount
end

function RefineryMediator:MaxNum()
    local valid,num = self:SetNum(self.maxCreateCount)
    return false,num
end

-- 加倍单次数量改变量 用于实现长按增速越来越快
function RefineryMediator:DoubleNumRatio()
    if self.numRatio >= self.maxNumRatio then return end

    local newRatio = math.min(math.ceil(self.numRatio * 1.05), self.maxNumRatio)
    
    --必须是3的倍数
    while newRatio % 3 ~= 0 do
        newRatio = newRatio + 1
    end
    self.numRatio = newRatio
end

function RefineryMediator:ResetNumRatio()
    self.numRatio = self.ratio
end

return RefineryMediator