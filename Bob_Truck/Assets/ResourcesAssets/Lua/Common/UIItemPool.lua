--[[
ui item Prefab 实例对象池,比如hud 
切换场景 new一个InstancesPool实例
--]]
local __super = require("Common/InstancesPool")
local UIItemPool = class("UIItemPool", __super)
local UnitySetPos = GameObjectUtil.SetPosition
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition
local UnityScrPickCastFloor = GameObjectUtil.ScreenPickCastFloor
local UnityScreen = UnityEngine.Screen
local UnityWorld3DPos2WorldUIPos = GameObjectUtil.World3DPos2WorldUIPos
local UnitySetScale = GameObjectUtil.SetScale
function UIItemPool:ctor()
	if g_UIItemPool ~= nil then 
		g_UIItemPool:Release();--释放当前
	end
	self.insts = {}
	self.lstUIBinder = {}
	self.rectScreen3D = {0,0,0,0} --屏幕对应的当前世界区域
	self.hudAssetObj = nil
end


---缓存不存在时
function UIItemPool:Instantiate(refPool, strResPath, callback, target)
	--2.加载资源
	if self.hudAssetObj == nil then 
		ManagerResourceModule.LuaLoadBundleAsync(strResPath, function(result, object)
										local newinst = nil;
										if result and object ~= nil then 
											self.hudAssetObj = object
											self:InstantiateFromAsset(self.hudAssetObj, refPool, callback, target)
										end 
										
		end);
	else 
		self:InstantiateFromAsset(self.hudAssetObj, refPool, callback, target)
	end
end

function UIItemPool:InstantiateFromAsset(object, refPool, callback, target)
	local newinst = UnityEngine.Object.Instantiate(object);
	if newinst ~= nil then
		newinst.transform.parent = Facade.m_containerBase.transform
		UnitySetScale(newinst, 1, 1, 1)
		newinst:SetActive(false)
		table.insert(refPool, newinst);
	end
	if callback ~= nil and type(callback) == "function" then 
		callback(target, newinst);
	end 
end


--回收实例,
function UIItemPool:DeleteInst(inst)
	if inst == nil then 
		return;
	end
	inst:SetActive(false);
	--inst.transform.parent = self.root_transform;
end

function UIItemPool:Is3DPosInScreen(x,y,z)
	return x >= self.rectScreen3D[1] and x <= self.rectScreen3D[3] and z >= self.rectScreen3D[2] and z <= self.rectScreen3D[4]
end

function UIItemPool:Is3DLineInScreen(x1_,y1_,z1_,x2_,y2_,z2_)
	if self:Is3DPosInScreen(x1_,y1_,z1_) or self:Is3DPosInScreen(x2_,y2_,z2_) then
		return true
	end
	local x1 = x1_
	local x2 = x2_
	local y1 = y1_
	local y2 = y2_
	local z1 = z1_
	local z2 = z2_
	if x2 < x1 then
		x1 = x2_
		x2 = x1_
		y1 = y2_
		y2 = y1_
		z1 = z2_
		z2 = z1_
	end
	if x2 < self.rectScreen3D[1] or x1 > self.rectScreen3D[3] then
		return false
	end
	local v = {x2 - x1,z2 - z1}
	local d = math.sqrt(v[1]*v[1] + v[2]*v[2])
	v[1] = v[1]/d
	v[2] = v[2]/d
	if math.abs(x2 - x1) < 0.00001 then
		return (x1 >= self.rectScreen3D[1] and x1 <= self.rectScreen3D[3])
	end
	local k = d/(x2-x1)
	local dx1 = self.rectScreen3D[1] - x1
	local dx2 = self.rectScreen3D[3] - x1
	local p1 = {x1+v[1]*dx1*k,z1+v[2]*dx1*k}
	local p2 = {x1+v[1]*dx2*k,z1+v[2]*dx2*k}
	
	if p1[2] >= self.rectScreen3D[2] and p1[2] <= self.rectScreen3D[4] then
		return true
	end
	if p2[2] >= self.rectScreen3D[2] and p2[2] <= self.rectScreen3D[4] then
		return true
	end
	
	return false
end

function UIItemPool:OnViewChanged(lod)
	local posMin = UnityScrPickCastFloor(0,0)
	local posMax = UnityScrPickCastFloor(UnityScreen.width, UnityScreen.height)
	self.rectScreen3D[1]=posMin.x
	self.rectScreen3D[2]=posMin.z
	self.rectScreen3D[3]=posMax.x
	self.rectScreen3D[4]=posMax.z
	self:UpdateHud(lod)
end

function UIItemPool:PostShowHudReq(baseobj, callback)
	if baseobj == nil then 
		return
	end
	local id = baseobj.ID 

	--刷新
	local hud = baseobj.hud
	if hud ~= nil then 
		local uuid = hud:GetInstanceID()
		if self.lstUIBinder[uuid] ~= nil then 
			callback(baseobj, self.lstUIBinder[uuid])
		end
	end
	--

	if self.lstHudReq == nil then 
		self.lstHudReq = {}
	end
	if self.lstHudReq[id] ~= nil then 
		return
	end
	self.lstHudReq[id]={baseobj,callback}

	
end

local aryDockFleetName = {"fleet1", "fleet2", "fleet3", "fleet4"}
function UIItemPool:BindHud(obj, uiid)
	if obj == nil then 
		return
	end
	self.lstUIBinder[uiid] = {}
	local title = obj.transform:Find("titleobj/title")
    if title ~= nil then
		self.lstUIBinder[uiid].title = title:GetComponent("UILabel")
	end

	local titleobj = obj.transform:Find("titleobj")
	self.lstUIBinder[uiid].titleobj = titleobj

	self.lstUIBinder[uiid].mask1 = obj.transform:Find("titleobj/title/mask1"):GetComponent("UISprite")

	self.lstUIBinder[uiid].fleet_info_lod0_1 = obj.transform:Find('fleet_info_lod0_1').gameObject
	self.lstUIBinder[uiid].fleet_info_lod2 = obj.transform:Find('fleet_info_lod2').gameObject

	self.lstUIBinder[uiid].fleet_info = obj.transform:Find('fleet_info_lod0_1/fleet_info').gameObject
	self.lstUIBinder[uiid].fleet_info2 = obj.transform:Find('fleet_info_lod2/fleet_info').gameObject

	self.lstUIBinder[uiid].safe_level = obj.transform:Find("safe_level"):GetComponent("UILabel")
	self.lstUIBinder[uiid].safe_level.text = ""

	local icon = obj.transform:Find("icon")
	self.lstUIBinder[uiid].icon = icon

	local owner_icon = obj.transform:Find("icon/owner_icon")
	self.lstUIBinder[uiid].owner_icon = owner_icon

	local style = obj.transform:Find('resourceStyle')
	if style ~= nil then
		self.lstUIBinder[uiid].style = style
		local styleList = {}
		for i = 1, 4 do
			table.insert(styleList, style:Find('style'..i).gameObject) 
		end
		self.lstUIBinder[uiid].styleList = styleList
	end
end

function UIItemPool:ChangeLod(obj, lod)
	if lod == 2 then
		obj.titleobj.gameObject:SetActive(false)
		obj.mask1.gameObject:SetActive(false)
		obj.safe_level.gameObject:SetActive(false)
		obj.style.gameObject:SetActive(false)
		obj.icon.gameObject:SetActive(true)
		obj.fleet_info_lod0_1.gameObject:SetActive(true)
		obj.fleet_info_lod2.gameObject:SetActive(false)
	elseif lod == 1 then
		obj.titleobj.gameObject:SetActive(true)
		obj.mask1.gameObject:SetActive(false)
		obj.safe_level.gameObject:SetActive(false)
		obj.style.gameObject:SetActive(true)
		obj.icon.gameObject:SetActive(false)
		obj.fleet_info_lod0_1.gameObject:SetActive(true)
		obj.fleet_info_lod2.gameObject:SetActive(false)
	else
		obj.titleobj.gameObject:SetActive(true)
		obj.mask1.gameObject:SetActive(true)
		obj.safe_level.gameObject:SetActive(false)
		obj.style.gameObject:SetActive(true)
		obj.icon.gameObject:SetActive(false)
		obj.fleet_info_lod0_1.gameObject:SetActive(true)
		obj.fleet_info_lod2.gameObject:SetActive(false)
	end
end

function UIItemPool:UpdateHud(lod)
	if self.lstHudReq == nil then 
		return
	end
	for k, v in pairs(self.lstHudReq) do
		if v ~= nil and v[1] ~= nil then 
			if self:Is3DPosInScreen(v[1].Pos.x, v[1].Pos.y, v[1].Pos.z) then 
				if v[1].hud == nil then 
					self:NewInst("UIPanel/SUniverse/NodeHudInfo.prefab", function(this, obj)
						if v[1].hud == nil then --异步回调再执行一次判断
							if obj ~= nil then 
								v[1].hud = obj
								local uuid = obj:GetInstanceID()
								self:BindHud(obj, uuid)
								obj:SetActive(true)
								if v[2] ~= nil then 
									v[2](v[1], self.lstUIBinder[uuid])
								end
								local posui = UnityWorld3DPos2WorldUIPos(v[1].Pos.x, v[1].Pos.y, v[1].Pos.z)
								UnitySetPos(obj, posui.x, posui.y, 0)
								self:ChangeLod(self.lstUIBinder[uuid], lod)
							end
						end
					end, nil)
				else 
					local posui = UnityWorld3DPos2WorldUIPos(v[1].Pos.x, v[1].Pos.y, v[1].Pos.z)
					UnitySetPos(v[1].hud, posui.x, posui.y, 0)
					local uuid = v[1].hud:GetInstanceID()
					self:ChangeLod(self.lstUIBinder[uuid], lod)
				end
			else --移出屏幕
				self:DeleteInst(v[1].hud)
				v[1].hud = nil
			end
		end
	end
end


function UIItemPool:PostRmvHudReq(baseobj)
	if baseobj == nil then 
		return
	end
	self:DeleteInst(baseobj.hud)
	baseobj.hud = nil
	local id = baseobj.ID 
	if self.lstHudReq == nil then 
		return
	end
	if self.lstHudReq[id] ~= nil then 
		self.lstHudReq[id] = nil
	end
end

function UIItemPool:Release()
	__super.Release(self)
	self.lstUIBinder = nil
end

return UIItemPool