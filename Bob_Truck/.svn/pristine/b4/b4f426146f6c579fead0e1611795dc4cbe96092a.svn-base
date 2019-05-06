local ShipBodyPanelBinder = class("ShipBodyPanelBinder");

function ShipBodyPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_TitleKey = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_Button_Close = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Button_Close"):GetComponent("UIButton");
	self.m_Button_More = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_More"):GetComponent("UIButton");
	self.m_Label_MbName = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_More/m_Label_MbName"):GetComponent("UILabel");
	self.m_Sprite_PeopleBG = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Sprite_PeopleBG"):GetComponent("UISprite");
	self.m_Label_PeopleEfficiency = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Sprite_PeopleBG/PeopleEfficiency/m_Label_PeopleEfficiency"):GetComponent("UILabel");
	self.m_GameObject_People = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Sprite_PeopleBG/m_GameObject_People").gameObject;
	self.m_Sprite_PeopleIcon = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Sprite_PeopleBG/m_GameObject_People/m_Sprite_PeopleIcon"):GetComponent("UISprite");
	self.m_Sprite_PeopleFrame = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Sprite_PeopleBG/m_GameObject_People/m_Sprite_PeopleFrame"):GetComponent("UISprite");
	self.m_Label_ProduceEfficiency = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Label_ProduceEfficiency"):GetComponent("UILabel");
	self.m_Button_Get = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_Get"):GetComponent("UIButton");
	self.m_CountDown = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_Get/m_CountDown"):GetComponent("UISprite");
	self.m_Label_Get = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_Get/Label_Getn/m_Label_Get"):GetComponent("UILabel");
	self.m_Button_JumHull = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_JumHull"):GetComponent("UIButton");
	self.m_Label_JumHull = transform:Find("UI_Pos/Anchor_Middle/PanelProduct/m_Button_JumHull/m_Label_JumHull"):GetComponent("UILabel");
	self.m_Hull_TabView = transform:Find("UI_Pos/Anchor_Middle/m_Hull_TabView").gameObject;
	self.m_SubPanel = transform:Find("UI_Pos/Anchor_Middle/m_Hull_TabView/View/TabItem 0/Hull_ListViewMacro/m_SubPanel").gameObject;
	self.m_PeopleList = transform:Find("UI_Pos/Anchor_Middle/m_PeopleList").gameObject;
	self.m_Sprite_PeopleBGBox = transform:Find("UI_Pos/Anchor_Middle/m_PeopleList/m_Sprite_PeopleBGBox"):GetComponent("UISprite");
end
return ShipBodyPanelBinder