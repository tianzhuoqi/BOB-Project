local FleetMemberPanelBinder = class("FleetMemberPanelBinder");

function FleetMemberPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("Anchor_Top/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_ButtonClose = transform:Find("Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
	self.m_Model_Pos = transform:Find("Anchor_Center/m_Model_Pos").gameObject;
	self.m_Object = transform:Find("Anchor_Center/m_Model_Pos/m_Object").gameObject;
	self.m_Name = transform:Find("Anchor_Center/m_Name"):GetComponent("UILabel");
	self.m_Label_Count = transform:Find("Anchor_Center/m_Name/g3N/m_Label_Count"):GetComponent("UILabel");
	self.m_Confirm = transform:Find("Anchor_Center/g1/m_Confirm").gameObject;
	self.m_Cancel = transform:Find("Anchor_Center/g1/m_Cancel"):GetComponent("UILabel");
	self.m_BtnChangeName = transform:Find("Anchor_Center/m_BtnChangeName"):GetComponent("UIButton");
end
return FleetMemberPanelBinder