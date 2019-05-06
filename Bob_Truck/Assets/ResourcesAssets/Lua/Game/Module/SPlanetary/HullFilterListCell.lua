local ListCell = require("Game/Module/UICommon/ListCell")

local HullFilterListCell = register("HullFilterListCell", ListCell)

function HullFilterListCell:Awake(gameObject)
    HullFilterListCell.super.Awake(self, gameObject)

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

    self.n_Label_tech = self:FindComponent("GameObject_Model/n_Label_tech", "UILabel")
    self.n_Label_modname = self:FindComponent("GameObject_Model/n_Label_tech/n_Label_modname", "UILabel")
    self.n_Sprite_Warship = self:FindComponent("GameObject_Model/n_Sprite_Warship", "UISprite")
    self.n_Button_Make = self:FindComponent("GameObject_Model/n_Button_Make", "UIButton")

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Make.gameObject)
    NLuaClickEvent:AddClick(self, self.Make)
end

function HullFilterListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.planetaryProxy:GetUserModByIndex(self.dataIndex)

    self.modData =  self.planetaryProxy:GetShipModConfigDataById(self.data.techID)
    local transTableName = self.modData.data[self.modData.EVar["transl_table_name_s"]]
    self.n_Label_tech.text = GetLanguageText(transTableName, self.modData.data[self.modData.EVar["mod_tech_name_s"]])
    self.n_Label_modname.text = self.data.modName

    local modId = UnityEngine.PlayerPrefs.GetInt(self.planetaryProxy:GetFilterKey())
    if modId == self.data.id then
        self.n_Button_Make.gameObject:SetActive(false)
    else
        self.n_Button_Make.gameObject:SetActive(true)
    end
end

function HullFilterListCell:Make()
    Facade:SendNotification(NotiConst.Notify_HullFilterMake, self.data.id)
end

return HullFilterListCell