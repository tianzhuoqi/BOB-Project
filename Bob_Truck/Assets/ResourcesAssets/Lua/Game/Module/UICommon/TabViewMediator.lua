local TabViewMediator = class("TabViewMediator", MediatorDynamic)

function TabViewMediator:OnRegister()
    self.view = self:GetViewComponent()

    for i=1,self.view.tabView.TabCount do
        local NLuaClickEvent = NLuaClickEvent.Get(self.view.tabView:GetTab(i-1).gameObject)
        local  data = {["index"] = i-1}
        NLuaClickEvent:AddClick(self, self.TabClick, data)
    end
end

function TabViewMediator:TabClick(data)
    self.view.tabView:OpenTabItem(data["index"])
end

return TabViewMediator