local IntroMediator = class("IntroMediator", MediatorDynamic)

function IntroMediator:OnRegister()
    local view = self:GetViewComponent()
    local notificationName = NotiConst.Utility_IntroWidget..view.introPoint
    self:RegisterObserver(notificationName, "HandleNotification")
end

function IntroMediator:HandleNotification(notification)
    local view = self:GetViewComponent()
    local content = {eventObject = view.eventObject, introId = notification:GetBody()}

    Facade:OpenUtilityPanel("UIGuidePanel")
	Facade:SendNotification(NotiConst.Utility_OpenGuide, content)
end

return IntroMediator