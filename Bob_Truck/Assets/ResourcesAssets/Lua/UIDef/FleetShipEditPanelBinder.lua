local FleetShipEditPanelBinder = class("FleetShipEditPanelBinder");

function FleetShipEditPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_ButtonClose = transform:Find("m_ButtonClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("m_Label_TitleKey"):GetComponent("UILabel");
	self.m_Label = transform:Find("m_Label_TitleKey/m_Label"):GetComponent("UILabel");
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Edit = transform:Find("g1/m_Edit"):GetComponent("UILabel");
	self.m_Create = transform:Find("g1/m_Create"):GetComponent("UILabel");
	self.m_Cancel = transform:Find("g1/m_Cancel"):GetComponent("UILabel");
	self.m_Des = transform:Find("g1/m_Des"):GetComponent("UILabel");
end
return FleetShipEditPanelBinder