local MarkListMediator = require("Game/Module/SUniverse/MarkListMediator")
local MarkListPanel = register("MarkListPanel", PanelBase)
local MarkListPanelBinder = require("UIDef/MarkListPanelBinder")
local UnityInput = UnityEngine.Input
local UnityScreen = UnityEngine.Screen

function MarkListPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = MarkListPanelBinder.New(self.gameObject)

	self.mediator = MarkListMediator.New("MarkListMediator")
    self.mediator:SetViewComponent(self)
    Facade:RegisterMediator(self.mediator)

    local event = NLuaClickEvent.Get(self.uiBinder.m_btnClickClose)
    event:AddClick(self, self.ButtonCloseClick)
    event:AddPress(self, self.ButtonCloseClick)
end

function MarkListPanel:ButtonCloseClick()
    Facade:SendNotification(NotiConst.Notify_UniverseCameraCtrlIgnoreUI)
    Facade:BackPanel()
end



function MarkListPanel:OpenPanel()
    MarkListPanel.super.OpenPanel(self)
    self:DoBlur()
    self.mediator:UpdateMarkList()
    self.mediator:RequestMarkList()
end


return MarkListPanel