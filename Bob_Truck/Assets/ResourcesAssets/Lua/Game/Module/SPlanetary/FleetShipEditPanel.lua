local FleetShipEditMediator = require("Game/Module/SPlanetary/FleetShipEditMediator")
local FleetShipEditPanel = register("FleetShipEditPanel", PanelBase)
local FleetShipEditPanelBinder = require("UIDef/FleetShipEditPanelBinder");

function FleetShipEditPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView();

    self.mediator = FleetShipEditMediator.New(NotiConst.FleetShipEditMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetShipEditPanel:InitView()
    self.uiBinder = FleetShipEditPanelBinder.New(self.gameObject)
end

function FleetShipEditPanel:OpenPanel()
    FleetShipEditPanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitView()
    self.mediator:InitData()
    self.mediator:RefreshView()
end

return FleetShipEditPanel