local CollectPanelBinder = class("CollectPanelBinder");

function CollectPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_Label_TitleKey = transform:Find("UI_Pos/Anchor_Top/Title/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("UI_Pos/Anchor_Top/Title/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_ButtonClose = transform:Find("UI_Pos/Anchor_Top/Title/m_ButtonClose"):GetComponent("UIButton");
	self.m_Model_building_Pos  = transform:Find("UI_Pos/Anchor_Middle/content/m_Model_building_Pos "):GetComponent("UITexture");
	self.m_CollectResource = transform:Find("UI_Pos/Anchor_Middle/content/m_CollectResource").gameObject;
	self.m_Collect_Frame = transform:Find("UI_Pos/Anchor_Middle/content/m_CollectResource/m_Collect_Frame"):GetComponent("UISprite");
	self.m_Collect_Icon = transform:Find("UI_Pos/Anchor_Middle/content/m_CollectResource/m_Collect_Icon"):GetComponent("UITexture");
	self.m_Collect_Time = transform:Find("UI_Pos/Anchor_Middle/content/m_CollectResource/m_Collect_Time"):GetComponent("UILabel");
	self.m_Collect_Count = transform:Find("UI_Pos/Anchor_Middle/content/m_CollectResource/m_Collect_Count"):GetComponent("UILabel");
	self.m_Collect_ProgressBar = transform:Find("UI_Pos/Anchor_Middle/content/m_CollectResource/m_Collect_ProgressBar"):GetComponent("UISlider");
	self.m_Button_mineral = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral"):GetComponent("UIButton");
	self.m_SelectMineral = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral").gameObject;
	self.m_Mineral_Icon = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/m_Mineral_Icon"):GetComponent("UITexture");
	self.m_Mineral_Name = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/m_Mineral_Name"):GetComponent("UILabel");
	self.m_Mineral_Frame = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/m_Mineral_Frame"):GetComponent("UISprite");
	self.m_LabelName01 = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/CollectSpeed/m_LabelName01"):GetComponent("UILabel");
	self.m_LabelValue01 = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/CollectSpeed/m_LabelValue01"):GetComponent("UILabel");
	self.m_LabelAdd = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/CollectSpeed/m_LabelValue01/m_LabelAdd"):GetComponent("UILabel");
	self.m_LabelValue02 = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Button_mineral/m_SelectMineral/CollectSpeed/m_LabelValue02"):GetComponent("UILabel");
	self.m_Mineral_ProgressBar = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Mineral_ProgressBar"):GetComponent("UISlider");
	self.m_Mineral_Fineness = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_Mineral_ProgressBar/m_Mineral_Fineness"):GetComponent("UILabel");
	self.m_ReceiveSign = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_ReceiveSign"):GetComponent("UISprite");
	self.m_FullSign = transform:Find("UI_Pos/Anchor_Middle/content/MineralItem/m_FullSign"):GetComponent("UISprite");
	self.m_Button_zoom = transform:Find("UI_Pos/Anchor_Middle/content/star/m_Button_zoom"):GetComponent("UIButton");
	self.m_StarsScrollView = transform:Find("UI_Pos/Anchor_Middle/content/star/star_ListViewSimple/m_StarsScrollView").gameObject;
	self.m_backpack_GameObject = transform:Find("UI_Pos/Anchor_Middle/content/m_backpack_GameObject").gameObject;
	self.m_ResourcesScrollView = transform:Find("UI_Pos/Anchor_Middle/content/m_backpack_GameObject/backpack_ListViewMacro/m_ResourcesScrollView").gameObject;
	self.m_MineraSelect_Button = transform:Find("UI_Pos/Anchor_Middle/content/m_backpack_GameObject/m_MineraSelect_Button"):GetComponent("UIButton");
	self.m_CloseMineral_Button = transform:Find("UI_Pos/Anchor_Middle/content/m_backpack_GameObject/m_CloseMineral_Button").gameObject;
	self.m_Hero = transform:Find("UI_Pos/Anchor_Middle/m_Hero"):GetComponent("UIButton");
	self.m_LabelKey2 = transform:Find("UI_Pos/Anchor_Middle/m_Hero/m_LabelKey2"):GetComponent("UILabel");
	self.m_CollectPlanet3D = transform:Find("m_CollectPlanet3D").gameObject;
	self.m_PlanetPool = transform:Find("m_CollectPlanet3D/m_PlanetPool").gameObject;
	self.m_Builiding3D = transform:Find("m_CollectPlanet3D/3DCollectBuilding/m_Builiding3D").gameObject;
end
return CollectPanelBinder