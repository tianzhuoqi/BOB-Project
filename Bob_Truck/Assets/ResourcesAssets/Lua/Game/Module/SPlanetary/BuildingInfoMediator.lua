local BuildingInfoMediator = class("BuildingInfoMediator", MediatorDynamic)

function BuildingInfoMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)

    self.modelShowCam = self.m_viewComponent.uiBinder.m_Model_Pos.transform:Find("Camera"):GetComponent("Camera")
    self.model = {}

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)
end

function BuildingInfoMediator:InitData()
    self.curBuilding = self.planetaryProxy:GetCurBuildingOper()

    local buildingConfigData = self.planetaryProxy:GetBuildingConifData(self.curBuilding.configId)
    local name = buildingConfigData.data[buildingConfigData.EVar["bldg_name_s"]]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]
    local maxLevel = buildingConfigData.data[buildingConfigData.EVar["max_bldg_lvl_n"]]
    local funcType = buildingConfigData.data[buildingConfigData.EVar["bldg_func_type_n"]]

    -- set dynamic text key by name
    self.m_viewComponent.uiBinder.m_Label_TitleKey.text = GetLanguageText("BuildingAttribute", name)   --建筑名
    self.m_viewComponent.uiBinder.m_LabelKey2.text = GetLanguageText(name, name.."Employee")       --英雄
    self.m_viewComponent.uiBinder.m_Label_SbLvTitle1.text = GetLanguageText(name, name.."LvV")    --建筑信息标题1
    self.m_viewComponent.uiBinder.m_Label_SbLvKey1.text = GetLanguageText(name, name.."LvN")
    self.m_viewComponent.uiBinder.m_Label_SbLvTitle2.text = GetLanguageText(name, name.."NumV")
    self.m_viewComponent.uiBinder.m_Label_SbLvKey2.text = GetLanguageText(name, name.."NumN")
    self.m_viewComponent.uiBinder.m_Label_DitelNameTitle1.text = GetLanguageText(name, name.."DescriptionTitle")
    self.m_viewComponent.uiBinder.m_Label_DitelaiKey.text = GetLanguageText("BuildingAttribute", name .. "Dtl")    --建筑描述
    self.m_viewComponent.uiBinder.m_Label_DitelNameTitle2.text = GetLanguageText(name, name.."DetailTitle")
    self.m_viewComponent.uiBinder.m_LabelLv.text = GetLanguageText(name, name.."TitleLv", level)

    self.m_viewComponent.uiBinder.m_Label_SbLvKey1.text = string.format("%s/%s", level, maxLevel)
    local buildingList = self.planetaryProxy:GetBuildingDataByType(funcType)
    local techId = self.planetaryProxy:GetTechIdByconfigId(self.curBuilding.configId)
    local techData = self.planetaryProxy:GetSkillTreeItemInConfig(techId)
    local maxNum = techData.data[techData.EVar['uock_bldg_qty_n']]
    self.m_viewComponent.uiBinder.m_Label_SbLvKey2.text = string.format("%s/%s", #buildingList, maxNum)

    for k,v in pairs(self.model) do
        v:SetActive(false)
    end

    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(true)

    local prefabName = buildingConfigData.data[buildingConfigData.EVar["prefab_name_s"]]
    if self.model[prefabName] then
        local buildingGo = self.model[prefabName]
        buildingGo:SetActive(true)
    else
        local buildingPrefab = ManagerResourceModule.LuaLoadBundle(NotiConst.ModelFBX_ResPath..prefabName..'.prefab')
        local buildingGo = UnityEngine.GameObject.Instantiate(buildingPrefab)
        buildingGo.transform.parent = self.m_viewComponent.uiBinder.m_Object.transform
        NGameObjectUtil.SetLocalPosition(buildingGo, 0, 0, 0)
        NGameObjectUtil.SetLocalRotation(buildingGo, 0, 0, 0)
        NGameObjectUtil.SetScale(buildingGo, 1, 1, 1)

        self.model[prefabName] = buildingGo
    end

    self.modelShowCam.targetTexture:Release()

    --list view
    self:SetBuildingInfoData(buildingConfigData)
    Facade:SendNotification("BuildingInfoListRefresh",#self.buildingInfoData)
end

function BuildingInfoMediator:Close()
    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)

    Facade:BackPanel()
end

function BuildingInfoMediator:SetBuildingInfoData(buildingConfigData)
    local totalList = {}
    
    local tableName = buildingConfigData.data[buildingConfigData.EVar["bldg_func_table_name_s"]]
    local attributeTable = _G["DATA_".. tableName]
    local level = buildingConfigData.data[buildingConfigData.EVar["bldg_lvl_n"]]

    if attributeTable ~= nil then
        for key, val in pairs(attributeTable.EVar) do
            local tempList = {}
            tempList.value = attributeTable[level][val]
            local CNKey = self.planetaryProxy:GetCNKey(key)
            tempList.titleStr = GetLanguageText("BuildingAttribute", CNKey.keyV)
            tempList.valueStr = GetLanguageText("BuildingAttribute", CNKey.keyN)
            table.insert(totalList, tempList)
        end
    end
    self.buildingInfoData = totalList
end

return BuildingInfoMediator