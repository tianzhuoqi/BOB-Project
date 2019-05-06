require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local ModTechListPanelListCell = register("ModTechListPanelListCell", ListCell)

local ModTechCfg = DATA_SHIP_MOD_TECH
local HullMatrCfg = DATA_SMT_AVAIL_HULL_LIST
local CpntCfg = DATA_SMT_AVAIL_CPNT_LIST

function ModTechListPanelListCell:OnClick()
    LogDebug('ModTechListPanelListCell OnClick dataIndex:{0}', self.dataIndex)
end

function ModTechListPanelListCell:Awake(gameObject)
    ModTechListPanelListCell.super.Awake(self, gameObject)
    self.txTitle = self:FindComponent("txTitle", "UILabel")
    self.group_desc = self:FindGameObject("group_desc")
    self.txNum1 = self:FindComponent("group_desc/txNum1", "UILabel")
    self.txNum2 = self:FindComponent("group_desc/txNum2", "UILabel")
    self.btnSel = self:FindGameObject("btnSel")
    self.btnHelp = self:FindGameObject("btnHelp")
    self.UserDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)

    local NLuaClickEvent = NLuaClickEvent.Get(self.btnSel.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonSelectClick)

    local NLuaClickEvent = NLuaClickEvent.Get(self.btnHelp.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonHelpClick)
end

function ModTechListPanelListCell:ButtonSelectClick()
    Facade:BackPanel()
    Facade:SendNotification(NotiConst.Notify_SelectModTech,{itemid = self.itemid})
end

function ModTechListPanelListCell:ButtonHelpClick()

end

function ModTechListPanelListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.dataIndex
    self:FreshItem()
end

function ModTechListPanelListCell:FreshItem()
    local lstModTechs = self.UserDataProxy:GetItemTypeList(NotiConst.ItemType.eIT_ShipModTech)
    local itemid = lstModTechs[self.data]
    self.itemid = itemid
    local itemcfg = ModTechCfg[itemid]
    self.txTitle.text = itemcfg[ModTechCfg.EVar.mod_tech_name_s]
    local hullCfg = HullMatrCfg[itemid]
    local lstMats = hullCfg[HullMatrCfg.EVar.hull_id_repeated100]
    self.txNum1.text = GetLanguageText("Common","StringFmt_HullCount", #lstMats)
    local partCfg = CpntCfg[itemid]
    local lstParts = partCfg[CpntCfg.EVar.cpnt_id_repeated100]
    self.txNum2.text = GetLanguageText("Common","StringFmt_PartsCount", #lstParts)
end

return ModTechListPanelListCell