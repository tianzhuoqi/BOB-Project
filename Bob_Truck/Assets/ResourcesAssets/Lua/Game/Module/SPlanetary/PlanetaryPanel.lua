local PlanetaryMediator = require("Game/Module/SPlanetary/PlanetaryMediator")
local PlanetaryPanel = register("PlanetaryPanel", PanelBase)
local MCamerCtrl = require("Common/CameraCtrl")
local PlanetaryPanelBinder = require("UIDef/PlanetaryPanelBinder");

function PlanetaryPanel:Awake(gameObject)
	self.gameObject = gameObject

	self.uiBinder = PlanetaryPanelBinder.New(self.gameObject);
	
	self.mediator = PlanetaryMediator.New("PlanetaryMediator")
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function PlanetaryPanel:OpenPanel()
	PlanetaryPanel.super.OpenPanel(self)

	self.mediator:BuildPlanetary()
end

function PlanetaryPanel:OnPopupClose()
    self.groupPopup:SetActive(false)
end

return PlanetaryPanel