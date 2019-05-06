local CreateSpaceBaseMediator = require("Game/Module/SPlanetary/CreateSpaceBaseMediator")
local CreateSpaceBasePanel = register("CreateSpaceBasePanel", PanelBase)
local CreateSpaceBasePanelBinder = require("UIDef/CreateSpaceBasePanelBinder");

function CreateSpaceBasePanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = CreateSpaceBasePanelBinder.New(self.gameObject)

    self.mediator = CreateSpaceBaseMediator.New(NotiConst.CreateSpaceBaseMediator)
    self.mediator:SetViewComponent(self)
    Facade:RegisterMediator(self.mediator)
end

function CreateSpaceBasePanel:OpenPanel()
    CreateSpaceBasePanel.super.OpenPanel(self)

    self:DoBlur()

    self.mediator:InitData()
end

return CreateSpaceBasePanel