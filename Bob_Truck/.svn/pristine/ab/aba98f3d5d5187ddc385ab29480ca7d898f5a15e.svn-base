local ShipBodyMediator = require("Game/Module/SPlanetary/ShipBodyMediator")
local ShipBodyPanel = register("ShipBodyPanel", PanelBase)
local ShipBodyPanelBinder = require("UIDef/ShipBodyPanelBinder")

function ShipBodyPanel:Awake(gameObject)
	ShipBodyPanel.super.Awake(self, gameObject)
	self.uiBinder = ShipBodyPanelBinder.New(self.gameObject)
	self.tableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")
	self.mediator = ShipBodyMediator.New(NotiConst.ShipBodyMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function ShipBodyPanel:OpenPanel()
	ShipBodyPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return ShipBodyPanel