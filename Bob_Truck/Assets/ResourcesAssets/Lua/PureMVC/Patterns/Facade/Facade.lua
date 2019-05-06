Controller = require("PureMVC/Core/Controller")
Model = require("PureMVC/Core/Model")
View = require("PureMVC/Core/View")

Notifier = require("PureMVC/Patterns/Observer/Notifier")
Observer = require("PureMVC/Patterns/Observer/Observer")
Notification =require("PureMVC/Patterns/Observer/Notification")

SimpleCommand = require("PureMVC/Patterns/Command/SimpleCommand")
MacroCommand = require("PureMVC/Patterns/Command/MacroCommand")

Mediator = require("PureMVC/Patterns/Mediator/Mediator")
MediatorDynamic = require("PureMVC/Patterns/Mediator/MediatorDynamic")
MediatorStative = require("PureMVC/Patterns/Mediator/MediatorStative")

ViewComponent = require("PureMVC/Patterns/ViewComponent/ViewComponent")
Proxy = require("PureMVC/Patterns/Proxy/Proxy")

local Facade = class("Facade")

function Facade:ctor()
	self:InitializeFacade()
end

function Facade:RegisterProxy(proxy)
	self.m_model:RegisterProxy(proxy)
end

function Facade:RetrieveProxy(proxyName)
	return self.m_model:RetrieveProxy(proxyName)
end

function Facade:RemoveProxy(proxyName)
	return self.m_model:RemoveProxy(proxyName)
end

function Facade:HasProxy(proxyName)
	return self.m_model:HasProxy(proxyName)
end

function Facade:RegisterCommand(notificationName, commandType)
	self.m_controller:RegisterCommand(notificationName, commandType)
end

function Facade:RemoveCommand(notificationName)
	self.m_controller:RemoveCommand(notificationName)
end

function Facade:HasCommand(notificationName)
	return self.m_controller:HasCommand(notificationName)
end

function Facade:RegisterMediator(mediator)
	self.m_view:RegisterMediator(mediator)
end

function Facade:RetrieveMediator(mediatorName)
	return self.m_view:RetrieveMediator(mediatorName)
end

function Facade:RemoveMediator(mediatorName)
	return self.m_view:RemoveMediator(mediatorName)
end

function Facade:HasMediator(mediatorName)
	return self.m_view:HasMediator(mediatorName)
end

function Facade:NotifyObservers(notification)
	self.m_view:NotifyObservers(notification)
end

function Facade:SendNotification(notificationName, body, type)
	self:NotifyObservers(Notification.New(notificationName, body, type))
end

function Facade.Instance()
	if Facade.m_instance == nil then
		Facade.m_instance = Facade.New()
	end

	return Facade.m_instance
end

function Facade:InitializeFacade()
	self:InitializeModel()
	self:InitializeController()
	self:InitializeView()
end

function Facade:InitializeController()
	if self.m_controller then 
		return 
	end
	self.m_controller = Controller.Instance()
end

function Facade:InitializeModel()
	if self.m_model then 
		return 
	end
	self.m_model = Model.Instance()
end

function Facade:InitializeView()
	if self.m_view then 
		return 
	end
	self.m_view = View.Instance()
end

function Facade:CleanView()
	if not self.m_view then 
		return 
	end
	self.m_view:Clean()
end

function Facade:CleanModel()
	if not self.m_model then 
		return 
	end
	self.m_model:Clean()
end

function Facade:CleanController()
	if not self.m_controller then 
		return 
	end
	self.m_controller:Clean()
end

function Facade:CleanAll()
	self:CleanView()
	self:CleanModel()
	self:CleanController()
	self.m_containerBase = nil
end

-- 以下是关于NUIPanelContainerBase的部分
function Facade:SetPanelContainerBase(component)
	self.m_containerBase = component
end

function Facade:RegisterPanelByPrefabPath(name, path, localPos, settledDepth, anchorSide,panelActiveType)
	if not self.m_containerBase then
		return
	end
	if panelActiveType == nil then
		panelActiveType = NotiConst.EPanelActiveType.EPAT_None
	end
	self.m_containerBase:RegisterPanelByPrefabPath(name, path, localPos, settledDepth, anchorSide,panelActiveType)
end

function Facade:ChangePanelDepth(name, adddepth)
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:ChangePanelDepth(name, addepth)
end

function Facade:OverLayerPanel(name)
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:OverLayerPanel(name)
end

function Facade:ReplacePanel(name)
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:ReplacePanel(name)
end

function Facade:BackPanel()
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:BackPanel()
end

function Facade:BackTwoPanel()
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:BackTwoPanel()
end

function Facade:BackMorePanel(name)
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:BackMorePanel(name)
end

function Facade:SetHomePagePoint()
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:SetHomePagePoint()
end

function Facade:ReturnHomePage()
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:SetHomePagePoint()
end

function Facade:IsRunPanel(name)
	if not self.m_containerBase then
		return nil
	end
	return self.m_containerBase:IsRunPanel(name)
end

function Facade:OpenUtilityPanel(name)
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:OpenUtilityPanel(name)
end

function Facade:CloseUtilityPanel(name)
	if not self.m_containerBase then
		return
	end
	self.m_containerBase:CloseUtilityPanel(name)
end

function Facade:LoadWebByUrl(url)
	if not self.m_containerBase then
		return nil
	end
	return self.m_containerBase:LoadWebByUrl(url)
end

function Facade:TopPanelName()
	if not self.m_containerBase then
		return nil
	end
	return self.m_containerBase:TopPanelName()
end

return Facade