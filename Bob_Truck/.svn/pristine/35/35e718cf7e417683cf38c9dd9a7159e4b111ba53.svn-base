require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local CollectListCell = register("CollectListCell", ListCell)

local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

function CollectListCell:OnClick()
    local curBuildingOper = planetaryProxy:GetCurBuildingOper()
    if curBuildingOper.dynamicData.planetId == self.planetId then
        return
    end
    if curBuildingOper.dynamicData.collectInfo.status == 0 then
        curBuildingOper.dynamicData.planetId = self.planetId 
        local planetCount = planetaryProxy:GetCollectablePlanetsCount()
        Facade:SendNotification("ShowCollectStars",planetCount)
    end
end

function CollectListCell:Awake(gameObject)
    CollectListCell.super.Awake(self, gameObject)
    self.n_Sprite_Choice = self:FindComponent("n_Sprite_Choice", "UISprite")
    self.n_PlanetTexture = self:FindComponent("n_PlanetTexture", "UITexture")

end

function CollectListCell:DrawCell(index)
    local curBuildingOper = planetaryProxy:GetCurBuildingOper()
    self.dataIndex = index + 1
    self.planetId = planetaryProxy:GetCollectablePlanetIds()[self.dataIndex]
    if index == 0 and curBuildingOper.dynamicData.planetId == 0 then
        curBuildingOper.dynamicData.planetId = self.planetId
        curBuildingOper.dynamicData.planetId = self.planetId
    end
    if curBuildingOper.dynamicData.planetId == self.planetId then
        self.n_Sprite_Choice.gameObject:SetActive(true)
    else
        self.n_Sprite_Choice.gameObject:SetActive(false)
    end

    self:ShowStar()
end

function CollectListCell:ShowStar( )
    body = {
        Index = self.dataIndex,
        Texture = self.n_PlanetTexture.mainTexture,
        PlanetId = self.planetId,
    }
    Facade:SendNotification("Set3DPlanet",body)
end




return CollectListCell