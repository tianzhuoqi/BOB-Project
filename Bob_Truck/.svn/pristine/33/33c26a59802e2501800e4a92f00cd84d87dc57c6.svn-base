local BuildingListMediator = require("Game/Module/SPlanetary/BuildingListMediator")
local BuildingListPanel = register("BuildingListPanel", PanelBase)
local BuildingListPanelBinder = require("UIDef/BuildingListPanelBinder")

function BuildingListPanel:Awake(gameObject)
	BuildingListPanel.super.Awake(self, gameObject)
	self.uiBinder = BuildingListPanelBinder.New(self.gameObject)

	self.mediator = BuildingListMediator.New(NotiConst.BuildingListMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function BuildingListPanel:OpenPanel()
	BuildingListPanel.super.OpenPanel(self)

	self:DoBlur()

	self.mediator:InitData()
end

return BuildingListPanel