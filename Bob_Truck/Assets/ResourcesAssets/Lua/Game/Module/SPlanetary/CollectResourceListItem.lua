require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")
local ListItem = register("CollectResourceListItem", ListCell)
local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
function ListItem:OnClick()
    if self.curBuildingOper.dynamicData.resourceId == self.itemId then
        self.curBuildingOper.dynamicData.resourceId = 0
    else
        self.curBuildingOper.dynamicData.resourceId = self.itemId
    end
    local resourceCount = planetaryProxy:GetPlanetCollectResourcesCount(self.curBuildingOper.dynamicData.planetId)
    Facade:SendNotification("ShowCollectMineral",resourceCount)
end

function ListItem:Awake(gameObject)
    ListItem.super.Awake(self, gameObject)
    self.n_Sprite_Icon = self:FindComponent("n_Sprite_Icon", "UITexture")
    self.n_Sprite_Frame = self:FindComponent("n_Sprite_Frame", "UISprite")
    self.n_Label_Number = self:FindComponent("n_Label_Number", "UILabel")
    self.n_Label_Name = self:FindComponent("n_Label_Name", "UILabel")
    self.n_Sprite_Select = self:FindComponent("n_Sprite_Select", "UISprite")

end

function ListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.data = self.dataIndex
    self.curBuildingOper = planetaryProxy:GetCurBuildingOper()
   
    local resourceInfo = planetaryProxy:GetPlanetCollectResources(self.curBuildingOper.dynamicData.planetId)[self.data]
    self:ShowItemInfo(resourceInfo)

end

function ListItem:ShowItemInfo(resourceInfo)
    self.itemId = resourceInfo.ID
    local fineness = resourceInfo.Fin
    local name,frame,icon = storehouseProxy:GetItemBaseData(self.itemId)
    self.n_Label_Name.text = GetLanguageText("ItemName",name)
    self.n_Label_Number.text = tostring(fineness).."%"
    self.n_Sprite_Frame.spriteName = frame
    self.n_Sprite_Icon.mainTexture = icon

    if self.curBuildingOper.dynamicData.resourceId == self.itemId then
        self.n_Sprite_Select.gameObject:SetActive(true)
    else
        self.n_Sprite_Select.gameObject:SetActive(false)
    end
end



return ListItem