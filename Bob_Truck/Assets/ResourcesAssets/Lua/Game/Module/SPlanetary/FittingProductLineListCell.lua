local ListItem = require("Game/Module/UICommon/ListItem")

local FittingProductLineListCell = register("FittingProductLineListCell", ListItem)

function FittingProductLineListCell:Awake(gameObject)
    FittingProductLineListCell.super.Awake(self, gameObject)

    self.n_Sprite_Icon = self:FindComponent("n_Sprite_Icon", "UITexture")
    self.n_Sprite_Frame = self:FindComponent("n_Sprite_Icon/n_Sprite_Frame", "UISprite")
    self.n_Button_Delete = self:FindComponent("n_Sprite_Icon/n_Button_Delete", "UIButton")
    self.n_Label_Num = self:FindComponent("n_Sprite_Icon/n_Label_Num", "UILabel")
    self.n_CountDown = self:FindComponent("n_Sprite_Icon/n_CountDown", "UISprite")
    self.n_Sprite_Add = self:FindComponent("n_Sprite_Add", "UISprite")

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Delete.gameObject)
    NLuaClickEvent:AddClick(self, self.Delete)

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.updateBeat = UpdateBeat
end

function FittingProductLineListCell:Delete()
    Facade:SendNotification(NotiConst.Notify_FittintEditHullProductLine, {index = self.dataIndex, type = 1})
end

function FittingProductLineListCell:OnDropUp(index, notificationKey)
    if notificationKey == NotiConst.Notify_FittintEditHullProductLine then
        Facade:SendNotification(notificationKey, {index = index, type = 0})
    end
end

function FittingProductLineListCell:Update()
    if self.hullfactData == nil then
        UpdateBeat:Remove(self.Update, self)
        return
    end
    local curTime = GetServerTimeStamp()
    local elapsedTime = math.floor((curTime - self.hullfactData.startTime)*(1 + self.hullfactData.personEfficiency*0.01))
    local time = self.costTime - elapsedTime - self.hullfactData.firstProductCostConfigTime
    if time <= 0 or (self.hullfactData.personEfficiency > 0 and curTime >= self.hullfactData.personEfficiencyEndTime) then
        self.updateBeat:Remove(self.Update, self)
        self.n_CountDown.fillAmount = 1
        Facade:SendNotification(NotiConst.Notify_FittintRefreshTime, 0)
        Facade:SendNotification(NotiConst.Notify_FittintGetHullFactData)
    else
        self.n_CountDown.fillAmount = 1 - time / self.costTime
        Facade:SendNotification(NotiConst.Notify_FittintRefreshTime, time)
    end
end

function FittingProductLineListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.planetaryProxy:GetHullfactMSGProductLineByIndex(self.dataIndex)

    self.updateBeat:Remove(self.Update, self)

    if self.data == nil then
        self.n_Sprite_Add.gameObject:SetActive(true)
        self.n_Sprite_Icon.gameObject:SetActive(false)

        if self.dataIndex == 1 then
            Facade:SendNotification(NotiConst.Notify_FittintRefreshTime, 0)
        end
    else
        self.shipCpntData = self.planetaryProxy:GetShipCpntConfigDataById(self.data.techId)
        if self.dataIndex == 1 then
            self.hullfactData = self.planetaryProxy:GetHullfactMSGData()
            self.costTime = self.shipCpntData.data[self.shipCpntData.EVar["time_cost_n"]]
            self.updateBeat:Add(self.Update, self)
        end
        self.n_CountDown.gameObject:SetActive(self.dataIndex == 1)
        self.n_Sprite_Add.gameObject:SetActive(false)
        self.n_Sprite_Icon.gameObject:SetActive(true)

        self.n_Label_Num.text = self.data.productCount
        self.n_Sprite_Icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.shipCpntData.data[self.shipCpntData.EVar["icon_name_s"]])
    end
end

return FittingProductLineListCell