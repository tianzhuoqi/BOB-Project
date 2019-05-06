local StorehousePanelBinder = class("StorehousePanelBinder");

function StorehousePanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_ButtonClose = transform:Find("m_ButtonClose"):GetComponent("UIButton");
	self.m_bkgnd = transform:Find("m_bkgnd"):GetComponent("UITexture");
	self.m_ListMine = transform:Find("TabView/View/TabItem 0/m_ListMine").gameObject;
	self.m_TableViewMine = transform:Find("TabView/View/TabItem 0/m_ListMine/m_TableViewMine").gameObject;
	self.m_ListElt = transform:Find("TabView/View/TabItem 1/m_ListElt").gameObject;
	self.m_TableViewElt = transform:Find("TabView/View/TabItem 1/m_ListElt/m_TableViewElt").gameObject;
end
return StorehousePanelBinder