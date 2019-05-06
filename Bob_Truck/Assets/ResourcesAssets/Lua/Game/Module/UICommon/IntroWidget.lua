local IntroMediator = require("Game/Module/UICommon/IntroMediator")

local IntroWidget = register("IntroWidget", WidgetBase)

function IntroWidget:Awake(eventObject, introPoint) 
    self.eventObject = eventObject
    self.introPoint = introPoint

    self.mediator = IntroMediator.New("IntroMediator"..self.introPoint)
    self.mediator:SetViewComponent(self)
    Facade:RegisterMediator(self.mediator)
end

return IntroWidget