local FormRefitPanelBinder = class("FormRefitPanelBinder");

function FormRefitPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Button_Close = transform:Find("UI_Pos/Anchor_Top/m_Button_Close"):GetComponent("UIButton");
	self.m_Title = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Title"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Title/m_LabelLv"):GetComponent("UILabel");
	self.m_Label_SelectedNumber = transform:Find("UI_Pos/Anchor_Middle/m_Label_SelectedNumber"):GetComponent("UILabel");
	self.m_Label_Skill = transform:Find("UI_Pos/Anchor_Middle/m_Label_Skill"):GetComponent("UILabel");
	self.m_Button_Yes = transform:Find("UI_Pos/Anchor_Middle/m_Button_Yes"):GetComponent("UIButton");
	self.m_Button_No = transform:Find("UI_Pos/Anchor_Middle/m_Button_No"):GetComponent("UIButton");
end
return FormRefitPanelBinder