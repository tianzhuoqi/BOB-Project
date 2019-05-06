local WorldPanelBinder = class("WorldPanelBinder");

function WorldPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_GroupPopup = transform:Find("m_GroupPopup").gameObject;
	self.m_btnClickClose = transform:Find("m_GroupPopup/m_btnClickClose").gameObject;
	self.m_Sprite_sign = transform:Find("m_GroupPopup/ringFrm/m_Sprite_sign"):GetComponent("UISprite");
	self.m_GroupExportInfo = transform:Find("Anchor_LeftTop/m_GroupExportInfo").gameObject;
	self.m_ExploreInfoItem = transform:Find("Anchor_LeftTop/m_GroupExportInfo/m_ExploreInfoItem").gameObject;
	self.m_ButtonMarkList = transform:Find("Anchor_RightBottom/m_ButtonMarkList"):GetComponent("UIButton");
	self.m_NodeInfo = transform:Find("Anchor_Bottom/m_NodeInfo").gameObject;
	self.m_ButtonGrid = transform:Find("Anchor_Bottom/m_NodeInfo/m_ButtonGrid").gameObject;
	self.m_A_ButtonMark = transform:Find("Anchor_Bottom/m_NodeInfo/m_ButtonGrid/m_A_ButtonMark"):GetComponent("UIButton");
	self.m_MarkLabel = transform:Find("Anchor_Bottom/m_NodeInfo/m_ButtonGrid/m_A_ButtonMark/m_MarkLabel"):GetComponent("UILabel");
	self.m_B_ButtonGoto = transform:Find("Anchor_Bottom/m_NodeInfo/m_ButtonGrid/m_B_ButtonGoto"):GetComponent("UIButton");
	self.m_C_ButtonFleetDirectiveButton = transform:Find("Anchor_Bottom/m_NodeInfo/m_ButtonGrid/m_C_ButtonFleetDirectiveButton"):GetComponent("UIButton");
	self.m_D_ButtonView = transform:Find("Anchor_Bottom/m_NodeInfo/m_ButtonGrid/m_D_ButtonView"):GetComponent("UIButton");
	self.m_Label_name = transform:Find("Anchor_Bottom/m_NodeInfo/m_Label_name"):GetComponent("UILabel");
end
return WorldPanelBinder