local FleetDirectivePanelBinder = class("FleetDirectivePanelBinder");

function FleetDirectivePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_SubPanel = transform:Find("Anchor_Center/ListViewSimple_Directive/m_SubPanel").gameObject;
end
return FleetDirectivePanelBinder