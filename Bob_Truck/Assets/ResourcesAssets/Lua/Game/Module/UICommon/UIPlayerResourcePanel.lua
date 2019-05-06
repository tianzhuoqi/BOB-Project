local UIPlayerResourceMediator = require("Game/Module/UICommon/UIPlayerResourceMediator")
local UIPlayerResourcePanel = register("UIPlayerResourcePanel", PanelBase)
local UIPlayerResourcePanelBinder = require("UIDef/UIPlayerResourcePanelBinder")

function UIPlayerResourcePanel:Awake(gameObject)
	UIPlayerResourcePanel.super.Awake(self, gameObject)
	self.uiBinder = UIPlayerResourcePanelBinder.New(self.gameObject)

	self.mediator = UIPlayerResourceMediator.New(NotiConst.UIPlayerResourceMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function UIPlayerResourcePanel:OpenPanel()
	UIPlayerResourcePanel.super.OpenPanel(self)
	self:DoBlur()

	self.mediator:ShowUI()
end

return UIPlayerResourcePanel