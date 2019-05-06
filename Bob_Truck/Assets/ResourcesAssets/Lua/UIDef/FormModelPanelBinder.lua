local FormModelPanelBinder = class("FormModelPanelBinder");

function FormModelPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_Title = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Label_Title"):GetComponent("UILabel");
	self.m_Label_Title02 = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Label_Title02"):GetComponent("UILabel");
	self.m_Button_Close = transform:Find("UI_Pos/Anchor_TopRight/m_Button_Close"):GetComponent("UIButton");
	self.m_HullTempModelShow = transform:Find("UI_Pos/Anchor_Middle/m_HullTempModelShow").gameObject;
	self.m_rtModel = transform:Find("UI_Pos/Anchor_Middle/ModelPanel/m_rtModel"):GetComponent("UITexture");
	self.m_GridGroup = transform:Find("UI_Pos/Anchor_Middle/ModelPanel/m_GridGroup").gameObject;
	self.m_Grid = transform:Find("UI_Pos/Anchor_Middle/ModelPanel/m_GridGroup/m_Grid"):GetComponent("UISprite");
	self.m_Label_Name = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/m_Label_Name"):GetComponent("UILabel");
	self.m_Button_Replace = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/m_Button_Replace"):GetComponent("UIButton");
	self.m_Label_Info1 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info1"):GetComponent("UILabel");
	self.m_Label_Info2 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info2"):GetComponent("UILabel");
	self.m_Label_Info3 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info3"):GetComponent("UILabel");
	self.m_Label_Info4 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info4"):GetComponent("UILabel");
	self.m_Label_Info5 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info5"):GetComponent("UILabel");
	self.m_Label_Info6 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info6"):GetComponent("UILabel");
	self.m_Label_Info7 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info7"):GetComponent("UILabel");
	self.m_Label_Info8 = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/GameObject_Info/m_Label_Info8"):GetComponent("UILabel");
	self.m_Button_TitleInfo = transform:Find("UI_Pos/Anchor_Middle/GameObject_Info/m_Button_TitleInfo"):GetComponent("UIButton");
	self.m_GameObject_Parts = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts").gameObject;
	self.m_Sprite_PartsIcon1 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts1/m_Sprite_PartsIcon1"):GetComponent("UITexture");
	self.m_Sprite_PartsFrame1 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts1/m_Sprite_PartsIcon1/m_Sprite_PartsFrame1"):GetComponent("UISprite");
	self.m_Sprite_PartsBG1 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts1/m_Sprite_PartsBG1"):GetComponent("UISprite");
	self.m_Sprite_PartsIcon2 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts2/m_Sprite_PartsIcon2"):GetComponent("UITexture");
	self.m_Sprite_PartsFrame2 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts2/m_Sprite_PartsIcon2/m_Sprite_PartsFrame2"):GetComponent("UISprite");
	self.m_Sprite_PartsBG2 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts2/m_Sprite_PartsBG2"):GetComponent("UISprite");
	self.m_Sprite_PartsIcon3 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts3/m_Sprite_PartsIcon3"):GetComponent("UITexture");
	self.m_Sprite_PartsFrame3 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts3/m_Sprite_PartsIcon3/m_Sprite_PartsFrame3"):GetComponent("UISprite");
	self.m_Sprite_PartsBG3 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts3/m_Sprite_PartsBG3"):GetComponent("UISprite");
	self.m_Sprite_PartsIcon4 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts4/m_Sprite_PartsIcon4"):GetComponent("UITexture");
	self.m_Sprite_PartsFrame4 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts4/m_Sprite_PartsIcon4/m_Sprite_PartsFrame4"):GetComponent("UISprite");
	self.m_Sprite_PartsBG4 = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Parts/Object_Parts4/m_Sprite_PartsBG4"):GetComponent("UISprite");
	self.m_GameObject_ModelPos = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_ModelPos"):GetComponent("UITexture");
	self.m_TabView = transform:Find("UI_Pos/Anchor_Middle/m_TabView").gameObject;
	self.m_DragScrollView = transform:Find("UI_Pos/Anchor_Middle/m_TabView/View/TabItem 0/GameObject_ListViewMacro/m_DragScrollView").gameObject;
	self.m_SubPanel = transform:Find("UI_Pos/Anchor_Middle/m_TabView/View/TabItem 0/GameObject_ListViewMacro/m_SubPanel").gameObject;
	self.m_Button_Yes = transform:Find("UI_Pos/Anchor_Middle/m_Button_Yes"):GetComponent("UIButton");
	self.m_Button_No = transform:Find("UI_Pos/Anchor_Middle/m_Button_No"):GetComponent("UIButton");
	self.m_GameObject_SkillList = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_SkillList").gameObject;
	self.m_Mod_Close = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_SkillList/m_Mod_Close"):GetComponent("UIButton");
	self.m_Sprite_PeopleBGBox = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_SkillList/m_Sprite_PeopleBGBox"):GetComponent("UISprite");
	self.m_GameObject_PartsList = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_PartsList").gameObject;
	self.m_Button_PartClose = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_PartsList/m_Button_PartClose"):GetComponent("UIButton");
	self.m_Sprite_PartsBGBox = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_PartsList/m_Sprite_PartsBGBox"):GetComponent("UISprite");
	self.m_Label_NeedBody = transform:Find("UI_Pos/Anchor_Middle/m_Label_NeedBody"):GetComponent("UILabel");
end
return FormModelPanelBinder