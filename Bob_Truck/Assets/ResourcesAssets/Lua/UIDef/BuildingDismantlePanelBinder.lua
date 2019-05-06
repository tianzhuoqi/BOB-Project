local BuildingDismantlePanelBinder = class("BuildingDismantlePanelBinder");

function BuildingDismantlePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_Label_UpInquiry = transform:Find("Anchor_Center/m_Label_UpInquiry"):GetComponent("UILabel");
	self.m_Label_BuildNumL = transform:Find("Anchor_Center/BuildModelPos/m_Label_BuildNumL"):GetComponent("UILabel");
	self.m_Label_Timer = transform:Find("Anchor_Center/Consume/Label_UpTim/m_Label_Timer"):GetComponent("UILabel");
	self.m_Label_Discount = transform:Find("Anchor_Center/Consume/m_Label_Discount"):GetComponent("UILabel");
	self.m_Sprite_Discount = transform:Find("Anchor_Center/Consume/m_Label_Discount/m_Sprite_Discount"):GetComponent("UISprite");
	self.m_Label_Money = transform:Find("Anchor_Center/Consume/m_Label_Money"):GetComponent("UILabel");
	self.m_Sprite_Money = transform:Find("Anchor_Center/Consume/m_Label_Money/m_Sprite_Money"):GetComponent("UISprite");
	self.m_Label_DzName01 = transform:Find("Anchor_Center/Consume/m_Label_DzName01"):GetComponent("UILabel");
	self.m_Label_Num01 = transform:Find("Anchor_Center/Consume/m_Label_DzName01/m_Label_Num01"):GetComponent("UILabel");
	self.m_Label_DzName02 = transform:Find("Anchor_Center/Consume/m_Label_DzName02"):GetComponent("UILabel");
	self.m_Label_Num02 = transform:Find("Anchor_Center/Consume/m_Label_DzName02/m_Label_Num02"):GetComponent("UILabel");
	self.m_Label_DzName03 = transform:Find("Anchor_Center/Consume/m_Label_DzName03"):GetComponent("UILabel");
	self.m_Label_Num03 = transform:Find("Anchor_Center/Consume/m_Label_DzName03/m_Label_Num03"):GetComponent("UILabel");
	self.m_Label_DzName04 = transform:Find("Anchor_Center/Consume/m_Label_DzName04"):GetComponent("UILabel");
	self.m_Label_Num04 = transform:Find("Anchor_Center/Consume/m_Label_DzName04/m_Label_Num04"):GetComponent("UILabel");
	self.m_Label_DzName05 = transform:Find("Anchor_Center/Consume/m_Label_DzName05"):GetComponent("UILabel");
	self.m_Label_Num05 = transform:Find("Anchor_Center/Consume/m_Label_DzName05/m_Label_Num05"):GetComponent("UILabel");
	self.m_Sprite_BakRsB = transform:Find("Anchor_Center/Consume/m_Sprite_BakRsB"):GetComponent("UISprite");
	self.m_btnDismantle = transform:Find("Anchor_Center/m_btnDismantle"):GetComponent("UIButton");
	self.m_Label_Dismantle = transform:Find("Anchor_Center/m_btnDismantle/m_Label_Dismantle"):GetComponent("UILabel");
end
return BuildingDismantlePanelBinder