local GlobalProxy = class("GlobalProxy",Proxy)

function GlobalProxy:OnRegister()

end

function GlobalProxy:OnRemove()

end
--设置服务器同步的时间
function GlobalProxy:SetSystemTimestamp(timestamp)
    self.m_data.timestampOffset = UnityEngine.Time.time
    --时间比服务器时间慢一秒
    self.m_data.systemTimestamp = timestamp + 1
    Facade:SendNotification(NotiConst.Notify_SystemTimestampUpdated)
end

--设置场景临时数据
function GlobalProxy:SetSceneData(sname,data)
    self.m_data.sceneData[sname] = data
end

function GlobalProxy:GetSceneData(sname)
    return self.m_data.sceneData[sname]
end

function GlobalProxy:SetCurrentScene(sname)
    self.m_data.sceneCurrent = sname
end

function GlobalProxy:GetCurrentScene()
    return self.m_data.sceneCurrent
end

return GlobalProxy