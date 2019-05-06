local FormMainPanelBinder = class("FormMainPanelBinder");

function FormMainPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Button_Close = transform:Find("UI_Pos/Anchor_Top/m_Button_Close"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("UI_Pos/Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("UI_Pos/Anchor_Top/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_Button_NewModel = transform:Find("UI_Pos/Anchor_Middle/m_Button_NewModel"):GetComponent("UIButton");
	self.m_SubPanel = transform:Find("UI_Pos/Anchor_Middle/GameObject_ListViewSimple/m_SubPanel").gameObject;
end
return FormMainPanelBinder