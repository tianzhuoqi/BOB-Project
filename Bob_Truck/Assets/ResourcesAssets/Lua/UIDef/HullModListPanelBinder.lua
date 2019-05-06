local HullModListPanelBinder = class("HullModListPanelBinder");

function HullModListPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnClose = transform:Find("Anchor_Top/m_btnClose"):GetComponent("UIButton");
end
return HullModListPanelBinder