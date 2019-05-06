local tian22222222222Binder = class("tian22222222222Binder");

function tian22222222222Binder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Force = transform:Find("m_Force").gameObject;
	self.m_testLabel = transform:Find("m_testLabel"):GetComponent("UILabel");
end
return tian22222222222Binder