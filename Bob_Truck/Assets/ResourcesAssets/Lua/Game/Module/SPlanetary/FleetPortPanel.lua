local FleetPortMediator = require("Game/Module/SPlanetary/FleetPortMediator")
local FleetPortPanel = register("FleetPortPanel", PanelBase)
local FleetPortPanelBinder = require("UIDef/FleetPortPanelBinder");

function FleetPortPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = FleetPortPanelBinder.New(self.gameObject)

    self.mediator = FleetPortMediator.New(NotiConst.FleetPortMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetPortPanel:OpenPanel()
    FleetPortPanel.super.OpenPanel(self)

    self:DoBlur()

    self.uiBinder.m_Model_Pos:SetActive(false)

    self.mediator:InitData()
end

function FleetPortPanel:ClosePanel()
    self.uiBinder.m_Model_Pos:SetActive(false)
end

function FleetPortPanel:ReopenPanel()
    self.uiBinder.m_Model_Pos:SetActive(true)
end

return FleetPortPanel