local FleetMemberMediator = require("Game/Module/SPlanetary/FleetMemberMediator")
local FleetMemberPanel = register("FleetMemberPanel", PanelBase)
local FleetMemberPanelBinder = require("UIDef/FleetMemberPanelBinder");

function FleetMemberPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = FleetMemberPanelBinder.New(self.gameObject)

    self.mediator = FleetMemberMediator.New(NotiConst.FleetMemberMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetMemberPanel:OpenPanel()
    FleetMemberPanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitData()
end

return FleetMemberPanel