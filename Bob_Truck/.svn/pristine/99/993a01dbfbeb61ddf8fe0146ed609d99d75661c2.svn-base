require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local HullModListPanelListCell = register("HullModListPanelListCell", ListCell)

local ModTechCfg = DATA_SHIP_MOD_TECH
local HullMatrCfg = DATA_SMT_AVAIL_HULL_LIST
local CpntCfg = DATA_SMT_AVAIL_CPNT_LIST

function HullModListPanelListCell:OnClick()
    LogDebug('HullModListPanelListCell OnClick dataIndex:{0}', self.dataIndex)
end

function HullModListPanelListCell:Awake(gameObject)
    HullModListPanelListCell.super.Awake(self, gameObject)
    self.group_view = self:FindGameObject("group_view").gameObject
    self.txTitle = self:FindComponent("group_view/txTitle", "UILabel")
    self.btnSel = self:FindGameObject("group_view/btnSel")
    self.btnHelp = self:FindGameObject("group_view/btnHelp")
    self.btnDel = self:FindGameObject("group_view/btnDel")
    self.btnModify = self:FindGameObject("group_view/btnModify")

    self.group_new = self:FindGameObject("group_new").gameObject
    self.btnNew = self:FindGameObject("group_new/btnNewMod")
    

    self.medator = Facade:RetrieveMediator("HullModListMediator")
    self.UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)

    local NLuaClickEvent = NLuaClickEvent.Get(self.btnSel.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonSelectClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.btnDel.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonDeleteClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.btnModify.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonModifyClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.btnHelp.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonHelpClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.btnNew.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonNewClick)
end

function HullModListPanelListCell:ButtonSelectClick()
    
end

function HullModListPanelListCell:ButtonDeleteClick()
    self.medator:ReqDeleteMod(self.dataIndex)
end

function HullModListPanelListCell:ButtonModifyClick()
    Facade:BackPanel()
    Facade:ReplacePanel("CreateHullTempltPanel")
    Facade:SendNotification(NotiConst.Notify_BeginModifyMod, {modidx = self.dataIndex})
end

function HullModListPanelListCell:ButtonHelpClick()

end

function HullModListPanelListCell:ButtonNewClick()
    --创建新模板
    Facade:BackPanel()
    Facade:ReplacePanel("CreateHullTempltPanel")
end

function HullModListPanelListCell:DrawCell(index)
    self.dataIndex = index + 1
    self:FreshItem()
end

function HullModListPanelListCell:FreshItem()
    local mod = self.UserDataProxy:GetHullModByIndex(self.dataIndex)
    self.group_new:SetActive(mod == nil)
    self.group_view:SetActive(mod ~= nil)
    if mod ~= nil then 
        local tech = ModTechCfg[mod.techID]
        self.txTitle.text = tech[ModTechCfg.EVar.mod_tech_name_s]
    end
end

return HullModListPanelListCell