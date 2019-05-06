local ExploreFleetLstPanelBinder = class("ExploreFleetLstPanelBinder");

function ExploreFleetLstPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_ListViewFleet = transform:Find("m_ListViewFleet").gameObject;
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_ButtonClose = transform:Find("Anchor_Top/m_ButtonClose"):GetComponent("UIButton");
end
return ExploreFleetLstPanelBinder