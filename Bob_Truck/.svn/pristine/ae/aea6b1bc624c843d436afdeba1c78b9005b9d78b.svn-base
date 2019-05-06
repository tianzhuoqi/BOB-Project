local GlobalMap = {
	classMap = {},
	objectMap = {},
}

function GlobalMap:LuaGC()
	local c = collectgarbage("count")
	LogDebug("Begin gc count = {0} kb", c)
	collectgarbage("collect")
	local c_ = collectgarbage("count")
	LogDebug("After gc count = {0} kb, Release {1} kb", c_, c - c_)
end

function GlobalMap:HasClass(className)
	return (self.classMap[className] ~= nil)
end 

function GlobalMap:AddClass(className, class) 
	if self:HasClass(className) then
		LogWarn("GlobalMap.AddClass : {0} has Exist!", className)
	end
	if not class then
		LogDebug('GlobalMap.AddClass : {0} == nil', className)
	end
	self.classMap[className] = class
end   
 
function GlobalMap:Class(className)
	local class = self.classMap[className]
	if class == nil then
		LogError("GlobalMap.Class {0} not Exist!", className)
	end
	return class
end
 
function GlobalMap:HasObject(objectHandle)
	return (self.objectMap[objectHandle] ~= nil)
end

function GlobalMap:AddObject(object)
	local handle = #self.objectMap+1
	self.objectMap[handle] = object
	return handle
end

function GlobalMap:ReleaseObject(objectHandle)
	self:CleanObjectTable(self.objectMap[objectHandle])
	self.objectMap[objectHandle] = nil
end

function GlobalMap:CleanAll()
	for k,v in pairs(self.objectMap) do
		if v ~= nil then
			self:CleanObjectTable(v)
		end
	end
	self.objectMap = {}
	-- require的只加载一次，class不能清
	-- self.classMap = {}
	self:LuaGC()
end


function GlobalMap:CleanObjectTable(tableData)
	local markMap = {}
	local clear;
	clear = function(item)
		if markMap[item] then
			return
		end
		markMap[item] = true
		if type(item) == "table" then
			for k, v in pairs(item) do
				local itype = type(v)
				if itype == "table" then
					clear(v)
				elseif itype == "userdata" then --只清理c#的
					item[k] = nil
				end
			end
		end
	end
	for k, v in pairs(tableData) do
		clear(v)
		tableData[k] = nil
	end
	markMap = {}	
	tableData = {}
end

--慎用
function GlobalMap:DeepCleanTable(tableData)
	local markMap = {}
	local clear;
	clear = function(item)
		if markMap[item] then
			return
		end
		markMap[item] = true
		if type(item) == "table" then
			for k, _ in pairs(item) do
				local itemOne = item[k]
				if type(itemOne) == "table" then
					clear(itemOne)
				elseif type(itemOne) ~= "function" then
					item[k] = nil
				end
			end
			if getmetatable(item) ~= nil then
				clear(getmetatable(item))
			end
		end
	end
	for k, item in pairs(tableData) do
		clear(item)
		item = nil
	end
	markMap = {}	
	tableData = {}
end

function GlobalMap:OnDestroy()
	log("Lua OnDestroy")
	self:DeepClearTable(self.objectMap)
	self.classMap = {}
	package.loaded["_G"] = {}
	LuaGC()
end

function GlobalMap:Object(objectHandle)
	local handle = tonumber(objectHandle)
	local object = self.objectMap[handle]
	if object == nil then
		LogError("GlobalMap.ObjectHandle : {0} is nil!", handle)
	end
	return object
end

return GlobalMap
