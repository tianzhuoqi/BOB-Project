local ListCell = require("Game/Module/UICommon/ListCell")

local FleetPortItem2ListCell = register("FleetPortItem2ListCell", ListCell)

function FleetPortItem2ListCell:Awake(gameObject)
    FleetPortItem2ListCell.super.Awake(self, gameObject)

    self.n_Label_ShipSort = self:FindComponent("GameObject_ModelXX/n_Label_ShipSort", "UILabel")
    self.n_Label_Name = self:FindComponent("GameObject_ModelXX/n_Label_Name", "UILabel")
    self.n_Sprite_Warship = self:FindComponent("GameObject_ModelXX/n_Sprite_Warship", "UITexture")
    self.n_Button_Refit = self:FindComponent("GameObject_ModelXX/n_Button_Refit", "UIButton")
    self.n_Button_Detail = self:FindComponent("GameObject_ModelXX/n_Button_Detail", "UIButton")

    self.cpntMatsView = {}
    for i=1,4 do
        table.insert(self.cpntMatsView, {
                        obj = self:FindComponent("GameObject_ModelXX/GameObject_Info/n_Sprite_Main"..i, "UITexture"),
                        frame = self:FindComponent("GameObject_ModelXX/GameObject_Info/n_Sprite_Main"..i.."/n_Sprite_MainFrame"..i, "UISprite")
                    })
    end

    NLuaClickEvent.Get(self.n_Button_Refit.gameObject):AddClick(self, self.Refit)

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
end

function FleetPortItem2ListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.planetaryProxy:GetUserModByIndex(self.dataIndex)

    self.n_Label_Name.text = self.data.modName

    self.material = {}

    for i=1,#self.data.cpntMats do
        local cpntId = self.data.cpntMats[i]
        if self.material[cpntId] == nil then
            self.material[cpntId] = 0
        end
        self.material[cpntId] = self.material[cpntId] + 1

        self.cpntMatsView[i].obj.gameObject:SetActive(true)

        local cnptData = self.planetaryProxy:GetShipCpntConfigDataById(cpntId)
        self.cpntMatsView[i].obj.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(cnptData.data[cnptData.EVar["icon_name_s"]])
    end

    for i=(#self.data.cpntMats+1),#self.cpntMatsView do
        self.cpntMatsView[i].obj.gameObject:SetActive(false)
    end

    for i=1,#self.data.hullParts do
        local hull = self.data.hullParts[i]
        if self.material[hull.hullId] == nil then
            self.material[hull.hullId] = 0
        end
        self.material[hull.hullId] = self.material[hull.hullId] + 1
    end

    self.nodeId = self.planetaryProxy:GetPlanetaryId()
    self.count = self:CalcCount()
    GameObjectUtil.SetButtonState(self.n_Button_Refit, self.count > 0 and 0 or 3)

    self.modData = self.planetaryProxy:GetShipModConfigDataById(self.data.techID)
    self.n_Sprite_Warship.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.modData.data[self.modData.EVar["ship_icon_name_s"]])
    self.n_Label_ShipSort.text = GetLanguageText(self.modData.data[self.modData.EVar["transl_table_name_s"]], self.modData.data[self.modData.EVar["mod_tech_name_s"]])
end

function FleetPortItem2ListCell:CalcCount()
    local maxCount = 99999999
    for i,v in pairs(self.material) do
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        if itemData == nil and v > 0 then
            maxCount = 0
            break
        end

        local count = math.floor(itemData.num/v)
        if count < maxCount then
            maxCount = count
        end

        if maxCount == 0 then
            break
        end
    end
    return maxCount
end

--编辑
function FleetPortItem2ListCell:EditModel()
    local index = self.dataIndex
    local userModData = self.planetaryProxy:GetUserModByIndex(index)
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    
    self.curBuilding.dynamicData.modelId = userModData.id
    self.curBuilding.dynamicData.mod = userModData
    self.curBuilding.dynamicData.type = 1

    Facade:ReplacePanel("FormModelPanel")
end

--改装
function FleetPortItem2ListCell:Refit()
    if self.count == 0 then
        return
    end

    local index = self.dataIndex
    local userModData = self.planetaryProxy:GetUserModByIndex(index)
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    self.curBuilding.dynamicData.modelId = userModData.id
    self.curBuilding.dynamicData.mod = userModData
    Facade:ReplacePanel("FormRefitPanel")
end

return FleetPortItem2ListCell