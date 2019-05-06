local UIWaitingMediator = class("UIWaitingMediator", MediatorDynamic)

function UIWaitingMediator:OnRegister()
    --将TestNotification与self.HandleNotification关联
    --self:RegisterObserver("OpenWaiting","RunWaitingObject")
    --self:RegisterObserver("CloseWaiting", "StopWaitingAndBack")
end

function UIWaitingMediator:RunWaitingObject()
    LogDebug("UIWaitingMediator.RunWaitingObject")
    local view = self:GetViewComponent()
    view:OpenPanel()
    view.waitingAnimation:Play()
end

function UIWaitingMediator:StopWaitingAndBack()
    LogDebug("UIWaitingMediator.StopWaitingAndBack")
    local view = self:GetViewComponent()
    view.waitingAnimation:Stop()
    view:ClosePanel()
end


return UIWaitingMediator