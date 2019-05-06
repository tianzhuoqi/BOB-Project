local UpdateMediator = require("Game/Module/SUpdate/UpdateMediator")
local UpdatePanel = register("UpdatePanel", PanelBase)

function UpdatePanel:Awake(gameObject) 
	self.mediator = UpdateMediator.New("UpdateMediator")
end

function UpdatePanel:OpenPanel()
	UpdatePanel.super.OpenPanel(self)

	self.mediator.NeedUpdate()
end

function UpdatePanel:ClosePanel() 
end

function UpdatePanel:ReopenPanel() 
end

function UpdatePanel:DestroyPanel() 
end

return UpdatePanel