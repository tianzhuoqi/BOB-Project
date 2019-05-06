require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local FormRefitListCell = register("FormRefitListCell", ListCell)

local ModTechCfg = DATA_SHIP_MOD_TECH
local HullMatrCfg = DATA_SMT_AVAIL_HULL_LIST
local CpntCfg = DATA_SMT_AVAIL_CPNT_LIST

function FormRefitListCell:OnClick()
    LogDebug('FormRefitListCell OnClick dataIndex:{0}', self.dataIndex)
end

function FormRefitListCell:Awake(gameObject)
    FormRefitListCell.super.Awake(self, gameObject)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
    self.n_Label_Name = self:FindComponent("GameObject_RefitXX/n_Label_Name", "UILabel")
    self.n_Label_Number1 = self:FindComponent("GameObject_RefitXX/n_Label_Number1", "UILabel")
    self.n_Label_Number2 = self:FindComponent("GameObject_RefitXX/n_Label_Number2", "UILabel")
    self.Sprite_YesBG = gameObject.transform:Find("GameObject_RefitXX/Sprite_YesBG").gameObject
    self.n_Sprite_Yes = gameObject.transform:Find("GameObject_RefitXX/Sprite_YesBG/n_Sprite_Yes").gameObject
    self.count = 0
    self.needCount = {}
    local NLuaClickEvent = NLuaClickEvent.Get(self.Sprite_YesBG)
    NLuaClickEvent:AddClick(self, self.ClickCheckBox)
end


function FormRefitListCell:DrawCell(index)
    self.dataIndex = index + 1
    self:FreshItem()
end

function FormRefitListCell:ClickCheckBox()
    local curSelect = self.planetaryProxy:GetcurFormRefitEditShipData()[self.dataIndex][2]
    local Select = false
    if self:CanSelect(curSelect) then
        Select = not curSelect
    end
    if curSelect ~= Select then
        self.planetaryProxy:SetcurFormRefitEditShipSelectData(self.dataIndex, Select)
        self:FreshItem()
    end
end

function FormRefitListCell:CanSelect(curSelect)
    if curSelect then
        self.planetaryProxy:SetcurFormRefitEditShipTempCount(-self.count)
        self.count = 0
        for k, v in pairs (self.needCount) do
            self.planetaryProxy:SetcurFormRefitEditShipTempNeedCount(k, -v)
        end
        self.needCount = {}
        return true
    else
        local nodeId = self.planetaryProxy:GetPlanetaryId()
        local data = self.storehouseProxy:GetStorehouseByNodeId(self.planetaryProxy:GetPlanetaryId())
        local hullParts = self.planetaryProxy:GetcurFormRefitEditShipData()[self.dataIndex][1].userShip.hullParts
        local count = 0
        local inventoryCount = {}
        for i = 1, #hullParts do
            local id = hullParts[i].hullId
            count = count + DATA_SHIP_HULL_TECH[id][DATA_SHIP_HULL_TECH.EVar['ssp_cost_n']]
            inventoryCount[id] = DATA_SHIP_HULL_TECH[id][DATA_SHIP_HULL_TECH.EVar['ssp_cost_n']]
        end
        if data.restOfCap < count + self.planetaryProxy:GetcurFormRefitEditShipTempCount() then

            return false
        else
            if self.needItemTable == nil then
                self.needItemTable = {}
                local hullParts = self.planetaryProxy:GetCurBuildingOper().dynamicData.mod.hullParts
                for i = 1, #hullParts do
                    if self.needItemTable[hullParts[i].hullId] == nil then
                        self.needItemTable[hullParts[i].hullId] = 1
                    else
                        self.needItemTable[hullParts[i].hullId] = self.needItemTable[hullParts[i].hullId] + 1
                    end
                end
            end
            local needCount = {}
            
            for k, v in pairs(self.needItemTable) do
                local item = self.storehouseProxy:GetItem(nodeId, k)
                local inventory = 0
                if inventoryCount[k] ~= nil then
                    inventory = inventoryCount[k]
                end
                if inventory - v >= 0 then
                    inventoryCount[k] = inventoryCount[k] - v
                else
                    if item == nil then
                        return false
                    elseif item.num + inventory < self.planetaryProxy:GetcurFormRefitEditShipTempNeedCount(k) + v then
                        return false
                    else
                        needCount[k] = v - inventory
                    end
                end
            end

            self.needCount = needCount
            for k, v in pairs(self.needCount) do
                self.planetaryProxy:SetcurFormRefitEditShipTempNeedCount(k, v)
            end
            self.count = count
            self.planetaryProxy:SetcurFormRefitEditShipTempCount(self.count)
            return true
        end
    end
end

function FormRefitListCell:FreshItem()
    local data = self.planetaryProxy:GetcurFormRefitEditShipData()
    self.n_Label_Name.text = data[self.dataIndex][1].shipId
    self.n_Label_Number1.text = data[self.dataIndex][1].fightNum
    local techText = DATA_SHIP_MOD_TECH[data[self.dataIndex][1].userShip.techID][DATA_SHIP_MOD_TECH.EVar['ship_type_n']]
    self.n_Label_Number2.text = techText
    self.n_Sprite_Yes:SetActive(data[self.dataIndex][2])
    local needList = self.planetaryProxy:GetcurFormRefitEditShipTempNeedCountAll()
    local count = 0
    for k, v in pairs(needList) do
        if v > 0 then
            count = count + 1
        end
    end

    Facade:SendNotification('initFormRefitNeedListCell', count)
end

return FormRefitListCell