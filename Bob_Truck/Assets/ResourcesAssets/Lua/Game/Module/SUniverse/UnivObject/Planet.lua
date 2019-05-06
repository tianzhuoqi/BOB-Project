-- 行星系内一个planet的表现层逻辑
-- 对应的数据层 data  => planetaryPackage.planetDataMap[planetId]
local Planet = class("Planet")

function Planet:ctor(planetData)
    self.data = planetData
    
end

-- 创建planet对象并显示，返回obj
function Planet:BuildPlanet(planetContainer, ringContainer, gridId)
    if self.data == nil then
        LogDebug("PlanetData is nil!!")
    end
    local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    --temp
    local nonePrefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Planets/Main/None.prefab")
    local ringPrefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Ring.prefab")
    local xy = planetaryProxy:GetPosByGridId(gridId)
    xy.x = xy.x - self.data.gridSize * 0.5
    xy.y = xy.y - self.data.gridSize * 0.5
    local r = math.sqrt(xy.x * xy.x + xy.y * xy.y)
    
    local planetGo
    local mask = self.data.mask
    local perfRes = self.data.perfRes
    local scale = self.data.gridSize * 0.5
    
    -- build surface
    --[[if mask then
        local planetPrefab = ManagerResourceModule.LuaLoadBundle(mask[1]..".prefab")
        planetGo = UnityEngine.GameObject.Instantiate(planetPrefab)
        if #mask > 1 then
            local meshRenderer = planetGo:GetComponent("MeshRenderer")
            local materials =  NGameObjectUtil.GetMeshRendererMaterials(meshRenderer)
            for i=2,#mask do
                local material = ManagerResourceModule.LuaLoadBundleMaterial(mask[i]..".mat")
                materials:Add(material)
            end
            NGameObjectUtil.SetMeshRendererMaterials(meshRenderer,materials)
        end
        planetGo.transform.parent = planetContainer.transform
        NGameObjectUtil.SetLocalPosition(planetGo, hex.position[1], 0, hex.position[2])
        NGameObjectUtil.SetScale(planetGo, scale, scale, scale)
    else
        planetGo = UnityEngine.GameObject.Instantiate(nonePrefab)
        planetGo.transform.parent = planetContainer.transform
        NGameObjectUtil.SetLocalPosition(planetGo,hex.position[1],0,hex.position[2])
        NGameObjectUtil.SetScale(planetGo,1,1,1)
    end]]
    if perfRes then
        local planetPrefab = ManagerResourceModule.LuaLoadBundle(perfRes)
        planetGo = UnityEngine.GameObject.Instantiate(planetPrefab)
        --[[local meshRenderer = planetGo:GetComponent("MeshRenderer")
        local materials =  NGameObjectUtil.GetMeshRendererMaterials(meshRenderer)
        local material = materials:get_Item(0)
        for k,v in pairs(perfRes.resource.properties) do
            local type,data = self[v.method](self.data,k)
            if type == "float" then
                NGameObjectUtil.SetMaterialsFloat(material,k,data)
            elseif type == "color" then
                NGameObjectUtil.SetMaterialsColor(material,k,data[1]/255,data[2]/255,data[3]/255)
            elseif type == "texture" then
                NGameObjectUtil.SetMaterialsTexture(material,k,data)
            end
        end]]
        planetGo.transform.parent = planetContainer.transform

        NGameObjectUtil.SetLocalPosition(planetGo, xy.x, 0, xy.y )
        NGameObjectUtil.SetScale(planetGo, scale, scale, scale)
    else
        
        planetGo = UnityEngine.GameObject.Instantiate(nonePrefab)
        planetGo.transform.parent = planetContainer.transform
        NGameObjectUtil.SetLocalPosition(planetGo, xy.x, 0, xy.y)
        NGameObjectUtil.SetScale(planetGo, scale, scale, scale)
    end

    local planetarySize = self.data.gridSize
    for i = 1, planetarySize do
        for j = 1, planetarySize do
            planetaryProxy:AddGridsUsedByGridId(gridId - (i - 1) * 1000 - (j - 1))
        end
    end

    local ringGo = UnityEngine.GameObject.Instantiate(ringPrefab)
    ringGo.transform.parent = ringContainer.transform
    NGameObjectUtil.SetScale(ringGo,r,r,r)

    -- add click event
    local NLuaClickEvent = NLuaClickEvent.Get(planetGo)
    NLuaClickEvent:Add3DClick(self, self.OnClick)
    return planetGo
end

-- 如果data发生改动
function Planet:OnDataChanged()
    
end

function Planet:OnClick()
    self:OpenGroupPopup()
end

function Planet:OpenGroupPopup()
    body = {
        planetId = self.data.id
    }
    Facade:SendNotification(NotiConst.Notify_PlanetaryChoosePlanet, body)
end

function Planet:ShowExploreResult()
    body = {
        planetId = self.data.id
    }
    Facade:SendNotification(NotiConst.Notify_PlanetShowExploreResult, body)
end

--星球shader动态方法
function Planet.RandomTable(planetPerfData,property)
    local resource = planetPerfData.perfRes.resource
    local p = resource.properties[property]
    local pType = p.type 
    local tableData = p.table
    local index = (planetPerfData.id+planetPerfData.gridId)%(#tableData)+1
    return pType,tableData[index]
end

function Planet.ResidTable(planetPerfData,property)
    local resource = planetPerfData.perfRes.resource
    local p = resource.properties[property]
    local pType = p.type 
    local tableData = p.table
    local index = planetPerfData.mRes
    return pType,tableData[index]
end

function Planet.RandomFloat(planetPerfData,property)
    local resource = planetPerfData.perfRes.resource
    local p = resource.properties[property]
    local pType = p.type
    local index = (planetPerfData.id+planetPerfData.gridId)%p.methodP
    local f = index/p.methodP
    if p.method2 then
        f = p.method2(f)
    end
    return pType,f
end

return Planet