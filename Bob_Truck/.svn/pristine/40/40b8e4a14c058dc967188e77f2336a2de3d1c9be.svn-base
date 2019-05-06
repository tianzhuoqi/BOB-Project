local ExplorationResultMediator = require("Game/Module/SPlanetary/ExplorationResultMediator")
local ExplorationResultPanel = register("ExplorationResultPanel", PanelBase)
local MCamerCtrl = require("Common/CameraCtrl")

function PlanetaryPanel:Awake(gameObject)
    self.gameObject = gameObject
    -- mediator
    self.mediator = ExplorationResultMediator.New("ExplorationResultMediator")
	self.mediator:SetViewComponent(self)
    Facade:RegisterMediator(self.mediator)
    -- obj
    self.blur = self:FindComponent("blurMask", "NUIMsgBoxStaticBlur")
    self.backBtn = self.FindGameObject("top_banner/back_button")
end

function PlanetaryPanel:OpenPanel()
    PlanetaryPanel.super.OpenPanel(self)

    self.mediator:ShowExplorationResult()
end

return ExplorationResultPanel