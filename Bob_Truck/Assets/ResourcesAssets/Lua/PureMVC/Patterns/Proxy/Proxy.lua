local Proxy = class("Proxy", Notifier)

Proxy.NAME = "Proxy"
function Proxy:ctor(proxyName, data)
	if not proxyName then 
		proxyName = Proxy.NAME 
	end
	self.m_proxyName = proxyName
	self.m_data = data
end

function Proxy:OnRegister()
end

function Proxy:OnRemove()
end

function Proxy:GetProxyName()
	return self.m_proxyName
end

function Proxy:GetData()
	return self.m_data
end

function Proxy:SetData(value)
	self.m_data = value
end

return Proxy
