local BuildingUpgradeMediator = require("Game/Module/SPlanetary/BuildingUpgradeMediator")
local BuildingUpgradePanel = register("BuildingUpgradePanel", PanelBase)
local BuildingUpgradePanelBinder = require("UIDef/BuildingUpgradePanelBinder")

function BuildingUpgradePanel:Awake(gameObject)
	BuildingUpgradePanel.super.Awake(self, gameObject)
	self.uiBinder = BuildingUpgradePanelBinder.New(self.gameObject)

	self.mediator = BuildingUpgradeMediator.New(NotiConst.BuildingUpgradeMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function BuildingUpgradePanel:OpenPanel()
	BuildingUpgradePanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return BuildingUpgradePanel