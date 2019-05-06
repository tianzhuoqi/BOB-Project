local ListCell = require("Game/Module/UICommon/ListCell")

local FormModelModListCell = register("FormModelModListCell", ListCell)

function FormModelModListCell:Awake(gameObject)
    FormModelModListCell.super.Awake(self, gameObject)

    self.n_Unlock = self:FindGameObject("n_Unlock")
    self.n_Label_Name = self:FindComponent("n_Unlock/n_Label_Name", "UILabel")
    self.n_Button_Ok = self:FindComponent("n_Unlock/n_Button_Ok", "UIButton")
    self.n_Button_TechInfo = self:FindComponent("n_Unlock/n_Button_TechInfo", "UIButton")
    self.n_Sprite_Frame1 = self:FindComponent("n_Sprite_Frame1", "UISprite")
    self.n_Sprite_Frame2 = self:FindComponent("n_Sprite_Frame2", "UISprite")
    self.n_Sprite_Frame3 = self:FindComponent("n_Sprite_Frame3", "UISprite")
    self.n_Label_Info1 = self:FindComponent("n_Label_Info1", "UILabel")
    self.n_Label_Info2 = self:FindComponent("n_Label_Info2", "UILabel")
    self.n_Lock = self:FindGameObject("n_Lock")
    self.n_Label_NameLc = self:FindComponent("n_Lock/n_Label_NameLc", "UILabel")

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Ok.gameObject)
    NLuaClickEvent:AddClick(self, self.Sure)

    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
end

function FormModelModListCell:OnClick()
    if self.IsLock then
        OpenMessageBox(NotiConst.MessageBoxType.Tip, GetLanguageText("ErrorCode", "EC61", self.requireLevel))
    end
end

function FormModelModListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.modData = self.planetaryProxy:GetShipModConfigDataByIndex(self.dataIndex)

    local name = GetLanguageText(self.modData.data[self.modData.EVar["transl_table_name_s"]], self.modData.data[self.modData.EVar["mod_tech_name_s"]])
    local level = self.modData.data[self.modData.EVar["ship_mod_lvl_n"]]
    self.n_Label_Name.text = name.." Lv"..level
    self.n_Label_NameLc.text = name.." Lv"..level

    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local buildingLevel = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    self.requireLevel = self.modData.data[self.modData.EVar["bldg_lvl_req_n"]]
    if buildingLevel >= self.requireLevel then
        self.n_Unlock:SetActive(true)
        self.n_Lock:SetActive(false)
    else
        self.n_Unlock:SetActive(false)
        self.n_Lock:SetActive(true)
    end

    self.IsLock = buildingLevel < self.requireLevel
end

function FormModelModListCell:Sure()
    Facade:SendNotification(NotiConst.Notify_FormModelChangeMod, self.dataIndex)
end

return FormModelModListCell