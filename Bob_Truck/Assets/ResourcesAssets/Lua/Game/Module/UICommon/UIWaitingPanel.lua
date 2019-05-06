local UIWaitingMediator = require("Game/Module/UICommon/UIWaitingMediator")
local UIWaitingPanel = register("UIWaitingPanel", PanelBase)

function UIWaitingPanel:Awake(gameObject)
    self.gameObject = gameObject

    self.mediator = UIWaitingMediator.New("UIWaitingMediator")
	Facade:RegisterMediator(self.mediator)
    self.mediator:SetViewComponent(self)

    self.waitingAnimation = self:FindComponent("JumpDots","Animation")
    self.textureObj = self:FindGameObject("Texture")
    self.texture = self.textureObj:GetComponent("UITexture")
    self.textureData = self.texture.mainTexture
end

function UIWaitingPanel:test()
    coroutine.wait(10)
    self:StopAllCoroutines()
end

function UIWaitingPanel:OpenPanel()
    --协程测试
    self.gameObject:SetActive(true)
    self:StartCoroutine(self.AddReference)
end

function UIWaitingPanel:AddReference()
    for i=0,10 do
        coroutine.wait(1)
        LogDebug("test "..i.."|"..os.time())
        --注意无法在当前协程里停止当前协程
    end
    Facade:SendNotification(NotiConst.Command_CloseWaiting, body)
end

function UIWaitingPanel:ClosePanel()
    self:StopAllCoroutines()
end

function UIWaitingPanel:ReopenPanel() 
    self:OpenPanel()
end

function UIWaitingPanel:DestroyPanel() 
    Facade:RemoveMediator(self.mediator:GetMediatorName())
end

return UIWaitingPanel