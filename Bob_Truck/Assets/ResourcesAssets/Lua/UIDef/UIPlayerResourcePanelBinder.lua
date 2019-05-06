local UIPlayerResourcePanelBinder = class("UIPlayerResourcePanelBinder");

function UIPlayerResourcePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd").gameObject;
	self.m_Civilization = transform:Find("Main/m_Civilization"):GetComponent("UILabel");
	self.m_Gas = transform:Find("Main/m_Gas"):GetComponent("UILabel");
	self.m_Stone = transform:Find("Main/m_Stone"):GetComponent("UILabel");
	self.m_LabelMoneyVal = transform:Find("Main/m_LabelMoneyVal"):GetComponent("UILabel");
	self.m_LabeUserNam = transform:Find("Main/m_LabeUserNam"):GetComponent("UILabel");
	self.m_LabeUserLv = transform:Find("Main/m_LabeUserNam/m_LabeUserLv"):GetComponent("UILabel");
end
return UIPlayerResourcePanelBinder