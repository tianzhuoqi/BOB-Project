local tian111111111111 = require("Game/Module/SLogin/tian111111111111")
local tian111111111111 = register("tian111111111111", PanelBase)
local tian111111111111Binder = require("UIDef/tian111111111111Binder")

function tian111111111111:Awake(gameObject)
	tian111111111111.super.Awake(self, gameObject)
	self.uiBinder = tian111111111111Binder.New(self.gameObject)

	self.mediator = tian111111111111.New(NotiConst.tian111111111111)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function tian111111111111:OpenPanel()
	tian111111111111.super.OpenPanel(self)
	self:DoBlur()
end

return tian111111111111