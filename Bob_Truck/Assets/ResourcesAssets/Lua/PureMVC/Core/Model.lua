local Model = class("Model")

function Model:ctor()
	self.m_proxyMap = {}
	self:InitializeModel()
end

function Model:RegisterProxy(proxy)
	self.m_proxyMap[proxy:GetProxyName()] = proxy
	proxy:OnRegister()
end

function Model:RetrieveProxy(proxyName)
	return self.m_proxyMap[proxyName]
end

function Model:HasProxy(proxyName)
	return self.m_proxyMap[proxyName] ~= nil
end

function Model:RemoveProxy(proxyName)
	local proxy = nil

	if self.m_proxyMap[proxyName] then
		proxy = self:RetrieveProxy(proxyName)
		self.m_proxyMap[proxyName] = nil
	end

	if proxy then 
		proxy:OnRemove()
	end
	return proxy
end

function Model.Instance()
	if Model.m_instance == nil then
		Model.m_instance = Model.New()
	end

	return Model.m_instance
end

function Model:InitializeModel()
end

function Model:Clean()
	self.m_proxyMap = {}
end

return Model