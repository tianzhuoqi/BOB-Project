require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")
local BuildingUpgradeListCell = register("BuildingUpgradeListCell", ListCell)
local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
function BuildingUpgradeListCell:OnClick()

end

function BuildingUpgradeListCell:Awake(gameObject)
    BuildingUpgradeListCell.super.Awake(self, gameObject)
    self.panelMediator = Facade:RetrieveMediator("BuildingUpgradeMediator")
    self.infoValue = self:FindComponent("Label_UpEf01/m_Label_ChangeValue01","UILabel")
    self.infoName = self:FindComponent("Label_UpEf01","UILabel")

end

function BuildingUpgradeListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.panelMediator.upgradeEffects[self.dataIndex]

    if self.data.infoTitleStr ~= nil then
        self.infoName.text = self.data.infoTitleStr
    else
        self.infoName.text = self.data.name..":"
    end
    
    if self.data.infoValueStr ~= nil then
        local str = StringFormat(self.data.infoValueStr, self.data.newValue - self.data.oldValue)
        self.infoValue.text = "+" .. str
    else 
        local str = self.data.oldValue.." >>> "..self.data.newValue
        self.infoValue.text = str
    end
end


return BuildingUpgradeListCell