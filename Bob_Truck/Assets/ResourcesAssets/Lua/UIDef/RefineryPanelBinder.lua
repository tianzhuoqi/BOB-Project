local RefineryPanelBinder = class("RefineryPanelBinder");

function RefineryPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_LabelLv = transform:Find("Anchor_Top/m_Label_TitleKey/m_LabelLv"):GetComponent("UILabel");
	self.m_StateInfo = transform:Find("Anchor_Center/Input/m_StateInfo"):GetComponent("UILabel");
	self.m_MineralSlot = transform:Find("Anchor_Center/Input/m_MineralSlot"):GetComponent("UIButton");
	self.m_PutSig = transform:Find("Anchor_Center/Input/m_MineralSlot/m_PutSig"):GetComponent("UISprite");
	self.m_AmountName = transform:Find("Anchor_Center/Input/m_MineralSlot/Des/m_AmountName"):GetComponent("UILabel");
	self.m_AmountNum = transform:Find("Anchor_Center/Input/m_MineralSlot/Des/m_AmountNum"):GetComponent("UILabel");
	self.m_ProgressBar = transform:Find("Anchor_Center/Input/m_MineralSlot/Des/m_ProgressBar").gameObject;
	self.m_Sprite_Bar = transform:Find("Anchor_Center/Input/m_MineralSlot/Des/m_ProgressBar/m_Sprite_Bar"):GetComponent("UISprite");
	self.m_CurMine = transform:Find("Anchor_Center/Input/m_MineralSlot/m_CurMine").gameObject;
	self.m_iconIn = transform:Find("Anchor_Center/Input/m_MineralSlot/m_CurMine/m_iconIn"):GetComponent("UITexture");
	self.m_QualityIn = transform:Find("Anchor_Center/Input/m_MineralSlot/m_CurMine/m_QualityIn"):GetComponent("UISprite");
	self.m_Label_Purity = transform:Find("Anchor_Center/Input/m_MineralSlot/m_CurMine/Purity/m_Label_Purity"):GetComponent("UILabel");
	self.m_InputName = transform:Find("Anchor_Center/Input/m_MineralSlot/m_CurMine/m_InputName"):GetComponent("UILabel");
	self.m_CurProduct = transform:Find("Anchor_Center/Input/m_CurProduct").gameObject;
	self.m_RemainTimeName = transform:Find("Anchor_Center/Input/m_CurProduct/m_RemainTimeName"):GetComponent("UILabel");
	self.m_RemainTimeNum = transform:Find("Anchor_Center/Input/m_CurProduct/m_RemainTimeNum"):GetComponent("UILabel");
	self.m_NumLabelOut = transform:Find("Anchor_Center/Input/m_CurProduct/Product/m_NumLabelOut"):GetComponent("UILabel");
	self.m_NumSprite2 = transform:Find("Anchor_Center/Input/m_CurProduct/Product/m_NumSprite2"):GetComponent("UISprite");
	self.m_OutName = transform:Find("Anchor_Center/Input/m_CurProduct/Product/m_OutName"):GetComponent("UILabel");
	self.m_QualityOut = transform:Find("Anchor_Center/Input/m_CurProduct/Product/m_QualityOut"):GetComponent("UISprite");
	self.m_iconOut = transform:Find("Anchor_Center/Input/m_CurProduct/Product/m_iconOut"):GetComponent("UITexture");
	self.m_NameSprite05 = transform:Find("Anchor_Center/Input/m_CurProduct/Product/m_NameSprite05"):GetComponent("UISprite");
	self.m_TabView = transform:Find("Anchor_Center/SelectView/m_TabView").gameObject;
	self.m_SubPanel = transform:Find("Anchor_Center/SelectView/m_TabView/View/TabItem 0/ListViewMacro/m_SubPanel").gameObject;
	self.m_StateInfo2 = transform:Find("Anchor_Center/SelectView/m_StateInfo2"):GetComponent("UILabel");
	self.m_ButtonGetResult = transform:Find("Anchor_Bottom/m_ButtonGetResult"):GetComponent("UIButton");
	self.m_ButtomGetResultLabel = transform:Find("Anchor_Bottom/m_ButtonGetResult/m_ButtomGetResultLabel"):GetComponent("UILabel");
	self.m_ButtonOperate = transform:Find("Anchor_Bottom/m_ButtonOperate"):GetComponent("UIButton");
	self.m_ButtomOperLabel = transform:Find("Anchor_Bottom/m_ButtonOperate/m_ButtomOperLabel"):GetComponent("UILabel");
	self.m_ButtonCancel = transform:Find("Anchor_Bottom/m_ButtonCancel"):GetComponent("UIButton");
	self.m_ButtomCancelLabel = transform:Find("Anchor_Bottom/m_ButtonCancel/m_ButtomCancelLabel"):GetComponent("UILabel");
end
return RefineryPanelBinder