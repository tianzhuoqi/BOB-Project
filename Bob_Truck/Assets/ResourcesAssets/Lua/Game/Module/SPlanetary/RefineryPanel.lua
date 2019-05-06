local RefineryMediator = require("Game/Module/SPlanetary/RefineryMediator")
local RefineryPanel = register("RefineryPanel", PanelBase)
local RefineryPanelBinder = require("UIDef/RefineryPanelBinder");
function RefineryPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = RefineryPanelBinder.New(self.gameObject)
    self.uiBinder.m_ProgressBar = self.uiBinder.m_ProgressBar:GetComponent("UIProgressBar")
    self.uiTableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")

    self.mediator = RefineryMediator.New("RefineryMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function RefineryPanel:OpenPanel()
    RefineryPanel.super.OpenPanel(self)

    self:DoBlur()
    
    self.mediator:InitData()
end

return RefineryPanel