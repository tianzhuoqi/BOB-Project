local UIMenuMediator = require("Game/Module/UICommon/UIMenuMediator")
local UIMenuPanel = register("UIMenuPanel", PanelBase)
local UIMenuPanelBinder = require("UIDef/UIMenuPanelBinder")

function UIMenuPanel:Awake(gameObject)
	UIMenuPanel.super.Awake(self, gameObject)
	self.uiBinder = UIMenuPanelBinder.New(self.gameObject)

	self.mediator = UIMenuMediator.New(NotiConst.UIMenuMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function UIMenuPanel:OpenPanel()
	UIMenuPanel.super.OpenPanel(self)
	self:DoBlur()
	UpdateBeat:Add(self.Update, self)
	self.mediator:OpenPanel()
end

function UIMenuPanel:Update()
    self.mediator:UpdateFleetListCount()
end

function UIMenuPanel:DestroyPanel()
	UpdateBeat:Remove(self.Update, self)
	self.mediator:DestroyPanel()
end

return UIMenuPanel