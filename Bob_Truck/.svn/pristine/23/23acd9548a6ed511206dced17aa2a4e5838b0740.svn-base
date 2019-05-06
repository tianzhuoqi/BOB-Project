local TabViewMediator = require("Game/Module/UICommon/TabViewMediator")

local TabViewWidget = register("TabViewWidget", WidgetBase)

function TabViewWidget:Awake(gameObject, mediatorName) 
    TabViewWidget.super.Awake(self, gameObject)

    self.tabView = self.gameObject:GetComponent("NTabView")
    self.mediatorName = mediatorName

    self.mediator = TabViewMediator.New(self.mediatorName.."TabViewMediator")
    self.mediator:SetViewComponent(self)
    Facade:RegisterMediator(self.mediator)
end