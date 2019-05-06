local MarkListPanelBinder = class("MarkListPanelBinder");

function MarkListPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_btnClickClose = transform:Find("m_btnClickClose").gameObject;
	self.m_SubPanel = transform:Find("Anchor_Bottom/AllListView/m_SubPanel").gameObject;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
end
return MarkListPanelBinder