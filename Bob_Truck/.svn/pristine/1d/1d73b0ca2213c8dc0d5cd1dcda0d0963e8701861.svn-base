local CreateHullTempltPanelBinder = class("CreateHullTempltPanelBinder");

function CreateHullTempltPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_btnClose = transform:Find("Anchor_Top/m_btnClose"):GetComponent("UIButton");
	self.m_txModTechName = transform:Find("Anchor_Center/m_txModTechName"):GetComponent("UILabel");
	self.m_btnSwitchTech = transform:Find("Anchor_Center/m_btnSwitchTech"):GetComponent("UIButton");
	self.m_btnStepBack = transform:Find("Anchor_Center/m_btnStepBack"):GetComponent("UIButton");
	self.m_groupHull = transform:Find("Anchor_Center/m_groupHull").gameObject;
	self.m_tabHullHead = transform:Find("Anchor_Center/m_groupHull/m_tabHullHead"):GetComponent("UIButton");
	self.m_tabHullBody = transform:Find("Anchor_Center/m_groupHull/m_tabHullBody"):GetComponent("UIButton");
	self.m_tabHullTail = transform:Find("Anchor_Center/m_groupHull/m_tabHullTail"):GetComponent("UIButton");
	self.m_rtModel = transform:Find("Anchor_Center/m_groupHull/m_rtModel"):GetComponent("UITexture");
	self.m_sprStep1bk = transform:Find("Anchor_Center/m_sprStep1bk"):GetComponent("UISprite");
	self.m_sprStep2bk = transform:Find("Anchor_Center/m_sprStep2bk"):GetComponent("UISprite");
	self.m_sprStep3bk = transform:Find("Anchor_Center/m_sprStep3bk"):GetComponent("UISprite");
	self.m_txStep1 = transform:Find("Anchor_Center/m_txStep1"):GetComponent("UILabel");
	self.m_txStep2 = transform:Find("Anchor_Center/m_txStep2"):GetComponent("UILabel");
	self.m_txStep3 = transform:Find("Anchor_Center/m_txStep3"):GetComponent("UILabel");
	self.m_sprProcess1_2 = transform:Find("Anchor_Center/m_sprProcess1_2"):GetComponent("UISprite");
	self.m_sprProcess2_3 = transform:Find("Anchor_Center/m_sprProcess2_3"):GetComponent("UISprite");
	self.m_btnNextStep = transform:Find("Anchor_Center/m_btnNextStep"):GetComponent("UIButton");
	self.m_groupCpnt = transform:Find("Anchor_Center/m_groupCpnt").gameObject;
	self.m_sprChooseCpntBk0 = transform:Find("Anchor_Center/m_groupCpnt/m_sprChooseCpntBk0"):GetComponent("UISprite");
	self.m_sprChooseCpntItem0 = transform:Find("Anchor_Center/m_groupCpnt/m_sprChooseCpntItem0"):GetComponent("UISprite");
	self.m_tabCpntAtt = transform:Find("Anchor_Center/m_groupCpnt/m_tabCpntAtt"):GetComponent("UIButton");
	self.m_tabCpntDef = transform:Find("Anchor_Center/m_groupCpnt/m_tabCpntDef"):GetComponent("UIButton");
	self.m_tabCpntSubsys = transform:Find("Anchor_Center/m_groupCpnt/m_tabCpntSubsys"):GetComponent("UIButton");
	self.m_btnComplete = transform:Find("Anchor_Center/m_btnComplete"):GetComponent("UIButton");
end
return CreateHullTempltPanelBinder