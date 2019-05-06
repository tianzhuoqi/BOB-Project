local BuildingInfoMediator = require("Game/Module/SPlanetary/BuildingInfoMediator")
local BuildingInfoPanel = register("BuildingInfoPanel", PanelBase)
local BuildingInfoPanelBinder = require("UIDef/BuildingInfoPanelBinder")

function BuildingInfoPanel:Awake(gameObject)
	BuildingInfoPanel.super.Awake(self, gameObject)
	self.uiBinder = BuildingInfoPanelBinder.New(self.gameObject)

	self.mediator = BuildingInfoMediator.New(NotiConst.BuildingInfoMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function BuildingInfoPanel:OpenPanel()
	BuildingInfoPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return BuildingInfoPanel