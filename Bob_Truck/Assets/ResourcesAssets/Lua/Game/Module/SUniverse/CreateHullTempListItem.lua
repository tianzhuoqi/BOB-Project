local ListItem = require("Game/Module/UICommon/ListItem")
local CreateHullTempListItem = register("CreateHullTempListItem", ListItem)
local UnityEngine_Object_Instantiate = UnityEngine.Object.Instantiate
local UnitySetPos = GameObjectUtil.SetPosition
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition
local UnitySetScale = GameObjectUtil.SetScale
local UnityToLocalPos = GameObjectUtil.ToLocalPos
--local s_sprDragClone = nil

function CreateHullTempListItem:Awake(gameObject)
    CreateHullTempListItem.super.Awake(self, gameObject)
    self.icon = self:FindComponent("icon", "UISprite")
    self.sel = self:FindComponent("sel", "UISprite")
    self.medator = Facade:RetrieveMediator("CreateHullTempMediator")
    self.viewParent = self.medator.m_viewComponent
end

function CreateHullTempListItem:OnClick()
    LogDebug('ListItem OnClick dataIndex:{0}', self.dataIndex)
    self.viewParent:OnItemClick(self.itemid)
end

function CreateHullTempListItem:OnPress(press)
    if press == false then 
        --判断拖曳结束
        if self.bPress and self.bDrag then 
            self:OnDragEnd()
        end
    end
    self.bPress = press
end

function CreateHullTempListItem:OnDrag(delta)
    if self.bPress and not self.bDrag then 
        self:OnDragStart()
    end
    self.viewParent:OnDrag(delta)
    --[[if s_sprDragClone ~= nil then --拖icon
        local pos = s_sprDragClone.transform.localPosition
        pos.x = pos.x + delta.x
        pos.y = pos.y + delta.y
        UnitySetLocalPos(s_sprDragClone, pos.x, pos.y, pos.z)
    end--]]
end

function CreateHullTempListItem:OnDragStart()
    self.bDrag = true
    self.viewParent:OnDragStart(self.itemid)
end

function CreateHullTempListItem:OnDragEnd()
    self.bDrag = false
    self.viewParent:OnDragEnd(self.itemid)
end

function CreateHullTempListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.bPress = false
    self.bDrag = false
    --当前是选舰体还是配件
    local lstItem = nil
    if self.medator.nSelCmpntType > 0 then 
        lstItem = self.medator:GetSelectCmpntTypeList()
    else 
        lstItem = self.medator:GetSelectHullTypeList()
    end
    self.itemid = lstItem[self.dataIndex]
    self:RefreshItem()
end

function CreateHullTempListItem:RefreshItem()
    self.sel.gameObject:SetActive(self.medator:IsItemChoosed(self.itemid))
end

return CreateHullTempListItem