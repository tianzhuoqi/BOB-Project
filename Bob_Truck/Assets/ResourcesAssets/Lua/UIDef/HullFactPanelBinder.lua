local HullFactPanelBinder = class("HullFactPanelBinder");

function HullFactPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_ButtonClose = transform:Find("m_ButtonClose"):GetComponent("UIButton");
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Title = transform:Find("m_Title"):GetComponent("UILabel");
	self.m_ItemListView = transform:Find("TabView/View/TabItem/m_ItemListView").gameObject;
	self.m_ButtonReceive = transform:Find("m_ButtonReceive"):GetComponent("UIButton");
end
return HullFactPanelBinder