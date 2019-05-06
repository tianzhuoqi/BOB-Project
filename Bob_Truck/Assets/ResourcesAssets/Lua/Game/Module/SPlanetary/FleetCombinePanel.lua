local FleetCombineMediator = require("Game/Module/SPlanetary/FleetCombineMediator")
local FleetCombinePanel = register("FleetCombinePanel", PanelBase)
local FleetCombinePanelBinder = require("UIDef/FleetCombinePanelBinder");

function FleetCombinePanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView();

    self.mediator = FleetCombineMediator.New(NotiConst.FleetCombineMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetCombinePanel:InitView()
    self.uiBinder = FleetCombinePanelBinder.New(self.gameObject);

    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, FleetCombinePanel.ButtonCloseClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_Cancel.gameObject)
    NLuaClickEvent:AddClick(self, FleetCombinePanel.ButtonCloseClick)
end

function FleetCombinePanel:ButtonCloseClick()
    Facade:BackPanel()
end

function FleetCombinePanel:OpenPanel()
    FleetCombinePanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitData()

    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local protFleetsData = fleetProxy:GetProtFleetsData()
    Facade:SendNotification("FleetCombinePanelNotify", #protFleetsData)
end

return FleetCombinePanel