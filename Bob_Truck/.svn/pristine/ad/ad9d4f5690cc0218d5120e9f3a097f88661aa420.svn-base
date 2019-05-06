local UITipsMediator = require("Game/Module/UICommon/UITipsMediator")
local UITipsPanel = register("UITipsPanel", PanelBase)

function UITipsPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.label = self:FindComponent("label", "UILabel")
    self.mediator = UITipsMediator.New("UITipsMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function UITipsPanel:ReopenPanel() 
    OpenPanel()
end

function UITipsPanel:DestroyPanel() 
    self:StopAllCoroutines()
    Facade:RemoveMediator(self.mediator:GetMediatorName())
end

return UITipsPanel