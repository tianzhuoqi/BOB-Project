local Notifier = class("Notifier")

function Notifier:ctor()
	self.m_facade = Facade.Instance()
end

function Notifier:SendNotification(notificationName, body, type) 
	self.m_facade:SendNotification(notificationName, body, type);
end

function Notifier:GetFacade()
	return self.m_facade;
end

return Notifier