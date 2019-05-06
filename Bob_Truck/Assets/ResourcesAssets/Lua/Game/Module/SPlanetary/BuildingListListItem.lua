local ListItem = require("Game/Module/UICommon/ListItem")

local BuildingListListItem = register("BuildingListListItem", ListItem)

function BuildingListListItem:Awake(gameObject)
    BuildingListListItem.super.Awake(self, gameObject)
    self.panelMediator = Facade:RetrieveMediator("BuildingListMediator")
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)

    self.n_BackMsg = self:FindGameObject("n_BackMsg")
    self.n_Sprite_BakRsB = self:FindComponent("n_BackMsg/n_Sprite_BakRsB", "UISprite")
    self.Label_Describe = self:FindComponent("n_BackMsg/Label_Describe", "UILabel")
    self.n_Label_Details01 = self:FindComponent("n_BackMsg/n_Label_Details01", "UILabel")
    -- self.n_Label_Money = self:FindComponent("n_BackMsg/n_Label_Money", "UILabel")
    -- self.n_Sprite_Money = self:FindComponent("n_BackMsg/n_Label_Money/n_Sprite_Money", "UISprite")
    --[[self.n_Label_DzName01 = self:FindComponent("n_BackMsg/n_Label_DzName01", "UILabel")
    self.n_Label_Num01 = self:FindComponent("n_BackMsg/n_Label_DzName01/n_Label_Num01", "UILabel")
    self.n_Label_DzName02 = self:FindComponent("n_BackMsg/n_Label_DzName02", "UILabel")
    self.n_Label_Num02 = self:FindComponent("n_BackMsg/n_Label_DzName02/n_Label_Num02", "UILabel")
    self.n_Label_DzName03 = self:FindComponent("n_BackMsg/n_Label_DzName03", "UILabel")
    self.n_Label_Num03 = self:FindComponent("n_BackMsg/n_Label_DzName03/n_Label_Num03", "UILabel")
    self.n_Label_DzName04 = self:FindComponent("n_BackMsg/n_Label_DzName04", "UILabel")
    self.n_Label_Num04 = self:FindComponent("n_BackMsg/n_Label_DzName04/n_Label_Num04", "UILabel")
    self.n_Label_DzName05 = self:FindComponent("n_BackMsg/n_Label_DzName05", "UILabel")
    self.n_Label_Num05 = self:FindComponent("n_BackMsg/n_Label_DzName05/n_Label_Num05", "UILabel")]]

    self.n_FrontMsg = self:FindGameObject("n_FrontMsg")
    self.n_Texture_Icon = self:FindComponent("n_FrontMsg/n_Texture_Icon", "UIEventGrayTexture")
    self.n_Sprite_BakRs = self:FindComponent("n_FrontMsg/Unlock/n_Sprite_BakRs", "UISprite")
    self.n_Sprite_Lock = self:FindComponent("n_FrontMsg/Lock/n_Sprite_Lock", "UISprite")
    self.n_Label_Number = self:FindComponent("n_FrontMsg/Unlock/Label_BuildNum/n_Label_Number", "UILabel")
    self.n_btnMsg = self:FindComponent("n_btnMsg", "UIButton")
    self.n_Sprite_Msg = self:FindComponent("n_btnMsg/n_Sprite_Msg", "UISprite")
    self.n_Sprite_Bak = self:FindComponent("n_FrontMsg/Unlock/n_Sprite_Bak", "UISprite")
    self.n_Label_Name = self:FindComponent("n_FrontMsg/Unlock/n_Label_Name", "UILabel")
    self.cellGo = gameObject.transform.parent.gameObject
    self.subView = gameObject.transform.parent:Find("SubView")
    self.n_InfoArrow = self.subView:Find("n_Arrow").gameObject
    self.n_Button_Building = self.subView:Find("n_Button_Building").gameObject
    self.n_Button_BuildClick = NLuaClickEvent.Get(self.n_Button_Building)
    self.n_Label_Time = self.subView:Find("n_Label_Time"):GetComponent("UILabel")
    self.n_Sub_Label_DzName01 = self.subView:Find("n_BackMsg/n_Label_DzName1"):GetComponent("UILabel")
    self.n_Sub_Label_Num01 = self.subView:Find("n_BackMsg/n_Label_DzName1/n_Label_Num01"):GetComponent("UILabel")
    self.n_Sub_Label_DzName02 = self.subView:Find("n_BackMsg/n_Label_DzName2"):GetComponent("UILabel")
    self.n_Sub_Label_Num02 = self.subView:Find("n_BackMsg/n_Label_DzName2/n_Label_Num01"):GetComponent("UILabel")
    self.n_Sub_Label_DzName03 = self.subView:Find("n_BackMsg/n_Label_DzName3"):GetComponent("UILabel")
    self.n_Sub_Label_Num03 = self.subView:Find("n_BackMsg/n_Label_DzName3/n_Label_Num01"):GetComponent("UILabel")
    self.n_Sub_Label_DzName04 = self.subView:Find("n_BackMsg/n_Label_DzName4"):GetComponent("UILabel")
    self.n_Sub_Label_Num04 = self.subView:Find("n_BackMsg/n_Label_DzName4/n_Label_Num01"):GetComponent("UILabel")
    self.n_Label_Time = self.subView:Find("n_Label_Time"):GetComponent("UILabel")
    self.n_Label_BDetail = self.subView:Find("n_Label_BDetail"):GetComponent("UILabel")
    
    self.n_UnLock = self:FindGameObject("n_FrontMsg/Unlock")
    self.n_Lock = self:FindGameObject("n_FrontMsg/Lock")
    self.SubViewItem = {}
    table.insert(self.SubViewItem, { DzName = self.n_Sub_Label_DzName01, Num = self.n_Sub_Label_Num01})
    table.insert(self.SubViewItem, { DzName = self.n_Sub_Label_DzName02, Num = self.n_Sub_Label_Num02})
    table.insert(self.SubViewItem, { DzName = self.n_Sub_Label_DzName03, Num = self.n_Sub_Label_Num03})
    table.insert(self.SubViewItem, { DzName = self.n_Sub_Label_DzName04, Num = self.n_Sub_Label_Num04})
    table.insert(self.SubViewItem, self.n_Label_Time)
    table.insert(self.SubViewItem, self.n_Label_BDetail)
    
    --[[self.View = {}
    table.insert(self.View, { DzName = self.n_Label_DzName01, Num = self.n_Label_Num01})
    table.insert(self.View, { DzName = self.n_Label_DzName02, Num = self.n_Label_Num02})
    table.insert(self.View, { DzName = self.n_Label_DzName03, Num = self.n_Label_Num03})
    table.insert(self.View, { DzName = self.n_Label_DzName04, Num = self.n_Label_Num04})
    table.insert(self.View, { DzName = self.n_Label_DzName05, Num = self.n_Label_Num05})]]

    local NLuaClickEvent = NLuaClickEvent.Get(self.n_btnMsg.gameObject)
    NLuaClickEvent:AddClick(self, self.ShowMsg)
end


function BuildingListListItem:UpdateSubView()
    GameObjectUtil.SetLocalPosition(self.n_InfoArrow, -205+self.index*200, -70, 0)
    local cost_table = self.configData.data[self.configData.EVar["cost_table_repeated5"]]
    local count = 0
    for i,v in ipairs(cost_table) do
        if v[1] ~= nil and v[2] > 0 then
            local itemConfigData = self.storehouseProxy:GetItemConfigData(v[1])
            local playerItemData = self.storehouseProxy:GetItem(self.planetaryProxy:GetPlanetaryId(), v[1])
            local playerItemNum = 0
            if playerItemData then
                playerItemNum = playerItemData.num
            end
            if itemConfigData ~= nil then
                count = count + 1
                local view = self.SubViewItem[count]
                view.DzName.gameObject:SetActive(true)
                local name_s = itemConfigData.relation["name_s"]
                view.DzName.text = GetLanguageText("ItemName",itemConfigData.data[itemConfigData.EVar[name_s]]).."x"
                view.Num.text = v[2]
                if playerItemNum < v[2] then
                    self.planetaryProxy:SetLabelColor(view.DzName, true)
                    self.planetaryProxy:SetLabelColor(view.Num, true)
                else
                    self.planetaryProxy:SetLabelColor(view.DzName, false)
                    self.planetaryProxy:SetLabelColor(view.Num, false)
                end
                --资源不足时标红
            end
        end
    end
    count = count + 1
    for i = count,4 do
        self.SubViewItem[i].DzName.gameObject:SetActive(false)
    end
    -- cost time
    self.SubViewItem[5].text = SecondFormat(self.configData.data[self.configData.EVar["time_cost_n"]])
    -- building detail info
    local buildingName = self.configData.data[self.configData.EVar["bldg_name_s"]]
    local transTableName = self.configData.data[self.configData.EVar["transl_table_name_s"]]
    self.SubViewItem[6].text = GetLanguageText(transTableName, buildingName .. "Dtl")
    self.n_Button_Building:SetActive(self.isUnlock)
end

function BuildingListListItem:OnClick()
    Facade:SendNotification(NotiConst.Notify_BuildingListListItemChangeSelect, {
        gameObject = self.cellGo,
        cellIndex = self.cellIndex,
        index = self.dataIndex,
    })
    local temp = {
        parent = self,
        id = self.dataIndex,
        OnClick = function(self)
            self.parent:OnBuild()
        end
    }
    self.n_Button_BuildClick:AddClick(temp, temp.OnClick)
    self:UpdateSubView()
end


function BuildingListListItem:OnBuild()
    if self.count > 0 then
        if not self.isUnlock then
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"请先解锁相关科技")
            return
        end

        if self.moreMaxCount then
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"建筑数量大于科技限制，请先升级科技")
            return
        end

        Facade:SendNotification(NotiConst.Notify_BuildingListListItemSelectBuild, self.dataIndex)
    else
        OpenMessageBox(NotiConst.MessageBoxType.Tip,"材料不足")
    end
end

function BuildingListListItem:DrawCell(index, cellIndex, itemsCount)

    self.index = index
    self.cellIndex = cellIndex + 1
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.data = self.planetaryProxy:GetBuildingPackageDataByIndex(self.dataIndex)
    self.configData = self.planetaryProxy:GetBuildingConifData(self.data.id)

    self.n_Label_Name.text = self.planetaryProxy:GetBuildingActualNameByName(self.configData.data[self.configData.EVar["bldg_name_s"]])
    --self.n_Label_Time.text = SecondFormat(self.configData.data[self.configData.EVar["time_cost_n"]])
    --self.n_Label_Details01.text = self.data.id
   
    self.material = {}
    local cost_table = self.configData.data[self.configData.EVar["cost_table_repeated5"]]
    local count = 0
    for i,v in ipairs(cost_table) do
        if v[1] ~= nil and v[1] > 0 then
            local itemConfigData = self.storehouseProxy:GetItemConfigData(v[1])
            if itemConfigData ~= nil then
                count = count + 1
                self.material[v[1]] = v[2]
            end
        end
    end
    


    if self.panelMediator.infoOpen[self.dataIndex] then
        self.n_FrontMsg:SetActive(false)
        self.n_BackMsg:SetActive(true)
    else
        self.n_FrontMsg:SetActive(true)
        self.n_BackMsg:SetActive(false)
    end

    self.nodeId = self.planetaryProxy:GetPlanetaryId()
    
    self.isUnlock = self.planetaryProxy:IsBuildingUnlockedByTech(self.data.id)
    self.moreMaxCount = self.planetaryProxy:IsBuildingCountMax(self.data.id)
    self.n_Label_Number.text = self.planetaryProxy:GetBuildingCount(self.configData.data[self.configData.EVar["bldg_func_type_n"]])..'/'..self.planetaryProxy:GetBuildingMax(self.data.id)
    self.n_UnLock:SetActive(self.isUnlock)
    self.n_Lock:SetActive(not self.isUnlock)
    self.n_Sprite_Lock.gameObject:SetActive(not self.isUnlock)
    self.count = self:CalcCount()
    
    if self.count > 0 then
        --self.n_Texture_Icon:SetNormal()
    else
        --self.n_Texture_Icon:SetGray()
    end

    self.n_Texture_Icon.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(self.configData.data[self.configData.EVar["icon_name_s"]])

    -- draw back info
    --local buildingName = self.configData.data[self.configData.EVar["bldg_name_s"]]
    --local transTableName = self.configData.data[self.configData.EVar["transl_table_name_s"]]
    --self.Label_Describe.text = GetLanguageText(transTableName, buildingName)
    --self.n_Label_Details01.text = GetLanguageText(transTableName, buildingName .. "Dtl")
end

function BuildingListListItem:CalcCount()
    local maxCount = 99999999
    for i,v in pairs(self.material) do
        local itemData = self.storehouseProxy:GetItem(self.nodeId, i)
        if itemData == nil and v > 0 then
            maxCount = 0
            break
        end

        if v > 0 then
            local count = math.floor(itemData.num/v)
            if count < maxCount then
                maxCount = count
            end
        end

        if maxCount == 0 then
            break
        end
    end
    return maxCount
end

function BuildingListListItem:ShowMsg()
    local openInfo = self.panelMediator.infoOpen[self.dataIndex]
    if openInfo then
        self.panelMediator.infoOpen[self.dataIndex] = false
    else
        self.panelMediator.infoOpen[self.dataIndex] = true 
    end
    openInfo = self.panelMediator.infoOpen[self.dataIndex]
    self.n_FrontMsg:SetActive(not openInfo)
    self.n_BackMsg:SetActive(openInfo)
end

return BuildingListListItem