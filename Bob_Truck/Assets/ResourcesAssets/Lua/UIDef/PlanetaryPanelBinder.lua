local PlanetaryPanelBinder = class("PlanetaryPanelBinder");

function PlanetaryPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_SpriteLoadingB = transform:Find("Anchor_Top/m_SpriteLoadingB"):GetComponent("UISprite");
	self.m_SpriteLoadingF = transform:Find("Anchor_Top/m_SpriteLoadingB/m_SpriteLoadingF"):GetComponent("UISprite");
	self.m_LabelTime = transform:Find("Anchor_Top/m_SpriteLoadingB/m_LabelTime"):GetComponent("UILabel");
	self.m_LabelRagNam = transform:Find("Anchor_Top/m_SpriteLoadingB/m_LabelRagNam"):GetComponent("UILabel");
	self.m_LabelRagVal = transform:Find("Anchor_Top/m_SpriteLoadingB/m_LabelRagVal"):GetComponent("UILabel");
	self.m_LabelCountDown = transform:Find("Anchor_Top/m_SpriteLoadingB/m_LabelCountDown"):GetComponent("UILabel");
	self.m_SpriteTimBak = transform:Find("Anchor_Top/TimeAward/m_SpriteTimBak"):GetComponent("UISprite");
	self.m_LabelAwardTime = transform:Find("Anchor_Top/TimeAward/m_SpriteTimBak/m_LabelAwardTime"):GetComponent("UILabel");
	self.m_ButtonGet = transform:Find("Anchor_Top/TimeAward/m_ButtonGet"):GetComponent("UIButton");
	self.m_GroupPopup = transform:Find("m_GroupPopup").gameObject;
	self.m_ButtonExplore = transform:Find("m_GroupPopup/m_ButtonExplore"):GetComponent("UIButton");
	self.m_ButtonGoto = transform:Find("m_GroupPopup/m_ButtonGoto"):GetComponent("UIButton");
	self.m_btnClickClose = transform:Find("m_GroupPopup/m_btnClickClose").gameObject;
	self.m_ButtonMine = transform:Find("m_GroupPopup/m_ButtonMine"):GetComponent("UIButton");
	self.m_ButtonCollet = transform:Find("m_GroupPopup/m_ButtonCollet"):GetComponent("UIButton");
	self.m_ButtonBuilding = transform:Find("m_GroupPopup/m_ButtonBuilding"):GetComponent("UIButton");
	self.m_contentText = transform:Find("info/m_contentText"):GetComponent("UILabel");
	self.m_InfoBackBuntton = transform:Find("info/m_InfoBackBuntton"):GetComponent("UIButton");
	self.m_CollectBackBuntton = transform:Find("collect/m_CollectBackBuntton"):GetComponent("UIButton");
	self.m_BuildingListBackBuntton = transform:Find("buildingList/m_BuildingListBackBuntton"):GetComponent("UIButton");
	self.m_EditBuildingModButton = transform:Find("EditBuildingMod/m_EditBuildingModButton").gameObject;
	self.m_EditBuildingModOKButton = transform:Find("EditBuildingMod/m_EditBuildingModButton/m_EditBuildingModOKButton"):GetComponent("UIButton");
	self.m_EditBuildingModCancelButton = transform:Find("EditBuildingMod/m_EditBuildingModButton/m_EditBuildingModCancelButton"):GetComponent("UIButton");
	self.m_BuildingButton = transform:Find("Anchor_BottomRight/Group/m_BuildingButton"):GetComponent("UIButton");
	self.m_WarehouseButton = transform:Find("Anchor_BottomRight/Group/m_WarehouseButton"):GetComponent("UIButton");
end
return PlanetaryPanelBinder