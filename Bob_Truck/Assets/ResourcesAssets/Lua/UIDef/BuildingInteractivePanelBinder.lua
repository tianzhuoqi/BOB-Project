local BuildingInteractivePanelBinder = class("BuildingInteractivePanelBinder");

function BuildingInteractivePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_BuildingInfo = transform:Find("Anchor_Center/m_BuildingInfo").gameObject;
	self.m_BuildingName = transform:Find("Anchor_Center/m_BuildingInfo/m_BuildingName"):GetComponent("UILabel");
	self.m_BuildingLv = transform:Find("Anchor_Center/m_BuildingInfo/m_BuildingLv"):GetComponent("UILabel");
	self.m_Building_Name = transform:Find("Anchor_Bottom/m_Building_Name"):GetComponent("UILabel");
	self.m_btnInteractiveAccelerate = transform:Find("Anchor_Bottom/m_btnInteractiveAccelerate"):GetComponent("UIButton");
	self.m_Label_Accelerate = transform:Find("Anchor_Bottom/m_btnInteractiveAccelerate/m_Label_Accelerate"):GetComponent("UILabel");
	self.m_btnInteractiveReceive = transform:Find("Anchor_Bottom/m_btnInteractiveReceive"):GetComponent("UIButton");
	self.m_Label_Receive = transform:Find("Anchor_Bottom/m_btnInteractiveReceive/m_Label_Receive"):GetComponent("UILabel");
	self.m_btnInteractiveFunction = transform:Find("Anchor_Bottom/m_btnInteractiveFunction"):GetComponent("UIButton");
	self.m_Label_Function = transform:Find("Anchor_Bottom/m_btnInteractiveFunction/m_Label_Function"):GetComponent("UILabel");
	self.m_btnInteractiveCancel = transform:Find("Anchor_Bottom/m_btnInteractiveCancel"):GetComponent("UIButton");
	self.m_Label_Cancel = transform:Find("Anchor_Bottom/m_btnInteractiveCancel/m_Label_Cancel"):GetComponent("UILabel");
	self.m_btnInteractiveDemolition = transform:Find("Anchor_Bottom/m_btnInteractiveDemolition"):GetComponent("UIButton");
	self.m_Label_Demolition = transform:Find("Anchor_Bottom/m_btnInteractiveDemolition/m_Label_Demolition"):GetComponent("UILabel");
	self.m_btnInteractiveUp = transform:Find("Anchor_Bottom/m_btnInteractiveUp"):GetComponent("UIButton");
	self.m_Label_Upgrade = transform:Find("Anchor_Bottom/m_btnInteractiveUp/m_Label_Upgrade"):GetComponent("UILabel");
	self.m_btnInteractiveMove = transform:Find("Anchor_Bottom/m_btnInteractiveMove"):GetComponent("UIButton");
	self.m_Label_Move = transform:Find("Anchor_Bottom/m_btnInteractiveMove/m_Label_Move"):GetComponent("UILabel");
end
return BuildingInteractivePanelBinder