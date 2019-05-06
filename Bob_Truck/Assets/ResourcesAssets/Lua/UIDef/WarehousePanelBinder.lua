local WarehousePanelBinder = class("WarehousePanelBinder");

function WarehousePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_ItemSellNum = transform:Find("Anchor_Center/m_ItemSellNum").gameObject;
	self.m_Label_NumTitle = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_Label_NumTitle"):GetComponent("UILabel");
	self.m_Label_Num = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_Label_Num"):GetComponent("UIInput");
	self.m_MenuMax = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_MenuMax"):GetComponent("UIButton");
	self.m_MenuOk = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_MenuOk"):GetComponent("UIButton");
	self.m_MenuCancel = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_MenuCancel"):GetComponent("UIButton");
	self.m_MenuAdd = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_MenuAdd"):GetComponent("UIButton");
	self.m_MenuReduce = transform:Find("Anchor_Center/m_ItemSellNum/GameObject_Menu/m_MenuReduce"):GetComponent("UIButton");
	self.m_Label_cube = transform:Find("Anchor_Center/ItemList/Tip/m_Label_cube"):GetComponent("UILabel");
	self.m_Sprite_Bar = transform:Find("Anchor_Center/ItemList/Tip/m_Sprite_Bar"):GetComponent("UISprite");
	self.m_TabView = transform:Find("Anchor_Center/ItemList/m_TabView").gameObject;
	self.m_SubPanel = transform:Find("Anchor_Center/ItemList/m_TabView/View/TabItem 0/ListViewMacro/m_SubPanel").gameObject;
end
return WarehousePanelBinder