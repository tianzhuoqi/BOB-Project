local FleetDirectiveMediator = require("Game/Module/SUniverse/FleetDirectiveMediator")
local FleetDirectivePanel = register("FleetDirectivePanel", PanelBase)
local FleetDirectivePanelBinder = require("UIDef/FleetDirectivePanelBinder")

function FleetDirectivePanel:Awake(gameObject)
	FleetDirectivePanel.super.Awake(self, gameObject)
	self.uiBinder = FleetDirectivePanelBinder.New(self.gameObject)

	self.mediator = FleetDirectiveMediator.New(NotiConst.FleetDirectiveMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetDirectivePanel:OpenPanel()
	FleetDirectivePanel.super.OpenPanel(self)
	self:DoBlur()
	self.mediator:ShowUI()
end

function FleetDirectivePanel:DestroyPanel()
	self.mediator:DestroyPanel()
end

return FleetDirectivePanel