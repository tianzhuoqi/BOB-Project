local BuildingCancelMediator = require("Game/Module/SPlanetary/BuildingCancelMediator")
local BuildingCancelPanel = register("BuildingCancelPanel", PanelBase)
local BuildingCancelPanelBinder = require("UIDef/BuildingCancelPanelBinder")

function BuildingCancelPanel:Awake(gameObject)
	BuildingCancelPanel.super.Awake(self, gameObject)
	self.uiBinder = BuildingCancelPanelBinder.New(self.gameObject)

	self.mediator = BuildingCancelMediator.New(NotiConst.BuildingCancelMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function BuildingCancelPanel:OpenPanel()
	BuildingCancelPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return BuildingCancelPanel