require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local TableCell = register("SkillTreeTechDetailListCell", ListCell)

local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)

function TableCell:Awake(gameObject)
    TableCell.super.Awake(self, gameObject)
    self.n_Label_DetailInfo = self:FindComponent("n_Label_DetailInfo", "UILabel")
    self.n_Label_InfoPercentage = self:FindComponent("n_Label_InfoPercentage", "UILabel")
    self.n_Sprite_DetailBGInactive = self:FindComponent("n_Sprite_DetailBGInactive", "UISprite")
    self.detailBGInactiveObj = self.n_Sprite_DetailBGInactive.gameObject

end

function TableCell:DrawCell(index)
    self.dataIndex = index + 1
    local paramStr = planetaryProxy:GetCurrentTechDetailData()[self.dataIndex]
    local currentLevel = planetaryProxy:GetCurrentSelectTechId() % 100
    if self.dataIndex == currentLevel then
        self.detailBGInactiveObj:SetActive(true)
    else
        self.detailBGInactiveObj:SetActive(false)
    end
    self.n_Label_DetailInfo.text = tostring(self.dataIndex)
    self.n_Label_InfoPercentage.text = tostring(paramStr)
   
end


return TableCell