local CollectMediator = require("Game/Module/SPlanetary/CollectMediator")
local CollectPanel = register("CollectPanel", PanelBase)
local CollectPanelBinder = require("UIDef/CollectPanelBinder")

function CollectPanel:Awake(gameObject)
	CollectPanel.super.Awake(self, gameObject)
	self.uiBinder = CollectPanelBinder.New(self.gameObject)

	self.mediator = CollectMediator.New(NotiConst.CollectMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function CollectPanel:OpenPanel()
	CollectPanel.super.OpenPanel(self)

	self:DoBlur()
	self.mediator:ShowUI()
end
	
function CollectPanel:ReopenPanel( )
	self.mediator:RefreshMineralUI()
end

return CollectPanel