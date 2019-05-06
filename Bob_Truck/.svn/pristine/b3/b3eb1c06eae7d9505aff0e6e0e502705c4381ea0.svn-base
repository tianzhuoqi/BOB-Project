local LoadingMediator = require("Game/Module/SLoading/LoadingMediator")
local LoadingPanel = register("LoadingPanel", PanelBase)
local UpdateBeat = UpdateBeat

function LoadingPanel:Awake(gameObject) 
	self.mediator = LoadingMediator.New("LoadingMediator")
	self.gameObject = gameObject
	self.processSprite = self:FindGameObject('Process'):GetComponent("UISprite")
end

function LoadingPanel:OpenPanel()
	LoadingPanel.super.OpenPanel(self)

	self.processNum = 0
	UpdateBeat:Add(self.Update, self)
end

function LoadingPanel:DestroyPanel() 
	UpdateBeat:Remove(self.Update, self)
end

function LoadingPanel:Update() 
	if self.processNum == nil then
		return
	end
	self.processNum = self.processNum + 1
	if ManagerScene.async.progress > 0.85 then
		self.processNum = 100
	end
	self.processSprite.fillAmount = self.processNum / 100
end

return LoadingPanel