local TabItem = require("Game/Module/UICommon/TabItem")

local FleetPortTabItem1 = register("FleetPortTabItem1", TabItem)

function FleetPortTabItem1:Awake(gameObject)
    FleetPortTabItem1.super.Awake(self, gameObject)

    self.view = {}
    self.view.n_Create = self:FindComponent("n_Create", "UIButton")
    self.view.n_Detail = self:FindGameObject("n_Detail")
    self.view.n_ButtonInfo = self:FindComponent("n_Detail/AttrNum/n_ButtonInfo", "UIButton")
    self.view.n_Des01 = self:FindComponent("n_Detail/AttrNum/n_Des01", "UILabel")
    self.view.n_AttrNum01 = self:FindComponent("n_Detail/AttrNum/n_Des01/n_AttrNum01", "UILabel")
    self.view.n_Des02 = self:FindComponent("n_Detail/AttrNum/n_Des02", "UILabel")
    self.view.n_AttrNum02 = self:FindComponent("n_Detail/AttrNum/n_Des02/n_AttrNum02", "UILabel")
    self.view.n_Des03 = self:FindComponent("n_Detail/AttrNum/n_Des03", "UILabel")
    self.view.n_AttrNum03 = self:FindComponent("n_Detail/AttrNum/n_Des03/n_AttrNum03", "UILabel")
    self.view.n_Des04 = self:FindComponent("n_Detail/AttrNum/n_Des04", "UILabel")
    self.view.n_AttrNum04 = self:FindComponent("n_Detail/AttrNum/n_Des04/n_AttrNum04", "UILabel")
    self.view.n_Attribute = self:FindComponent("n_Attribute", "UILabel")
    self.view.n_bgFrp = self:FindComponent("n_Attribute/n_bgFrp", "UISprite")
    self.view.n_SubPanel = self:FindComponent("Fleet/n_SubPanel", "NTableView")

    self:InitView()

    Facade:SendNotification(NotiConst.Notify_FleetProtInitTabItemView, {key = "FleetPortTabItem1", view = self.view})
end

function FleetPortTabItem1:InitView()
    local NLuaClickEvent = NLuaClickEvent.Get(self.view.n_Create.gameObject)
    NLuaClickEvent:AddClick(self, self.CreateClick)
end

--创建舰队
function FleetPortTabItem1:CreateClick()
    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    fleetProxy:SetCurrentOperation({type = 0})
    fleetProxy:SetFleetShipsData({})
    Facade:ReplacePanel("FleetShipEditPanel")
end

return FleetPortTabItem1