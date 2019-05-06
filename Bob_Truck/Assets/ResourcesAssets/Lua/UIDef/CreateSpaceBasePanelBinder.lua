local CreateSpaceBasePanelBinder = class("CreateSpaceBasePanelBinder");

function CreateSpaceBasePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("Anchor_Top/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_btnSClose = transform:Find("Anchor_TopRight/m_btnSClose"):GetComponent("UIButton");
	self.m_Model_Pos = transform:Find("Anchor_Center/m_Model_Pos").gameObject;
	self.m_Object = transform:Find("Anchor_Center/m_Model_Pos/m_Object").gameObject;
	self.m_Label_DitelKey2 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelKey2"):GetComponent("UILabel");
	self.m_btnMessageBoard = transform:Find("Anchor_Center/GameObject_Detil/m_btnMessageBoard"):GetComponent("UIButton");
	self.m_LabelKey = transform:Find("Anchor_Center/GameObject_Detil/m_btnMessageBoard/m_LabelKey"):GetComponent("UILabel");
	self.m_Label_SbLvKey = transform:Find("Anchor_Center/GameObject_Detil/m_Label_SbLvKey"):GetComponent("UILabel");
	self.m_Label_DitelNameKey = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelNameKey"):GetComponent("UILabel");
	self.m_Label_DitelaiKey = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaiKey"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN001 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN001"):GetComponent("UILabel");
	self.m_Label1 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN001/m_Label1"):GetComponent("UILabel");
	self.m_Label_DitelKey02 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelKey02"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN002 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN002"):GetComponent("UILabel");
	self.m_Label2 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN002/m_Label2"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN003 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN003"):GetComponent("UILabel");
	self.m_Label3 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN003/m_Label3"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN004 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN004"):GetComponent("UILabel");
	self.m_Label4 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN004/m_Label4"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN005 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN005"):GetComponent("UILabel");
	self.m_Label5 = transform:Find("Anchor_Center/GameObject_Detil/ScrollView/m_Label_DitelaikeyN005/m_Label5"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN01 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaikeyN01"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN02 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaikeyN02"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN03 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaikeyN03"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN04 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaikeyN04"):GetComponent("UILabel");
	self.m_Label_DitelaikeyN05 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaikeyN05"):GetComponent("UILabel");
	self.m_Label_Ditelaikey1 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_Ditelaikey1"):GetComponent("UILabel");
	self.m_Label_DitelaiKey2 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaiKey2"):GetComponent("UILabel");
	self.m_Label_DitelaiKey3 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaiKey3"):GetComponent("UILabel");
	self.m_Label_DitelaiKey4 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaiKey4"):GetComponent("UILabel");
	self.m_Label_DitelaiKey5 = transform:Find("Anchor_Center/GameObject_Detil/m_Label_DitelaiKey5"):GetComponent("UILabel");
	self.m_Hero = transform:Find("Anchor_Center/GameObject_Detil/m_Hero"):GetComponent("UIButton");
	self.m_LabelKey2 = transform:Find("Anchor_Center/GameObject_Detil/m_Hero/m_LabelKey2"):GetComponent("UILabel");
end
return CreateSpaceBasePanelBinder