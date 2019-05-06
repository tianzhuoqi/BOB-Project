local UIPlayerResourceMediator = class("UIPlayerResourceMediator", MediatorDynamic)
local userDataProxy = Facade:RetrieveProxy(NotiConst.Package_UserData)
function UIPlayerResourceMediator:OnRegister()
    self.uiBinder = self:GetViewComponent().uiBinder

    self:RegisterObserver("UpdatePlayerInfo","UPdatePlayerInfo")
end

function UIPlayerResourceMediator:ShowUI()
    self:UPdatePlayerInfo()
end

function UIPlayerResourceMediator:UPdatePlayerInfo()
    local playerInfo = userDataProxy:GetPlayerInfo()
    local level = playerInfo.level
    local name = playerInfo.name
    local starDust = playerInfo.starDust
    self.uiBinder.m_LabeUserNam.text = name
    self.uiBinder.m_LabeUserLv.text = "LV."..tostring(level)
    self.uiBinder.m_LabelMoneyVal.text = tostring(starDust)--AddUnit(starDust)
end

return UIPlayerResourceMediator