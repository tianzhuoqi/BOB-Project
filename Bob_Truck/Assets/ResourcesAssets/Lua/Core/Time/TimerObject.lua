--[[
    定时器创建的实例,负责记录在特定时间后完成的事件
    类似unity中的Invoike
]]
local TimerObject = class("TimerObject")

function TimerObject:ctor(guid, triggerTick, isLoop, callback) 
    self.guid = guid                                --定时器GUID
    self.triggerTick = triggerTick                  --间隔多长时间触发
    
    local callbackType = type(callback)
    if callbackType == "function" then
        self.callback = callback                    --回调函数

        if isLoop == true then
            self:Start()
        else
            self:Execute()
        end
    else
        LogError("TimerObject {0} callback is not function", guid)
    end
end

function TimerObject:TimerGuid()
    return self.guid
end

--到时间就执行一次
function TimerObject:Execute()
    self.coroutine = coroutine.create(function(timerObj)
        coroutine.wait(timerObj.triggerTick)
        timerObj.callback()

        --只要stop就表示obj的生命周期结束需要回收
        ManagerTimer:Remove(self)
    end)
    coroutine.resume(self.coroutine, self)
end

--循环每间隔一段时间执行一次callback
--一定要配套Stop调用
function TimerObject:Start()
    self.coroutine = coroutine.create(function(timerObj)
        while true do
            coroutine.wait(timerObj.triggerTick)
            timerObj.callback()
        end
    end)
    coroutine.resume(self.coroutine, self)
end

--stop需要确认是否在这之前执行一次callback
function TimerObject:Stop(executeCallback)
    if self.coroutine ~= nil and coroutine.status(self.coroutine) ~= "dead" then
        if executeCallback then
            self.callback()
        end
        coroutine.stop(self.coroutine)
    end
end

return TimerObject