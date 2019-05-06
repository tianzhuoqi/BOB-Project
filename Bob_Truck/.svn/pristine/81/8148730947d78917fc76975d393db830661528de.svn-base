local FormModelMediator = require("Game/Module/SPlanetary/FormModelMediator")
local FormModelPanel = register("FormModelPanel", PanelBase)
local FormModelPanelBinder = require("UIDef/FormModelPanelBinder")

function FormModelPanel:Awake(gameObject)
	FormModelPanel.super.Awake(self, gameObject)
	self.uiBinder = FormModelPanelBinder.New(self.gameObject)

	self.mediator = FormModelMediator.New(NotiConst.FormModelMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FormModelPanel:OpenPanel()
	FormModelPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return FormModelPanel