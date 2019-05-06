--[[
整个宇宙,由N个NBlock组成,每个Block内包含N个Galaxy
每个Galaxy包含N个Star
上面是静态的对象，当然也包含动态对象，比如舰队...
动态对象放到lstDynmicBlocks内
--]]

local Universe = class("Universe");
local MGalaxy = require("Game/Module/SUniverse/UnivObject/Galaxy");
local MCamerCtrl = require("Common/CameraCtrl");
local MSpaceFleet = require("Game/Module/SUniverse/UnivObject/SpaceFleet");
local MItemPool = require("Common/UIItemPool")
local UnityInput = UnityEngine.Input;
local UnityScreen = UnityEngine.Screen;
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition;
local UnitySetRot = GameObjectUtil.SetRotation;
local UnitySetPos = GameObjectUtil.SetPosition;
local UnitySetLineRenderPos = GameObjectUtil.SetLineRenderPos;
local UnityScrPickCastFloor = GameObjectUtil.ScreenPickCastFloor;
local UnityCamForwardCastFloor = GameObjectUtil.CamForwardCastFloor;
local mathfloor = math.floor;
local mathmin = math.min;
local mathmax = math.max;
local UnityTime = UnityEngine.Time;

--静态变量
--尺寸
Universe.nWidth = 100000;
Universe.nHeight = 100000;
--Block尺寸
Universe.nBlockSize = 80;
Universe.nBlockNumPerW = math.ceil(Universe.nWidth/Universe.nBlockSize);
Universe.nBlockNumPerH = math.ceil(Universe.nHeight/Universe.nBlockSize);
Universe.LineResPath = "ModelFBX/Solarsystem/Star_Trails.prefab";
Universe.InfluenceResPath = "ModelFBX/Solarsystem/Star_Trails 1.prefab";
Universe.FleetNavResPath = "ModelFBX/Solarsystem/Star_Trails 2.prefab";
Universe.FleetNavedResPath = "ModelFBX/Solarsystem/Star_Trails 3.prefab";
--end 静态变量
Universe.SyncSceneNodeInterV = 5--轮询拉取点线数据间隔 
function Universe:ctor()
	self.lstBlocks = {}; --所有区块(静态)
	self.lstDynamicBlocks = {};--动态区块
	self.lstViewBlocks = {}; --当前可见区块 index
	self.lstGalaxy = {};--Galaxy列表
	self.lstLines = {};--连线列表
	self.lstFleetPathLines = {};--fleet路径连线列表
	self.lstDynamics = {};--动态对象列表

	local go = UnityEngine.GameObject.New("Universe");
	self.transform = go.transform;
	self.orign = {0, 0}; --世界起始点
	self.camctrl=MCamerCtrl.New();
	self.UIItemPool = MItemPool.New()
	self.maxViewR=2;--相机拉到最远时，可视block半径，0时只看到当前块，1时9块
	self.viewR = 1;--最少看9格，避免1格时在屏幕拖动时在格子边界突然出现/消失
	self.camctrl:AddCallback(Universe.OnViewPosChanged, self, 1);
	self.camctrl:AddCallback(Universe.OnViewAreaChanged, self, 2);
	self.camctrl:AddCallback(Universe.OnMouseClick, self, 3);
	self.camctrl:AddCallback(Universe.OnViewChangedRealtime, self, 4)
	--拖曳区间
	self.camDragRect={0,0,10,10};--left,top,right,bottom

	self.Lod = 1

	UpdateBeat:Add(self.Update, self);
	self:ImmediateSyncSceneNodeData()

	self.userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
end

function Universe:Release()
	UpdateBeat:Remove(self.Update, self);
	self.camctrl:Release()
	self.UIItemPool:Release()
end

function Universe:Update(dt)
	local dt = UnityTime.deltaTime
	local cameraY = self.camctrl.main_cam_transf.localPosition.y
	for i=1, #self.lstDynamics do
		local dynamicObj = self.lstDynamics[i]
		dynamicObj:Update(dt);
		--绘制路径
		if dynamicObj.__cname ==  "SpaceFleet" and dynamicObj.bMoving then
			dynamicObj:SetShowState(cameraY)
			self:DrawFleetPath(dynamicObj.ID)
		end
	end

	if cameraY <= 80 then
		self.Lod = 0
	elseif cameraY <= 140 then
		self.Lod = 1
	else
		self.Lod = 2
	end

	--轮询拉取点线数据
	self.fNextLastSyncNodeData = self.fNextLastSyncNodeData - dt
	if self.fNextLastSyncNodeData <= 0 then 
		self.fNextLastSyncNodeData = Universe.SyncSceneNodeInterV
		self:RequsetSceneNodeData()
	end

	self:UpdateRewardTime()
end

function Universe:ImmediateSyncSceneNodeData()
	self.fNextLastSyncNodeData = 0.2
end

function Universe:RequsetSceneNodeData()
	
	local lstNodeID = self:GetInScreenGalaxyID()
	if #lstNodeID < 1 then 
		return
	end
	Facade:SendNotification(NotiConst.Command_RPCSCENEN_NODE_DATA, lstNodeID)
end
--收集视野内的点id
function Universe:GetInScreenGalaxyID()
	local lst = {}
	local tNow = os.time()
	for i = 1, #self.lstViewBlocks do
		local block = self:GetBlock(self.lstViewBlocks[i], false)
		if block ~= nil then
			for k = 1, #block do
				if block[k].__cname == 'Galaxy' and (block[k].LastSyncDataTm == nil or (tNow-block[k].LastSyncDataTm)>Universe.SyncSceneNodeInterV) then
					if self.UIItemPool:Is3DPosInScreen(block[k].Pos.x, 0, block[k].Pos.z) then 
						table.insert(lst, block[k].ID)
						block[k].LastSyncDataTm = tNow
					end
				end
			end
		end
	end
	return lst
end

function Universe:ToLocalPos(x,y)
	return x-self.orign[1], y-self.orign[2];
end

--坐标转换成block索引
function Universe:BlockIndexByPos(posx, posy)
	local blockx = mathfloor(posx/Universe.nBlockSize);
	local blocky = mathfloor(posy/Universe.nBlockSize);
	local index = mathfloor(blocky*Universe.nBlockNumPerW + blockx);
	return index
end 

--计算可见区块索引
function Universe:CalViewBlocks(posx, posy)
	local blockx = mathfloor(posx/Universe.nBlockSize);
	local blocky = mathfloor(posy/Universe.nBlockSize);
	local nViewRadus = mathfloor(self.viewR);--可视半径
	local loopx0 = mathfloor(mathmax(0, blockx-nViewRadus));
	local loopx1 = mathfloor(mathmin(blockx+nViewRadus, Universe.nBlockNumPerW-1));
	if loopx1 < loopx0 then 
		loopx1 = loopx0;
	end
	local loopy0 = mathfloor(mathmax(0, blocky-nViewRadus));
	local loopy1 = mathfloor(mathmin(blocky+nViewRadus, Universe.nBlockNumPerH-1));
	if loopy1 < loopy0 then 
		loopy1 = loopx0;
	end
	local result = {};
	local blockidx = 0;
	for i=loopx0, loopx1 do 
		for k=loopy0, loopy1 do 
			blockidx = math.floor(k*Universe.nBlockNumPerW + i);
			--if self:GetBlock(blockidx, false) ~= nil then
				table.insert(result, blockidx);	
			--end
		end
	end
	return result;
end 
---静态对象格子
function Universe:BlockByPos(posx, posy)
	local index = self:BlockIndexByPos(posx, posy);
	return self:GetBlock(index);
end 

function Universe:GetBlock(index, bNewWhenNil)
	if self.lstBlocks[index] == nil then 
		if bNewWhenNil ~= false then 
			self.lstBlocks[index] = {};
		end
	end
	return self.lstBlocks[index];
end 
--end 静态对象格子

---动态对象格子
function Universe:DynamicBlockByPos(posx, posy)
	local index = self:BlockIndexByPos(posx, posy);
	return self:GetDynamicBlock(index);
end 

function Universe:GetDynamicBlock(index, bNewWhenNil)
	if self.lstDynamicBlocks[index] == nil then 
		if bNewWhenNil ~= false then 
			self.lstDynamicBlocks[index] = {};
		end
	end
	return self.lstDynamicBlocks[index];
end
---end 动态对象格子

function Universe:SetBlockViewSt(index, bInView)
	local block=self:GetBlock(index, false);
	if block ~= nil then
		for i=1, #block do 
			if block[i].SetViewStatus ~= nil then 
				block[i]:SetViewStatus(bInView);
				if bInView then 
					table.insert(self.lstEnterViewGalaxy, block[i]);
				else 
					table.insert(self.lstOutViewGalaxy, block[i]);
				end
			end
		end
	end
	local dblock=self:GetDynamicBlock(index, false);
	if dblock ~= nil then 
		for i=1, #dblock do
			if dblock[i].SetViewStatus ~= nil then 
				dblock[i]:SetViewStatus(bInView);
			end
		end
	end
	
end 

function Universe:RmvViewBlock(index)
	for i=1, #self.lstViewBlocks do 
		if index == self.lstViewBlocks[i] then 
			table.remove(self.lstViewBlocks, i);
			return true;
		end
	end
	return false;
end 

function Universe:IsBlockInView(idx)
	for i=1, #self.lstViewBlocks do 
		if idx == self.lstViewBlocks[i] then
			return true;
		end
	end
	return false;
end

function Universe:ChangeLod()
	for i = 1, #self.lstViewBlocks do
		local block = self:GetBlock(self.lstViewBlocks[i], false)
		if block ~= nil then
			for k = 1, #block do
				if block[k].__cname == 'Galaxy' then
					block[k]:ChangeLod(self.Lod)
				end
			end
		end
	end

	local LinePool = g_InstancesPool:GetPool(Universe.LineResPath)
	if LinePool ~= nil then
		for i= 1, #LinePool do 
			self:ChangeLineLod(LinePool[i])
		end
	end
	
	local LinePool1 = g_InstancesPool:GetPool(Universe.FleetNavResPath)
	if LinePool1 ~= nil then
		for i= 1, #LinePool1 do 
			self:ChangeLineLod(LinePool1[i])
		end
	end
end

function Universe:ChangeLineLod(line)
	if self.Lod == 2 then
		UnitySetLocalPos(line, 1000, 1000, 1000)
	else
		UnitySetLocalPos(line, 0, 0, 0)
	end
end

function Universe:GenerateVoronoi()
	self.InfluencePool = g_InstancesPool:GetPool(Universe.InfluenceResPath)
	local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
	if self.InfluencePool ~= nil then
		for k= 1, #self.InfluencePool do 
			g_InstancesPool:DeleteInst(self.InfluencePool[k])
		end
	end

	if self.Lod ~= 1 then
		return
	end

	local points = System.Collections.Generic.List_UnityEngine_Vector4.New()
	local OwnerPointTable = {}
	for i = 1, #self.lstViewBlocks do
		local block = self:GetBlock(self.lstViewBlocks[i], false)
		if block ~= nil then
			for k = 1, #block do
				if block[k].__cname == 'Galaxy' then
					local ownerId = universeProxy:GetNodeOwner(block[k].cfg.id)
					if ownerId ~= 0 then
						if  OwnerPointTable[ownerId] == nil then
							OwnerPointTable[ownerId] = {}
						end
						local area = block[k].cfg.area
						for j = 1, #area  do
							local pos
							if  j == #area then
								if area[#area][1] > area[1][1] then
									pos = Vector4.New(area[1][1], area[1][2], area[#area][1], area[#area][2])
								else
									pos = Vector4.New(area[#area][1], area[#area][2], area[1][1], area[1][2])
								end
							else
								if area[j][1] > area[j + 1][1] then
									pos = Vector4.New(area[j + 1][1], area[j + 1][2], area[j][1], area[j][2])
								else
									pos = Vector4.New(area[j][1], area[j][2], area[j + 1][1], area[j + 1][2])
								end
							end
							local isExists = false
							for i = 1, #OwnerPointTable[ownerId] do
								if OwnerPointTable[ownerId][i] ==  pos then
									table.remove(OwnerPointTable[ownerId], pos)
									isExists = true
									break
								end
							end
							if not isExists then
								table.insert( OwnerPointTable[ownerId], pos)
							end
						end
					end
				end
			end
		end
	end
	for k, v in pairs(OwnerPointTable) do
		for i=1,#v do
			points:Add(v[i])
		end
	end

	if self.coDrawVoronoi ~= nil then
		StopCoroutine(self.coDrawVoronoi)
	end

	self.coDrawVoronoi = StartCoroutine(Universe.DrawVoronoi, points)
end

function Universe:DrawVoronoi(BordersList)
	for i = 0, BordersList.Count - 1 do
        g_InstancesPool:NewInst(Universe.InfluenceResPath, 
        function(this, obj)
            if obj ~= nil then 
                obj:SetActive(true);
                GameObjectUtil.SetLocalPosition(obj, 0, 0, 0);
                GameObjectUtil.SetLineRenderPos(obj, 0, BordersList[i].x, 0, BordersList[i].y);
				GameObjectUtil.SetLineRenderPos(obj, 1, BordersList[i].z, 0, BordersList[i].w);
			end
        end, 
		nil);
		if i % 10 == 0 then
			--WaitForSeconds(0.1)
		end
	end
end

function Universe:MakeFleetPathLineUUID(fleetId,fleetPathLine)
	return fleetId.."("..fleetPathLine[1].x..","..fleetPathLine[1].y..","..fleetPathLine[2].x..","..fleetPathLine[2].y..")"
end

function Universe:ClearFleetPath(fleetId)
	if self.lstFleetPathLines[fleetId] == nil then
		self.lstFleetPathLines[fleetId] = {}
	end
	for k,v in pairs(self.lstFleetPathLines[fleetId]) do
		if v ~= nil then
			g_InstancesPool:DeleteInst(v)
			self.lstFleetPathLines[fleetId][k] = nil
		end
	end
	self.lstFleetPathLines[fleetId] = {}
end

function Universe:DrawFleetPath(fleetId)
	local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
	local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
	local path = fleetProxy:GetFleetMoveNodes(fleetId)
	if path == nil then
		return
	end
	local pathLines = {}
    for i=1,#path-1 do
        local node1 = universeProxy:GetNode(path[i])
        local node2 = universeProxy:GetNode(path[i+1])
        table.insert(pathLines, {node1.position,node2.position})
    end
	local needShow = {}
	local remove = {}
	for i,v in ipairs(pathLines) do
		if self.UIItemPool:Is3DLineInScreen(v[1].x, 0, v[1].y,v[2].x, 0, v[2].y) then 
			table.insert(needShow, v)
		else
			table.insert(remove, v)
		end
	end
	if self.lstFleetPathLines[fleetId] == nil then
		self.lstFleetPathLines[fleetId] = {}
	end
	for i,v in ipairs(remove) do
		local uuid = self:MakeFleetPathLineUUID(fleetId,v)
		if self.lstFleetPathLines[fleetId][uuid] ~= nil then
			g_InstancesPool:DeleteInst(self.lstFleetPathLines[fleetId][uuid])
			self.lstFleetPathLines[fleetId][uuid] = nil
		end
	end
	for i,v in ipairs(needShow) do
		local uuid = self:MakeFleetPathLineUUID(fleetId,v)
		if self.lstFleetPathLines[fleetId][uuid] == nil then
			g_InstancesPool:NewInst(Universe.FleetNavResPath, 
			function(this, obj)
				if obj ~= nil then
					self.lstFleetPathLines[fleetId][uuid] = obj;
					obj:SetActive(true);
					GameObjectUtil.SetLocalPosition(obj, 0, 0, 0)
					GameObjectUtil.SetLineRenderPos(obj, 0, v[1].x, 0, v[1].y)
					GameObjectUtil.SetLineRenderPos(obj, 1, v[2].x, 0, v[2].y)
				end
			end, 
			nil)
		end
	end

end


--添加星系
function Universe:AddGalaxy(cfg)
	local galaxyid = cfg.id;
	local galaxy = MGalaxy.New(galaxyid);
	--转换坐标
	cfg.pos[1] = cfg.pos[1] - self.orign[1];
	cfg.pos[2] = cfg.pos[2] - self.orign[2];
	local bDragRgnUpdate = false
	if cfg.pos[1] < self.camDragRect[1] then 
		self.camDragRect[1] = cfg.pos[1];
		bDragRgnUpdate = true
	elseif cfg.pos[1] > self.camDragRect[3] then
		self.camDragRect[3] = cfg.pos[1];
		bDragRgnUpdate = true
	end
	if cfg.pos[2] < self.camDragRect[2] then 
		self.camDragRect[2] = cfg.pos[2];
		bDragRgnUpdate = true
	elseif cfg.pos[2] > self.camDragRect[4] then
		self.camDragRect[4] = cfg.pos[2];
		bDragRgnUpdate = true
	end
	if bDragRgnUpdate then 
		self.camctrl:SetDragRect(self.camDragRect[1], self.camDragRect[2], self.camDragRect[3], self.camDragRect[4])
	end
	
	galaxy:Init(cfg, self);
	self.lstGalaxy[galaxyid] = galaxy
	local block = self:BlockByPos(cfg.pos[1], cfg.pos[2]);
	if block == nil then 
		LogWarn("Universe:AddGalaxy get block nil");
		return nil;
	end
	table.insert(block, galaxy);
	return galaxy;
end

--添加舰队
function Universe:AddSpaceFleet(cfg,id)
	local spacefleet = MSpaceFleet.New(id);
	--转换坐标
	cfg.pos[1] = cfg.pos[1] - self.orign[1];
	cfg.pos[2] = cfg.pos[2] - self.orign[2];
	spacefleet:Init(cfg, self);
	table.insert(self.lstDynamics, spacefleet);
	local blockidx = self:BlockIndexByPos(cfg.pos[1], cfg.pos[2]);
	
	local block = self:GetDynamicBlock(blockidx);
	if block == nil then 
		LogWarn("Universe:AddSpaceFleet get block nil");
		return nil;
	end
	spacefleet:SetBlockIdx(blockidx);
	table.insert(block, spacefleet);
	spacefleet:SetPosChangedCallback(Universe.OnDynamicObjPosChanged, self);
	if self:IsBlockInView(blockidx) then 
		--spacefleet:SetViewStatus(true)
	end
	return spacefleet;
end

function Universe:RmvSpaceFleet(id)
	local n = #(self.lstDynamics)
	for i=1, n do 
		if self.lstDynamics[i].ID == id then 
			--从DBlock 删除
			local obj = self.lstDynamics[i]
			local obj_idx = obj:GetBlockIdx();
			local block = self:GetDynamicBlock(obj_idx)
			for i=1, #block do
				if block[i] == obj then
					table.remove(block, i)
					break
				end
			end
			--SetViewSt
			obj:SetViewStatus(false)
			--rmv
			table.remove(self.lstDynamics, i)
			return
		end
	end
end

function Universe:UpdateGalaxy(galaxyId,show)
	local galaxy = self:GetGalaxy(galaxyId)
	galaxy:ShowHud(show)
end

--获取动态对象，若type不为nil返回该类型的对象
function Universe:GetDynamicObj(id,type)
	local n = #(self.lstDynamics)
	for i=1, n do 
		if self.lstDynamics[i].ID == id then
			if type and self.lstDynamics[i].__cname == type then
				return self.lstDynamics[i]
			else
				return self.lstDynamics[i]
			end
		end
	end
	return nil
end

function Universe:StopSpaceFleet(id, galaxyid)
	local objFleet = self:GetDynamicObj(id,"SpaceFleet");
	if objFleet then
		self:RmvSpaceFleet(id)
	end
end

function Universe:GetSpaceFleetInScreen()
	local screenNodes = self:GetInScreenGalaxyID()
	local spaceFleets = {}
	local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
	for i,v in ipairs(self.lstDynamics) do
		if v.__cname == "SpaceFleet" then
			local fleet = fleetProxy:GetFleetDataByFleetId(v.id)
			if table.indexOf(screenNodes,fleet.fromNodeId) or table.indexOf(screenNodes,fleet.toNodeId) then
				table.insert(spaceFleets,v)
			end
		end
	end
	return spaceFleets
end

function Universe:GetGalaxy(id)
	return self.lstGalaxy[id];
end

--该星系与其他星系连线,两个星系中有任何一个不在视野，连线也不显示
function Universe:CreateGalaxyLine(galaxy)
	if galaxy == nil then 
		return;
	end
	local end_ids = galaxy.cfg.connect;
	local id0 = galaxy.ID;
	for i=1, #end_ids do 
		local end_galaxy = self:GetGalaxy(end_ids[i]);
		self:LineTogether(galaxy, end_galaxy);
	end
end

function Universe:LineTogether(galaxy0, galaxy1)
	if galaxy0 == nil or galaxy1 == nil then 
		return;
	end
	local id0 = galaxy0.ID;
	local id1 = galaxy1.ID;
	local lineid = self:MakeLineUUID(id0, id1);
	if lineid <= 0 then 
		return;
	end 
	if self.lstLines[lineid] ~= nil then 
		return;
	end
	g_InstancesPool:NewInst(Universe.LineResPath, 
	function(this, obj)
		if obj ~= nil then 
			self.lstLines[lineid] = obj;
			obj:SetActive(true);
			--obj.name = "line_"..tostring(lineid);
			obj.transform.parent = self.transform;
			UnitySetLocalPos(obj, 0, 0, 0);
			UnitySetLineRenderPos(obj, 0, galaxy0.cfg.pos[1], 0, galaxy0.cfg.pos[2]);
			UnitySetLineRenderPos(obj, 1, galaxy1.cfg.pos[1], 0, galaxy1.cfg.pos[2]);
			self:ChangeLineLod(obj)
		end
	end, 
	nil);
end

--用两个galaxy的id组成一条边线的标识
function Universe:MakeLineUUID(id0, id1)
	if self:GetGalaxy(id0) == nil then 
		return 0;
	end
	if self:GetGalaxy(id1) == nil then 
		return 0;
	end
	local idmin = (id1 > id0 and id0) or id1;
	local idmax = (id1 > id0 and id1) or id0;
	return mathfloor(idmin*100000 + idmax), idmin;
end

function Universe:ClearGalaxyLine(galaxy)
	if galaxy == nil then 
		return;
	end
	local end_ids = galaxy.cfg.connect;
	local id0 = galaxy.ID;
	for i=1, #end_ids do
		local lineid = self:MakeLineUUID(id0, end_ids[i]);
		if lineid > 1 then 
			if self.lstLines[lineid] ~= nil then 
				g_InstancesPool:DeleteInst(self.lstLines[lineid]);
				self.lstLines[lineid] = nil;
			end
		end
	end
end


function Universe:LateInit()
	self.camctrl:SetDragRect(self.camDragRect[1], self.camDragRect[2], self.camDragRect[3], self.camDragRect[4]);
	--self.camctrl:SetZoomRang(3,120);
	--镜头定位到主基地
	local UnivProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
	local MBaseNode = UnivProxy:GetMainBaseNode()
	if MBaseNode ~= nil then
		self.camctrl:DirectSetCamPos(MBaseNode.position.x,MBaseNode.position.y)
		UnivProxy:SetCurrentPosition(MBaseNode.position.x,MBaseNode.position.y)
	end
	
	self.camctrl:LateInit()
end

function Universe:GotoPosition(x,y,play,callback)
	if self.corId then
		StopCoroutine(self.corId)
	end
	self.corId = StartCoroutine(self._GotoPosition, self,x,y,play,callback)
	
end

function Universe:_GotoPosition(self,x,y,play,callback)
	local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
	local univData = universeProxy:GetData()
	local ax = math.floor(x/univData.ClusterSize)
	local ay = math.floor(y/univData.ClusterSize)
	local centerNodeId = IntMoveToLeft(ax,20)+IntMoveToLeft(ay,11)+1
	local areaNodes = universeProxy:ReadLuaNodeDataById(centerNodeId)
    local cameraData = universeProxy:BuildCameraData(areaNodes,self.lstGalaxy)
	for k,v in pairs(cameraData) do 
		self:AddGalaxy(v)
	end
	
	if play then
		local ox = self.camctrl.main_cam_transf.localPosition.x
		local oy = self.camctrl.main_cam_transf.localPosition.z
		local loopd = 0.016
		local dur = 0.06
		local n = dur/loopd
		local dx = (x - ox)/n
		local dy = (y - oy)/n
		for i=1,n do
			ox = ox + dx
			oy = oy + dy
			self.camctrl:DirectSetCamPos(ox,oy)
			self.camctrl:LateInit()
			coroutine.wait(loopd)
		end
	end
	self.camctrl:DirectSetCamPos(x,y)
	self.camctrl:LateInit()
	if callback then
		callback()
	end
end

-- 1为拉到最近 0为最远
function Universe:SetZoom(zoomRangePercent)
	self.camctrl:SetZoom(zoomRangePercent)
	self:Update()
	self.camctrl:LateInit()
end

--摄像机视点变化
function Universe:OnViewPosChanged(viewx, viewy)
	--1,计算最新可见block
	self.lstEnterViewGalaxy = {};--本次计算进入视野的galaxy
	self.lstOutViewGalaxy = {};--本次计算进入视野的galaxy
	local viewblks = self:CalViewBlocks(viewx, viewy);
	for i=1, #viewblks do 
		--移除上次可见块
		if not self:RmvViewBlock(viewblks[i]) then 
			self:SetBlockViewSt(viewblks[i], true);
		end
	end
	--剩余上次可见块就是从可见变为不可见的块
	for i=1, #self.lstViewBlocks do 
		self:SetBlockViewSt(self.lstViewBlocks[i], false);
	end

	--处理连线
	for i=1, #self.lstOutViewGalaxy do 
		self:ClearGalaxyLine(self.lstOutViewGalaxy[i]);
	end
	for i=1, #self.lstEnterViewGalaxy do 
		self:CreateGalaxyLine(self.lstEnterViewGalaxy[i]);

	end 
	
	
	--保存最新可见
	self.lstViewBlocks=viewblks;

	self:GenerateVoronoi()

	self:LoadNodeArea()

	self:ChangeLod()

	self.UIItemPool:OnViewChanged(self.Lod)

	--重置拉取数据时间
	self:ImmediateSyncSceneNodeData()
end
function Universe:OnViewChangedRealtime(x,y)
	local data = {x = x, y = y}
	Facade:SendNotification(NotiConst.Command_PUniverseCameraUpdate, data)
	self:ChangeLod()
	self:GenerateVoronoi()
	self.UIItemPool:OnViewChanged(self.Lod)
end

--加载周围的点数据
function Universe:LoadNodeArea()
	local cameraX = self.camctrl.main_cam_transf.localPosition.x
	local cameraY = self.camctrl.main_cam_transf.localPosition.z
	local d = -1
	local centerNodeId = nil
	for i = 1, #self.lstViewBlocks do
		local block = self:GetBlock(self.lstViewBlocks[i], false)
		if block ~= nil then
			for k = 1, #block do
				if block[k].__cname == 'Galaxy' then
					local dx = cameraX-block[k].cfg.pos[1]
					local dy = cameraY-block[k].cfg.pos[2]
					local td = dx*dx+dy*dy
					if d<0 or td<d then
						d = td
						centerNodeId = block[k].cfg.id
					end
				end
			end
		end
	end
	if centerNodeId ~= nil then
		local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
		local areaNodes = universeProxy:ReadLuaNodeDataById(centerNodeId)
    	local cameraData = universeProxy:BuildCameraData(areaNodes,self.lstGalaxy)
		for k,v in pairs(cameraData) do 
			self:AddGalaxy(v);
		end
	end
end

--相机视域变化 拉高/低了
function Universe:OnViewAreaChanged(fZoomPercent)
	self.viewR = mathfloor(mathmax(1,self.maxViewR*fZoomPercent));
end 

--点击事件回调
function Universe:OnMouseClick(x, z)
	local galaxy_hited = nil;
	for i=1, #self.lstViewBlocks do 
		local galaxys = self:GetBlock(self.lstViewBlocks[i], false);
		if galaxys ~= nil then 
			for k=1, #galaxys do
				if galaxys[k]:IsPosIn(x, z) then 
					galaxy_hited = galaxys[k];
					break;
				end
			end
		end
		if galaxy_hited ~= nil then 
			break;
		end
	end
	if galaxy_hited ~= nil then 
		Facade:SendNotification(NotiConst.Command_PUniverseChooseGalxay, galaxy_hited.ID)
	end
end

--动态对象位置变化回调
function Universe:OnDynamicObjPosChanged(obj)
	if obj == nil then 
		return;
	end
	local pos = obj:GetPostion();
	local idx = self:BlockIndexByPos(pos.x, pos.z);
	local obj_idx = obj:GetBlockIdx();
	if idx == obj_idx then
		return;
	end
	obj:SetBlockIdx(idx);--设置新的block
	local preblocks = self:GetDynamicBlock(obj_idx);
	local bPreInView = self:IsBlockInView(obj_idx);
	if preblocks ~= nil then
		for i=1, #preblocks do
			if preblocks[i] == obj then
				table.remove(preblocks, i);
				break;
			end
		end
	end
	local newblocks = self:GetDynamicBlock(idx);
	local bNewInView = self:IsBlockInView(idx);
	if newblocks ~= nil then
		table.insert(newblocks, obj);
	end
	--视野切换
	if bNewInView ~= bPreInView then
		obj:SetViewStatus(bNewInView);
	end
end

function Universe:UpdateRewardTime()
	local rewardTimeLeft = self.userDataProxy:GetRewardTimeLeft()
	local timeData = rewardTimeLeft.timeLeft - (GetServerTimeStamp() - rewardTimeLeft.curTime)
	self.userDataProxy:SetRewardTimeLeft(timeData)
end

return Universe;