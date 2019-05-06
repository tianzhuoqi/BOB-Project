--[[
    时区和同步时间的Object,负责管理自己的时间和同步服务器的时间
]]

local SyncTimerObject = class("SyncTimerObject")

function SyncTimerObject:ctor()
    self.starttime = 0
end

--获取开始时间
function SyncTimerObject:GetStartTime()
    return self.starttime
end

--重置，初始化
function SyncTimerObject:Start()
    self.starttime = self:GetLocalTime()
end

--获取本地开启时间
function SyncTimerObject:GetLocalTime()
    return os.time() - Utils:BeginTime()
end

--完成同步后到当前时间的时间差
function SyncTimerObject:FromSyncToNow()
    return self:GetLocalTime() - self.starttime
end

--回满需要的时间
function SyncTimerObject:FullTime(fullTime)
    return fullTime - self:FromSyncToNow()
end

--同步后，回满需要多长时间
function SyncTimerObject:FullResidueTime(fullTime, currentTime)
    return  fullTime - currentTime - self:FromSyncToNow()
end

--完成同步后，服务器系统的时间
function SyncTimerObject:NowServerTime(currentTime)
    return self:FromSyncToNow() + currentTime
end

return SyncTimerObject