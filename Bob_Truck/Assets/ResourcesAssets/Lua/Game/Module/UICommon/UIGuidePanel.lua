local UIGuideMediator = require("Game/Module/UICommon/UIGuideMediator")
local UIGuidePanel = register("UIGuidePanel", PanelBase)
local UIGuidePanelBinder = require("UIDef/UIGuidePanelBinder")

function UIGuidePanel:Awake(gameObject)
    UIGuidePanel.super.Awake(self, gameObject)
    self.uiBinder = UIGuidePanelBinder.New(self.gameObject)

    self.mediator = UIGuideMediator.New("UIGuideMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

return UIGuidePanel