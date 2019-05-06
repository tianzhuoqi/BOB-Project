local FormShowMediator = class("FormShowMediator", MediatorDynamic)

function FormShowMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    self.cnptViewList = {}
    table.insert(self.cnptViewList, self.m_viewComponent.uiBinder.m_Sprite_PartsBG1)
    table.insert(self.cnptViewList, self.m_viewComponent.uiBinder.m_Sprite_PartsBG2)
    table.insert(self.cnptViewList, self.m_viewComponent.uiBinder.m_Sprite_PartsBG3)
    table.insert(self.cnptViewList, self.m_viewComponent.uiBinder.m_Sprite_PartsBG4)

    NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_Button_Yes.gameObject):AddClick(self, self.Close)
end

function FormShowMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.mod = self.curBuilding.dynamicData.mod

    for i=1,#self.mod.cpntMats do
        local cnptData = self.planetaryProxy:GetShipCpntConfigDataById(self.mod.cpntMats[i])
        self.cnptViewList[i].gameObject:SetActive(true)
        self.cnptViewList[i].mainTexture = ManagerResourceModule.LuaLoadBundleTexture(cnptData.data[cnptData.EVar["icon_name_s"]])
    end

    for i=(#self.mod.cpntMats+1),#self.cnptViewList do
        self.cnptViewList[i].gameObject:SetActive(false)
    end

    self.modData = self.planetaryProxy:GetShipModConfigDataById(self.mod.techID)
    self.m_viewComponent.uiBinder.m_Label_Name.text = GetLanguageText(self.modData.data[self.modData.EVar["transl_table_name_s"]], self.modData.data[self.modData.EVar["mod_tech_name_s"]])
    self.m_viewComponent.uiBinder.m_Label_NameV.text = self.mod.modName

    self.hullList = self.mod.hullParts
    self:InitModelShow()
end

function FormShowMediator:Close()
    self:ClearModelShow()
    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)
    Facade:BackPanel()
end

--初始化model show
function FormShowMediator:InitModelShow()
    self:ClearModelShow()
    local obj = self.m_viewComponent.uiBinder.m_Model_Pos
	obj:SetActive(true)
    self.ModelParent = self.m_viewComponent.uiBinder.m_Object.transform
    GameObjectUtil.SetLocalRotation(self.ModelParent.gameObject, 0, 0, 0)
    self.ModelShowCam = obj.transform:Find("Camera"):GetComponent("Camera")

    self.gridGroup = {}
    self.hasLoaded = {}

    if #self.hullList > 0 then
        for i,v in ipairs(self.hullList) do
            local grid = {}
            grid.hullId = v.hullId
            grid.left = v.left
            grid.right = v.right
            grid.front = v.front
            grid.back = v.back
            grid.index = v.attachIndex

            table.insert(self.gridGroup, grid)
        end

        local grid = self.gridGroup[1]
        g_InstancesPool:NewInst(self:GetHullModelName(grid.hullId), self.OnHullModelLoaded, self, {grid = grid})
    end
end

function FormShowMediator:GetHullModelName(hullId)
    local hullConfigData = self.planetaryProxy:GetShipHullConfigData(hullId)
    return "ModelFBX/ship/transport/"..hullConfigData.data[hullConfigData.EVar["prefab_name_s"]]..".prefab"
end

--修改模板时使用
function FormShowMediator:OnHullModelLoaded(obj, data)
    if obj == nil then 
        return
    end
    obj:SetActive(true)
    obj.layer = 5
    obj.transform.parent = self.ModelParent
    GameObjectUtil.SetScale(obj,8,8,8)
    GameObjectUtil.SetLocalRotation(obj,0,-90,0)

    local grid = data.grid
    grid.modelObj = obj.transform
    local gridFrom = data.from

    GameObjectUtil.SetLocalPosition(obj,0,0,0)
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
            GameObjectUtil.SetPosition(grid.modelObj.gameObject, pos.x, pos.y, pos.z)
        end
    end

    self.ModelShowCam.targetTexture:Release()

    table.insert(self.hasLoaded, grid.index)
    if #self.hasLoaded == #self.hullList then
        self:UpdateCamPos()
    end

    if grid.left ~= nil and grid.left > 0 and not self:IsLoaded(grid.left) then
        local tempGrid = self:GetGuidByIndex(grid.left)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.right ~= nil and grid.right > 0 and not self:IsLoaded(grid.right) then
        local tempGrid = self:GetGuidByIndex(grid.right)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.front ~= nil and grid.front > 0 and not self:IsLoaded(grid.front) then
        local tempGrid = self:GetGuidByIndex(grid.front)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end

    if grid.back ~= nil and grid.back > 0 and not self:IsLoaded(grid.back) then
        local tempGrid = self:GetGuidByIndex(grid.back)
        g_InstancesPool:NewInst(self:GetHullModelName(tempGrid.hullId), self.OnHullModelLoaded, self, {grid = tempGrid, from = grid})
    end
end

function FormShowMediator:GetGuidByIndex(index)
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

function FormShowMediator:UpdateCamPos()
    local center = GameObjectUtil.GetCenter(self.ModelParent)
    GameObjectUtil.SetLocalPosition(self.ModelParent.gameObject, self.ModelParent.localPosition.x, 0, self.ModelParent.localPosition.z)

    local bound = self:CalcGridBound()
    local newY = (bound.dist + 8)*3
    local v = Vector3(0, newY, 0)
    v = Vector3(self.ModelParent.transform.localPosition.x, 0, self.ModelParent.transform.localPosition.z) + v
    GameObjectUtil.SetLocalPosition(self.ModelShowCam.gameObject, v.x, v.y, v.z)
    GameObjectUtil.SetLocalRotation(self.ModelParent.gameObject, -40, -130, -33)
    GameObjectUtil.SetLocalPosition(self.ModelParent.gameObject, self.ModelParent.localPosition.x - 20, self.ModelParent.localPosition.y, self.ModelParent.localPosition.z + 20)
    self.ModelShowCam.targetTexture:Release()
end

--计算边界盒子
function FormShowMediator:CalcGridBound()
    local maxPoint = 0
    local minPoint = 0

    for i=1,#self.gridGroup do
        local grid = self.gridGroup[i]
        local front = grid.modelObj:Find("front")
        local back = grid.modelObj:Find("back")

        if i == 1 then
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
            if front and front.position.x < minPoint then
                minPoint = front.position.x
            end
            if back and back.position.x > maxPoint then
                maxPoint = back.position.x
            end
        end
    end

    local dist = (maxPoint - minPoint)*math.pow(10,2)

    return {dist = dist}
end

function FormShowMediator:IsLoaded(index)
    for i=1,#self.hasLoaded do
        if self.hasLoaded[i] == index then
            return true
        end
    end
    return false
end 

function FormShowMediator:ClearModelShow()
    if self.gridGroup == nil then
        return
    end

    local n = #self.gridGroup
    for i=1, n do 
        g_InstancesPool:DeleteInst(self.gridGroup[i].modelObj.gameObject)
    end
    self.gridGroup = {}
    self.hasLoaded = {}
    self:UpdateCamPos()
    self.ModelShowCam.targetTexture:Release()
end

return FormShowMediator