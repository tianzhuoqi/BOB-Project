local FleetDisbandPanelBinder = class("FleetDisbandPanelBinder");

function FleetDisbandPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Confirm = transform:Find("Anchor_Middle/g1/m_Confirm"):GetComponent("UILabel");
	self.m_Cancel = transform:Find("Anchor_Middle/g1/m_Cancel"):GetComponent("UILabel");
	self.m_Des = transform:Find("Anchor_Middle/g1/m_Des"):GetComponent("UILabel");
	self.m_ButtonClose = transform:Find("Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
	self.m_Title = transform:Find("Anchor_Top/GameObject_Title/m_Title"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("Anchor_Top/GameObject_Title/m_Title/m_LabelLv"):GetComponent("UILabel");
	self.m_CheckAll = transform:Find("m_CheckAll"):GetComponent("UILabel");
end
return FleetDisbandPanelBinder