local ListViewMediator = class("ListViewMediator", MediatorDynamic)

function ListViewMediator:OnRegister()
    local view = self:GetViewComponent()
    self:RegisterObserver(view.notificationName, "HandleNotification")
end

function ListViewMediator:HandleNotification(notification)
    local body = notification:GetBody()
    local isScrollReset = false
    if type(body) == "number" then
        self.dataCount = notification:GetBody()
    else
        self.dataCount = body.dataCount
        isScrollReset = self.isScrollReset
    end
    local view = self:GetViewComponent()
    view:Init(isScrollReset)
end

function ListViewMediator:DataCount()
    if self.dataCount == nil then
        return 0
    else
        return self.dataCount
    end
end

return ListViewMediator