local FleetShipQueueEditMediator = require("Game/Module/SPlanetary/FleetShipQueueEditMediator")
local FleetShipQueueEditPanel = register("FleetShipQueueEditPanel", PanelBase)
local FleetShipQueueEditPanelBinder = require("UIDef/FleetShipQueueEditPanelBinder");

function FleetShipQueueEditPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView();

    self.mediator = FleetShipQueueEditMediator.New(NotiConst.FleetShipQueueEditMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetShipQueueEditPanel:InitView()
    self.uiBinder = FleetShipQueueEditPanelBinder.New(self.gameObject);
end

function FleetShipQueueEditPanel:OpenPanel()
    FleetShipQueueEditPanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitData()
    self.mediator:RefreshView()
end

return FleetShipQueueEditPanel