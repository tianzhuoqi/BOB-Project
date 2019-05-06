local RenameMediator = require("Game/Module/UICommon/RenameMediator")
local RenamePanel = register("RenamePanel", PanelBase)
local RenamePanelBinder = require("UIDef/RenamePanelBinder")

function RenamePanel:Awake(gameObject)
	RenamePanel.super.Awake(self, gameObject)
	self.uiBinder = RenamePanelBinder.New(self.gameObject)

	self.mediator = RenameMediator.New(NotiConst.RenameMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function RenamePanel:OpenPanel()
	RenamePanel.super.OpenPanel(self)
	self:DoBlur()

	self.mediator:InitData()
end

return RenamePanel