local Observer = require("PureMVC/Patterns/Observer/Observer")

local View = class("View")

function View:ctor()
	self.m_mediatorMap = {}
	self.m_observerMap = {}
    self:InitializeView()
end

function View:InitializeView()
end

function View:RegisterObserver(notificationName, observer)
	if not self.m_observerMap[notificationName] then
		self.m_observerMap[notificationName] = {}
	end

	local list=self.m_observerMap[notificationName]
	list[#list+1] = observer
end

function View:NotifyObservers(notification)
	local observers
	if self.m_observerMap[notification:GetName()] then
		local observers_ref = self.m_observerMap[notification:GetName()]
		observers = {}
		for i = 1, #observers_ref do
			observers[i] = observers_ref[i]
		end
	end

	if observers then
		for i = 1, #observers do
			local observer = observers[i]
			observer:NotifyObserver(notification)
		end
	end
end

function View:RemoveObserver(notificationName, notifyContext)
	-- the observer list for the notification under inspection
	if self.m_observerMap[notificationName] then
		local observers = self.m_observerMap[notificationName];

		-- find the observer for the notifyContext
		for i=1,#observers do
			if (observers[i]:CompareNotifyContext(notifyContext)) then
				-- there can only be one Observer for a given notifyContext 
				-- in any given Observer list, so remove it and break
				table.remove(observers,i)
				break;
			end
		end

		-- Also, when a Notification's Observer list length falls to 
		-- zero, delete the notification key from the observer map
		if #observers == 0 then
			self.m_observerMap[notificationName]=nil
		end
	end
end

function View:RegisterMediator(mediator)
	-- do not allow re-registration (you must to removeMediator fist)
	if self.m_mediatorMap[mediator:GetMediatorName()] then 
		return 
	end

	-- Register the Mediator for retrieval by name
	self.m_mediatorMap[mediator:GetMediatorName()] = mediator
	
--[[
	-- Get Notification interests, if any.
	local interests = mediator:ListNotificationInterests();

	-- Register Mediator as an observer for each of its notification interests
	if #interests > 0 then
		-- Create Observer
		local observer = Observer.New("HandleNotification", mediator);

		-- Register Mediator as Observer for its list of Notification interests
		for i=1,#interests do
			self:RegisterObserver(tostring(interests[i]), observer);
		end
	end
]]

	-- alert the mediator that it has been registered
	mediator:OnRegister()
end

function View:RetrieveMediator(mediatorName)
	return self.m_mediatorMap[mediatorName]
end

function View:RemoveMediator(mediatorName)
	local mediator
	-- Retrieve the named mediator
	if not self.m_mediatorMap[mediatorName] then 
		return 
	end
	mediator = self.m_mediatorMap[mediatorName]
	
--[[
	-- for every notification this mediator is interested in...
	local interests = mediator:ListNotificationInterests();

	for i=1,#interests do
		-- remove the observer linking the mediator 
		-- to the notification interest
		self:RemoveObserver(interests[i], mediator);
	end
]]

	-- remove the mediator from the map		
	self.m_mediatorMap[mediatorName] = nil

	-- alert the mediator that it has been removed
	if mediator then 
		mediator:OnRemove() 
	end
	return mediator
end

function View:HasMediator(mediatorName)
	return self.m_mediatorMap[mediatorName] ~= nil
end

function View.Instance()
	if View.m_instance == nil then
		View.m_instance = View.New()
	end

	return View.m_instance
end

function View:InitializeModel()
end

function View:Clean()
	local needRemove = {}
	-- Destroy所有的Panel
	for k,v in pairs(self.m_mediatorMap) do
		if v then
			local viewComponent = v:GetViewComponent()
			if viewComponent then
				if viewComponent.DestroyPanel then
					viewComponent:DestroyPanel()
				end
				-- 确保协程全部停止
				viewComponent:StopAllCoroutines()
			end
			table.insert(needRemove,k)
		end
	end
	for _,v in ipairs(needRemove) do
		if v then
			self:RemoveMediator(v)
		end
	end
	self.m_mediatorMap = {}
	self.m_observerMap = {}
end

return View