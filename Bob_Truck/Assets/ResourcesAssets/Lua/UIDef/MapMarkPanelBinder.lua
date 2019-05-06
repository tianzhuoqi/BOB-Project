local MapMarkPanelBinder = class("MapMarkPanelBinder");

function MapMarkPanelBinder:ctor(gameObject)
	local transform = gameObject.transform;
	self.m_bkgnd = transform:Find("Center/m_bkgnd"):GetComponent("UITexture");
	self.m_ButtonClose = transform:Find("Center/m_ButtonClose"):GetComponent("UIButton");
	self.m_Position = transform:Find("Center/m_Position"):GetComponent("UILabel");
	self.m_InputName = transform:Find("Center/m_InputName"):GetComponent("UIInput");
	self.m_ButtonSave = transform:Find("Center/m_ButtonSave"):GetComponent("UIButton");
	self.m_TypeSelect = transform:Find("Center/m_TypeSelect").gameObject;
	self.m_type1 = transform:Find("Center/m_TypeSelect/m_type1"):GetComponent("UIButton");
	self.m_typeBg1 = transform:Find("Center/m_TypeSelect/m_type1/m_typeBg1"):GetComponent("UISprite");
	self.m_type2 = transform:Find("Center/m_TypeSelect/m_type2"):GetComponent("UIButton");
	self.m_typeBg2 = transform:Find("Center/m_TypeSelect/m_type2/m_typeBg2"):GetComponent("UISprite");
	self.m_type3 = transform:Find("Center/m_TypeSelect/m_type3"):GetComponent("UIButton");
	self.m_typeBg3 = transform:Find("Center/m_TypeSelect/m_type3/m_typeBg3"):GetComponent("UISprite");
	self.m_type4 = transform:Find("Center/m_TypeSelect/m_type4"):GetComponent("UIButton");
	self.m_typeBg4 = transform:Find("Center/m_TypeSelect/m_type4/m_typeBg4"):GetComponent("UISprite");
	self.m_type5 = transform:Find("Center/m_TypeSelect/m_type5"):GetComponent("UIButton");
	self.m_typeBg5 = transform:Find("Center/m_TypeSelect/m_type5/m_typeBg5"):GetComponent("UISprite");
end
return MapMarkPanelBinder