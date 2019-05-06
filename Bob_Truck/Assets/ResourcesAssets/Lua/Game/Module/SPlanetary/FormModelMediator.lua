local FormModelMediator = class("FormModelMediator", MediatorDynamic)

local ShipHullType = NotiConst.ShipHullType
local UnitySetPos = GameObjectUtil.SetPosition
local UnitySetScale = GameObjectUtil.SetScale
local UnityEngine_Object_Instantiate = UnityEngine.Object.Instantiate
local UnitySetUITextureMainTex = GameObjectUtil.SetUITextureMainTex
local SetLocalRotation = GameObjectUtil.SetLocalRotation
local SetLocalPosition = GameObjectUtil.SetLocalPosition
local UnityScrPickCastFloor = GameObjectUtil.ScreenPickCastFloor
local UIPos2ScreenPoint = GameObjectUtil.UIPos2ScreenPoint
local ScreenPoint2UIPos = GameObjectUtil.ScreenPoint2UIPos
local UnityInput = UnityEngine.Input
local math_floor = math.floor

function FormModelMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    self.firstOpen = true
    self.cnptViewList = {}
    table.insert(self.cnptViewList, {detail = self.m_viewComponent.uiBinder.m_Sprite_PartsIcon1, add = self.m_viewComponent.uiBinder.m_Sprite_PartsBG1.gameObject})
    table.insert(self.cnptViewList, {detail = self.m_viewComponent.uiBinder.m_Sprite_PartsIcon2, add = self.m_viewComponent.uiBinder.m_Sprite_PartsBG2.gameObject})
    table.insert(self.cnptViewList, {detail = self.m_viewComponent.uiBinder.m_Sprite_PartsIcon3, add = self.m_viewComponent.uiBinder.m_Sprite_PartsBG3.gameObject})
    table.insert(self.cnptViewList, {detail = self.m_viewComponent.uiBinder.m_Sprite_PartsIcon4, add = self.m_viewComponent.uiBinder.m_Sprite_PartsBG4.gameObject})

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Close.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Replace.gameObject)
    NLuaClickEvent:AddClick(self, self.OpenChangeModPanel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_No.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Yes.gameObject)
    NLuaClickEvent:AddClick(self, self.Edit)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Sprite_PeopleBGBox.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseChangeModPanel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Mod_Close.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseChangeModPanel)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Sprite_PartsBGBox.gameObject)
    NLuaClickEvent:AddClick(self, self.CloseCpntPanel)

    for i=1,#self.cnptViewList do
        NLuaClickEvent = NLuaClickEvent.Get(self.cnptViewList[i].add)
        NLuaClickEvent:AddClick(self, self.OpenCpntPanel)

        NLuaClickEvent = NLuaClickEvent.Get(self.cnptViewList[i].detail.gameObject)
        NLuaClickEvent:AddClick(self, self.DelCpnt, {index = 1})
    end

    self:RegisterObserver(NotiConst.Notify_FormModelOpenTabItem, "OpenTabItem")
    self:RegisterObserver(NotiConst.Notify_FormModelChangeMod, "ChangeMod")
    self:RegisterObserver(NotiConst.Notify_FormModelAddCpnt, "AddCpnt")
    self:RegisterObserver(NotiConst.Notify_FormModelOnDrag, "OnDrag")
    self:RegisterObserver(NotiConst.Notify_FormModelOnDragStart, "OnDragStart")
    self:RegisterObserver(NotiConst.Notify_FormModelOnDragEnd, "OnDragEnd")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ADDUSERMOD), self.OnAdd, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.EDITMOD), self.OnModify, self)

    self:InitGridGroup()
end

function FormModelMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.curTabIndex = 0
    self.curSelectedHullId = 0
    self.cnptList = {}
    self.hullList = {}

    self.type = self.curBuilding.dynamicData.type --0:新增，1：修改
    if self.type == 1 then
        self.modId = self.curBuilding.dynamicData.modelId -- 模板ID
        self.techId = self.curBuilding.dynamicData.mod.techID
        self.modData = self.planetaryProxy:GetShipModConfigDataById(self.techId)

        local cpntMats = self.curBuilding.dynamicData.mod.cpntMats
        for i=1,#cpntMats do
            table.insert(self.cnptList, cpntMats[i])
        end

        local hullParts = self.curBuilding.dynamicData.mod.hullParts
        for i=1,#hullParts do
            table.insert(self.hullList, hullParts[i])
        end

        self.m_viewComponent.uiBinder.m_Button_Replace.gameObject:SetActive(false)
        self.m_viewComponent.uiBinder.m_Label_Title.text = GetLanguageText("AssemblyCenter", "ACTitle2")
    else
        self.modData = self.planetaryProxy:GetShipModConfigDataByIndex(1)
        self.techId = self.modData.data.id

        self.m_viewComponent.uiBinder.m_Button_Replace.gameObject:SetActive(true)
        self.m_viewComponent.uiBinder.m_Label_Title.text = GetLanguageText("AssemblyCenter", "ACTitle")
    end

    if self.firstOpen == false then
        self.planetaryProxy:ResetModsUsedData()
        self.m_viewComponent.uiBinder.m_TabView:GetComponent("NTabView"):OpenTabItem(self.curTabIndex)
    end
    self.firstOpen = false

    self.planetaryProxy:LoadShipModCpntConfigData(self.techId)
    self:RefreshView()

    self:InitModelShow()
end

function FormModelMediator:RefreshView()
    self.m_viewComponent.uiBinder.m_Label_Name.text = GetLanguageText("ItemName",self.modData.data[self.modData.EVar["mod_tech_name_s"]])

    self.modType = self.modData.data[self.modData.EVar["ship_struct_dir_n"]]
    self.modSlotQty = self.modData.data[self.modData.EVar["slot_qty_n"]]

    for i=1,#self.cnptList do
        self.cnptViewList[i].detail.gameObject:SetActive(true)
        self.cnptViewList[i].add:SetActive(false)

        local cnptData = self.planetaryProxy:GetShipCpntConfigDataById(self.cnptList[i])
        self.cnptViewList[i].detail.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(cnptData.data[cnptData.EVar["icon_name_s"]])
    end

    for i=(#self.cnptList+1),#self.cnptViewList do
        self.cnptViewList[i].detail.gameObject:SetActive(false)
        self.cnptViewList[i].add:SetActive(true)
    end

    for i=(self.modSlotQty+1),#self.cnptViewList do
        self.cnptViewList[i].detail.gameObject:SetActive(false)
        self.cnptViewList[i].add:SetActive(false)
    end

    self.planetaryProxy:ResetModsUsedData()
end

function FormModelMediator:Close()
    self:ClearModelShow()
    self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(false)

    Facade:BackPanel()
end

function FormModelMediator:OpenTabItem(notification)
    local index = notification:GetBody()
    self.curTabIndex = index

    local hullType = self.curTabIndex
    self.planetaryProxy:LoadShipModHullConfigDataByType(self.techId)
    local shipHullData = self.planetaryProxy:GetShipModHullConfigDataByType(hullType)
    self.planetaryProxy:SetPackageShipHullData(shipHullData)
    Facade:SendNotification("FormModelPanelNotity", #shipHullData)
    self.m_viewComponent.uiBinder.m_SubPanel:GetComponent("NTableView"):ScrollResetPosition()
end

function FormModelMediator:OpenTabItemNoRefresh()
    local hullType = self.curTabIndex
    self.planetaryProxy:LoadShipModHullConfigDataByType(self.techId)
    local shipHullData = self.planetaryProxy:GetShipModHullConfigDataByType(hullType)
    self.planetaryProxy:SetPackageShipHullData(shipHullData)
    Facade:SendNotification("FormModelPanelNotity", #shipHullData)
end

function FormModelMediator:OpenChangeModPanel()
    self.m_viewComponent.uiBinder.m_GameObject_SkillList.gameObject:SetActive(true)
    self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(false)

    local modDataList = self.planetaryProxy:GetShipModConfigData()
    Facade:SendNotification("FormModelPanelModNotity", #modDataList)
end

function FormModelMediator:CloseChangeModPanel()
    self.m_viewComponent.uiBinder.m_GameObject_SkillList.gameObject:SetActive(false)
    self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(true)
end

function FormModelMediator:ChangeMod(notification)
    local index = notification:GetBody()
    self.modData = self.planetaryProxy:GetShipModConfigDataByIndex(index)
    self.techId = self.modData.data.id

    self:CloseChangeModPanel()
    self.cnptList = {}
    self.hullList = {}
    self.planetaryProxy:LoadShipModCpntConfigData(self.techId)
    self:RefreshView()

    self:ClearModelShow()
    self:ShowDefaultGrid()

    Facade:SendNotification(NotiConst.Notify_FormModelOpenTabItem, self.curTabIndex)
end

function FormModelMediator:OpenCpntPanel()
    self.m_viewComponent.uiBinder.m_GameObject_PartsList.gameObject:SetActive(true)
    self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(false)

    local cpntDataList = self.planetaryProxy:GetShipCpntConfigData()
    Facade:SendNotification("FormModelPanelCpntNotity", #cpntDataList)
end

function FormModelMediator:CloseCpntPanel()
    self.m_viewComponent.uiBinder.m_GameObject_PartsList.gameObject:SetActive(false)
    self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(true)
end

function FormModelMediator:AddCpnt(notification)
    local index = notification:GetBody()
    local cnptData = self.planetaryProxy:GetShipCpntConfigDataByIndex(index)
    self:CloseCpntPanel()
    table.insert(self.cnptList, cnptData.data.id)
    self:RefreshView()
end

function FormModelMediator:DelCpnt(data)
    table.remove(self.cnptList, data.index)
    self:RefreshView()
end

function FormModelMediator:OpenTips(content)
    self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(false)
    OpenMessageBox(NotiConst.MessageBoxType.Tip, content, "提示", {enterCallback = function()
        self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(true)
    end})
end

function FormModelMediator:Edit()
    --检测合理性
    if not (self.hasHead and self.hasBody and self.hasTail) then
        return 
    end

    if self.type == 1 then
        local  TCSEditMod = buildingModFact_pb.TCSEditMod()
        TCSEditMod.modId = self.modId
        for i,v in ipairs(self.gridGroup) do
            local HullPart = db_pb.HullPart()
            HullPart.hullId = v.hullId
            HullPart.attachIndex = v.index
            HullPart.attachPart = 0
            HullPart.left = v.left == nil and 0 or v.left
            HullPart.right = v.right == nil and 0 or v.right
            HullPart.front = v.front == nil and 0 or v.front
            HullPart.back = v.back == nil and 0 or v.back
            table.insert(TCSEditMod.hullParts, HullPart)
        end
        for i=1,#self.cnptList do
            table.insert(TCSEditMod.cpntMats, self.cnptList[i])
        end
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.EDITMOD, TCSEditMod:SerializeToString())
    else
        self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(false)
        self:RegisterObserver(NotiConst.Notify_FormModelInputName, "InputName")
        Facade:ReplacePanel("RenamePanel")
    end
end                                                                           

function FormModelMediator:InputName(notification)
    self:RemoveObserver(NotiConst.Notify_FormModelInputName)
    local modName = notification:GetBody()
    if modName == nil or modName == "" then
        self.m_viewComponent.uiBinder.m_HullTempModelShow:SetActive(true)
        return
    end

    local  TCSAddUserMod = buildingModFact_pb.TCSAddUserMod()
    TCSAddUserMod.techID = self.techId
    TCSAddUserMod.modName = modName
    TCSAddUserMod.buildingId = self.curBuilding.targetBuilding
    for i,v in ipairs(self.gridGroup) do
        local HullPart = db_pb.HullPart()
        HullPart.hullId = v.hullId
        HullPart.attachIndex = v.index
        HullPart.attachPart = 0
        HullPart.left = v.left == nil and 0 or v.left
        HullPart.right = v.right == nil and 0 or v.right
        HullPart.front = v.front == nil and 0 or v.front
        HullPart.back = v.back == nil and 0 or v.back
        table.insert(TCSAddUserMod.hullParts, HullPart)
    end
    for i=1,#self.cnptList do
        table.insert(TCSAddUserMod.cpntMats, self.cnptList[i])
    end

    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.ADDUSERMOD, TCSAddUserMod:SerializeToString())
end

function FormModelMediator:OnAdd(btsData)
    if btsData == nil then 
        LogDebug("FormModelMediator:OnAdd btsData==nil")
        return
    end

    local TSCAddUserMod = buildingModFact_pb.TSCAddUserMod()
    TSCAddUserMod:MergeFromString(btsData)
    if TSCAddUserMod.result then
        self.planetaryProxy:AddUserMod(TSCAddUserMod.mod)
        self.curBuilding.dynamicData.mod = TSCAddUserMod.mod
        Facade:BackPanel()
        self:Close()

        Facade:ReplacePanel("FormShowPanel")
    else
        LogError("FleetShipEditMediator:OnEditFleet Failed")
    end
end

function FormModelMediator:OnModify(btsData)
    if btsData == nil then 
        LogDebug("FormModelMediator:OnModify btsData==nil")
        return
    end

    local TSCEditMod = buildingModFact_pb.TSCEditMod()
    TSCEditMod:MergeFromString(btsData)
    if TSCEditMod.result then
        self.planetaryProxy:EditUserMod(TSCEditMod.mod)
        self:Close()
    else
        LogError("FleetShipEditMediator:OnEditFleet Failed")
    end
end

function FormModelMediator:InitGridGroup()
    local obj = self.m_viewComponent.uiBinder.m_HullTempModelShow
    self.grids = {}
    local grids = obj.transform:Find("Grids")
    for i=1,20 do
        local grid = grids:Find("grid"..i).gameObject
        table.insert(self.grids, grid)
    end
end

--初始化model show
function FormModelMediator:InitModelShow()
    local obj = self.m_viewComponent.uiBinder.m_HullTempModelShow
	obj:SetActive(true)
    self.ModelParent = obj.transform:Find("Model")
    self.ModelShowCam = obj.transform:Find("Camera"):GetComponent("Camera")
    self.DefaultModel = obj.transform:Find("Model/default").gameObject
    self.DefaultModel:SetActive(false)

    self.activeGrids = {}
    self.gridGroup = {}
    self.hasLoaded = {}
    self.off = 0.046
    self.halfOff = self.off*0.5
    self.extremeOff = 0.04
    self.index = 0
    if #self.hullList > 0 then
        for i,v in ipairs(self.hullList) do
            local grid = {}
            grid.hullId = v.hullId
            grid.left = v.left
            grid.right = v.right
            grid.front = v.front
            grid.back = v.back
            grid.index = v.attachIndex

            if grid.index > self.index then
                self.index = grid.index
            end

            table.insert(self.gridGroup, grid)
        end

        local grid = self.gridGroup[1]
        grid.x = 0
        grid.y = 0
        g_InstancesPool:NewInst(self:GetHullModelName(grid.hullId), self.OnEditHullModelLoaded, self, {grid = grid})
    end

    if self.type == 0 then
        self:ShowDefaultGrid()

        self:OpenChangeModPanel()
        self:CheckIsComplete()
    end
end

function FormModelMediator:GetHullModelName(hullId)
    local hullConfigData = self.planetaryProxy:GetShipHullConfigData(hullId)
    return "ModelFBX/ship/transport/"..hullConfigData.data[hullConfigData.EVar["prefab_name_s"]]..".prefab"
end

function FormModelMediator:CheckIsComplete()
    --检测合理性
    self.hasHead = false
    self.hasBody = false
    self.hasTail = false

    for i,v in ipairs(self.gridGroup) do
        local hullConfigData = self.planetaryProxy:GetShipHullConfigData(v.hullId)
        local hullType =  hullConfigData.data[hullConfigData.EVar["hull_type_n"]]
        if hullType == NotiConst.ShipHullType.eSHT_Head then
            self.hasHead = true
        elseif hullType == NotiConst.ShipHullType.eSHT_Body then
            self.hasBody = true
        elseif hullType == NotiConst.ShipHullType.eSHT_Tail then
            self.hasTail = true
        end
    end

    if self.hasHead and self.hasBody and self.hasTail then
        GameObjectUtil.SetButtonState(self.m_viewComponent.uiBinder.m_Button_Yes, 0)
        self.m_viewComponent.uiBinder.m_GameObject_Parts:SetActive(true)
        self.m_viewComponent.uiBinder.m_Label_NeedBody.text = ""
    else
        GameObjectUtil.SetButtonState(self.m_viewComponent.uiBinder.m_Button_Yes, 3)
        self.m_viewComponent.uiBinder.m_GameObject_Parts:SetActive(false)

        local tip = ""
        if not self.hasHead then
            tip = tip.."舰首"
        end
        if not self.hasBody then
            if tip ~= "" then
                tip = tip.."、"
            end
            tip = tip.."舰中"
        end
        if not self.hasTail then
            if tip ~= "" then
                tip = tip.."、"
            end
            tip = tip.."舰尾"
        end

        tip = "还缺少:"..tip

        self.m_viewComponent.uiBinder.m_Label_NeedBody.text = tip
    end
end

function FormModelMediator:ShowDefaultGrid()
    self.activeGrids = {}
    local grid = self.grids[1]
    grid:SetActive(true)
    SetLocalPosition(grid,0,0,0)
    table.insert(self.activeGrids, {obj = grid, x = 0, y = 0})

    SetLocalPosition(self.ModelParent.gameObject, 0, 0, 0)
    grid:SetActive(false)
    self:UpdateCamPos()
end

--修改模板时使用
function FormModelMediator:OnEditHullModelLoaded(obj, data)
    if obj == nil then 
        return
    end
    obj:SetActive(true)
    obj.layer = 5
    obj.transform.parent = self.ModelParent
    self:SetObjTransform(obj, data.grid.hullId)

    local grid = data.grid
    grid.modelObj = obj.transform
    local gridFrom = data.from

    local callBack = {
        Self = self,
        Index = grid.index,
        OnClick = function(data)
            local self = data.Self

            local corId = coroutine.create(self.RemoveHull)
            coroutine.resume(corId, self, data.Index)
        end
    }

    local NLuaClickEvent = NLuaClickEvent.Get(obj)
    NLuaClickEvent:Add3DClick(callBack, callBack.OnClick, self.ModelShowCam)

    if gridFrom then
        local pos = nil
        if gridFrom.left == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("left").position - grid.modelObj:Find("right").position
        elseif  gridFrom.right == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("right").position - grid.modelObj:Find("left").position
        elseif  gridFrom.front == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("front").position - grid.modelObj:Find("back").position
        elseif  gridFrom.back == grid.index then
            pos = grid.modelObj.position + gridFrom.modelObj:Find("back").position - grid.modelObj:Find("front").position
        end
        if pos then
            UnitySetPos(grid.modelObj.gameObject, pos.x, pos.y, pos.z)
        end
    end

    table.insert(self.hasLoaded, grid.index)

    if #self.hasLoaded == #self.hullList then
        self:UpdateCamPos()
        self:CheckIsComplete()
    end

    if grid.left ~= nil and grid.left > 0 and not self:IsLoaded(grid.left) then
        local tempGrid = self:GetGuidByIndex(grid.left)
        tempGrid.x = grid.x
        tempGrid.y = grid.y - 1
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnEditHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.right ~= nil and grid.right > 0 and not self:IsLoaded(grid.right) then
        local tempGrid = self:GetGuidByIndex(grid.right)
        tempGrid.x = grid.x
        tempGrid.y = grid.y + 1
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnEditHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.front ~= nil and grid.front > 0 and not self:IsLoaded(grid.front) then
        local tempGrid = self:GetGuidByIndex(grid.front)
        tempGrid.x = grid.x - 1
        tempGrid.y = grid.y
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnEditHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.back ~= nil and grid.back > 0 and not self:IsLoaded(grid.back) then
        local tempGrid = self:GetGuidByIndex(grid.back)
        tempGrid.x = grid.x + 1
        tempGrid.y = grid.y
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnEditHullModelLoaded, self, {grid = tempGrid, from = grid})
    end
end

function FormModelMediator:SetObjTransform(obj, hullId)
    SetLocalRotation(obj,0,-90,0)
    local hullConfigData = self.planetaryProxy:GetShipHullConfigData(hullId)
    local uiScale =  hullConfigData.data[hullConfigData.EVar["ui_scale_n"]]
    local scale = 8*uiScale*0.01
    UnitySetScale(obj,scale,scale,scale)
    SetLocalPosition(obj,0,0,0)
end

function FormModelMediator:UpdateCamPos()
    if self.ModelParent.childCount > 0 then
        local center = GameObjectUtil.GetCenter(self.ModelParent)
        UnitySetPos(self.ModelShowCam.gameObject, center.x, self.ModelShowCam.transform.position.y, center.z)
    else
        SetLocalPosition(self.ModelParent.gameObject, 0, 0, 0)
        UnitySetPos(self.ModelShowCam.gameObject, self.ModelParent.transform.position.x, self.ModelShowCam.transform.position.y, self.ModelParent.transform.position.z)
    end

    local bound = self:CalcGridBound()
    local defaultY = 150
    local defaultOffset = 36
    if bound.dist > 24 then
        local newY = bound.dist * defaultY * 0.9 / 24
        if newY < defaultY then
            newY = defaultY
        end
        defaultOffset = defaultOffset * newY / defaultY
        SetLocalPosition(self.ModelShowCam.gameObject, self.ModelShowCam.transform.localPosition.x, newY, self.ModelShowCam.transform.localPosition.z - defaultOffset)
    else
        SetLocalPosition(self.ModelShowCam.gameObject, self.ModelShowCam.transform.localPosition.x, defaultY, self.ModelShowCam.transform.localPosition.z - defaultOffset )
    end
end

function FormModelMediator:GetGuidByIndex(index)
    if index == nil or index == 0 then
        return nil
    end

    for i=1,#self.gridGroup do
        if self.gridGroup[i].index == index then
            return self.gridGroup[i]
        end
    end
    return nil
end

function FormModelMediator:IsLoaded(index)
    for i=1,#self.hasLoaded do
        if self.hasLoaded[i] == index then
            return true
        end
    end
    return false
end 

function FormModelMediator:ClearModelShow()
    local n = #self.gridGroup
    for i=1, n do 
        g_InstancesPool:DeleteInst(self.gridGroup[i].modelObj.gameObject)
    end
    self.gridGroup = {}
    self.index = 0
    self:ClearActiveGrids()
    self:UpdateCamPos()
end

function FormModelMediator:ClearActiveGrids()
    if #self.activeGrids > 0 then
        for i,v in ipairs(self.activeGrids) do
            v.obj:SetActive(false)
        end

        self.activeGrids = {}
    end
end

--计算网格可用性
function FormModelMediator:CalcGrid()
    local curHullConfigData = self.planetaryProxy:GetShipHullConfigData(self.curSelectedHullId)
    local count = 0

    local bound = self:CalcGridBound()

    for i=1,#self.gridGroup do
        local grid = self.gridGroup[i]
        local hullConfigData = self.planetaryProxy:GetShipHullConfigData(grid.hullId)

        if hullConfigData.data[hullConfigData.EVar["hull_slot_front_n"]] == 1 and (grid.front == nil or grid.front == 0) and curHullConfigData.data[curHullConfigData.EVar["hull_slot_back_n"]] == 1 then
            local allowed = true
            local x = grid.x - 1
            local y = grid.y
            local existGrid = self:GetGridByAxis(x, y)
            if existGrid ~= nil then
                allowed = false
            end
            if allowed and bound.limitX then
                allowed = x >= bound.minX and x <= bound.maxX
            end
            if allowed and bound.limitY then
                allowed = y >= bound.minY and y <= bound.maxY
            end

            if allowed then
                count = count + 1
                local gridObj = self.grids[count]
                local pos = grid.modelObj:Find("front").position
                UnitySetPos(gridObj, pos.x - self.halfOff, pos.y, pos.z)
                gridObj:SetActive(true)

                local result, activeGrid = self:CanMergeGrid(gridObj)
                if result then
                    activeGrid.back = grid.index
                    gridObj:SetActive(fasle)
                    count = count - 1
                else
                    table.insert(self.activeGrids, {obj = gridObj, back = grid.index, x = x, y = y})
                end
            end
        end

        if hullConfigData.data[hullConfigData.EVar["hull_slot_back_n"]] == 1 and (grid.back == nil or grid.back == 0) and curHullConfigData.data[curHullConfigData.EVar["hull_slot_front_n"]] == 1 then
            local allowed = true
            local x = grid.x + 1
            local y = grid.y
            local existGrid = self:GetGridByAxis(x, y)
            if existGrid ~= nil then
                allowed = false
            end
            if allowed and bound.limitX then
                allowed = x >= bound.minX and x <= bound.maxX
            end
            if allowed and bound.limitY then
                allowed = y >= bound.minY and y <= bound.maxY
            end

            if allowed then
                count = count + 1
                local gridObj = self.grids[count]
                local pos = grid.modelObj:Find("back").position
                UnitySetPos(gridObj, pos.x + self.halfOff, pos.y, pos.z)
                gridObj:SetActive(true)

                local result, activeGrid = self:CanMergeGrid(gridObj)
                if result then
                    activeGrid.front = grid.index
                    gridObj:SetActive(fasle)
                    count = count - 1
                else
                    table.insert(self.activeGrids, {obj = gridObj, front = grid.index, x = x, y = y})
                end
            end
        end
        
        if self.modType == 1 then
            if hullConfigData.data[hullConfigData.EVar["hull_slot_left_n"]] == 1 and (grid.left == nil or grid.left == 0) and curHullConfigData.data[curHullConfigData.EVar["hull_slot_right_n"]] == 1 then
                local allowed = true
                local x = grid.x
                local y = grid.y - 1
                local existGrid = self:GetGridByAxis(x, y)
                if existGrid ~= nil then
                    allowed = false
                end
                if allowed and bound.limitX then
                    allowed = x >= bound.minX and x <= bound.maxX
                end
                if allowed and bound.limitY then
                    allowed = y >= bound.minY and y <= bound.maxY
                end

                if allowed then
                    count = count + 1
                    local gridObj = self.grids[count]
                    local pos = grid.modelObj:Find("left").position
                    UnitySetPos(gridObj, pos.x, pos.y, pos.z - self.halfOff)
                    gridObj:SetActive(true)

                    local result, activeGrid = self:CanMergeGrid(gridObj)
                    if result then
                        activeGrid.right = grid.index
                        gridObj:SetActive(fasle)
                        count = count - 1
                    else
                        table.insert(self.activeGrids, {obj = gridObj, right = grid.index, x = x, y = y})
                    end
                end
            end

            if hullConfigData.data[hullConfigData.EVar["hull_slot_right_n"]] == 1 and (grid.right == nil or grid.right == 0) and curHullConfigData.data[curHullConfigData.EVar["hull_slot_left_n"]] == 1 then
                local allowed = true
                local x = grid.x
                local y = grid.y + 1
                local existGrid = self:GetGridByAxis(x, y)
                if existGrid ~= nil then
                    allowed = false
                end
                if allowed and bound.limitX then
                    allowed = x >= bound.minX and x <= bound.maxX
                end
                if allowed and bound.limitY then
                    allowed = y >= bound.minY and y <= bound.maxY
                end

                if allowed then
                    count = count + 1
                    local gridObj = self.grids[count]
                    local pos = grid.modelObj:Find("right").position
                    UnitySetPos(gridObj, pos.x, pos.y, pos.z + self.halfOff)
                    gridObj:SetActive(true)

                    local result, activeGrid = self:CanMergeGrid(gridObj)
                    if result then
                        activeGrid.left = grid.index
                        gridObj:SetActive(fasle)
                        count = count - 1
                    else
                        table.insert(self.activeGrids, {obj = gridObj, left = grid.index, x = x, y = y})
                    end
                end
            end
        else
            if hullConfigData.data[hullConfigData.EVar["hull_slot_top_n"]] == 1 and (grid.left == nil or grid.left == 0) and curHullConfigData.data[curHullConfigData.EVar["hull_slot_bottom_n"]] == 1 then
                local allowed = true
                local x = grid.x
                local y = grid.y - 1
                local existGrid = self:GetGridByAxis(x, y)
                if existGrid ~= nil then
                    allowed = false
                end
                if allowed and bound.limitX then
                    allowed = x >= bound.minX and x <= bound.maxX
                end
                if allowed and bound.limitY then
                    allowed = y >= bound.minY and y <= bound.maxY
                end

                if allowed then
                    count = count + 1
                    local gridObj = self.grids[count]
                    local pos = grid.modelObj:Find("left").position
                    UnitySetPos(gridObj, pos.x, pos.y, pos.z + self.halfOff)
                    gridObj:SetActive(true)

                    local result, activeGrid = self:CanMergeGrid(gridObj)
                    if result then
                        activeGrid.right = grid.index
                        gridObj:SetActive(fasle)
                        count = count - 1
                    else
                        table.insert(self.activeGrids, {obj = gridObj, right = grid.index, x = x, y = y})
                    end
                end
            end

            if hullConfigData.data[hullConfigData.EVar["hull_slot_bottom_n"]] == 1 and (grid.right == nil or grid.right == 0) and curHullConfigData.data[curHullConfigData.EVar["hull_slot_top_n"]] == 1 then
                local allowed = true
                local x = grid.x
                local y = grid.y + 1
                local existGrid = self:GetGridByAxis(x, y)
                if existGrid ~= nil then
                    allowed = false
                end
                if allowed and bound.limitX then
                    allowed = x >= bound.minX and x <= bound.maxX
                end
                if allowed and bound.limitY then
                    allowed = y >= bound.minY and y <= bound.maxY
                end

                if allowed then
                    count = count + 1
                    local gridObj = self.grids[count]
                    local pos = grid.modelObj:Find("right").position
                    UnitySetPos(gridObj, pos.x, pos.y, pos.z - self.halfOff)
                    gridObj:SetActive(true)

                    local result, activeGrid = self:CanMergeGrid(gridObj)
                    if result then
                        activeGrid.left = grid.index
                        gridObj:SetActive(fasle)
                        count = count - 1
                    else
                        table.insert(self.activeGrids, {obj = gridObj, left = grid.index, x = x, y = y})
                    end
                end
            end
        end
    end
end

--合并格子
function FormModelMediator:CanMergeGrid(newGrid)
    local result = false
    for i,v in ipairs(self.activeGrids) do
        local dir = newGrid.transform.position - v.obj.transform.position
        if dir.magnitude < self.extremeOff then
            return true, v
        end
    end
    return result, nil
end

--根据坐标获取
function FormModelMediator:GetGridByAxis(x, y)
    for i,v in ipairs(self.gridGroup) do
        if v.x == x and v.y == y then
            return v
        end
    end
    return nil
end

--计算边界盒子
function FormModelMediator:CalcGridBound()
    local maxX = 0
    local minX = 0
    local maxY = 0
    local minY = 0

    local maxPoint = 0
    local minPoint = 0

    for i=1,#self.gridGroup do
        local grid = self.gridGroup[i]
        local front = grid.modelObj:Find("front")
        local back = grid.modelObj:Find("back")

        if i == 1 then
            maxX = grid.x
            minX = grid.x
            maxY = grid.y
            minY = grid.y

            if front then
                minPoint = front.position.x
            else
                minPoint = back.position.x
            end
            if back then
                maxPoint = back.position.x
            else
                maxPoint = front.position.x
            end
        else
            if grid.x > maxX then
                maxX = grid.x
            end
            if grid.x < minX then
                minX = grid.x
            end
            if grid.y > maxY then
                maxY = grid.y
            end
            if grid.y < minY then
                minY = grid.y
            end

            if front and front.position.x < minPoint then
                minPoint = front.position.x
            end
            if back and back.position.x > maxPoint then
                maxPoint = back.position.x
            end
        end
    end

    local limitX = (maxX - minX) >= 4 and true or false
    local limitY = (maxY - minY) >= 2 and true or false
    local dist = (maxPoint - minPoint)*math.pow(10,2)

    --LogDebug("maxX = {0}, minX = {1}, limitX = {2}, maxY = {3}, minY = {4}, limitY = {5}", maxX, minX, limitX, maxY, minY, limitY)
    return {maxX = maxX, minX = minX, limitX = limitX, maxY = maxY, minY = minY, limitY = limitY, dist = dist}
end

function FormModelMediator:FunctionRef(grid)
    table.insert(self.hasLoaded, grid.index)

    if grid.left ~= nil and grid.left > 0 and not self:IsLoaded(grid.left) then
        local tempGrid = self:GetGuidByIndex(grid.left)
        if tempGrid then
            self:FunctionRef(tempGrid)
        end
    end

    if grid.right ~= nil and grid.right > 0 and not self:IsLoaded(grid.right) then
        local tempGrid = self:GetGuidByIndex(grid.right)
        if tempGrid then
            self:FunctionRef(tempGrid)
        end
    end

    if grid.front ~= nil and grid.front > 0 and not self:IsLoaded(grid.front) then
        local tempGrid = self:GetGuidByIndex(grid.front)
        if tempGrid then
            self:FunctionRef(tempGrid)
        end
    end

    if grid.back ~= nil and grid.back > 0 and not self:IsLoaded(grid.back) then
        local tempGrid = self:GetGuidByIndex(grid.back)
        if tempGrid then
            self:FunctionRef(tempGrid)
        end
    end
end

function FormModelMediator:RemoveHull(index)
    LogDebug("RemoveHull index {0}", index)
    coroutine.wait(0.1)

    local grid = nil
    for i=1,#self.gridGroup do
        if self.gridGroup[i].index == index then
            grid = self.gridGroup[i]
            table.remove(self.gridGroup, i)
            break
        end
    end

    if grid == nil then
        return
    end

    if #self.gridGroup > 1 then
        self.hasLoaded = {}
        self:FunctionRef(self.gridGroup[1])

        if #self.hasLoaded < #self.gridGroup then
            table.insert(self.gridGroup, grid)
            self:OpenTips("该部位不能拆除")
            return
        end
    end
    
    --清理关系
    if grid.left ~= nil and grid.left > 0 then
        local tempGrid = self:GetGuidByIndex(grid.left)
        if tempGrid then
            tempGrid.right = 0
        end
    end

    if grid.right ~= nil and grid.right > 0 then
        local tempGrid = self:GetGuidByIndex(grid.right)
        if tempGrid then
            tempGrid.left = 0
        end
    end

    if grid.front ~= nil and grid.front > 0 then
        local tempGrid = self:GetGuidByIndex(grid.front)
        if tempGrid then
            tempGrid.back = 0
        end
    end

    if grid.back ~= nil and grid.back > 0 then
        local tempGrid = self:GetGuidByIndex(grid.back)
        if tempGrid then
            tempGrid.front = 0
        end
    end

    g_InstancesPool:DeleteInst(grid.modelObj.gameObject)

    if #self.gridGroup == 0 then
        self:ShowDefaultGrid()
    else
        self:UpdateCamPos()
    end

    self:CheckIsComplete()
end

--模型拼接
function FormModelMediator:OnDragStart(notification)
    local hullId = notification:GetBody()
    self.m_viewComponent.uiBinder.m_DragScrollView:SetActive(fasle)
    g_InstancesPool:DeleteInst(self.objDrag)

    --创建默认的模型
    local obj = UnityEngine.GameObject.Instantiate(self.DefaultModel)
    obj.transform.parent = self.DefaultModel.transform.parent
    UnitySetScale(obj,20,20,20)
    SetLocalRotation(obj,0,-90,0)
    SetLocalPosition(obj,0,0,0)
    obj:SetActive(true)
    obj.layer = 5
    self.objDrag = obj

    g_InstancesPool:NewInst(self:GetHullModelName(hullId), self.OnHullModelLoaded, self, {hullId = hullId})

    self.curSelectedHullId = hullId
    self:CalcGrid()
end

function FormModelMediator:OnDrag(notification)
    local delta = notification:GetBody()

    if self.objDrag == nil then 
        return
    end

    local pos = NGameObjectUtil.ScreenPickCastFloorByLayer(UnityInput.mousePosition.x, UnityInput.mousePosition.y, 'PlanetPlane', self.ModelShowCam)
    UnitySetPos(self.objDrag, pos.x, pos.y, pos.z)
end

function FormModelMediator:OnDragEnd(notification)
    local hullId = notification:GetBody()
    self.m_viewComponent.uiBinder.m_DragScrollView:SetActive(true)
    if self.objDrag == nil then 
        return
    end

    if not self:CanAddComposeHull(hullId) then
        g_InstancesPool:DeleteInst(self.objDrag)
    end

    self.objDrag = nil

    if #self.gridGroup > 0 then
        self:ClearActiveGrids()
    end
end

function FormModelMediator:CanAddComposeHull(hullId)
    local pos = NGameObjectUtil.ScreenPickCastFloorByLayer(UnityInput.mousePosition.x, UnityInput.mousePosition.y, 'PlanetPlane', self.ModelShowCam)
    local grid = nil

    if #self.gridGroup == 0 and #self.activeGrids == 1 then
        local tempGrid = self.activeGrids[1]
        local objPos = tempGrid.obj.transform.position
        if pos.x >= (objPos.x - self.halfOff*6) and pos.x < (objPos.x + self.halfOff*6) and pos.z >= (objPos.z - self.halfOff*3) and pos.z < (objPos.z + self.halfOff*3) then
            grid = tempGrid
        end
    else
        for i,v in ipairs(self.activeGrids) do
            local objPos = v.obj.transform.position
            if pos.x >= (objPos.x - self.halfOff) and pos.x < (objPos.x + self.halfOff) and pos.z >= (objPos.z - self.halfOff) and pos.z < (objPos.z + self.halfOff) then
                grid = v
                break
            end
        end
    end

    --判断是否在正确的位置
    if grid == nil then
        return false
    end

    self.index = self.index + 1

    local gridData = {}
    gridData.hullId = hullId
    gridData.left = grid.left
    gridData.right = grid.right
    gridData.front = grid.front
    gridData.back = grid.back
    gridData.modelObj = self.objDrag.transform
    gridData.index = self.index
    gridData.x = grid.x
    gridData.y = grid.y

    local callBack = {
        Self = self,
        Index = gridData.index,
        OnClick = function(data)
            local self = data.Self

            local corId = coroutine.create(self.RemoveHull)
            coroutine.resume(corId, self, data.Index)
        end
    }

    local NLuaClickEvent = NLuaClickEvent.Get(self.objDrag)
    NLuaClickEvent:Add3DClick(callBack, callBack.OnClick, self.ModelShowCam)

    if #self.gridGroup == 0 then
        local objPos = grid.obj.transform.position
        UnitySetPos(self.objDrag, objPos.x, objPos.y, objPos.z)
    else
        SetLocalPosition(gridData.modelObj.gameObject,0,0,0)
        local pos = nil
        local gridFrom = nil
        
        gridFrom = self:GetGuidByIndex(gridData.back)
        if gridFrom then
            gridFrom.front = gridData.index
            pos = gridData.modelObj.position + gridFrom.modelObj:Find("front").position - gridData.modelObj:Find("back").position
        end

        gridFrom = self:GetGuidByIndex(gridData.front)
        if gridFrom then
            gridFrom.back = gridData.index
            pos = gridData.modelObj.position + gridFrom.modelObj:Find("back").position - gridData.modelObj:Find("front").position
        end
        
        gridFrom = self:GetGuidByIndex(gridData.right)
        if gridFrom then
            gridFrom.left = gridData.index
            pos = gridData.modelObj.position + gridFrom.modelObj:Find("left").position - gridData.modelObj:Find("right").position
        end

        gridFrom = self:GetGuidByIndex(gridData.left)
        if gridFrom then
            gridFrom.right = gridData.index
            pos = gridData.modelObj.position + gridFrom.modelObj:Find("right").position - gridData.modelObj:Find("left").position
        end

        if pos then
            UnitySetPos(gridData.modelObj.gameObject, pos.x, pos.y, pos.z)
        end
    end

    table.insert(self.gridGroup, gridData)

    self:UpdateCamPos()
    self:CheckIsComplete()

    return true
end

function FormModelMediator:OnHullModelLoaded(obj, data)
    if obj == nil then 
        return
    end
    g_InstancesPool:DeleteInst(self.objDrag)
    obj:SetActive(true)
    obj.layer = 5
    self.objDrag = obj
    obj.transform.parent = self.ModelParent
    self:SetObjTransform(obj, data.hullId)
end

return FormModelMediator