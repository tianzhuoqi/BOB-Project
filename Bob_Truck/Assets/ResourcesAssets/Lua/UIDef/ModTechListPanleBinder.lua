local ModTechListPanleBinder = class("ModTechListPanleBinder");

function ModTechListPanleBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_texBkgnd = transform:Find("m_texBkgnd"):GetComponent("UITexture");
	self.m_btnClose = transform:Find("Anchor_Top/m_btnClose"):GetComponent("UIButton");
end
return ModTechListPanleBinder