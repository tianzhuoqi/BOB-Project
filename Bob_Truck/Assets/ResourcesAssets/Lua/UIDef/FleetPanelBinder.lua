local FleetPanelBinder = class("FleetPanelBinder");

function FleetPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_ButtonClose = transform:Find("UI_Pos/Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("UI_Pos/Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_SubPanel = transform:Find("UI_Pos/Anchor_Middle/AllListView/m_SubPanel").gameObject;
end
return FleetPanelBinder