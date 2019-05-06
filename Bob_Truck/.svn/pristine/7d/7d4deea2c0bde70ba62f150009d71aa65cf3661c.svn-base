local FleetGoodsDropUp = register("FleetGoodsDropUp", WidgetBase)

function FleetGoodsDropUp:Awake(gameObject)
    FleetGoodsDropUp.super.Awake(self, gameObject)

    self.dragDropItem = gameObject.transform:GetComponent('UIDragDropItem')
end

function FleetGoodsDropUp:OnDropUp(index, notificationKey)
    if self.dragDropItem.m_notificationKey ~= notificationKey and index > 0 then
        Facade:SendNotification(NotiConst.Notify_FleetGoodsDropUp, { index = index, notificationKey = notificationKey })
    end
end

return FleetGoodsDropUp 