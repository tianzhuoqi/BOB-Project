local HullFilterMediator = require("Game/Module/SPlanetary/HullFilterMediator")
local HullFilterPanel = register("HullFilterPanel", PanelBase)
local HullFilterPanelBinder = require("UIDef/HullFilterPanelBinder")

function HullFilterPanel:Awake(gameObject)
	HullFilterPanel.super.Awake(self, gameObject)
	self.uiBinder = HullFilterPanelBinder.New(self.gameObject)

	self.mediator = HullFilterMediator.New(NotiConst.HullFilterMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function HullFilterPanel:OpenPanel()
	HullFilterPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return HullFilterPanel