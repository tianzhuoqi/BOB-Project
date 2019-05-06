local Mediator = class("Mediator", Notifier)

Mediator.NAME = "Mediator"

function Mediator:ctor(mediatorName)
	Mediator.super.ctor(self)
	if not mediatorName then 
		mediatorName = Mediator.NAME 
	end
	self.m_mediatorName = mediatorName
	self.observers = {}
end

function Mediator:ListNotificationInterests()
	return {}
end

function Mediator:RegisterObserver(notifyName,notifyMethod)
	local view = View.Instance()
	local observer = Observer.New(notifyMethod, self)
	view:RegisterObserver(notifyName, observer)
	self.observers[notifyName] = true
end

function Mediator:RemoveObserver(notifyName)
	local view = View.Instance()
	view:RemoveObserver(notifyName, self)
	self.observers[notifyName] = nil
end

function Mediator:HandleNotification(notification)
end

--创建
function Mediator:OnRegister()
end

--销毁
function Mediator:OnRemove()
	for k,v in pairs(self.observers) do
		self:RemoveObserver(k)
	end
end

function Mediator:GetMediatorName()
	return self.m_mediatorName
end

function Mediator:GetViewComponent()
	return self.m_viewComponent
end

function Mediator:SetViewComponent(value)
	self.m_viewComponent = value
end

return Mediator