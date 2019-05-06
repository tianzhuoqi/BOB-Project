local BuildingListPanelBinder = class("BuildingListPanelBinder");

function BuildingListPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_TabView = transform:Find("Anchor_Center/BuildList/m_TabView").gameObject;
	self.m_SubPanel = transform:Find("Anchor_Center/BuildList/m_TabView/View/TabItem 0/ListViewMacro/m_SubPanel").gameObject;
end
return BuildingListPanelBinder