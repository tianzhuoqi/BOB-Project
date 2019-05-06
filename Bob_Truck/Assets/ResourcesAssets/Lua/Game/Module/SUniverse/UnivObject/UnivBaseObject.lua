--[[
	描述一个宇宙对象基类
--]]
local UnivBaseObject = class("UnivBaseObject");
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition;
local UnitySetScale = GameObjectUtil.SetScale;
local UnitySetLocalRot = GameObjectUtil.SetLocalRotation;
function UnivBaseObject:ctor(id)
	--self.cfg 星球配置 cfg.ResPath对应模型资源 cfg.pos={1,2}对应出生点x,z cfg.scale缩放
	self.ID = id;
	self.transform = nil;
	self.parent = nil;
	self.bInView = false;
	self.Pos = Vector3(0,0,0);--位置
	self.Rot = Vector3(0,0,0)--旋转
	self.lstChilds = {};--子物体
end

function UnivBaseObject:SetPostion(x,y,z)
    self.Pos.x = x;
    self.Pos.y = y;
	self.Pos.z = z;
    if self.transform ~= nil then
		UnitySetLocalPos(self.transform.gameObject, x, y, z);
	end 
end

function UnivBaseObject:SetRot(x,y,z)
	self.Rot.x = x
	self.Rot.y = y
	self.Rot.z = z
	if self.transform ~= nil then
		UnitySetLocalRot(self.transform.gameObject, x, y, z)		
	end
end

function UnivBaseObject:GetPostion()
	return self.Pos;
end

function UnivBaseObject:Init(cfg, parent, loadCall)
	self.parent = parent;
	self.loadCall = loadCall
	self.cfg = clone(cfg);
	if cfg.pos[3] then
		self:SetPostion(cfg.pos[1], cfg.pos[2], cfg.pos[3]);
	else
		self:SetPostion(cfg.pos[1], 0, cfg.pos[2]);
	end
	
	if self.cfg.rot ~= nil then 
		self:SetRot(self.cfg.rot[1], self.cfg.rot[2], self.cfg.rot[3]);
	end
	if parent ~= nil and parent.transform ~= nil and parent.bInView then 
		self:InitAppearance();
	end
end

function UnivBaseObject:SetViewStatus(bInView)
	self.bInView = bInView;
	if bInView then 
		if self.transform == nil then 
			self:InitAppearance();
		end
	else 
		--回收inst
		if self.transform ~= nil then 
			g_InstancesPool:DeleteInst(self.transform.gameObject);
		end
		self.transform = nil;
		--头顶信息
		if self.ShowHud ~= nil then 
			self:ShowHud(false)
		end
	end
	
	self:UpdateChildsViewSt(self.bInView);
end 

--初始外观
function UnivBaseObject:InitAppearance()
	if self.cfg == nil then 
		LogDebug("UnivBaseObject:InitAppearance cfg nil:"..tostring(self.__cname));
		return;
	end
	g_InstancesPool:NewInst(self.cfg.ResPath, UnivBaseObject.OnResLoaded, self);
end

function UnivBaseObject:OnResLoaded(obj)
	--LogDebug("Star:OnResLoaded:"..tostring(obj));
	if obj == nil or self.transform ~= nil then 
		return;
	end
	if not self.bInView then
		return;
	end
	if self.cfg.Name ~= nil then
		obj.name = self.cfg.Name;
	end
	obj:SetActive(true);
	self.transform = obj.transform;
	if self.parent ~= nil then 
		self.transform.parent = self.parent.transform;
	end
	self:SetPostion(self.Pos.x, self.Pos.y, self.Pos.z);

	UnitySetScale(obj, 1, 1, 1);
	self:SetRot(self.Rot.x, self.Rot.y, self.Rot.z)
	self:UpdateChildsViewSt(self.bInView);
	--头顶信息
	if self.ShowHud ~= nil then 
		self:ShowHud(self.bInView)
	end

	if self.loadCall then
		self.loadCall(self.parent,obj,self.cfg)
	end
end

function UnivBaseObject:AddChild(child)
	table.insert(self.lstChilds, child);
end

function UnivBaseObject:CleanChild()
	for i=1, #self.lstChilds do 
		self.lstChilds[i]:SetViewStatus(false);
	end
	self.lstChilds = {}
end

function UnivBaseObject:UpdateChildsViewSt()
	for i=1, #self.lstChilds do 
		self.lstChilds[i]:SetViewStatus(self.bInView);
	end
end

return UnivBaseObject;