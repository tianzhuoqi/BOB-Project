--[[
相机操作类,可以通过左键按住拖动,滚轮(设备上双指)缩放
--]]
local CameraCtrl = class("CameraCtrl");

local UnityInput = UnityEngine.Input;
local UnityScreen = UnityEngine.Screen;
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition;
local UnitySetRot = GameObjectUtil.SetRotation;
local UnitySetPos = GameObjectUtil.SetPosition;
local UnityScrPickCastFloor = GameObjectUtil.ScreenPickCastFloor;
local UnityCamForwardCastFloor = GameObjectUtil.CamForwardCastFloor;
local Vector3 = Vector3;
local UnityApplication = UnityEngine.Application;
local mathabs = math.abs;
local tempVector2 = Vector2.New(0, 0)
local UpdateBeat = UpdateBeat

function CameraCtrl:ctor()
	self.bPress = false;
	self.bZoom = false;
	self.bFirstInitTm = 0.1
	UpdateBeat:Add(self.Update, self);
	self.enable = true

	local objMainCam = UnityEngine.Camera.main.gameObject;
	self.main_cam = objMainCam;
	self.main_cam_transf = objMainCam.transform;

	local backgroundMask = self.main_cam_transf:Find('backgroundMask')
	if backgroundMask ~= nil then
		self.backgroundMask = backgroundMask:GetComponent('Renderer').sharedMaterial
		self.backgroundMaskObj = backgroundMask.gameObject
		self.backgroundMaskObjLocalPos = backgroundMask.localPosition
	end

	local backgroundStar = self.main_cam_transf:Find('backgroundStar')
	if backgroundStar ~= nil then
		self.backgroundStar = backgroundStar:GetComponent('Renderer').sharedMaterial
		self.backgroundStarObj = backgroundStar.gameObject
		self.backgroundStarObjLocalPos = backgroundStar.localPosition
	end

	local backgroundStar_02 = self.main_cam_transf:Find('backgroundStar_02')
	if backgroundStar_02 ~= nil then
		self.backgroundStar_02 = backgroundStar_02:GetComponent('Renderer').sharedMaterial
		self.backgroundStarObj_02 = backgroundStar_02.gameObject
		self.backgroundStarObj_02LocalPos = backgroundStar_02.localPosition
	end

	local SC_nebulae = self.main_cam_transf:Find('SC_nebulae')
	if SC_nebulae ~= nil then
		self.SC_nebulaes = SC_nebulae:GetComponent('Renderer').sharedMaterials
		self.SC_nebulaeObj = SC_nebulae.gameObject
		self.SC_nebulaeLocalPos = SC_nebulae.localPosition
	end
	
	self.bEditorModel = UnityApplication.isEditor;--unity3d编辑器模式
	self.lstEndDragCallbacks = {};--拖曳结束回调
	self.lstEndZoomCallbacks = {};--zoom结束回调
	self.lstClickCallbacks = {};--click回调
	self.lstDragingCallbacks = {}--拖动实时回调
	self.ZoomRang = {31,179};--zoom区间
	self.DragRect = {-100,-100,500,500};--拖曳区间left,top,right,bottom
	self.lstTouch = {};
	for i=1, 4 do 
		self.lstTouch[i]={};
	end
	--在zoom的时候,指定当两手指缩放一个对角线,为一个zoom的最大距离
	self.ZoomMaxOnce = 120;--操作最大距离时相机zoom的距离
	self.ZoomDevMaxDis = UnityScreen.width--math.sqrt(UnityScreen.width*UnityScreen.width + UnityScreen.height*UnityScreen.height);--对角线,操作最大距离
	--UnitySetPos(self.main_cam, 0, self.ZoomRang[1], 0);
	self.universePackage = LoadPackage("Universe")
end

function CameraCtrl:SetZoom(zoomRangePercent)
	local zoomY = self.ZoomRang[1] + (self.ZoomRang[2]-self.ZoomRang[1])*(1-zoomRangePercent)
	self:SetCameraPos(self.main_cam, self.main_cam_transf.position.x, zoomY, self.main_cam_transf.position.z)
	self:Apply()
end

function CameraCtrl:SetCameraPos(obj, x, y, z)
	UnitySetPos(obj, x, y, z);

	if self.backgroundMask ~= nil then
		tempVector2.x = x / 5000
		tempVector2.y = z / 5000
		self.backgroundMask:SetTextureOffset('_MainTex', -tempVector2)
		UnitySetLocalPos(self.backgroundMaskObj, self.backgroundMaskObjLocalPos.x, self.backgroundMaskObjLocalPos.y, self.backgroundMaskObjLocalPos.z + (y - 80) / 4 );
	end
	
	if self.backgroundStar ~= nil then
		tempVector2.x = x / 4000
		tempVector2.y = z / 4000
		self.backgroundStar:SetTextureOffset('_MainTex', -tempVector2)
		UnitySetLocalPos(self.backgroundStarObj, self.backgroundStarObjLocalPos.x, self.backgroundStarObjLocalPos.y, self.backgroundStarObjLocalPos.z + (y - 80) / 2);
	end

	if self.backgroundStar_02 ~= nil then
		tempVector2.x = x / 6000
		tempVector2.y = z / 6000
		self.backgroundStar_02:SetTextureOffset('_MainTex', -tempVector2)
		UnitySetLocalPos(self.backgroundStarObj_02, self.backgroundStarObj_02LocalPos.x, self.backgroundStarObj_02LocalPos.y, self.backgroundStarObj_02LocalPos.z + (y - 80) / 3);
	end

	if self.SC_nebulaeObj ~= nil then
		local sharedMaterialIndex = (math.floor( x * 0.2 / 900 ) + math.floor( z * 0.2 / 1100 ) * math.ceil((self.universePackage.WorldWidth * self.universePackage.ClusterSize) / 900)) % 7
		for i = 0, 6 do
			local tempColor = self.SC_nebulaes[i]:GetColor('_TintColor')
			if i ~= sharedMaterialIndex then
				tempColor.a = 0;
				self.SC_nebulaes[i]:SetColor('_TintColor',tempColor)
			else
				tempColor.a = 128;
				self.SC_nebulaes[i]:SetColor('_TintColor',tempColor)
			end
		end

		local tempX = (math.floor(x * 0.2) % 900 - 450)
		local tempy = (math.floor(z * 0.2) % 1100 - 550)
		UnitySetLocalPos(self.SC_nebulaeObj, self.SC_nebulaeLocalPos.x - tempX, self.SC_nebulaeLocalPos.y - tempy, self.SC_nebulaeLocalPos.z + (y - 80) / 2);
	end
end

function CameraCtrl:SetDragRect(l, t, r, b)
	self.DragRect[1]=l;
	self.DragRect[2]=t;
	self.DragRect[3]=r;
	self.DragRect[4]=b;
end

function CameraCtrl:SetZoomRang(min, max)
	self.ZoomRang[1]= math.max(1, min);
	self.ZoomRang[2]= math.max(max, self.ZoomRang[1]);
end

function CameraCtrl:Release()
	UpdateBeat:Remove(self.Update, self);
end

function CameraCtrl:AddCallback(func, target, callbk_type)
	if type(func) ~= "function" then 
		return;
	end
	local t = {func,target};
	if callbk_type == 1 then 
		table.insert(self.lstEndDragCallbacks, t);
	elseif callbk_type == 2 then
		table.insert(self.lstEndZoomCallbacks, t);
	elseif callbk_type == 3 then 
		table.insert(self.lstClickCallbacks, t);
	elseif callbk_type == 4 then 
		table.insert(self.lstDragingCallbacks, t)
	end
end

function CameraCtrl:InvokeCallback(lstCallback, arg1, arg2)
	if lstCallback == nil then 
		return;
	end
	for i=1, #lstCallback do 
		lstCallback[i][1](lstCallback[i][2], arg1, arg2);
	end
end


function CameraCtrl:Update(dt)
	if self.bFirstInitTm > 0 then 
		self.bFirstInitTm = self.bFirstInitTm - 0.05
		if self.bFirstInitTm <= 0 then 
			self:LateInit()
		end
	end

	if UnityInput ~= nil then
		if  self:GetInputTouchCount()>=2 then --zoom
			self.bPress = false;--取消drag
			if self.bZoom == true then 
				self:Zooming();
			else
				self:BeginZoom();
				if self.bEditorModel then
					self:Zooming();
				end
			end
		else 
			if self.bZoom then 
				self:EndZoom();
			end
			if UnityInput.GetMouseButtonDown(0) then 
				self:BeginDrag();
			elseif UnityInput.GetMouseButtonUp(0) then 
				self:EndDrag();
			end
			if self.bPress == true and UnityInput.GetMouseButton(0) then 
				if math.abs(self.lastMusPt.x - UnityInput.mousePosition.x) >= 1 or 
					math.abs(self.lastMusPt.y - UnityInput.mousePosition.y) >= 1 then 
					self:Draging();
					self.lastMusPt = UnityInput.mousePosition;
				end
			end
		end
		
	end
end


--拖曳相关---------------------
function CameraCtrl:BeginDrag()
	if UICamera.isOverUI then
		if not self.ignoreUI then
			return
		end
	end
	if self.bPress == true then 
		return;
	end
	self.bPress = true;

	if not self.enable then
		do
			return
		end
	end

	local ptMouse = UnityInput.mousePosition;
	local ptHit = UnityScrPickCastFloor(ptMouse.x, ptMouse.y);--self:RayCastPt(ray0);
	local ptLook = UnityCamForwardCastFloor();--self:RayCastPt(ray1);
	self.ptOrgnCam = self.main_cam_transf.position;
	self.ptDetaCamWithMous = ptHit - ptLook;
	self.lastMusPt = UnityInput.mousePosition;
	self.orgMusPt = UnityInput.mousePosition;
end

function CameraCtrl:Draging()
	if not self.enable then
		do
			return
		end
	end
	local ptMouse = UnityInput.mousePosition;
	local ptHit = UnityScrPickCastFloor(ptMouse.x, ptMouse.y);--self:RayCastPt(ray0);
	local ptLook = UnityCamForwardCastFloor();
	local ptNewLook = ptHit - self.ptDetaCamWithMous;
	local ptLookDt = ptNewLook-ptLook;
	local ptNew = self.ptOrgnCam - ptLookDt;
	self:SetCameraPos(self.main_cam, math.clamp(ptNew.x,self.DragRect[1],self.DragRect[3]), ptNew.y, math.clamp(ptNew.z,self.DragRect[2],self.DragRect[4]));
	
	local ptScreCenter = UnityScrPickCastFloor(UnityScreen.width*0.5, UnityScreen.height*0.5);
	ptScreCenter.x = math.floor(ptScreCenter.x+0.5)
	ptScreCenter.z = math.floor(ptScreCenter.z+0.5)
	self:InvokeCallback(self.lstDragingCallbacks, ptScreCenter.x, ptScreCenter.z);
end

function CameraCtrl:InitCameraPos(x, y)
	self:SetCameraPos(self.main_cam, math.clamp(self.main_cam_transf.position.x + x,self.DragRect[1],self.DragRect[3]), self.main_cam_transf.position.y, math.clamp(self.main_cam_transf.position.z + y,self.DragRect[2],self.DragRect[4]));
end

function CameraCtrl:EndDrag()
	if not self.bPress then
		return
	end
	self.bPress = false;

	if not self.enable then
		do
			return
		end
	end
	--判断点击
	if mathabs(self.orgMusPt.x - UnityInput.mousePosition.x) < 5 and 
	   mathabs(self.orgMusPt.x - UnityInput.mousePosition.x) < 5 then 
		local ptHit = UnityScrPickCastFloor(UnityInput.mousePosition.x, UnityInput.mousePosition.y);
		self:InvokeCallback(self.lstClickCallbacks, ptHit.x, ptHit.z);
	else
		local ptScreCenter = UnityScrPickCastFloor(UnityScreen.width*0.5, UnityScreen.height*0.5);
		self:InvokeCallback(self.lstEndDragCallbacks, ptScreCenter.x, ptScreCenter.z); 
	end
	self.ignoreUI = false
end
--end 拖曳-----------------

--Zoom 相关 ---------------
function CameraCtrl:GetInputTouchCount()
	if self.bEditorModel then 
		local fMousWheelV = UnityInput.GetAxis("Mouse ScrollWheel");
		if  not Mathf.Approximately(fMousWheelV, 0) then 
			local scw = UnityScreen.width
			local sch = UnityScreen.height
			local dtper = 0.1
			if fMousWheelV < 0 then
				--模拟touch,起始touch点 
				self.lstTouch[1][1] = 0;
				self.lstTouch[1][2] = 0;
				self.lstTouch[2][1] = scw;
				self.lstTouch[2][2] = sch;
				--松开点
				self.lstTouch[3][1] = self.lstTouch[1][1]+scw*dtper
				self.lstTouch[3][2] = self.lstTouch[1][2]+sch*dtper
				self.lstTouch[4][1] = self.lstTouch[2][1]-scw*dtper
				self.lstTouch[4][2] = self.lstTouch[2][2]-sch*dtper
			else 
				--松开点
				self.lstTouch[3][1] = 0;
				self.lstTouch[3][2] = 0;
				self.lstTouch[4][1] = scw;
				self.lstTouch[4][2] = sch;
				--模拟touch,起始touch点 
				self.lstTouch[1][1] = self.lstTouch[3][1]+scw*dtper
				self.lstTouch[1][2] = self.lstTouch[3][2]+sch*dtper
				self.lstTouch[2][1] = self.lstTouch[4][1]-scw*dtper
				self.lstTouch[2][2] = self.lstTouch[4][2]-sch*dtper
				
			end
			return 2;
		end
	else 
		return UnityInput.touchCount;
	end
	return 0;
end
function CameraCtrl:BeginZoom()
	if UICamera.isOverUI then
		return
	end
	if self.bZoom == true then 
		return;
	end
	
	self.bZoom = true;
	--记录起始两个touch点
	if not self.bEditorModel then
		local ptTouch1 = UnityInput.GetTouch(0).position;
		local ptTouch2 = UnityInput.GetTouch(1).position;
		self.lstTouch[1][1] = ptTouch1.x;
		self.lstTouch[1][2] = ptTouch1.y;
		self.lstTouch[2][1] = ptTouch2.x;
		self.lstTouch[2][2] = ptTouch2.y;
	end
	local dx1 = self.lstTouch[2][1]-self.lstTouch[1][1];
	local dy1 = self.lstTouch[2][2]-self.lstTouch[1][2];
	self.dis0 = math.sqrt(dx1*dx1+dy1*dy1);--起始两个touch点之间的距离
	self.ptCamLookAt = UnityCamForwardCastFloor();
	self.ptOrgnCam = self.main_cam_transf.position;
end


function CameraCtrl:Zooming()
	if self.bZoom ~= true then 
		return;
	end
	if not self.bEditorModel then
		--记录当前点
		local ptTouch1 = UnityInput.GetTouch(0).position;
		local ptTouch2 = UnityInput.GetTouch(1).position;
		self.lstTouch[3][1] = ptTouch1.x;
		self.lstTouch[3][2] = ptTouch1.y;
		self.lstTouch[4][1] = ptTouch2.x;
		self.lstTouch[4][2] = ptTouch2.y;
	end
	if #self.lstTouch < 4 then 
		return;
	end
	local dx2 = self.lstTouch[4][1]-self.lstTouch[3][1];
	local dy2 = self.lstTouch[4][2]-self.lstTouch[3][2];
	local dis1 = math.sqrt(dx2*dx2+dy2*dy2);--当前两点间距离
	if Mathf.Approximately(dis1, self.dis0) then 
		return;
	end
	local sdt = math.abs(dis1-self.dis0);
	local zooms = (sdt/self.ZoomDevMaxDis)*self.ZoomMaxOnce;
	local cam_transf = self.main_cam_transf;
	local ptNew;
	if dis1 > self.dis0 then --far away
		ptNew = self.ptOrgnCam + cam_transf.forward*zooms;
	else 
		ptNew = self.ptOrgnCam - cam_transf.forward*zooms;
	end
	--判断zoom边界
	local fNowMagnitude = (ptNew - self.ptCamLookAt):SqrMagnitude();
	if ptNew.y < 0 or fNowMagnitude < self.ZoomRang[1]*self.ZoomRang[1] then
		ptNew = self.ptCamLookAt - cam_transf.forward*self.ZoomRang[1];
	elseif fNowMagnitude > self.ZoomRang[2]*self.ZoomRang[2] then
		ptNew = self.ptCamLookAt - cam_transf.forward*self.ZoomRang[2];
	end
	self:SetCameraPos(self.main_cam, ptNew.x, ptNew.y, ptNew.z);

	local ptScreCenter = UnityScrPickCastFloor(UnityScreen.width*0.5, UnityScreen.height*0.5);
	self:InvokeCallback(self.lstDragingCallbacks, ptScreCenter.x, ptScreCenter.z);
end

function CameraCtrl:EndZoom()
	if self.bZoom ~= true then 
		return;
	end
	self.bZoom = false;
	self:Apply();
end
--end Zoom ---------------

function CameraCtrl:Apply()
	if self.ptCamLookAt == nil then
		return;
	end
	local v = self.main_cam_transf.position-self.ptCamLookAt;
	local fDisFromViewPt = v.x*v.x+v.y*v.y+v.z*v.z;
	local fDisPercent = fDisFromViewPt/(self.ZoomRang[2]*self.ZoomRang[2]);
	self:InvokeCallback(self.lstEndZoomCallbacks, fDisPercent);
	self:InvokeCallback(self.lstEndDragCallbacks, self.ptCamLookAt.x, self.ptCamLookAt.z);
end

function CameraCtrl:DirectSetCamPos(x,z)
	if self.main_cam == nil then
		return
	end
	self:SetCameraPos(self.main_cam, x, self.main_cam_transf.position.y, z);
end

function CameraCtrl:LateInit()
	self.ptCamLookAt = UnityScrPickCastFloor(UnityScreen.width*0.5, UnityScreen.height*0.5);
	--判断zoom边界
	local cam_transf = self.main_cam_transf
	local ptNew = cam_transf.position
	local fNowMagnitude = (ptNew - self.ptCamLookAt):SqrMagnitude();
	if ptNew.y < 0 or fNowMagnitude < self.ZoomRang[1]*self.ZoomRang[1] then
		ptNew = self.ptCamLookAt - cam_transf.forward*self.ZoomRang[1];
	elseif fNowMagnitude > self.ZoomRang[2]*self.ZoomRang[2] then
		ptNew = self.ptCamLookAt - cam_transf.forward*self.ZoomRang[2];
	end
	self:SetCameraPos(self.main_cam, ptNew.x, ptNew.y, ptNew.z);
	self:Apply();
end

return CameraCtrl;