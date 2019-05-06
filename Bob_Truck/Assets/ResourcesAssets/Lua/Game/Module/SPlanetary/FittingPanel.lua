local FittingMediator = require("Game/Module/SPlanetary/FittingMediator")
local FittingPanel = register("FittingPanel", PanelBase)
local FittingPanelBinder = require("UIDef/FittingPanelBinder")

function FittingPanel:Awake(gameObject)
	FittingPanel.super.Awake(self, gameObject)
	self.uiBinder = FittingPanelBinder.New(self.gameObject)
	self.tableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")
	self.mediator = FittingMediator.New(NotiConst.FittingMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FittingPanel:OpenPanel()
	FittingPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return FittingPanel