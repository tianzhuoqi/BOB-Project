-- 描述行星系内整个六边形结构

local Grids = class("Grids")

Grids.gridMap = nil
Grids.allValidGrids = nil

function Hexes:ctor(gridMap)
    self.gridMap = gridMap
    self.allValidGrids = {}
    self.allGridsData = {}
    self.gridPrefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Hex.prefab")
    self.planetsInstanceData = {}
    -- temp load building prefabs
    self.spaceStation01Prefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Buildings/spaceStation01.prefab")
    self.spaceStation02Prefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Buildings/spaceStation02.prefab")
    self.spaceStation03Prefab = ManagerResourceModule.LuaLoadBundle("ModelFBX/Solarsystem/Buildings/spaceStation03.prefab")
end

function Hexes:SetHexContainer(container)
    self.hexContainer = container
end

function Hexes:SetBuildingContainer(container)
    self.buildingContainer = container
end

function Hexes:BuildHexMapInArea(maxLevel)
    for idx, hex in ipairs(self.hexMap) do
        if hex.level > maxLevel then
            break
        end
        local hexGo = self:BuildHexByIndex(idx)
        table.insert(self.allValidHexes, hexGo)
        
    end
    for idx,_ in ipairs(self.allValidHexes) do
        table.insert(self.allHexesData,self:BuildHexData(idx))
    end
end

function Hexes:BuildHexByIndex(gridId)
    local curHex = self.hexMap[gridId]
    local hexGo = UnityEngine.GameObject.Instantiate(self.hexPrefab)
    hexGo.transform.parent = self.hexContainer.transform
    NGameObjectUtil.SetLocalPosition(hexGo, curHex.position[1], 0.01, curHex.position[2])
    return hexGo
end

function Hexes:GetHexDataById(gridId)
    return self.allHexesData[gridId]
end

function Hexes:BuildHexData(gridId)
    local v = self.hexMap[gridId]
    if self.allHexesData[gridId] ~= nil then
        return self.allHexesData[gridId]
    end
    local hexGo = self.allValidHexes[gridId]
    local hexData ={
        pSelf = self, 
        hex = v,
        gameObject = hexGo,
        status = 0,
        buildings = {},
        OnClick = function(self)
            if self.status == 0 then
                Facade:SendNotification(NotiConst.Notify_PlanetCloseGroupPopup)
            elseif self.status == 1 then
                local body = {gridId = gridId}
                Facade:SendNotification(NotiConst.Notify_PlanetaryChooseHexe, body)
            elseif self.status == 2 then
            end
        end
    }
    local NLuaClickEvent = NLuaClickEvent.Get(hexGo)
    NLuaClickEvent:Add3DClick(hexData, hexData.OnClick)
    return hexData
end

function Hexes:GetHexAroundHexes(gridId)
    local all = {}
    local curHex = self.hexMap[gridId]
    for k, v in pairs(curHex.connect) do
        local hexGo = self.allValidHexes[v.id]
        local hexData = self:BuildHexData(v.id)
        table.insert(all, hexData)
    end
    return all
end

function Hexes:GetHexBygridId(gridId)
    return self.hexMap[gridId]
end

function Hexes:LightHexById(gridId) 
    self:LightHex(self:GetHexDataById(gridId))
end

function Hexes:LightHex(hexData) 
    local addGo = (hexData.gameObject.transform:Find("Add")).gameObject
    hexData.status = 1
    addGo:SetActive(true)
end

return Hexes