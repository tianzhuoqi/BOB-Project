local UIGuidePanelBinder = class("UIGuidePanelBinder");

function UIGuidePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Force = transform:Find("m_Force").gameObject;
end
return UIGuidePanelBinder