local tian22222222222 = require("Game/Module/SLogin/tian22222222222")
local tian22222222222 = register("tian22222222222", PanelBase)
local tian22222222222Binder = require("UIDef/tian22222222222Binder")

function tian22222222222:Awake(gameObject)
	tian22222222222.super.Awake(self, gameObject)
	self.uiBinder = tian22222222222Binder.New(self.gameObject)

	self.mediator = tian22222222222.New(NotiConst.tian22222222222)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function tian22222222222:OpenPanel()
	tian22222222222.super.OpenPanel(self)
	self:DoBlur()
end

return tian22222222222