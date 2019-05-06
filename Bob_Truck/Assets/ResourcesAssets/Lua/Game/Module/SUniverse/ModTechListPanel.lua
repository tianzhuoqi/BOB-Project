local ModTechListMediator = require("Game/Module/SUniverse/ModTechListMediator")
local ModTechListPanel = register("ModTechListPanel", PanelBase)
local ModTechListPanelBinder = require("UIDef/ModTechListPanelBinder");

function ModTechListPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView()

    self.mediator = ModTechListMediator.New("ModTechListMediator")
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function ModTechListPanel:OpenPanel()
    ModTechListPanel.super.OpenPanel(self)

    self:ResetView()

    --初始化listview
    local UserDProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    local nModTechCount = UserDProxy:GetItemTypeListCount(NotiConst.ItemType.eIT_ShipModTech)    
    Facade:SendNotification("ModTechListPanelLstVNotify", nModTechCount);
end

function ModTechListPanel:DestroyPanel()
end

function ModTechListPanel:ResetView()
   
end

function ModTechListPanel:InitView()
    self.uiBinder = ModTechListPanelBinder.New(self.gameObject)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnClose.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonCloseClick)
end

function ModTechListPanel:ButtonCloseClick()
    Facade:BackPanel()
end

return ModTechListPanel