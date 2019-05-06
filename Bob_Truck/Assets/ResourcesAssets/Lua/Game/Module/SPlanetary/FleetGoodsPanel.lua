local FleetGoodsMediator = require("Game/Module/SPlanetary/FleetGoodsMediator")
local FleetGoodsPanel = register("FleetGoodsPanel", PanelBase)
local FleetGoodsPanelBinder = require("UIDef/FleetGoodsPanelBinder");

function FleetGoodsPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = FleetGoodsPanelBinder.New(self.gameObject)

    self.mediator = FleetGoodsMediator.New(NotiConst.FleetGoodsMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function FleetGoodsPanel:OpenPanel()
    FleetGoodsPanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitData()
end

return FleetGoodsPanel