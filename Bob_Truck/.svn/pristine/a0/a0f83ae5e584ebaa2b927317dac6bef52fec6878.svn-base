local ListViewMediator = require("Game/Module/UICommon/ListViewMediator")

local ListViewWidget = register("ListViewWidget", WidgetBase)

function ListViewWidget:Awake(gameObject, mediatorName, notificationName) 
    ListViewWidget.super.Awake(self, gameObject)

    self.tableView = self.gameObject:GetComponent("NTableView")
    self.mediatorName = mediatorName
    self.notificationName = notificationName

    self.mediator = ListViewMediator.New(self.mediatorName.."ListViewMediator")
    self.mediator:SetViewComponent(self)
    Facade:RegisterMediator(self.mediator)
end

--初始化
function ListViewWidget:Init(isScrollReset)
    self.tableView:TableChange()

    if isScrollReset then
        self:ScrollResetPosition()
    end
end

--ListView数据数量
function ListViewWidget:DataCount()
    return self.mediator:DataCount()
end

--更新DrawCell
function ListViewWidget:UpdateDrawCell()
    self.tableView:UpdateDrawCell()
end

--定位到某一行
function ListViewWidget:ScrollViewToIndex(index)
    self.tableView:ScrollViewToIndex(index)
end

--复位
function ListViewWidget:ScrollResetPosition()
    self.tableView:ScrollResetPosition()
end

function ListViewWidget:onDropUp(notification)
    Facade:SendNotification(notification)
end

return ListViewWidget