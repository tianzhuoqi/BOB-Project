local UIMessageBoxMediator = class("UIMessageBoxMediator", MediatorDynamic)

function UIMessageBoxMediator:OnRegister()
    self:RegisterObserver(NotiConst.Utility_OpenMessageBox, "OpenMessageBox")
end

function UIMessageBoxMediator:OpenMessageBox(notification)
    self.view = self:GetViewComponent()
    local body = notification:GetBody()

    self:Create(body.type, body.content, body.title)
    -- set callback
    self.enterCallback = body.enterCallback
    self.cancelCallback = body.cancelCallback
end

function UIMessageBoxMediator:Create(type, content, title)
    local view = self.view
    self:SetType(type)
    if content ~= nil then
        view.content.text = content
    else
        view.content.text = "empty content"
    end
    if title ~= nil then
        view.title.text = title
    else
        view.title.text = "MsgBox"
    end
end

function UIMessageBoxMediator:SetType(type)
    local view = self.view
    if(type == nil) then
        type = NotiConst.MessageBoxType.Confirm
    end
    if type == NotiConst.MessageBoxType.Confirm then                          
       view.centerBtn.gameObject:SetActive(true)
       view.enterBtn.gameObject:SetActive(false)
       view.cancelBtn.gameObject:SetActive(false)
    elseif type == NotiConst.MessageBoxType.EnterCancel then               
       view.centerBtn.gameObject:SetActive(false)
       view.enterBtn.gameObject:SetActive(true)
       view.cancelBtn.gameObject:SetActive(true)
    elseif type == NotiConst.MessageBoxType.Tip then 
       view.centerBtn.gameObject:SetActive(false)
       view.enterBtn.gameObject:SetActive(false)
       view.cancelBtn.gameObject:SetActive(false)
       view:StartCoroutine(view.CloseTimer)
    end    
end

function UIMessageBoxMediator:EnterCallback()
    if self.enterCallback ~= nil then
        self.enterCallback()
    end
end

function UIMessageBoxMediator:CancelCallback()
    if self.cancelCallback ~= nil then
        self.cancelCallback()
    end
end

return UIMessageBoxMediator