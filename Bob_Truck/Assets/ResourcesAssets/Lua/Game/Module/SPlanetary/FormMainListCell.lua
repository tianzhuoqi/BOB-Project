local ListCell = require("Game/Module/UICommon/ListCell")

local FormMainListCell = register("FormMainListCell", ListCell)

function FormMainListCell:Awake(gameObject)
    FormMainListCell.super.Awake(self, gameObject)

    self.n_Label_Name = self:FindComponent("GameObject_ModelXX/n_Label_Name", "UILabel")
    self.n_Label_ShipSort = self:FindComponent("GameObject_ModelXX/n_Label_ShipSort", "UILabel")
    self.n_Button_Delete = self:FindComponent("GameObject_ModelXX/n_Button_Delete", "UIButton")
    self.n_Label_Info = self:FindComponent("GameObject_ModelXX/GameObject_Info/n_Label_Info", "UILabel")
    self.n_Sprite_Warship = self:FindComponent("GameObject_ModelXX/n_Sprite_Warship", "UITexture")
    self.n_Button_Edit = self:FindComponent("GameObject_ModelXX/n_Button_Edit", "UIButton")
    self.n_Button_Make = self:FindComponent("GameObject_ModelXX/n_Button_Make", "UIButton")
    self.n_Label_Make = self:FindComponent("GameObject_ModelXX/n_Button_Make/n_Label_Make", "UILabel")
    self.n_Button_JumBody = self:FindComponent("SubView/n_Button_JumBody", "UIButton")
    self.n_Button_JumPlus = self:FindComponent("SubView/n_Button_JumPlus", "UIButton")
    self.n_Button_Assembly = self:FindComponent("SubView/n_Button_Assembly", "UIButton")
    self.n_Label_AssemblyNum = self:FindComponent("SubView/n_Button_Assembly/n_Label_AssemblyNum", "UILabel")

    self.n_SubView = self:FindGameObject("SubView")

    self.cpntMatsView = {}
    for i=1,4 do
        table.insert(self.cpntMatsView, {
                        obj = self:FindComponent("GameObject_ModelXX/GameObject_Info/n_Sprite_Main"..i, "UITexture"),
                        frame = self:FindComponent("GameObject_ModelXX/GameObject_Info/n_Sprite_Main"..i.."/n_Sprite_MainFrame"..i, "UISprite")
                    })
    end

    self.hullPartsView = {}
    for i=1,15 do
        table.insert(self.hullPartsView, self:FindComponent("SubView/n_LabelItemBNam"..i, "UILabel"))
    end

    self.costLabel = {}
    for i=1,5 do
        table.insert(self.costLabel, self:FindComponent("SubView/n_LabelItemPNam"..i, "UILabel"))
    end

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Delete.gameObject)
    NLuaClickEvent:AddClick(self, self.DelModel)

    NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Edit.gameObject)
    NLuaClickEvent:AddClick(self, self.EditModel)

    NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Make.gameObject)
    NLuaClickEvent:AddClick(self, self.Make)

    NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Assembly.gameObject)
    NLuaClickEvent:AddClick(self, self.Assembly)
    
    NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_JumBody.gameObject)
    NLuaClickEvent:AddClick(self, self.JumBody)

    NLuaClickEvent = NLuaClickEvent.Get(self.n_Button_JumPlus.gameObject)
    NLuaClickEvent:AddClick(self, self.JumPlus)
end

function FormMainListCell:DrawCell(index)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    self.dataIndex = index + 1
    self.data = self.planetaryProxy:GetUserModByIndex(self.dataIndex)

    self.n_Label_Name.text = self.data.modName

    self.material = {}
    self.materialCpnt = {}
    self.materialHull = {}

    for i=1,#self.data.cpntMats do
        local cpntId = self.data.cpntMats[i]
        if self.material[cpntId] == nil then
            self.material[cpntId] = 0
        end
        self.material[cpntId] = self.material[cpntId] + 1
        self.materialCpnt[cpntId] = self.material[cpntId]

        self.cpntMatsView[i].obj.gameObject:SetActive(true)

        local cnptData = self.planetaryProxy:GetShipCpntConfigDataById(cpntId)
        self.cpntMatsView[i].obj.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(cnptData.data[cnptData.EVar["icon_name_s"]])
    end

    for i=(#self.data.cpntMats+1),#self.cpntMatsView do
        self.cpntMatsView[i].obj.gameObject:SetActive(false)
    end

    for i=1,#self.data.hullParts do
        local hull = self.data.hullParts[i]
        if self.material[hull.hullId] == nil then
            self.material[hull.hullId] = 0
        end
        self.material[hull.hullId] = self.material[hull.hullId] + 1
        self.materialHull[hull.hullId] = self.material[hull.hullId]
    end

    self.nodeId = self.planetaryProxy:GetPlanetaryId()
    self.count = self:CalcCount()
    self.n_Label_Info.text = self.count
    self.n_Label_AssemblyNum.text = "×" .. self.count

    if self.n_SubView.activeSelf then
        self.n_Label_Make.text = GetLanguageText("AssemblyCenter", "ACOFoldBtn")
    else
        self.n_Label_Make.text = GetLanguageText("AssemblyCenter", "ACOUnfoldBtn")
    end

    local count = 0
    for i,v in pairs(self.materialCpnt) do
        count = count + 1
        local cnptData = self.planetaryProxy:GetShipCpntConfigDataById(i)
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        local num = itemData == nil and 0 or itemData.num
        if num >= v then
            self.costLabel[count].text = string.format("%sx%d", GetLanguageText("ItemName",cnptData.data[cnptData.EVar["cpnt_name_s"]]), v)
        else
            self.costLabel[count].text = string.format("[ff4f3e]%sx%d[-]", GetLanguageText("ItemName",cnptData.data[cnptData.EVar["cpnt_name_s"]]), v)
        end
    end

    for i=(count+1),#self.costLabel do
        self.costLabel[i].text = ""
    end

    count = 0
    for i,v in pairs(self.materialHull) do
        count = count + 1
        local hullData = self.planetaryProxy:GetShipHullConfigData(i)
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        local num = itemData == nil and 0 or itemData.num
        if num >= v then
            self.hullPartsView[count].text = string.format("%sx%d", GetLanguageText("ItemName",hullData.data[hullData.EVar["hull_name_s"]]), v)
        else
            self.hullPartsView[count].text = string.format("[ff4f3e]%sx%d[-]", GetLanguageText("ItemName",hullData.data[hullData.EVar["hull_name_s"]]), v)
        end
    end

    for i=(count+1),#self.hullPartsView do
        self.hullPartsView[i].text = ""
    end

    GameObjectUtil.SetButtonState(self.n_Button_Assembly, self.count > 0 and 0 or 3)

    self.modData = self.planetaryProxy:GetShipModConfigDataById(self.data.techID)
    self.n_Sprite_Warship.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.modData.data[self.modData.EVar["ship_icon_name_s"]])
    self.n_Label_ShipSort.text = GetLanguageText(self.modData.data[self.modData.EVar["transl_table_name_s"]], self.modData.data[self.modData.EVar["mod_tech_name_s"]])
end

function FormMainListCell:CalcCount()
    local maxCount = 99999999
    for i,v in pairs(self.material) do
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        if itemData == nil and v > 0 then
            maxCount = 0
            break
        end

        local count = math.floor(itemData.num/v)
        if count < maxCount then
            maxCount = count
        end

        if maxCount == 0 then
            break
        end
    end
    return maxCount
end

--删除
function FormMainListCell:DelModel()
    Facade:SendNotification(NotiConst.Notify_FormMainDelModel, {index = self.dataIndex, cellObj = self.gameObject})
end

--编辑
function FormMainListCell:EditModel()
    Facade:SendNotification(NotiConst.Notify_FormMainEditModel, self.dataIndex)
end

--改装
function FormMainListCell:Refit()
    Facade:SendNotification(NotiConst.Notify_FormMainRefit, self.dataIndex)
end

--显隐切换
function FormMainListCell:Make()
    local coroutineId = coroutine.create(function(listCell)
        coroutine.wait(0.3)

        if listCell.n_SubView.activeSelf then
            listCell.n_Label_Make.text = GetLanguageText("AssemblyCenter", "ACOFoldBtn")
        else
            listCell.n_Label_Make.text = GetLanguageText("AssemblyCenter", "ACOUnfoldBtn")
        end
    end)
    coroutine.resume(coroutineId, self)
    
    --GameObjectUtil.SendMessage(self.gameObject, "OnClick")
end

--组装
function FormMainListCell:Assembly()
    if self.count > 0 then
        Facade:SendNotification(NotiConst.Notify_FormMainMake, self.dataIndex)
    end
end

function FormMainListCell:JumBody()
    local buildingDataList = self.planetaryProxy:GetBuildingDataByType(common_pb.HULLFACT)

    if self.planetaryProxy == nil then
        self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    end

    if #buildingDataList > 0 then
        local buildingData = buildingDataList[1]

        self.planetaryProxy:SetCurBuildingOper(
            {
                uid = GetServerTimeStamp(),
                nodeId = self.planetaryProxy:GetPlanetaryId(),
                targetBuilding = buildingData.id,
                configId = buildingData.buildingConfigId,
                type = 0,
                dynamicData = {}
            }
        )

        UnityEngine.PlayerPrefs.SetInt(NotiConst.Notify_HullFilterMakeDataKey..buildingData.id, self.data.id)

        local callBack = {
            Self = self,
            Count = 1,
            Complete = 0,
            OnComplete = function(self)
                if self.Complete == self.Count then
                    Facade:SendNotification(NotiConst.Notify_FormMainClose)
                    Facade:ReplacePanel("ShipBodyPanel")
                end
            end,
            OnUserMods = function(struct,btsData)
                local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
                local self = struct.Self
                if btsData == nil then
                    planetaryProxy:SetUserMods({})
                else
                    local TSCUserMods = buildingModFact_pb.TSCUserMods()
                    TSCUserMods:MergeFromString(btsData)
                    
                    planetaryProxy:SetUserMods(TSCUserMods.mods)
                end
    
                struct.Complete = struct.Complete + 1
                ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self)
                struct:OnComplete()
            end
        }
    
        ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), callBack.OnUserMods, callBack)
        local TCSUserMods = buildingModFact_pb.TCSUserMods()
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
    else
        OpenMessageBox(NotiConst.MessageBoxType.Tip, "请先建造舰壳厂")
    end
end

function FormMainListCell:JumPlus()
    local buildingDataList = self.planetaryProxy:GetBuildingDataByType(common_pb.CPNTFACT)

    if self.planetaryProxy == nil then
        self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    end

    if #buildingDataList > 0 then
        local buildingData = buildingDataList[1]

        self.planetaryProxy:SetCurBuildingOper(
            {
                uid = GetServerTimeStamp(),
                nodeId = self.planetaryProxy:GetPlanetaryId(),
                targetBuilding = buildingData.id,
                configId = buildingData.buildingConfigId,
                type = 0,
                dynamicData = {}
            }
        )

        UnityEngine.PlayerPrefs.SetInt(NotiConst.Notify_HullFilterMakeDataKey..buildingData.id, self.data.id)

        local callBack = {
            Self = self,
            Count = 1,
            Complete = 0,
            OnComplete = function(self)
                if self.Complete == self.Count then
                    Facade:SendNotification(NotiConst.Notify_FormMainClose)
                    Facade:ReplacePanel("FittingPanel")
                end
            end,
            OnUserMods = function(struct,btsData)
                local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
                local self = struct.Self
                if btsData == nil then
                    planetaryProxy:SetUserMods({})
                else
                    local TSCUserMods = buildingModFact_pb.TSCUserMods()
                    TSCUserMods:MergeFromString(btsData)
    
                    planetaryProxy:SetUserMods(TSCUserMods.mods)
                end
    
                struct.Complete = struct.Complete + 1
                ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), self)
                struct:OnComplete()
            end
        }
    
        ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.USERMODS), callBack.OnUserMods, callBack)
        local TCSUserMods = buildingModFact_pb.TCSUserMods()
        NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.USERMODS, TCSUserMods:SerializeToString())
    else
        OpenMessageBox(NotiConst.MessageBoxType.Tip, "请先建造舰船部件厂")
    end
end

return FormMainListCell