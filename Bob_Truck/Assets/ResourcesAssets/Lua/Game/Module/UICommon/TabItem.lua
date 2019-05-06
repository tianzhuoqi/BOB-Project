local TabItem = register("TabItem", WidgetBase)

function TabItem:Init(index, notificationName)
    LogDebug('TabItem Init index:{0}, notificationName:{1}', index, notificationName)
    Facade:SendNotification(notificationName, index)

    ManagerIntro:TriggerIntro()
end

return TabItem