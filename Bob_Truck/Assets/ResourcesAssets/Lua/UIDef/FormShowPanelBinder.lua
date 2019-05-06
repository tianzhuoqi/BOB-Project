local FormShowPanelBinder = class("FormShowPanelBinder");

function FormShowPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_Title = transform:Find("Anchor_Top/GameObject_Title/m_Label_Title"):GetComponent("UILabel");
	self.m_Model_Pos = transform:Find("Anchor_Middle/m_Model_Pos").gameObject;
	self.m_Object = transform:Find("Anchor_Middle/m_Model_Pos/m_Object").gameObject;
	self.m_Label_Name = transform:Find("Anchor_Middle/GameObject_Info/m_Label_Name"):GetComponent("UILabel");
	self.m_Label_NameV = transform:Find("Anchor_Middle/GameObject_Info/m_Label_Name/m_Label_NameV"):GetComponent("UILabel");
	self.m_Label_Info1 = transform:Find("Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info1"):GetComponent("UILabel");
	self.m_Label_Info2 = transform:Find("Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info2"):GetComponent("UILabel");
	self.m_Label_Info3 = transform:Find("Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info3"):GetComponent("UILabel");
	self.m_Button_TitleInfo = transform:Find("Anchor_Middle/GameObject_Info/m_Button_TitleInfo"):GetComponent("UIButton");
	self.m_Label_FatiV = transform:Find("Anchor_Middle/GameObject_Info/Label_FatiN/m_Label_FatiV"):GetComponent("UILabel");
	self.m_Sprite_PartsBG1 = transform:Find("Anchor_Middle/GameObject_Parts/Object_Parts1/m_Sprite_PartsBG1"):GetComponent("UITexture");
	self.m_Sprite_PartsBG2 = transform:Find("Anchor_Middle/GameObject_Parts/Object_Parts2/m_Sprite_PartsBG2"):GetComponent("UITexture");
	self.m_Sprite_PartsBG3 = transform:Find("Anchor_Middle/GameObject_Parts/Object_Parts3/m_Sprite_PartsBG3"):GetComponent("UITexture");
	self.m_Sprite_PartsBG4 = transform:Find("Anchor_Middle/GameObject_Parts/Object_Parts4/m_Sprite_PartsBG4"):GetComponent("UITexture");
	self.m_Button_Yes = transform:Find("Anchor_Middle/m_Button_Yes"):GetComponent("UIButton");
end
return FormShowPanelBinder