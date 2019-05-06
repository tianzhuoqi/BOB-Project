local TabItem = require("Game/Module/UICommon/TabItem")

local FleetPortTabItem0 = register("FleetPortTabItem0", TabItem)

function FleetPortTabItem0:Awake(gameObject)
    FleetPortTabItem0.super.Awake(self, gameObject)

    self.view = {}
    self.view.n_Create = self:FindComponent("n_Create", "UIButton")
    self.view.n_Detail = self:FindGameObject("n_Detail")
    self.view.n_Disband = self:FindComponent("n_Detail/n_Disband", "UIButton")
    self.view.n_Discharge = self:FindComponent("n_Detail/n_Discharge", "UIButton")
    self.view.n_Des01 = self:FindComponent("n_Detail/AttrNum/n_Des01", "UILabel")
    self.view.n_AttrNum01 = self:FindComponent("n_Detail/AttrNum/n_Des01/n_AttrNum01", "UILabel")
    self.view.n_Des02 = self:FindComponent("n_Detail/AttrNum/n_Des02", "UILabel")
    self.view.n_AttrNum02 = self:FindComponent("n_Detail/AttrNum/n_Des02/n_AttrNum02", "UILabel")
    self.view.n_Des03 = self:FindComponent("n_Detail/AttrNum/n_Des03", "UILabel")
    self.view.n_AttrNum03 = self:FindComponent("n_Detail/AttrNum/n_Des03/n_AttrNum03", "UILabel")
    self.view.n_Des04 = self:FindComponent("n_Detail/AttrNum/n_Des04", "UILabel")
    self.view.n_AttrNum04 = self:FindComponent("n_Detail/AttrNum/n_Des04/n_AttrNum04", "UILabel")
    self.view.n_ButtonInfo = self:FindComponent("n_Detail/AttrNum/n_ButtonInfo", "UIButton")
    self.view.n_AttributeShipNum = self:FindComponent("n_AttributeShipNum", "UILabel")
    self.view.n_SubPanel = self:FindComponent("Fleet/n_SubPanel", "NTableView")

    self:InitView()

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    Facade:SendNotification(NotiConst.Notify_FleetProtInitTabItemView, {key = "FleetPortTabItem0", view = self.view})
end

function FleetPortTabItem0:InitView()
    local NLuaClickEvent = NLuaClickEvent.Get(self.view.n_Disband.gameObject)
    NLuaClickEvent:AddClick(self, self.DisbandClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.view.n_Discharge.gameObject)
    NLuaClickEvent:AddClick(self, self.LoadGoodsClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.view.n_Create.gameObject)
    NLuaClickEvent:AddClick(self, self.CreateClick)
end

--解散舰艇
function FleetPortTabItem0:DisbandClick()
    Facade:ReplacePanel("FleetDisbandPanel")
end

--装卸货物
function FleetPortTabItem0:LoadGoodsClick()
    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local protFleetData = fleetProxy:GetProtFleetsData()
    if #protFleetData > 0 then
        Facade:ReplacePanel("FleetGoodsPanel")
    else
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"你有舰船吗?")
    end
end

--创建舰队
function FleetPortTabItem0:CreateClick()
    Facade:SendNotification(NotiConst.Notify_ProtFleetGetProtShipsData)

    local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    fleetProxy:SetCurrentOperation({type = 0})
    fleetProxy:SetFleetShipsData({})
    Facade:ReplacePanel("FleetShipEditPanel")
end

return FleetPortTabItem0