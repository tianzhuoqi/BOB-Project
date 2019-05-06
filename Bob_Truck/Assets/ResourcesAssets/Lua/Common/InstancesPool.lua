--[[
Prefab 实例对象池
切换场景 new一个InstancesPool实例
--]]
local InstancesPool = class("InstancesPool");
InstancesPool.sPoolID = 1;
g_InstancesPool = nil; --当前激活的pool实例
function InstancesPool:ctor()
	if g_InstancesPool ~= nil then 
		g_InstancesPool:Release();--释放当前
	end
	self.insts = {};
	--new unity gameobject,用作pool 内实例的初始父结点
	local go = UnityEngine.GameObject.New("InstancesPool"..InstancesPool.sPoolID); 
	self.root_transform = go.transform;
	InstancesPool.sPoolID = InstancesPool.sPoolID+1;
	g_InstancesPool = self;
end

function InstancesPool:GetPool(strResPath)
	if self.insts[strResPath] == nil then 
		self.insts[strResPath] = {};
	end
	return self.insts[strResPath];
end

--从缓存池取实例或者new 实例
--@callback 异步加载回调函数,当target是一个对象时,callback表示为target的成员函数
function InstancesPool:NewInst(strResPath, callback, target, data)
	--1.从pool 取
	local ref = self:GetPool(strResPath);
	local checknil = false;
	local objret = nil;
	--for i=1, #ref do 
	for k,v in pairs(ref) do --虽然ref中存取的元素根据下标顺序存取，但当ref[i]被外部释放掉(即ref[i]=nil)后,会导致ref下标不再连续，致使#ref遍历不完整
		if v == nil then 
			checknil = true;
		elseif v.activeSelf ~= true then
			objret = v;
			break;
		end
	end
	--if checknil then 
	--	self:DoCheckNil(strResPath);
	--end
	
	if objret == nil then 
		self:Instantiate(ref, strResPath, callback, target, data)
	else 
		if callback ~= nil and type(callback) == "function" then 
			callback(target, objret, data);
		end
	end 
end
--从缓存池取实例(在确定缓冲池中必须有需要的实例时使用)
function InstancesPool:NewInstSynch(strResPath)
	local ref = self:GetPool(strResPath)
	local objret = nil
	for k,v in pairs(ref) do --虽然ref中存取的元素根据下标顺序存取，但当ref[i]被外部释放掉(即ref[i]=nil)后,会导致ref下标不再连续，致使#ref遍历不完整
		if v == nil then 
			checknil = true;
		elseif v.activeSelf ~= true then
			objret = v;
			break;
		end
	end
	return objret
end

---缓存不存在时
function InstancesPool:Instantiate(refPool, strResPath, callback, target, data)
	--空游戏对象特殊处理
	if strResPath == "EmptyGameObject" then 
		local newinst = UnityEngine.GameObject.New(strResPath);
		newinst.transform.parent = self.root_transform;
		table.insert(refPool, newinst);
		if callback ~= nil and type(callback) == "function" then 
			callback(target, newinst, data);
		end
		return;
	end
	--2.加载资源
	ManagerResourceModule.LuaLoadBundleAsync(strResPath, function(result, object)
									local newinst = nil;
									if result and object ~= nil then 
										newinst = UnityEngine.Object.Instantiate(object);
										if newinst ~= nil then
											newinst.transform.parent = self.root_transform;
											table.insert(refPool, newinst);
										end
									end 
									if callback ~= nil and type(callback) == "function" then 
										callback(target, newinst, data);
									end 
	end);
end


function InstancesPool:DoCheckNil(strResPath)
	--[[local rmv = {};
	local ref = self:GetPool(strResPath);
	for i=1, #ref do 
		if ref[i] == nil then
			table.insert(rmv, i);
		end
	end 
	for i=#rmv, 1, -1 do 
		table.remove(ref, rmv[i]);
	end--]]
end 

--回收实例,
function InstancesPool:DeleteInst(inst)
	if inst == nil then 
		return;
	end
	inst:SetActive(false);
	inst.transform.parent = self.root_transform;
end

function InstancesPool:Release()
	for k, v in pairs(self.insts) do 
		for i=1, #v do 
			v[i] = nil;
		end
	end
	self.insts = nil;
end

function InstancesPool:PreLoadScene()
	if g_InstancesPool ~= nil then 
		g_InstancesPool:Release();--释放当前
	end
	g_InstancesPool = nil;
	--InstancesPool.New();
end

return InstancesPool;