local SkillTreePanelBinder = class("SkillTreePanelBinder");

function SkillTreePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_Title02 = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Label_Title02"):GetComponent("UILabel");
	self.m_Button_Close = transform:Find("UI_Pos/Anchor_Top/GameObject_Title/m_Button_Close"):GetComponent("UIButton");
	self.m_TabView = transform:Find("UI_Pos/Anchor_Middle/m_TabView").gameObject;
	self.m_SubPanel = transform:Find("UI_Pos/Anchor_Middle/m_TabView/View/TabItem0/m_SubPanel").gameObject;
	self.m_GameObject_Accelerate = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate").gameObject;
	self.m_Progress_Slider = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate/ProgressBar/m_Progress_Slider"):GetComponent("UISlider");
	self.m_Label_SliderName = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate/ProgressBar/m_Label_SliderName"):GetComponent("UILabel");
	self.m_Label_SliderTimeRemain = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate/ProgressBar/m_Label_SliderTimeRemain"):GetComponent("UILabel");
	self.m_Button_immediatly = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate/m_Button_immediatly"):GetComponent("UIButton");
	self.m_Label_Cost = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate/m_Button_immediatly/GameObject/m_Label_Cost"):GetComponent("UILabel");
	self.m_Sprite_Cost = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Accelerate/m_Button_immediatly/GameObject/m_Sprite_Cost"):GetComponent("UISprite");
	self.m_GameObject_Detail = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Detail").gameObject;
	self.m_Sprite_DetailBG = transform:Find("UI_Pos/Anchor_Middle/m_GameObject_Detail/m_Sprite_DetailBG"):GetComponent("UISprite");
	self.m_Label_TechCount = transform:Find("UI_Pos/Anchor_Middle/m_Label_TechCount"):GetComponent("UILabel");
	self.m_Label_Aggregate = transform:Find("UI_Pos/Anchor_Middle/m_Label_Aggregate"):GetComponent("UILabel");
	self.m_GameObject_Queue = transform:Find("UI_Pos/Anchor_Bottom/m_GameObject_Queue").gameObject;
	self.m_Progress_Queue = transform:Find("UI_Pos/Anchor_Bottom/m_GameObject_Queue/m_Progress_Queue"):GetComponent("UISlider");
	self.m_Label_QueueLabel = transform:Find("UI_Pos/Anchor_Bottom/m_GameObject_Queue/m_Label_QueueLabel"):GetComponent("UILabel");
	self.m_Button_Cancle = transform:Find("UI_Pos/Anchor_Bottom/m_GameObject_Queue/m_Button_Cancle"):GetComponent("UIButton");
	self.m_Button_Go = transform:Find("UI_Pos/Anchor_Bottom/m_GameObject_Queue/m_Button_Go"):GetComponent("UIButton");
end
return SkillTreePanelBinder