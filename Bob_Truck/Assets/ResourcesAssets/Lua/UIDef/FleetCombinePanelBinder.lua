local FleetCombinePanelBinder = class("FleetCombinePanelBinder");

function FleetCombinePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_ButtonClose = transform:Find("m_ButtonClose"):GetComponent("UIButton");
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Title = transform:Find("m_Title"):GetComponent("UILabel");
	self.m_CheckAll = transform:Find("m_CheckAll"):GetComponent("UILabel");
	self.m_Confirm = transform:Find("g1/m_Confirm"):GetComponent("UILabel");
	self.m_Cancel = transform:Find("g1/m_Cancel"):GetComponent("UILabel");
	self.m_Des = transform:Find("g1/m_Des"):GetComponent("UILabel");
end
return FleetCombinePanelBinder