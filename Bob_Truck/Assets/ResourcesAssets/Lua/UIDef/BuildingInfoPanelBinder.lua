local BuildingInfoPanelBinder = class("BuildingInfoPanelBinder");

function BuildingInfoPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("Anchor_Top/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Model_Pos = transform:Find("Anchor_Center/m_Model_Pos").gameObject;
	self.m_Object = transform:Find("Anchor_Center/m_Model_Pos/m_Object").gameObject;
	self.m_Label_DitelNameTitle1 = transform:Find("Anchor_Center/GameObject_Detil/ListViewSimple/SubPanel/m_Label_DitelNameTitle1"):GetComponent("UILabel");
	self.m_Label_DitelaiKey = transform:Find("Anchor_Center/GameObject_Detil/ListViewSimple/SubPanel/m_Label_DitelaiKey"):GetComponent("UILabel");
	self.m_Label_DitelNameTitle2 = transform:Find("Anchor_Center/GameObject_Detil/ListViewSimple/SubPanel/m_Label_DitelNameTitle2"):GetComponent("UILabel");
	self.m_Label_Ditelaikey1 = transform:Find("Anchor_Center/GameObject_Detil/ListViewSimple/SubPanel/Cell/m_Label_Ditelaikey1"):GetComponent("UILabel");
	self.m_Label1 = transform:Find("Anchor_Center/GameObject_Detil/ListViewSimple/SubPanel/Cell/m_Label_Ditelaikey1/m_Label1"):GetComponent("UILabel");
	self.m_Hero = transform:Find("Anchor_Center/GameObject_Detil/m_Hero"):GetComponent("UIButton");
	self.m_LabelKey2 = transform:Find("Anchor_Center/GameObject_Detil/m_Hero/m_LabelKey2"):GetComponent("UILabel");
	self.m_Label_SbLvTitle1 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_SbLvTitle1"):GetComponent("UILabel");
	self.m_Label_SbLvKey1 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_SbLvTitle1/m_Label_SbLvKey1"):GetComponent("UILabel");
	self.m_Label_SbLvTitle2 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_SbLvTitle2"):GetComponent("UILabel");
	self.m_Label_SbLvKey2 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_SbLvTitle2/m_Label_SbLvKey2"):GetComponent("UILabel");
	self.m_Label_DitelaiKeySco = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaiKeySco"):GetComponent("UILabel");
end
return BuildingInfoPanelBinder