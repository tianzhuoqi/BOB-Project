local ExplorationResultMediator = class("ExplorationResultMediator", MediatorDynamic)

function ExplorationResultMediator:OnRegister()
    self.view = self:GetViewComponent()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    -- event bind
    local NLuaClickEvent = NLuaClickEvent.Get(self.view.backBtn.gameObject)
    NLuaClickEvent:AddClick(self, self.OnBackButtonClick)
end

function ExplorationResultMediator:OnBackButtonClick()
    Facade:BackPanel()
end


function ExplorationResultMediator:ShowExplorationResult()
    local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    --TODO
end

return ExplorationResultMediator