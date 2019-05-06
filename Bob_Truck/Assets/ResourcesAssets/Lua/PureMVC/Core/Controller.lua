local View = require("PureMVC/Core/View")
local Observer = require("PureMVC/Patterns/Observer/Observer")

local Controller = class("Controller")

function Controller:ctor()
	self.m_commandMap = {}
	self:InitializeController()
end	

function Controller:ExecuteCommand(note)
	local commandType = nil
	if not self.m_commandMap[note:GetName()] then 
		return 
	end
	commandType = self.m_commandMap[note:GetName()]

	local commandInstance = commandType.New()
	commandInstance:Execute(note)
end

function Controller:RegisterCommand(notificationName, commandType)
	if not self.m_commandMap[notificationName] then
		self.m_view:RegisterObserver(notificationName, Observer.New("ExecuteCommand", self))
	end
	self.m_commandMap[notificationName] = commandType
end

function Controller:HasCommand(notificationName)
	return self.m_commandMap[notificationName] ~= nil
end

function Controller:RemoveCommand(notificationName)
	if self.m_commandMap[notificationName] then
		self.m_view:RemoveObserver(notificationName, self)
		self.m_commandMap:Remove(notificationName)
	end
end

function Controller.Instance()
	if Controller.m_instance == nil then
		Controller.m_instance = Controller.New()
	end

	return Controller.m_instance;
end

function Controller:InitializeController()
	self.m_view = View.Instance()
end

function Controller:Clean()
	self.m_commandMap = {}
end

return Controller
