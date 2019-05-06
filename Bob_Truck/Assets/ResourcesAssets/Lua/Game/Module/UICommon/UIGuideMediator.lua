local UIGuideMediator = class("UIGuideMediator", MediatorDynamic)

function UIGuideMediator:OnRegister()
    self.eventObject = nil
    self.eventCollider = nil
    self.selfObject = nil
    self.selfCollider = nil

    self.forceHand = self.m_viewComponent.uiBinder.m_Force.transform:Find("hand").gameObject
    self.forceHandImpl = self.m_viewComponent.uiBinder.m_Force.transform:Find("hand/hand_impl").gameObject
    self.forceHandIntro = self.m_viewComponent.uiBinder.m_Force.transform:Find("hand/hand_impl/hand_intro").gameObject
    self.forceHandIntroHand = self.m_viewComponent.uiBinder.m_Force.transform:Find("hand/hand_impl/hand_intro/hand"):GetComponent("UISprite")
    self.forceBgGroup = self.m_viewComponent.uiBinder.m_Force.transform:Find("bggroup").gameObject
    self.forceBgGroupLeft = self.m_viewComponent.uiBinder.m_Force.transform:Find("bggroup/left").gameObject
    self.forceBgGroupRight = self.m_viewComponent.uiBinder.m_Force.transform:Find("bggroup/right").gameObject
    self.forceBgGroupText = self.m_viewComponent.uiBinder.m_Force.transform:Find("bggroup/text").gameObject
    self.forceBgGroupPicture = self.m_viewComponent.uiBinder.m_Force.transform:Find("bggroup/picture").gameObject

    self.force = {}
    self.force[2] = self.forceBgGroupLeft
    self.force[3] = self.forceBgGroupRight
    self.force[4] = self.forceBgGroupText
    self.force[5] = self.forceBgGroupPicture

    local NLuaClickEvent = NLuaClickEvent.Get(self.forceHandImpl)
    NLuaClickEvent:AddClick(self, self.HandImplClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_bkgnd.gameObject)
    NLuaClickEvent:AddClick(self, self.MaskClick)

    self:RegisterObserver(NotiConst.Utility_OpenGuide, "OpenGuide")
end

function UIGuideMediator:OpenGuide(notification)
    local body = notification:GetBody()
    self.introId = body.introId
    local guideData = ManagerIntro:GetGuideDataById(self.introId)
    self.showType = guideData.data[guideData.EVar["show_type_n"]]
    
    self.m_viewComponent.uiBinder.m_bkgnd.gameObject:SetActive(self.showType < 10)
    self.m_viewComponent.uiBinder.m_Force:SetActive(self.showType < 10)
    self.forceBgGroup:SetActive(self.showType > 1 and self.showType < 10)

    if self.showType >= 1 and self.showType <= 3 then
        self:HandBuild(body.eventObject, guideData.data)
    end

    if self.showType >= 2 and self.showType <= 5 then
        self.force[self.showType]:SetActive(true)
    end
end

function UIGuideMediator:HandBuild(eventObject, guideData)
    self.forceHand:SetActive(true)

    self.eventObject = eventObject
    self.selfObject = self.forceHandImpl
    self.eventCollider = self.eventObject:GetComponent("BoxCollider")
    self.selfCollider = self.selfObject:GetComponent("BoxCollider")

    local colliderEnable = true
    if not self.eventObject.activeSelf then
        colliderEnable = false
    end

    if not self.eventCollider.enabled then
        colliderEnable = false
    end

    self.selfCollider.enabled = colliderEnable

    self.selfCollider.center = self.eventCollider.center
    self.selfCollider.size = self.eventCollider.size

    self.forceHandIntro.transform.localPosition = Vector3(guideData.offsetX, guideData.offsetY, 0)
    self.selfObject.transform.position = self.eventObject.transform.position
    GameObjectUtil.SetFlip(self.forceHandIntroHand, guideData.mirror)
end

function UIGuideMediator:HandUnBind()
    self.forceHand:SetActive(fasle)

    self.eventObject = nil
    self.eventCollider = nil
    self.selfObject = nil
    self.selfCollider = nil
end

function UIGuideMediator:HandImplClick()
    if self.eventObject then
        GameObjectUtil.SendMessage(self.eventObject, "OnClick")
    end

    self:CloseAndCompleteIntro()
end

function UIGuideMediator:MaskClick()
    if self.showType >= 1 and self.showType <= 3 then
        return
    end

    self:CloseAndCompleteIntro()
end

function UIGuideMediator:CloseAndCompleteIntro()
    Facade:CloseUtilityPanel("UIGuidePanel")

    self:HandUnBind()
    for i,v in pairs(self.force) do
        v:SetActive(fasle)
    end

    ManagerIntro:CompleteIntro(self.introId)
end

return UIGuideMediator