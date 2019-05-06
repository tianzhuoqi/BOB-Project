local FormMainMediator = require("Game/Module/SPlanetary/FormMainMediator")
local FormMainPanel = register("FormMainPanel", PanelBase)
local FormMainPanelBinder = require("UIDef/FormMainPanelBinder")

function FormMainPanel:Awake(gameObject)
	FormMainPanel.super.Awake(self, gameObject)
	self.uiBinder = FormMainPanelBinder.New(self.gameObject)

	self.mediator = FormMainMediator.New(NotiConst.FormMainMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FormMainPanel:OpenPanel()
	FormMainPanel.super.OpenPanel(self)

	self:DoBlur()
	
	self.mediator:InitData()
end

function FormMainPanel:ReopenPanel()
	self.mediator:InitData()
end

return FormMainPanel