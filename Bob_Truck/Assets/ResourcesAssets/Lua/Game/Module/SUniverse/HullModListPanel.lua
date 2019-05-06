local HullModListMediator = require("Game/Module/SUniverse/HullModListMediator")
local HullModListPanel = register("HullModListPanel", PanelBase)
local HullModListPanelBinder = require("UIDef/HullModListPanelBinder");

function HullModListPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView()

    self.mediator = HullModListMediator.New("HullModListMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end


function HullModListPanel:OpenPanel()
    HullModListPanel.super.OpenPanel(self)

    self:DoBlur()
    self:ResetView()

    --初始化listview
    local UserDProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local nModCount = UserDProxy:GetHullModListCount()+1
    
    Facade:SendNotification("HullModListPanelLstVNotify", nModCount);
end

function HullModListPanel:DestroyPanel()
    
end

function HullModListPanel:ResetView()
   
end

function HullModListPanel:InitView()
    self.uiBinder = HullModListPanelBinder.New(self.gameObject)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnClose.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCloseClick)
end

function HullModListPanel:ButtonCloseClick()
    Facade:BackPanel()
end

return HullModListPanel