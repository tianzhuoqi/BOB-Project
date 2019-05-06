local UITipsMediator = class("UITipsMediator", MediatorDynamic)

function UITipsMediator:OnRegister()
    self:RegisterObserver(NotiConst.Utility_OpenTips, "TipsEnqueue")
    self.view = self:GetViewComponent()
    self.view.tipsQueue = {}
    self.view.queueTop = 1
    self.view.queueLast = 1
    
    self.timeAni = 1.5
end

function UITipsMediator:StartQueue()
    self.view.queueCoID = self.view:StartCoroutine(self.ExtractingTipsFromQueue, self)
end

--将一个tip加入队列
function UITipsMediator:TipsEnqueue(notification)
    local body = notification:GetBody()

    self.view.tipsQueue[self.view.queueLast] = body
    self.view.queueLast = self.view.queueLast + 1

    if self.view.queueCoID == nil then                       -- if queue is not running
        self:StartQueue()
    end
end

function UITipsMediator:ExtractingTipsFromQueue(mediator)
    local view = self                                   --注意，这里的self是view component
    while true do
        if view.queueTop == view.queueLast then         -- queue is empty, end coroutine
            break
        end
        local body = view.tipsQueue[view.queueTop]
        view.tipsQueue[view.queueTop] = nil           
        view.queueTop = view.queueTop + 1
        mediator:ShowTips(view, body, function()
            coroutine.resume(view.queueCoID)
        end)
        coroutine.yield()                   -- yield , waiting for callback
    end
    view.queueTop = 1
    view.queueLast = 1
    view.queueCoID = nil
    Facade:CloseUtilityPanel("UITipsPanel")
end

--显示一条tip
function UITipsMediator:ShowTips(view, body, callback)
    if body.content ~= nil then
        view.label.text = body.content
    else
        view.label.text = "no content"
    end
    --view:animation:Play()  播放动画 调整位置
    view:StartCoroutine(self.CoTipsTimer, callback)
end

function UITipsMediator:CoTipsTimer(callback)
    local view = self
    coroutine.wait(self.timeAni)

    if callback ~= nil then
        callback()
    end
end

return UITipsMediator   