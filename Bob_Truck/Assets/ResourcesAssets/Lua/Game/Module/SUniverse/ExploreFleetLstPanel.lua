--[[
点击星系 探索弹出界面
--]]
local ExploreFleetLstMediator = require("Game/Module/SUniverse/ExploreFleetLstMediator")
local ExploreFleetLstPanel = register("ExploreFleetLstPanel", PanelBase)
local ExploreFleetLstPanelBinder = require("UIDef/ExploreFleetLstPanelBinder");
function ExploreFleetLstPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView()
    
    self.mediator = ExploreFleetLstMediator.New("ExploreFleetLstMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end


function ExploreFleetLstPanel:OpenPanel()
    ExploreFleetLstPanel.super.OpenPanel(self)

    self:DoBlur()
    --初始化ListView 
    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local stSelOperInfo = fleetProxy:GetCurrentOperation()
    local fleetList = fleetProxy:GetFleetListInfoData()
    Facade:SendNotification("ExploreFleetLstListVNotify", #fleetList);
end

function ExploreFleetLstPanel:InitView()
    self.uiBinder = ExploreFleetLstPanelBinder.New(self.gameObject)

    
    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, ExploreFleetLstPanel.ButtonCloseClick)
end

function ExploreFleetLstPanel:ButtonCloseClick()
    Facade:BackPanel()
end

return ExploreFleetLstPanel