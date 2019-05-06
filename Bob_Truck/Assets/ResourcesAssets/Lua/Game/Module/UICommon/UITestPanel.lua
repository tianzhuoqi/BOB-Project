--[[
    产品拼接界面测试使用
]]
local UITestPanel = register("UITestPanel", PanelBase)

function UITestPanel:Awake(gameObject)
    self.gameObject = gameObject
end

return UITestPanel