local FleetGoodsPanelBinder = class("FleetGoodsPanelBinder");

function FleetGoodsPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_ButtonClose = transform:Find("Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
	self.m_GoodsTabView = transform:Find("Anchor_Center/m_GoodsTabView").gameObject;
	self.m_fleet_cube = transform:Find("Anchor_Center/m_GoodsTabView/View/TabItem 0/Fleet/TipFleet/m_fleet_cube"):GetComponent("UILabel");
	self.m_fleet_Bar = transform:Find("Anchor_Center/m_GoodsTabView/View/TabItem 0/Fleet/TipFleet/m_fleet_Bar"):GetComponent("UISprite");
	self.m_Fleet_SubPanel = transform:Find("Anchor_Center/m_GoodsTabView/View/TabItem 0/Fleet/ListViewMacro/m_Fleet_SubPanel").gameObject;
	self.m_depot_cube = transform:Find("Anchor_Center/m_GoodsTabView/View/TabItem 0/Depot/TipWarehouse/m_depot_cube"):GetComponent("UILabel");
	self.m_depot_Bar = transform:Find("Anchor_Center/m_GoodsTabView/View/TabItem 0/Depot/TipWarehouse/m_depot_Bar"):GetComponent("UISprite");
	self.m_Depot_SubPanel = transform:Find("Anchor_Center/m_GoodsTabView/View/TabItem 0/Depot/ListViewMacro/m_Depot_SubPanel").gameObject;
	self.m_ButtonReturn = transform:Find("m_ButtonReturn"):GetComponent("UILabel");
	self.m_SetNum = transform:Find("m_SetNum").gameObject;
	self.m_CloseSetNum = transform:Find("m_SetNum/m_CloseSetNum"):GetComponent("UIButton");
	self.m_CutDown = transform:Find("m_SetNum/g0/m_CutDown"):GetComponent("UISprite");
	self.m_Add = transform:Find("m_SetNum/g0/m_Add"):GetComponent("UISprite");
	self.m_Editbox = transform:Find("m_SetNum/g0/m_Editbox"):GetComponent("UIInput");
	self.m_Max = transform:Find("m_SetNum/g0/m_Max"):GetComponent("UISprite");
	self.m_ButtonSure = transform:Find("m_SetNum/m_ButtonSure"):GetComponent("UILabel");
	self.m_Title = transform:Find("GameObject_Title/m_Title"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("GameObject_Title/m_Title/m_LabelLv"):GetComponent("UILabel");
end
return FleetGoodsPanelBinder