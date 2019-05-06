local BigMapPanelBinder = class("BigMapPanelBinder");

function BigMapPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_ButtonClose = transform:Find("UI_Pos/Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("UI_Pos/Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_ButtonToBigMap = transform:Find("UI_Pos/Anchor_Top/m_ButtonToBigMap"):GetComponent("UIButton");
	self.m_SubPanel = transform:Find("UI_Pos/Anchor_Center/AllListView/m_SubPanel").gameObject;
	self.m_ButtonGo = transform:Find("UI_Pos/Anchor_Center/Bottom_Anchor/m_ButtonGo"):GetComponent("UIButton");
	self.m_ButtonSmall = transform:Find("UI_Pos/Anchor_Center/Panel/m_ButtonSmall"):GetComponent("UIButton");
	self.m_ButtonBig = transform:Find("UI_Pos/Anchor_Center/Panel/m_ButtonBig"):GetComponent("UIButton");
end
return BigMapPanelBinder