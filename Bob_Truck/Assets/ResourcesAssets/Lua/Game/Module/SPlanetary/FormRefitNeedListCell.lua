require("Proto/scene_pb")
local ListCell = require("Game/Module/UICommon/ListCell")

local FormRefitNeedListCell = register("FormRefitNeedListCell", ListCell)

function FormRefitNeedListCell:OnClick()
    LogDebug('FormRefitNeedListCell OnClick dataIndex:{0}', self.dataIndex)
end

function FormRefitNeedListCell:Awake(gameObject)
    FormRefitNeedListCell.super.Awake(self, gameObject)
    self.planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
    self.n_Label_NeedInfo = self:FindComponent("n_Label_NeedInfo", "UILabel")
    self.n_Label_NeedName = self:FindComponent("n_Label_NeedInfo/n_Label_NeedName", "UILabel")
end


function FormRefitNeedListCell:DrawCell(index)
    self.dataIndex = index + 1
    self:FreshItem()
end


function FormRefitNeedListCell:FreshItem()
    local needList = self.planetaryProxy:GetcurFormRefitEditShipTempNeedCountAll()
    local index = 0
    for k, v in pairs(needList) do
        index = index + 1
        if index == self.dataIndex then
            self.n_Label_NeedInfo.text = v
            self.n_Label_NeedName.text = DATA_SHIP_HULL_TECH[k][DATA_SHIP_HULL_TECH.EVar.hull_name_s]
            break
        end
    end
end

return FormRefitNeedListCell