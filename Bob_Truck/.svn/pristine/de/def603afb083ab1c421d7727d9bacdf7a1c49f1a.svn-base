local FleetDisbandMediator = require("Game/Module/SPlanetary/FleetDisbandMediator")
local FleetDisbandPanel = register("FleetDisbandPanel", PanelBase)
local FleetDisbandPanelBinder = require("UIDef/FleetDisbandPanelBinder");

function FleetDisbandPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = FleetDisbandPanelBinder.New(self.gameObject)

    self.mediator = FleetDisbandMediator.New(NotiConst.FleetDisbandMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetDisbandPanel:OpenPanel()
    FleetDisbandPanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitData()

    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local protFleetsData = fleetProxy:GetProtFleetsData()
    Facade:SendNotification("FleetDisbandPanelNotify", #protFleetsData)
end

return FleetDisbandPanel