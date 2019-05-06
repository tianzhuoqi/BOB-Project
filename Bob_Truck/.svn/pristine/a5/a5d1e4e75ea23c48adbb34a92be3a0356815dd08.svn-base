require("Proto/building_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local BuildingListCell = register("BuildingListCell", ListCell)

function BuildingListCell:OnClick()
    local body = {buildingConfigId = self.building[self.dataIndex][1]}
    
    Facade:SendNotification(NotiConst.Notify_PlanetChooseBuilding, body)
end

function BuildingListCell:Awake(gameObject)
    BuildingListCell.super.Awake(self, gameObject)
    self.name = self:FindGameObject("Button").transform:Find('buildingName'):GetComponent('UILabel')
    local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.building = planetaryProxy:GetBuildingList()
    self.nodeId = planetaryProxy:GetPlanetaryId()
    self.pos = planetaryProxy:GetChosenPlanetId()
end

function BuildingListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.dataIndex
    self:FreshItem()
end

function BuildingListCell:FreshItem()
    self.name.text = self.building[self.dataIndex][2][DATA_BUILDING.EVar['bldg_name_s']]
end



return BuildingListCell