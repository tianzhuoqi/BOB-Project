local RenamePanelBinder = class("RenamePanelBinder");

function RenamePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_ButtonOK = transform:Find("Anchor_Center/m_ButtonOK"):GetComponent("UIButton");
	self.m_LabelName = transform:Find("Anchor_Center/m_LabelName"):GetComponent("UIInput");
	self.m_ButtonBake = transform:Find("Anchor_Center/m_ButtonBake"):GetComponent("UIButton");
end
return RenamePanelBinder