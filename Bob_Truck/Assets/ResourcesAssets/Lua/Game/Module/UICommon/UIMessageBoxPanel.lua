local UIMessageBoxMediator = require("Game/Module/UICommon/UIMessageBoxMediator")
local UIMessageBoxPanel = register("UIMessageBoxPanel", PanelBase)

function UIMessageBoxPanel:Awake(gameObject)
    self.gameObject = gameObject

    self.mediator = UIMessageBoxMediator.New("UIMessageBoxMediator")
    Facade:RegisterMediator(self.mediator)
    self.mediator:SetViewComponent(self)

    --self.scrollview = self:FindComponent("scrollviewpanel", "UIScrollView")
    self.content = self:FindGameObject("scrollviewpanel").transform:Find("content"):GetComponent("UILabel")
    self.title = self:FindComponent("title", "UILabel")
    self.centerBtn = self:FindGameObject("centerbtn")
    self.enterBtn = self:FindGameObject("enterbtn")
    self.cancelBtn = self:FindGameObject("cancelbtn")
    self.enterLabel = self.enterBtn.transform:Find("enterlabel"):GetComponent("UILabel")
    self.cancelLabel = self.cancelBtn.transform:Find("cancellabel"):GetComponent("UILabel")
    self.maskClose = self:FindGameObject("mask")

    self.blurScript = self:FindGameObject("mask"):GetComponent("NUIMsgBoxStaticBlur")      --模糊脚本
    --OnClick的绑定
    local NLuaClickEvent = NLuaClickEvent.Get(self.centerBtn.gameObject)
    NLuaClickEvent:AddClick(self, self.OnCenterBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.enterBtn.gameObject)
    NLuaClickEvent:AddClick(self, self.OnEnterBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.cancelBtn.gameObject)
    NLuaClickEvent:AddClick(self, self.OnCancelBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.maskClose.gameObject)
    NLuaClickEvent:AddClick(self, self.OnCloseClick)

    self.BlurRadius = 20.0
end

function UIMessageBoxPanel:OpenPanel()
    self.blurScript:GaussianBlur()
    self.gameObject:SetActive(true)

end

function UIMessageBoxPanel:ReopenPanel()
    self.blurScript:GaussianBlur()
    self.gameObject:SetActive(true)
end

function UIMessageBoxPanel:DestroyPanel() 
    Facade:RemoveMediator(self.mediator:GetMediatorName())
end

function UIMessageBoxPanel:ClosePanel()
    self:StopAllCoroutines()
end

function UIMessageBoxPanel:OnCenterBtnClick()
    self.mediator:EnterCallback()
    CloseMessageBox()
end

function UIMessageBoxPanel:OnEnterBtnClick()
    self.mediator:EnterCallback()
    CloseMessageBox()
end

function UIMessageBoxPanel:OnCancelBtnClick()
    self.mediator:CancelCallback()
    CloseMessageBox()
end

function UIMessageBoxPanel:OnCloseClick()
    self.mediator:EnterCallback()
    CloseMessageBox()
end

function UIMessageBoxPanel:CloseTimer()
    coroutine.wait(2)
    self.mediator:EnterCallback()
    CloseMessageBox()
end