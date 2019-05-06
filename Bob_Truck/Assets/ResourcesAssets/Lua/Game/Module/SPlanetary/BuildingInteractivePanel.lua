local BuildingInteractiveMediator = require("Game/Module/SPlanetary/BuildingInteractiveMediator")
local BuildingInteractivePanel = register("BuildingInteractivePanel", PanelBase)
local BuildingInteractivePanelBinder = require("UIDef/BuildingInteractivePanelBinder")

function BuildingInteractivePanel:Awake(gameObject)
	BuildingInteractivePanel.super.Awake(self, gameObject)
	self.uiBinder = BuildingInteractivePanelBinder.New(self.gameObject)

	self.mediator = BuildingInteractiveMediator.New(NotiConst.BuildingInteractiveMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function BuildingInteractivePanel:OpenPanel()
	BuildingInteractivePanel.super.OpenPanel(self)
	local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    Facade:SendNotification(NotiConst.Notify_BuildingInteractiveRefreshView, planetaryProxy:GetCurBuildingOper().targetBuilding)
end

return BuildingInteractivePanel