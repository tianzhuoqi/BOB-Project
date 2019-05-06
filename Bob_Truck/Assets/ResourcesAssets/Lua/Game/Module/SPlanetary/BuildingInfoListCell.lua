require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")
local BuildingInfoListCell = register("BuildingInfoListCell", ListCell)
local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
function BuildingInfoListCell:OnClick()

end

function BuildingInfoListCell:Awake(gameObject)
    BuildingInfoListCell.super.Awake(self, gameObject)
    self.panelMediator = Facade:RetrieveMediator("BuildingInfoMediator")
    self.titleLabel = self:FindComponent("m_Label_Ditelaikey1", "UILabel")
    self.valueLabel = self:FindComponent("m_Label_Ditelaikey1/m_Label1", "UILabel")
end

function BuildingInfoListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.panelMediator.buildingInfoData[self.dataIndex]
    
    if self.data.titleStr ~= nil then
        self.titleLabel.text = self.data.titleStr
    else
        self.titleLabel.text = "title"
    end

    if self.data.valueStr ~= nil then
        self.valueLabel.text = StringFormat(self.data.valueStr, self.data.value)
    else
        self.valueLabel.text = tostring(self.data.value)
    end
end


return BuildingInfoListCell