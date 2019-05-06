local UIMenuPanelBinder = class("UIMenuPanelBinder");

function UIMenuPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_BackButton = transform:Find("Anchor_Bottom/m_BackButton"):GetComponent("UIButton");
	self.m_EnterPlanetaryButton = transform:Find("Anchor_Bottom/m_EnterPlanetaryButton"):GetComponent("UIButton");
	self.m_TechButton = transform:Find("Anchor_Bottom/m_TechButton"):GetComponent("UIButton");
	self.m_Feelt = transform:Find("Anchor_Bottom/m_Feelt"):GetComponent("UIButton");
	self.m_FleetCount = transform:Find("Anchor_Bottom/m_Feelt/m_FleetCount"):GetComponent("UILabel");
	self.m_GroupGM = transform:Find("Anchor_Bottom/m_GroupGM").gameObject;
	self.m_ButtonOk = transform:Find("Anchor_Bottom/m_GroupGM/m_ButtonOk"):GetComponent("UIButton");
	self.m_EditboxGM = transform:Find("Anchor_Bottom/m_GroupGM/m_EditboxGM"):GetComponent("UIInput");
	self.m_MapButton = transform:Find("Anchor_Bottom/m_MapButton"):GetComponent("UIButton");
	self.m_bkgnd = transform:Find("m_bkgnd").gameObject;
end
return UIMenuPanelBinder