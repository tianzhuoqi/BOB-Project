local CreateSpaceBaseMediator = class("CreateSpaceBaseMediator", MediatorDynamic)

local safeLeveTable = 
{
	"A", "B", "C", "D", "E"
}

function CreateSpaceBaseMediator:OnRegister()
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)

    self.modelShowCam = self.m_viewComponent.uiBinder.m_Model_Pos.transform:Find("Camera"):GetComponent("Camera")
    self.model = {}

    local NLuaClickEvent = NLuaClickEvent.Get(self.m_viewComponent.uiBinder.m_btnSClose.gameObject)
    NLuaClickEvent:AddClick(self, self.Close)
end

function CreateSpaceBaseMediator:InitData()
    local curBuilding = self.planetaryProxy:GetCurBuildingOper()
    local dynamicData = curBuilding.dynamicData
    local configData = self.planetaryProxy:GetBuildingConifData(curBuilding.configId)
    local nodeData = self.universeProxy:GetNode(curBuilding.nodeId)

    --self.m_viewComponent.uiBinder.m_Label_TitleKey.text = dynamicData.owner
    self.m_viewComponent.uiBinder.m_Label_SbLvKey.text = string.format("Lv. %d/%d", configData.data[configData.EVar["bldg_lvl_n"]], configData.data[configData.EVar["max_bldg_lvl_n"]])
    --self.m_viewComponent.uiBinder.m_Label_DitelKey1.text = nodeData.name..' Lv'..safeLeveTable[tonumber(nodeData.slv[1]) + 1]..nodeData.slv[2]
    --self.m_viewComponent.uiBinder.m_Label_DitelKey2.text = dynamicData.isPrimary and "次" or "主"

    --self.m_viewComponent.uiBinder.m_Label_DitelaikeyN01.text = 'capacitance:'
    --self.m_viewComponent.uiBinder.m_Label_DitelaikeyN02.text = 'Charge:'
    --self.m_viewComponent.uiBinder.m_Label_DitelaikeyN03.text = 'range:'
    
    --雇员的具体数据表现还没有，先随便显示个数字


    local level = configData.data[configData.EVar["bldg_lvl_n"]]
    local tableName = configData.data[configData.EVar["bldg_func_table_name_s"]]
    local funcTable = _G["DATA_" .. tableName]

    local max_ele_cap = funcTable[level][funcTable.EVar['max_ele_cap_n']]
    max_ele_cap = math.floor(self.planetaryProxy:GetValueAfterAddition(max_ele_cap,"BUILDING","max_ele_cap"))
    local ele_regen_rate = funcTable[level][funcTable.EVar['ele_regen_rate_n']]
    ele_regen_rate = math.floor(self.planetaryProxy:GetValueAfterAddition(ele_regen_rate,"BUILDING","ele_regen_rate"))
    local affact_rng = funcTable[level][funcTable.EVar['affact_rng_n']]
    affact_rng = math.floor(self.planetaryProxy:GetValueAfterAddition(affact_rng,"BUILDING","affact_rng"))
    local max_item_cap = funcTable[level][funcTable.EVar['max_item_cap_n']]
    max_item_cap = math.floor(self.planetaryProxy:GetValueAfterAddition(max_item_cap,"BUILDING","max_item_cap"))
        

    -- 读取建筑属性
    self.m_viewComponent.uiBinder.m_Label1.text = 10
    self.m_viewComponent.uiBinder.m_Label2.text = StringFormat(GetLanguageText("BuildingAttribute","ATRBChargeN"), ele_regen_rate)
    self.m_viewComponent.uiBinder.m_Label3.text = GetLanguageText("BuildingAttribute","ATRBCapN", affact_rng)
    self.m_viewComponent.uiBinder.m_Label4.text = GetLanguageText("BuildingAttribute","ATRBRangeN", affact_rng)
    self.m_viewComponent.uiBinder.m_Label5.text = GetLanguageText("BuildingAttribute","ATRBCapacityN", max_item_cap)

    -- self.m_viewComponent.uiBinder.m_Label_Ditelaikey1.text = string.format("供电:+%dkw (供电范围 %d)", max_ele_cap, affact_rng)
    -- self.m_viewComponent.uiBinder.m_Label_DitelaiKey2.text = string.format("劳力:+%d人", configData.data[configData.EVar["max_labor_uk_n"]])
    -- self.m_viewComponent.uiBinder.m_Label_DitelaiKey3.text = string.format("存储:+%d立方", max_item_cap)
    -- self.m_viewComponent.uiBinder.m_Label_DitelaiKey4.text = string.format("队列:%d/{1}", dynamicData.buildingLine)
    --self.m_viewComponent.uiBinder.m_Label_DitelaiKey5.text = string.format("耐久:%d/{1}", dynamicData.durability)

    for k,v in pairs(self.model) do
        v:SetActive(false)
    end

    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(true)

    local prefabName = configData.data[configData.EVar["prefab_name_s"]]
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

    local name = configData.data[configData.EVar["bldg_name_s"]]
    local level = configData.data[configData.EVar["bldg_lvl_n"]]
    self.m_viewComponent.uiBinder.m_LabelLv.text = string.format("Lv.%s", level)
end

function CreateSpaceBaseMediator:Close()
    self.m_viewComponent.uiBinder.m_Model_Pos:SetActive(false)

    Facade:BackPanel()
end

return CreateSpaceBaseMediator