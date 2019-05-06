local BuildingDismantleMediator = require("Game/Module/SPlanetary/BuildingDismantleMediator")
local BuildingDismantlePanel = register("BuildingDismantlePanel", PanelBase)
local BuildingDismantlePanelBinder = require("UIDef/BuildingDismantlePanelBinder")

function BuildingDismantlePanel:Awake(gameObject)
	BuildingDismantlePanel.super.Awake(self, gameObject)
	self.uiBinder = BuildingDismantlePanelBinder.New(self.gameObject)

	self.mediator = BuildingDismantleMediator.New(NotiConst.BuildingDismantleMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function BuildingDismantlePanel:OpenPanel()
	BuildingDismantlePanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return BuildingDismantlePanel