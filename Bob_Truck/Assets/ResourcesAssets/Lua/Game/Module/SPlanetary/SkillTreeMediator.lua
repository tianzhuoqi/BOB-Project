local SkillTreeMediator = class("SkillTreeMediator", MediatorDynamic)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local userDataProxy = Facade:RetrieveProxy(NotiConst.Package_UserData)
local universeProxy = Facade:RetrieveProxy(NotiConst.Package_Universe)
function SkillTreeMediator:OnRegister()
    self.uiBinder = self:GetViewComponent().uiBinder
    self.skillTreeTableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")
    self.tabView = self.uiBinder.m_TabView:GetComponent("NTabView")
   
    local luaclickEvent = NLuaClickEvent.Get(self.uiBinder.m_Button_Close.gameObject)
    luaclickEvent:AddClick(self,self.BackPanel)
   
    luaclickEvent = NLuaClickEvent.Get(self.uiBinder.m_Sprite_DetailBG.gameObject)
    luaclickEvent:AddClick(self,self.CloseDetailView)

    self:RegisterObserver("InitSkillTree", "InitSkillTree")
    self:RegisterObserver("ListItemChangeSelect", "ListItemChangeSelect")
    self:RegisterObserver("OpenTechDetailView","OpenDetailView")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.TECHFINISHED), self.TechFinishedCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.TECHLEVELUP), self.TechLevelUpCallback, self)

    self.skillTreetype = NotiConst.SkillTreeType.eSKILLTREE_Building
    self.isFirstOpen = true
end

function SkillTreeMediator:ShowUI( )
    self.uiBinder.m_GameObject_Accelerate:SetActive(false)
    self.uiBinder.m_GameObject_Detail:SetActive(false)
    
    if self.isFirstOpen == false then
        self.tabView:OpenTabItem(0)
    end
    self.isFirstOpen = false
end

function SkillTreeMediator:DestroyPanel()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.TECHFINISHED), self.TechFinishedCallback)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.TECHLEVELUP), self.TechLevelUpCallback)
end

--科技树的显示
function SkillTreeMediator:InitSkillTree(notify)
    local index = notify:GetBody()
    local str = ""
    if index == 0 then
        self.skillTreetype = NotiConst.SkillTreeType.eSKILLTREE_Building
        str = GetLanguageText("SkillTree", "STArchite")
    elseif index == 1 then
        self.skillTreetype = NotiConst.SkillTreeType.eSKILLTREE_Production
        str = GetLanguageText("SkillTree", "STDevelop")
    elseif index == 2 then
        self.skillTreetype = NotiConst.SkillTreeType.eSKILLTREE_Ship
        str = GetLanguageText("SkillTree", "STShip")
    elseif index == 3 then 
        self.skillTreetype = NotiConst.SkillTreeType.eSKILLTREE_Fighting
        str = GetLanguageText("SkillTree", "STFight")
    end
    self.uiBinder.m_Label_Title02.text = str
    planetaryProxy:SetCurrentSelectSkillTreeType(self.skillTreetype)
    planetaryProxy:SaveNeedShowSkillTreeId(self.skillTreetype)
    self.skillTreeTableView:ScrollResetPosition()
    self:ShowSkillTree()
    self:SetTechUnlockProgress()
end

function SkillTreeMediator:ShowSkillTree()
    self.lastSubViewCellIndex = 0
    self.lastSubViewDataIndex = 0
    self.skillTreeTableView:CloseSubViewAll(false)
    local count = planetaryProxy:GetNeedShowSkillTreeItemCount(self.skillTreetype)
    Facade:SendNotification("ShowSkillTree",count)
end

function SkillTreeMediator:SetTechUnlockProgress()
    local progress = planetaryProxy:GetTechUnlockProgress(self.skillTreetype)
    local progressStr = string.format("%2d",progress * 100)
    self.uiBinder.m_Label_Aggregate.text = GetLanguageText("SkillTree", "STAggregate",progressStr)
    self.uiBinder.m_Label_TechCount.text = GetLanguageText("SkillTree", "STTechCount",userDataProxy:GetTechPoint())
end

function SkillTreeMediator:ListItemChangeSelect(notification)
    local body = notification:GetBody()

    if self.lastSubViewCellIndex ~= body.cellIndex then
        self.skillTreeTableView:CloseSubViewAll(false)
        if self.lastSubViewDataIndex ~= body.index then
            self.skillTreeTableView:ToggleSubView(body.gameObject,true,true)
            self.lastSubViewCellIndex = body.cellIndex
            self.lastSubViewDataIndex = body.index
        else
            self.lastSubViewDataIndex = 0
            self.lastSubViewCellIndex = 0
        end
    else 
        if self.lastSubViewDataIndex == body.index then
            self.skillTreeTableView:CloseSubViewAll(false)
            self.lastSubViewDataIndex = 0
            self.lastSubViewCellIndex = 0
        else
            self.lastSubViewCellIndex = body.cellIndex
            self.lastSubViewDataIndex = body.index
        end
    end
end

function SkillTreeMediator:TechLevelUpCallback(sData)
    if sData ~= nil then
        local TSCTechLevelUp = buildingTech_pb.TSCTechLevelUp()
        TSCTechLevelUp:MergeFromString(sData)
        planetaryProxy:SetUnlockTechData(TSCTechLevelUp.technology)
        local nodeId = universeProxy:GetMainBaseNode()
        storehouseProxy:UseItemByDatas(nodeId,TSCTechLevelUp.items)
        userDataProxy:SetTechPoint(TSCTechLevelUp.techPoint)
        userDataProxy:SetStarDust(TSCTechLevelUp.starDust)
        userDataProxy:SendNotificationUpdatePlayerInfo()
        self:ShowSkillTree()
    end
end

--研究完成通知
function SkillTreeMediator:TechFinishedCallback(sData)
    if sData ~= nil then
        local TSCTechFinished = buildingTech_pb.TSCTechFinished()
        TSCTechFinished:MergeFromString(sData)
        planetaryProxy:SetUnlockTechData(TSCTechFinished.technology)
        self:ShowSkillTree()
        self:SetTechUnlockProgress()
    end
end

--打开科技详情
function SkillTreeMediator:OpenDetailView()
    self.uiBinder.m_GameObject_Detail:SetActive(true)
    self:SaveTechDetail()
    local techId = planetaryProxy:GetCurrentSelectTechId()
    self.currentSelectTechMaxLevel = planetaryProxy:GetSkillMaxLevelInConfig(techId)
    Facade:SendNotification("ShowTechDetail",self.currentSelectTechMaxLevel)
end

function SkillTreeMediator:SaveTechDetail()
    local techId = planetaryProxy:GetCurrentSelectTechId()
    local datas = planetaryProxy:GetSameTechAllParamStrings(techId)
    planetaryProxy:SetCurrentTechDetailData(datas)
end

function SkillTreeMediator:CloseDetailView( )
    self.uiBinder.m_GameObject_Detail:SetActive(false)
end

function SkillTreeMediator:BackPanel()
    Facade:BackPanel()
end

return SkillTreeMediator