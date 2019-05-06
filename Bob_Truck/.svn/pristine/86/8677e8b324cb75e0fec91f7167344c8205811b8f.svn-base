local FleetShipQueueEditPanelBinder = class("FleetShipQueueEditPanelBinder");

function FleetShipQueueEditPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_ButtonClose = transform:Find("m_ButtonClose"):GetComponent("UIButton");
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Title = transform:Find("m_Title"):GetComponent("UILabel");
	self.m_Name = transform:Find("m_Name"):GetComponent("UILabel");
	self.m_Save = transform:Find("g1/m_Save"):GetComponent("UILabel");
	self.m_Cancel = transform:Find("g1/m_Cancel"):GetComponent("UILabel");
end
return FleetShipQueueEditPanelBinder