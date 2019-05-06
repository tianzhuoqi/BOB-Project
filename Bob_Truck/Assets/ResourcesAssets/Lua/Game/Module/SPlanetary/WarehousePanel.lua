local WarehouseMediator = require("Game/Module/SPlanetary/WarehouseMediator")
local WarehousePanel = register("WarehousePanel", PanelBase)
local WarehousePanelBinder = require("UIDef/WarehousePanelBinder")

function WarehousePanel:Awake(gameObject)
	WarehousePanel.super.Awake(self, gameObject)
	self.uiBinder = WarehousePanelBinder.New(self.gameObject)
	self.tableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")
	self.mediator = WarehouseMediator.New(NotiConst.WarehouseMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function WarehousePanel:OpenPanel()
	WarehousePanel.super.OpenPanel(self)

	self:DoBlur()
	self.uiBinder.m_ItemSellNum:SetActive(false)

	self.mediator:InitData()
end

function WarehousePanel:DestroyPanel()
	self.mediator:DestroyPanel()
end

return WarehousePanel