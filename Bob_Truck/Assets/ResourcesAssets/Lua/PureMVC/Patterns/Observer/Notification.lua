local Notification = class("Notification")

function Notification:ctor(name, body, type)
	self.m_name = name
	self.m_body = body
	self.m_type = type
end

function Notification:GetName()
	return self.m_name
end
		
function Notification:GetBody()
	return self.m_body
end

function Notification:SetBody(value)
	self.m_body = value
end	

function Notification:GetType()
	return self.m_type
end

function Notification:SetType(value)
	self.m_type = value
end	

return Notification