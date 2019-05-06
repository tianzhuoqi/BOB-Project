local FormShowMediator = require("Game/Module/SPlanetary/FormShowMediator")
local FormShowPanel = register("FormShowPanel", PanelBase)
local FormShowPanelBinder = require("UIDef/FormShowPanelBinder")

function FormShowPanel:Awake(gameObject)
	FormShowPanel.super.Awake(self, gameObject)
	self.uiBinder = FormShowPanelBinder.New(self.gameObject)

	self.mediator = FormShowMediator.New(NotiConst.FormShowMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FormShowPanel:OpenPanel()
	FormShowPanel.super.OpenPanel(self)
	self:DoBlur()

	self.mediator:InitData()
end

return FormShowPanel