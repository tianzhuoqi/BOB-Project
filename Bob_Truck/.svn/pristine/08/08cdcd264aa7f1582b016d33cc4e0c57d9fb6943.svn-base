local FormRefitMediator = require("Game/Module/SPlanetary/FormRefitMediator")
local FormRefitPanel = register("FormRefitPanel", PanelBase)
local FormRefitPanelBinder = require("UIDef/FormRefitPanelBinder")

function FormRefitPanel:Awake(gameObject)
	FormRefitPanel.super.Awake(self, gameObject)
	self.uiBinder = FormRefitPanelBinder.New(self.gameObject)

	self.mediator = FormRefitMediator.New(NotiConst.FormRefitMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FormRefitPanel:OpenPanel()
	FormRefitPanel.super.OpenPanel(self)

	self:DoBlur()
	self.mediator:InitData()
end

return FormRefitPanel