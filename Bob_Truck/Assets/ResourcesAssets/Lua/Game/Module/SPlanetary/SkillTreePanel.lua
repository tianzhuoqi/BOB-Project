local SkillTreeMediator = require("Game/Module/SPlanetary/SkillTreeMediator")
local SkillTreePanel = register("SkillTreePanel", PanelBase)
local SkillTreePanelBinder = require("UIDef/SkillTreePanelBinder")

function SkillTreePanel:Awake(gameObject)
	SkillTreePanel.super.Awake(self, gameObject)
	self.uiBinder = SkillTreePanelBinder.New(self.gameObject)

	self.mediator = SkillTreeMediator.New(NotiConst.SkillTreeMediator)
	self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function SkillTreePanel:OpenPanel()
	SkillTreePanel.super.OpenPanel(self)

	self:DoBlur()
	self.mediator:ShowUI()
end

function SkillTreePanel:DestroyPanel()
	self.mediator:DestroyPanel()
end

return SkillTreePanel