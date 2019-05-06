local FleetPortPanelBinder = class("FleetPortPanelBinder");

function FleetPortPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Title = transform:Find("Anchor_Top/m_Title"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("Anchor_Top/m_Title/m_LabelLv"):GetComponent("UILabel");
	self.m_ButtonClose = transform:Find("Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
	self.m_Model_Pos = transform:Find("Anchor_Center/m_Model_Pos").gameObject;
	self.m_Object = transform:Find("Anchor_Center/m_Model_Pos/m_Object").gameObject;
	self.m_TabView = transform:Find("Anchor_Center/m_TabView").gameObject;
	self.m_point01 = transform:Find("Anchor_Center/m_TabView/Tabs/Tab 0/m_point01"):GetComponent("UISprite");
	self.m_point02 = transform:Find("Anchor_Center/m_TabView/Tabs/Tab 1/m_point02"):GetComponent("UISprite");
	self.m_point03 = transform:Find("Anchor_Center/m_TabView/Tabs/Tab 2/m_point03"):GetComponent("UISprite");
end
return FleetPortPanelBinder