local CollectMediator = class("CollectMediator", MediatorDynamic)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local resPath = 'ModelFBX/Solarsystem/Buildings/'

function CollectMediator:OnRegister()
    self.collectPanel = self:GetViewComponent()
    self.uiBinder = self.collectPanel.uiBinder
    self.resourceTableView = self.uiBinder.m_ResourcesScrollView:GetComponent("NTableView")
    --self.starTableView = self.uiBinder.m_StarsScrollView:GetComponent("NTableView")
    --3D物体需要放在UIRoot外面，否则缩小太大，效果太差
    local planet3DTransform = self.uiBinder.m_CollectPlanet3D.transform
    planet3DTransform.parent = nil
    planet3DTransform.localScale = Vector3.one
    planet3DTransform.localPosition = Vector3.New(50000,0,0)
    self.buildingTransform = self.uiBinder.m_Builiding3D.transform

    --不需要显示行星和选择行星，屏蔽掉
    --[[
    self.planetPoolTransform = self.uiBinder.m_PlanetPool.transform
    
    --保存每一个tablecell对应的生成rendertexture相关信息,渲染tablecell,就是对其对应的生成rendertexture进行设置
    self.planet3DTable = {} 
    for i= 1,7 do
        local name = string.format( "3DPlanet%d",i)
        local planetObj = planet3DTransform:Find(name).gameObject
        local planetTransform = planetObj.transform
        planetObj:SetActive(false)
        local planetItem = {}
        planetItem["Obj"] = planetObj
        planetItem["Camera"] = planetTransform:Find("RenderCamera"):GetComponent("Camera")
        planetItem["PlanetParent"] = planetTransform:Find("PlanetParent").transform
        planetItem["PlanetId"] = -1
        table.insert(self.planet3DTable,planetItem)
    end
    ]]
    self.uiBinder.m_backpack_GameObject:SetActive(false)

    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self,self.OnClickClosePanel)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_Button_mineral.gameObject)
    NLuaClickEvent:AddClick(self,self.OnClickOpenMineral)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_MineraSelect_Button.gameObject)
    NLuaClickEvent:AddClick(self,self.OnClickStartCollect)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_CloseMineral_Button.gameObject)
    NLuaClickEvent:AddClick(self,self.OnClickCloseMineral)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ReceiveSign.gameObject)
    NLuaClickEvent:AddClick(self,self.OnClickReceive)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_FullSign.gameObject)
    NLuaClickEvent:AddClick(self,self.OnClickFull)

    self.buildingObj = nil
    self.collectCount = 0

    --self:RegisterObserver("Set3DPlanet","Set3DPlanet")
end

function CollectMediator:ShowUI( )
    self.curBuildingOper = planetaryProxy:GetCurBuildingOper()
    planetaryProxy:SetCollectablePlanetIds()

    local buildingConfigData = planetaryProxy:GetBuildingConifData(self.curBuildingOper.configId)
    local name = buildingConfigData.data[buildingConfigData.EVar["bldg_name_s"]]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("BuildingAttribute", name)
    self.m_viewComponent.uiBinder.m_LabelLv.text = string.format("Lv.%s", level)

    --self:InstantiatePlanet3D()
    self:InstantiateBuilding()
    self.uiBinder.m_CollectPlanet3D:SetActive(true)
    self:RefreshMineralUI()

    --self.starTableView:ScrollResetPosition()
    --local planetCount = planetaryProxy:GetCollectablePlanetsCount()
    --Facade:SendNotification("ShowCollectStars",planetCount)

    --不再选择星球，默认取一个星球
    self.curBuildingOper.dynamicData.planetId = planetaryProxy:GetCollectablePlanetIds()[1]

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.COLLECTIONPLANTSTART), self.CollectionPlantStartCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.COLLECTIONPLANTCOLLECT), self.CollectionPlantReceiveCallback, self)
end

--显示矿物相关的UI
function  CollectMediator:RefreshMineralUI()
    local resourceId = self.curBuildingOper.dynamicData.resourceId
    local planetId = self.curBuildingOper.dynamicData.planetId
    local collectInfo = self.curBuildingOper.dynamicData.collectInfo
    self.collectCount = collectInfo.remainingCount
    --矿物信息
    local name,frame,icon = storehouseProxy:GetItemBaseData(resourceId)
    local fineness = planetaryProxy:GetResourceFineness(planetId,resourceId)
    --采集场已有矿物的显示
    local showCollectResource = function ()
        self.uiBinder.m_Collect_Frame.spriteName = frame
        self.uiBinder.m_Collect_Icon.mainTexture = icon
    end
    --已选择的矿物显示
    local showSelectedResource = function ()
        self.uiBinder.m_Mineral_Name.text = GetLanguageText("ItemName",name)
        self.uiBinder.m_Mineral_Frame.spriteName = frame
        self.uiBinder.m_Mineral_Icon.mainTexture = icon
        --[[
        --矿物纯度显示
        self.uiBinder.m_Mineral_ProgressBar.value = tostring(fineness/100)
        self.uiBinder.m_Mineral_Fineness.text = tostring(fineness)..tostring("%")
        ]]
    end

    self:ShowSign()

    local configId = self.curBuildingOper.configId
    local tableData = planetaryProxy:GetCollectFuncData(configId)
    local evar = tableData.Evar
    local data = tableData.data
    local maxCount = data[evar["max_cap_n"]]
    local value = planetaryProxy:GetValueAfterAddition(maxCount,"BLDG_SURF_COL","max_cap")
    maxCount = math.floor(value)
    self.collectPanel:StopAllCoroutines()
    self.uiBinder.m_Collect_ProgressBar.value = self.collectCount / maxCount
    if collectInfo.status  == 0 then
        if self.collectCount > 0 then
            self.uiBinder.m_CollectResource:SetActive(true)
            self.uiBinder.m_Collect_Time.gameObject:SetActive(false)
            self.uiBinder.m_Collect_Count.text = string.format("%d/%d",self.collectCount,maxCount)
            showCollectResource()
        else
            self.uiBinder.m_CollectResource:SetActive(false)
        end
        self.uiBinder.m_SelectMineral:SetActive(false)
        --self.uiBinder.m_Mineral_ProgressBar.gameObject:SetActive(false)
    else
        self.uiBinder.m_Collect_Time.gameObject:SetActive(true)
        self.uiBinder.m_CollectResource:SetActive(true)
        self.uiBinder.m_SelectMineral:SetActive(true)
        --self.uiBinder.m_Mineral_ProgressBar.gameObject:SetActive(true)
        showSelectedResource()
        showCollectResource()

        --矿物采集计时
        local speed = planetaryProxy:GetPlanetReourceProduceSpeed(fineness)
        local multiplier = storehouseProxy:GetItemProduceMultiplier(resourceId)
        speed = speed * multiplier
        local speed_coeff = data[evar["mining_spd_coeff_n"]]
        local minTime = data[evar["min_col_intvl_n"]]
        local additionId_speed = planetaryProxy:GetAdditionId("BLDG_SURF_COL","mining_spd_coeff")
        local percentageValue_speed,absoluteValue_speed = planetaryProxy:GetAdditionValue(additionId_speed)
        local addition_speed = (speed_coeff + absoluteValue_speed) * (1 + percentageValue_speed / 100)
        speed = math.floor(speed * addition_speed / 100)
        
        self.uiBinder.m_LabelValue01.text = StringFormat(GetLanguageText("MiningStation", "ResourceEfficiencyN1"), speed)
        self.uiBinder.m_LabelAdd.text = StringFormat(GetLanguageText("MiningStation", "ResourceEfficiencyN2"), addition_speed)

        self.collectPanel:StartCoroutine(self.UpdateCollectTime,self,speed,minTime,maxCount)
    end
end

function CollectMediator:UpdateCollectTime(self,speed,minTime,maxCount)
    local startTime = self.curBuildingOper.dynamicData.collectInfo.startTime /1000
    local remainCount = self.curBuildingOper.dynamicData.collectInfo.remainingCount
    while true do
        local serverTime = GetServerTimeStamp()
        local time = math.max(serverTime - startTime,0)
        local count = math.floor(speed * minTime / 3600) * math.floor(time / minTime)
        self.collectCount = math.min(count + remainCount,maxCount)
        self.uiBinder.m_Collect_Count.text = string.format("%d/%d",self.collectCount,maxCount)
        self:ShowSign()
        self.uiBinder.m_Collect_ProgressBar.value = self.collectCount / maxCount
        if self.collectCount >= maxCount then
            self.uiBinder.m_Collect_Time.gameObject:SetActive(false)
            break
        else
            self.uiBinder.m_Collect_Time.gameObject:SetActive(true)
            local remainderTime = time % minTime
            self.uiBinder.m_Collect_Time.text = SecondToMinutes(minTime - remainderTime)
        end
        coroutine.wait(1)
    end
end

--可领取和满仓的标记显示
function CollectMediator:ShowSign()
    local isFull = storehouseProxy:IsStorehouseFull(self.curBuildingOper.nodeId)
    if self.collectCount <= 0 then
        self.uiBinder.m_ReceiveSign.gameObject:SetActive(false)
        self.uiBinder.m_FullSign.gameObject:SetActive(false)
    else
        if isFull then
            self.uiBinder.m_FullSign.gameObject:SetActive(true)
            self.uiBinder.m_ReceiveSign.gameObject:SetActive(false)
        else
            self.uiBinder.m_FullSign.gameObject:SetActive(false)
            self.uiBinder.m_ReceiveSign.gameObject:SetActive(true)
        end
    end
end


--3D模型相关---------------------------
--创建星球3D模型(进入收集界面创建所有需要的星球，并保存，离开时销毁。可优化到进入场景时创建与销毁)
function CollectMediator:InstantiatePlanet3D()
    --初始化保存的数据
    for i = 1, #self.planet3DTable do
        self.planet3DTable[i].Obj:SetActive(false)
        self.planet3DTable[i].Camera.targetTexture = nil
        self.planet3DTable[i].PlanetId = -1
    end

    local planetIds = planetaryProxy:GetCollectablePlanetIds()
    if planetIds == nil then
        return
    end
    --保存所有需要的星球3d模型
    self.planetPool = {}
    local count = planetaryProxy:GetCollectablePlanetsCount()
    for i = 1, count do
        local id = planetIds[i]
        local planetObj = planetaryProxy:GetPlanetDataByPlanetId(id).obj
        local newPlanet = UnityEngine.Object.Instantiate(planetObj)
        local childObj = newPlanet.transform:Find("Planet")
        if childObj ~= nil then
            childObj.gameObject:SetActive(false)
        end
        newPlanet.transform.parent = self.planetPoolTransform
        newPlanet.transform.localPosition = Vector3.zero
        local str = tostring(id)
        self.planetPool[id + 1] = newPlanet         --id是从0开始的，不能作为key直接保存
    end
end

--创建采集3d建筑
function CollectMediator:InstantiateBuilding()
    local configId = self.curBuildingOper.configId
    local configData = planetaryProxy:GetBuildingConifData(configId)
    local prefabName = configData.data[configData.EVar["prefab_name_s"]]
    local buildingPrefab = ManagerResourceModule.LuaLoadBundle(resPath..prefabName..'.prefab')
    local buildingClone = UnityEngine.Object.Instantiate(buildingPrefab)
    local buildingTrans = buildingClone.transform
    buildingTrans.parent = self.buildingTransform
    buildingTrans.localScale = Vector3.one
    buildingTrans.localPosition = Vector3.zero
    buildingTrans.localRotation = Vector3.zero
    self.buildingObj = buildingClone
end

--显示星球
function CollectMediator:Set3DPlanet(notify)
    local data = notify:GetBody()
    local index = data.Index
    local texture = data.Texture
    local planetId = data.PlanetId
    local planetItem = self.planet3DTable[index]
    planetItem.Obj:SetActive(true)
    if planetItem.PlanetId ~= planetId then
        local oldPlanet = self.planetPool[planetItem.PlanetId + 1]
        if oldPlanet ~= nil then
            oldPlanet.transform.parent = self.planetPoolTransform
            oldPlanet.transform.localPosition = Vector3.zero
        end
        planetItem.Camera.targetTexture = texture
        local planetParentTrans = planetItem.PlanetParent
        local newPlanet = self.planetPool[planetId + 1]
        newPlanet.transform.parent = planetParentTrans
        newPlanet.transform.localPosition = Vector3.zero
        newPlanet.transform.localScale = Vector3.one
        self.planet3DTable[index].PlanetId = planetId
    end
end

--点击事件相关-------------------------------------------------------
--领取按钮事件
function CollectMediator:OnClickReceive()
    if self.collectCount > 0 then
        local TCSCollectionPlantCollect = buildingCollectionPlant_pb.TCSCollectionPlantCollect()
        TCSCollectionPlantCollect.buildingId = self.curBuildingOper.targetBuilding
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.COLLECTIONPLANTCOLLECT, TCSCollectionPlantCollect:SerializeToString())
    end    
end

--点击满仓标识事件
function CollectMediator:OnClickFull()
    OpenMessageBox(NotiConst.MessageBoxType.Tip,"仓库已满")
end

--打开资源窗口
function CollectMediator:OnClickOpenMineral()
    local isFull = storehouseProxy:IsStorehouseFull(self.curBuildingOper.nodeId)
    if isFull or self.collectCount > 0 then
        return
    else
        self.uiBinder.m_backpack_GameObject:SetActive(true)
        local selectPlanet = self.curBuildingOper.dynamicData.planetId
        local resourceCount = planetaryProxy:GetPlanetCollectResourcesCount(selectPlanet)
        self.resourceTableView:ScrollResetPosition()
        Facade:SendNotification("ShowCollectMineral",resourceCount)
        if self.curBuildingOper.dynamicData.collectInfo.status ~= 0 then
            self.curBuildingOper.dynamicData.oldResourceId = self.curBuildingOper.dynamicData.resourceId
        else
            self.curBuildingOper.dynamicData.oldResourceId = 0
        end
    end
end

--关闭当前界面
function CollectMediator:OnClickClosePanel()
    --关闭前清除3d模型
    if self.planetPool ~= nil then
        for key,value in pairs(self.planetPool) do
            UnityEngine.Object.Destroy(value)
        end
        self.planetPool = nil
    end

    if self.buildingObj ~= nil then
        UnityEngine.Object.Destroy(self.buildingObj)
        self.buildingObj = nil
    end
    self.uiBinder.m_CollectPlanet3D:SetActive(false)

    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.COLLECTIONPLANTSTART), self.CollectionPlantStartCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.COLLECTIONPLANTCOLLECT), self.CollectionPlantReceiveCallback)

    Facade:BackPanel()
end

--关闭资源选择界面  
function CollectMediator:OnClickCloseMineral()
    self.uiBinder.m_backpack_GameObject:SetActive(false)
end

--开始或取消采集
function CollectMediator:OnClickStartCollect()
    if self.curBuildingOper.dynamicData.resourceId == self.curBuildingOper.dynamicData.oldResourceId then
        if self.curBuildingOper.dynamicData.resourceId == 0 then
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"未选择采集资源")
        else
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"已选择采集该资源")
        end
        return
    end
    if self.curBuildingOper.dynamicData.resourceId ~= 0 and self.collectCount > 0 then
        self:OnClickCloseMineral()
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"请先领取已产出的资源，再更改采集资源")
        return 
    end

    local TCSCollectionPlantStart = buildingCollectionPlant_pb.TCSCollectionPlantStart()
    TCSCollectionPlantStart.buildingId = self.curBuildingOper.targetBuilding
    TCSCollectionPlantStart.planetId = self.curBuildingOper.dynamicData.planetId
    TCSCollectionPlantStart.resourceId = self.curBuildingOper.dynamicData.resourceId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.COLLECTIONPLANTSTART, TCSCollectionPlantStart:SerializeToString())
end

--开始采集回调
function CollectMediator:CollectionPlantStartCallback(stData)
    if stData ~= nil then
        local TSCCollectionPlantStart = buildingCollectionPlant_pb.TSCCollectionPlantStart()
        TSCCollectionPlantStart:MergeFromString(stData)
        self.curBuildingOper.dynamicData.collectInfo = TSCCollectionPlantStart.collectInfo
        self:RefreshMineralUI()
        --修改建筑的getItemTime数据，用于外部建筑可领取的显示
        planetaryProxy:SetBuildingData_GetItemTime(TSCCollectionPlantStart.nodeBuilding)
    
    else
        self.curBuildingOper.dynamicData.resourceId = 0
    end
    self.curBuildingOper.dynamicData.oldResourceId = 0
    self.uiBinder.m_backpack_GameObject:SetActive(false)
end

--领取监听回调
function CollectMediator:CollectionPlantReceiveCallback(stData)
    if stData ~= nil then
        local TSCCollectionPlantCollect = buildingCollectionPlant_pb.TSCCollectionPlantCollect()
        TSCCollectionPlantCollect:MergeFromString(stData)
        self.curBuildingOper.dynamicData.collectInfo = TSCCollectionPlantCollect.collectInfo
        self:RefreshMineralUI()
        planetaryProxy:SetBuildingData_GetItemTime(TSCCollectionPlantCollect.building)
    end
end

return CollectMediator