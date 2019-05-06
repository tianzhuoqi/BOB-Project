local WidgetBase = class("WidgetBase", ViewComponent)

function WidgetBase:Awake(gameObject) 
    self.gameObject = gameObject
end

function WidgetBase:OnClick()
end

function WidgetBase:OnPress(pressed)
end

function WidgetBase:OnLongPress()
end

function WidgetBase:OnDrag(delta)
end

function WidgetBase:OnScroll(delta)
end

function WidgetBase:OnDropUp(index, notificationKey)
end

function WidgetBase:OnDestroy()
    self:StopAllCoroutines()
end

return WidgetBase