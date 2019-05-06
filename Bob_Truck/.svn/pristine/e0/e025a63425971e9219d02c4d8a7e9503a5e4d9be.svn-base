local BuildingUpgradePanelBinder = class("BuildingUpgradePanelBinder");

function BuildingUpgradePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnSClose = transform:Find("Anchor_Top/m_btnSClose"):GetComponent("UIButton");
	self.m_Label_TitleKey = transform:Find("Anchor_Top/m_Label_TitleKey"):GetComponent("UILabel");
	self.m_Label_upgrade = transform:Find("Anchor_Top/m_Label_upgrade"):GetComponent("UILabel");
	self.m_Label_UpInquiry = transform:Find("Anchor_Center/m_Label_UpInquiry"):GetComponent("UILabel");
	self.m_Texture_IconL = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_Texture_IconL"):GetComponent("UITexture");
	self.m_Label_BuildNumL = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_Label_BuildNumL"):GetComponent("UILabel");
	self.m_Texture_IconR = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_Texture_IconR"):GetComponent("UITexture");
	self.m_Label_BuildNumR = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_Label_BuildNumR"):GetComponent("UILabel");
	self.m_ModelPos = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_ModelPos").gameObject;
	self.m_BuildingCamera = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_ModelPos/m_BuildingCamera"):GetComponent("Camera");
	self.m_ModelPosUp = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_ModelPosUp").gameObject;
	self.m_BuildingCameraUp = transform:Find("Anchor_Center/BuildModelPos/FrontMsg/m_ModelPosUp/m_BuildingCameraUp"):GetComponent("Camera");
	self.m_Label_Timer = transform:Find("Anchor_Center/UpgradeEffect/Sprite_UpTim/m_Label_Timer"):GetComponent("UILabel");
	self.m_Label_ChangeValue01 = transform:Find("Anchor_Center/UpgradeEffect/ListViewSimple/SubPanel/Cell/Label_UpEf01/m_Label_ChangeValue01"):GetComponent("UILabel");
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
	self.m_btnUpgrade = transform:Find("Anchor_Center/m_btnUpgrade"):GetComponent("UIButton");
	self.m_Label_Upgrade = transform:Find("Anchor_Center/m_btnUpgrade/m_Label_Upgrade"):GetComponent("UILabel");
	self.m_Info_Button = transform:Find("Anchor_Center/m_Info_Button"):GetComponent("UIButton");
end
return BuildingUpgradePanelBinder