local HullFilterPanelBinder = class("HullFilterPanelBinder");

function HullFilterPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_Button_Close = transform:Find("Anchor_Top/GameObject_Title/m_Button_Close"):GetComponent("UIButton");
	self.m_Button_NewModel = transform:Find("Anchor_Middle/m_Button_NewModel"):GetComponent("UIButton");
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
end
return HullFilterPanelBinder