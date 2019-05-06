local FleetMediator = require("Game/Module/SUniverse/FleetMediator")
local FleetPanel = register("FleetPanel", PanelBase)
local FleetPanelBinder = require("UIDef/FleetPanelBinder");

function FleetPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView()

    self.mediator = FleetMediator.New(NotiConst.FleetMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetPanel:InitView()
    self.uiBinder = FleetPanelBinder.New(self.gameObject)
    self.tableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")
    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, FleetPanel.ButtonCloseClick)
end

function FleetPanel:ScrollReset()
    self.tableView:ResetState()
    self.tableView:ScrollResetPosition()
end

function FleetPanel:ButtonCloseClick()
    Facade:BackPanel()
end

function FleetPanel:OpenPanel()
    FleetPanel.super.OpenPanel(self)

    self:DoBlur()
    self.mediator:UpdateList()
    self.mediator:RequestList()
end

return FleetPanel