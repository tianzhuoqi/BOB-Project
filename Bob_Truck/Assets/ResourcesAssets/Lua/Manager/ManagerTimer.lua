local TimerObject = require("Core/Time/TimerObject")

local ManagerTimer = class("ManagerTimer")

function ManagerTimer:ctor()
    self.guidIndex = 0
    self.timerList = {}
end

function ManagerTimer.Instance()
	if ManagerTimer.m_instance == nil then
		ManagerTimer.m_instance = ManagerTimer.New()
	end

	return ManagerTimer.m_instance
end

--注册一个定时器
function ManagerTimer:RegisterTimer(triggerTick, callback, loop)
    self.guidIndex = self.guidIndex + 1
    local guid = self.guidIndex
    local timerObj = TimerObject.New(guid, triggerTick, loop, callback)
    table.insert(self.timerList, timerObj)
    LogDebug("ManagerTimer RegisterTimer guid: {0}, count: {1}", guid, #self.timerList)
    return guid
end

--删除定时器
function ManagerTimer:RemoveTimerByGuid(guid, executeCallback)
    for i = 1, #self.timerList do
        local timerObj = self.timerList[i]
        if timerObj:TimerGuid() == guid then
            timerObj:Stop(executeCallback)
            self:Remove(timerObj)
            break
        end
    end
end

--清理全部定时器
function ManagerTimer:Release()
    for i = 1, #self.timerList do
        local timerObj = self.timerList[i]
        timerObj:Stop(false)
        self:Remove(timerObj)
    end
end

--删除定时器,此函数谨慎调用
--timerObj可能没有stop协程,需要手动stop再remove
function ManagerTimer:Remove(timerObj)
    for i = 1, #self.timerList do
        if timerObj == self.timerList[i] then
            table.remove(self.timerList, i)
            break
        end
    end
    LogDebug("ManagerTimer Remove count: {0}", #self.timerList)
end

return ManagerTimer