local BigMapMediator = require("Game/Module/SUniverse/BigMapMediator")
local BigMapPanel = register("BigMapPanel", PanelBase)
local BigMapPanelBinder = require("UIDef/BigMapPanelBinder")
local UnityInput = UnityEngine.Input
local UnityScreen = UnityEngine.Screen

function BigMapPanel:Awake(gameObject)
    self.gameObject = gameObject
    self.uiBinder = BigMapPanelBinder.New(self.gameObject)
    self.mapPanel = self:FindGameObject("UI_Pos/Anchor_Center/Panel")
    self.mapPanelPos = self.mapPanel.transform.localPosition
    self.mapPanelAll = self:FindGameObject("UI_Pos/Anchor_Center/PanelAll")
    self.bigMap = self:FindGameObject("UI_Pos/Anchor_Center/Panel/MapContainer")
    self.bigMapAll = self:FindGameObject("UI_Pos/Anchor_Center/PanelAll/MapContainer")
    self.bigMapTexture = self:FindComponent("UI_Pos/Anchor_Center/Panel/MapContainer/BigMap","UITexture")
    self.bigMapTextureAll = self:FindComponent("UI_Pos/Anchor_Center/PanelAll/MapContainer/BigMap","UITexture")
    self.homeLocation = self:FindGameObject("UI_Pos/Anchor_Center/Panel/MapContainer/BigMap/HomeLocation")
    self.currentLocation = self:FindGameObject("UI_Pos/Anchor_Center/Panel/MapContainer/Current")
    self.selector = self:FindGameObject("UI_Pos/Anchor_Center/Panel/MapContainer/Selector")
    self.homeLocationA = self:FindGameObject("UI_Pos/Anchor_Center/PanelAll/MapContainer/HomeLocation")
    self.selectorA = self:FindGameObject("UI_Pos/Anchor_Center/PanelAll/MapContainer/Selector")
    
    self.positionX = self:FindComponent("UI_Pos/Anchor_Center/Bottom_Anchor/LabelX","UIInput")
    self.positionY = self:FindComponent("UI_Pos/Anchor_Center/Bottom_Anchor/LabelY","UIInput")
    self.uiTableView = self.uiBinder.m_SubPanel:GetComponent("NTableView")
    local NLuaEventRegister = NLuaEventRegister.Get(self.positionX.gameObject)
    NLuaEventRegister:RegisterEvent(self.positionX.onChange, self, self.OnPosChanged)
    NLuaEventRegister = NLuaEventRegister.Get(self.positionY.gameObject)
    NLuaEventRegister:RegisterEvent(self.positionY.onChange, self, self.OnPosChanged)

    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.globalProxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)

    self.ignoreChanged = false
    self.gotoButton = self:FindGameObject("UI_Pos/Anchor_Center/Bottom_Anchor/m_ButtonGo")
    self.closeButton = self.uiBinder.m_ButtonClose.gameObject

    

    self.lastTouchPsotion = nil
    self.isPress = false
    self.longPress = false
    self.firstTouchD = 0
    self.firstTouchPosition = {0,0}
    self.twoTouchPress = false
    self.lastPressTime = os.time()
    self.moveStep = 0.5
    self.scaleStep = 0.1

    self.mapScale = 1
    self.oldMapScale = 1
    
    self.curX = 0
    self.curY = 0
    self.selectorPosition = {0,0}
    self.bigMapSize = {self.bigMapTexture.width,self.bigMapTexture.height}
    
    self.areaPos = {0,0}

	self.mediator = BigMapMediator.New("BigMapMediator")
    self.mediator:SetViewComponent(self)
    local uiRoot = UnityEngine.GameObject.Find("UI Root")
    self.uiRootPosition = uiRoot.transform.position
    local uiRootS = uiRoot:GetComponent("UIRoot")
    local uiRootPanel = uiRoot:GetComponent("UIPanel")
    self.cameraScale = uiRoot.transform.localScale.x
    local activeHeight = uiRootS.activeHeight * UICamera.currentCamera.orthographicSize
    local activeWidth = UnityScreen.width * activeHeight / UnityScreen.height
    self.windowSize = {500 + 1,500 + 1}
    
    Facade:RegisterMediator(self.mediator)
    
    NLuaClickEvent.Get(self.gotoButton):AddClick(self, self.ButtonGoClick)
    NLuaClickEvent.Get(self.closeButton):AddClick(self, self.ButtonCloseClick)
    NLuaClickEvent.Get(self.uiBinder.m_ButtonToBigMap.gameObject):AddClick(self, self.ButtonGotoBigMap)
    NLuaClickEvent.Get(self.uiBinder.m_ButtonSmall.gameObject):AddClick(self, self.ModeMin)
    NLuaClickEvent.Get(self.uiBinder.m_ButtonBig.gameObject):AddClick(self, self.ModeMax)
    self:BindGridClick()


end

function BigMapPanel:ButtonGoClick()
    local wX = tonumber(self.positionX.value)
    local wY = tonumber(self.positionY.value)
    if wX and wY then
        if wX < 0 or wX > self.realSize[1] or wY < 0 or wY > self.realSize[2] then
            OpenMessageBox(NotiConst.MessageBoxType.Tip,"超出区域范围")
        else
            self.mediator.targetPosition = {wX,wY}
            self.mediator:Goto()
            Facade:BackPanel()
            if self.globalProxy:GetCurrentScene() == "SPlanetarySystem" then
                self.globalProxy:SetSceneData("SPlanetarySystem",{{x=wX,y=wY}})
                ManagerScene:OpenSceneUseLoadingScene("SUniverse")
            end
        end
    end
    
end

function BigMapPanel:ButtonCloseClick()
    Facade:BackPanel()
end



function BigMapPanel:OpenPanel()
    BigMapPanel.super.OpenPanel(self)
    self:DoBlur()
    local filter = {0,0,self.realSize[1],self.realSize[2]}
    Facade:SendNotification(NotiConst.Notify_MapMarkListFilter,filter)
    self.mode = 1
    self:InitPosition(self.mediator:GetCurrentPosition(),self.mediator:GetHomePosition())
    UpdateBeat:Add(self.Update,self)
    self.mediator:UpdateMarkList()
    self.mediator:RequestMarkList()
    --todobycn
    self:ChangeRegionName("宇宙")
    self.closeButton:SetActive(true)
    self.uiBinder.m_ButtonToBigMap.gameObject:SetActive(false)
end


function BigMapPanel:OnPosChanged()
    if self.positionX.value == "" then
        self.positionX.value = "0"
    end
    if self.positionY.value == "" then
        self.positionY.value = "0"
    end
    local wX = tonumber(self.positionX.value)
    local wY = tonumber(self.positionY.value)
    if wX and wY and not self.ignoreChanged then
        if wX < 0 or wX > self.realSize[1] or wY < 0 or wY > self.realSize[2] then
            self.positionX.value = tostring(self.mediator.targetPosition[1])
            self.positionY.value = tostring(self.mediator.targetPosition[2])
            OpenMessageBox(NotiConst.MessageBoxType.Comfirm,"超出区域范围")
        else
            self.mediator.targetPosition = {wX,wY}
        end
    end
end


function BigMapPanel:ClosePanel()
    UpdateBeat:Remove(self.Update,self)
end

function BigMapPanel:ReopenPanel()
    UpdateBeat:Add(self.Update,self)
end

function BigMapPanel:DestroyPanel()
    UpdateBeat:Remove(self.Update,self)
end

function BigMapPanel:ModeMin()
    self.mapScale = self.scaleSize[1]
end

function  BigMapPanel:ModeMax()
    self.mapScale = self.scaleSize[2]
end

function BigMapPanel:InitPosition(pos,homePos)
    local bigMapSize = self.bigMapSize
    local windowSize = self.windowSize
    local bigMap = self.bigMap
    local homeLocation = self.homeLocation
    local selector = self.selector
    local areaMapSize = bigMapSize
    if self.mode == 1 then
        self.scaleSize = {self.windowSize[2]/bigMapSize[2],1}
        self.mapScale = self.scaleSize[1]
        bigMap = self.bigMapAll
        homeLocation = self.homeLocationA
        selector = self.selectorA
        self.mapPanel:SetActive(false)
        self.mapPanelAll:SetActive(true)
        self.areaPos = {0,0}
    else
        bigMapSize = {self.bigMapSize[1]/5,self.bigMapSize[2]/5}
        self.scaleSize = {self.windowSize[2]/bigMapSize[2],self.windowSize[2]/bigMapSize[2]*2}
        self.mapScale = self.scaleSize[1]
        windowSize = self.windowSize
        self.mapPanel:SetActive(true)
        self.mapPanelAll:SetActive(false)
    end
    

    local right = self.bigMapSize[1]/2*self.mapScale-windowSize[1]/2
    local top = self.bigMapSize[2]/2*self.mapScale-windowSize[2]/2
    self.mediator.targetPosition = {pos.x,pos.y}
    local px = -(pos.x/self.realSize[1]*self.bigMapSize[1] - self.bigMapSize[1]/2)
    local py = -(pos.y/self.realSize[2]*self.bigMapSize[2] - self.bigMapSize[2]/2)
    local hx = (homePos.x/self.realSize[1]*self.bigMapSize[1] - self.bigMapSize[1]/2)
    local hy = (homePos.y/self.realSize[2]*self.bigMapSize[2] - self.bigMapSize[2]/2)
    local cx = (pos.x/self.realSize[1]*self.bigMapSize[1] - self.bigMapSize[1]/2)
    local cy = (pos.y/self.realSize[2]*self.bigMapSize[2] - self.bigMapSize[2]/2)
    NGameObjectUtil.SetLocalPosition(homeLocation,hx,hy,0)
    NGameObjectUtil.SetScale(homeLocation,1/self.mapScale,1/self.mapScale,1/self.mapScale)
    NGameObjectUtil.SetScale(self.selector,1/self.mapScale,1/self.mapScale,1/self.mapScale)
    NGameObjectUtil.SetScale(self.selectorA,1/self.mapScale,1/self.mapScale,1/self.mapScale)
    local tx = -px+self.areaPos[1]
    local ty = -py+self.areaPos[2]
    --[[if px<-right then
        tx = -px+(-right)
        px = px - tx
    end
    if px>right then
        tx = -px+(right)
        px = px - tx
    end
    if py<-top then
        ty = -py+(-top)
        py = py - ty
    end
    if py>top then
        ty = -py+(top)
        py = py - ty
    end]]
    self.selectorPosition = {tx,ty}
    NGameObjectUtil.SetLocalPosition(selector,tx,ty,0)
    local right = self.bigMapSize[1]/2*self.mapScale-self.windowSize[1]/2
    local top = self.bigMapSize[2]/2*self.mapScale-self.windowSize[2]/2
    px = px*self.mapScale
    py = py*self.mapScale
    if px < -right then
        px = -right
    end
    if py < -top then
        py = -top
    end
    if px > right then
        px = right
    end
    if py > top then
        py = top
    end
    NGameObjectUtil.SetLocalPosition(bigMap,px,py,0)
    NGameObjectUtil.SetScale(bigMap,self.mapScale,self.mapScale,self.mapScale)
    self:UpdatePosInfo()
end


function BigMapPanel:BindGridClick()
    for x = 0,4 do
        for y = 0,4 do
            local btn = self:FindGameObject("UI_Pos/Anchor_Center/PanelAll/gridButton/btn"..x..y)
            local btnCall = {
                pSelf = self,
                x = x,
                y = y,
                OnClick = function(self)
                    self.pSelf:OnGridClick(self.x,self.y)
                end,
            }
            NLuaClickEvent.Get(btn):AddClick(btnCall, btnCall.OnClick)
        end
    end
end

function BigMapPanel:ChangeRegionName(name)
    self.uiBinder.m_Label_TitleKey.text = name
end


function BigMapPanel:OnGridClick(x,y)
    local id = y*5+x+1
    local regionData = self.universeProxy:GetRegionDataById(id)
    --todobycn
    self:ChangeRegionName(GetLanguageText("BuildingCommon",regionData.cn))

    local mapSize = {self.bigMapSize[1]/5,self.bigMapSize[2]/5}
    local k = mapSize[2]/500
    local px = self.bigMapTexture.width/2 - x*mapSize[1] - 250*k
    local py = self.bigMapTexture.height/2 - y*mapSize[2] - 250*k
    
    self.areaPos={px,py}
    NGameObjectUtil.SetLocalPosition(self.bigMapTexture.gameObject,px,py,0)
    self.mode = 2
    local realPos = self.mediator.targetPosition
    self:InitPosition({x=realPos[1],y=realPos[2]},self.mediator:GetHomePosition())
    local k1 = self.realSize[1]/self.bigMapSize[1]
    local k2 = self.realSize[2]/self.bigMapSize[2]
    local filter = {x*mapSize[1]*k1,y*mapSize[2]*k2,(x+1)*mapSize[1]*k1,(y+1)*mapSize[2]*k2}
    Facade:SendNotification(NotiConst.Notify_MapMarkListFilter,filter)
    self.closeButton:SetActive(false)
    self.uiBinder.m_ButtonToBigMap.gameObject:SetActive(true)
    
end

function BigMapPanel:SelectPoint(position)
    if UICamera.hoveredObject and (UICamera.hoveredObject.name == "Panel" or string.sub(UICamera.hoveredObject.name,1,3)=="btn") then
        local x = (position[1]-self.curX)/self.mapScale
        local y = (position[2]-self.curY)/self.mapScale
        local hx = self.bigMapSize[1]/2
        local hy = self.bigMapSize[2]/2
        if self.mode == 2 then
            hx = hx/5
            hy = hy/5
        end
        if x < -hx then
            x = -hx
        end
        if y < -hy then
            y = -hy
        end
        if x > hx then
            x = hx - 1
        end
        if y > hy then
            y = hy - 1
        end
        
        self.selectorPosition = {x,y}
        if self.mode == 1 then
            NGameObjectUtil.SetLocalPosition(self.selectorA,x,y,0)
        else
            NGameObjectUtil.SetLocalPosition(self.selector,x,y,0)
        end
        self:UpdatePosInfo()
    end
end

function BigMapPanel:Update()
    local bigMapSize = self.bigMapSize
    if self.mode ~= 1 then
        bigMapSize = {self.bigMapSize[1]/5,self.bigMapSize[2]/5}
    end
    if UnityInput ~= nil then
        if UnityInput.touchCount > 1 then --缩放
            if self.mode == 1 then
                self.isPress = false
                return
            end
            local t1 = UnityInput.GetTouch(0).position;
            local t2 = UnityInput.GetTouch(1).position;
            local p1 = {t1.x,t1.y}
            local p2 = {t2.x,t2.y}
            local dx = p1[1]-p2[1]
            local dy = p1[2]-p2[2]
            local d = math.sqrt(dx*dx+dy*dy)
            if self.twoTouchPress then
                local scaleK = d / self.firstTouchD
                self.mapScale = self.oldMapScale * scaleK
            else
                self.firstTouchD = d
                self.twoTouchPress = true
            end
            self.isPress = false
        else
            if UnityInput.GetMouseButtonDown(0) then
                self.isPress = true
                self.lastPressTime = 0
                local p = self:GetNGUIPosition(UnityInput.mousePosition)
                self.lastTouchPsotion = {p.x,p.y}
                self.firstTouchPosition = {p.x,p.y}
            end
            if UnityInput.GetMouseButtonUp(0) then
                self.isPress = false
                local p = self:GetNGUIPosition(UnityInput.mousePosition)
                local dx = p.x - self.firstTouchPosition[1]
                local dy = p.y - self.firstTouchPosition[2]
                local d = math.sqrt(dx*dx+dy*dy)
                if d < 10 then
                    self:SelectPoint(self.firstTouchPosition)
                end
            end
            self.twoTouchPress = false
            self.oldMapScale = self.mapScale
		end
        if self.isPress then
            if UICamera.hoveredObject and (UICamera.hoveredObject.name ~= "Panel" and string.sub(UICamera.hoveredObject.name,1,3)~="btn") then
                self.isPress = false
                return
            end
            if not self.longPress then
                local p = self:GetNGUIPosition(UnityInput.mousePosition)
                local dx = p.x - self.lastTouchPsotion[1]
                local dy = p.y - self.lastTouchPsotion[2]
                self.curX = self.curX + self.moveStep*dx
                self.curY = self.curY + self.moveStep*dy
                self.lastTouchPsotion = {p.x,p.y}
                if self.mode == 2 and self.mapScale == self.scaleSize[1] then
                    self:SelectPoint({p.x,p.y})
                end
            else
                local p = self:GetNGUIPosition(UnityInput.mousePosition)
                if self.mode == 1 then
                    self:SelectPoint({p.x,p.y})
                end
                if self.mode == 2 and self.mapScale == self.scaleSize[1] then
                    self:SelectPoint({p.x,p.y})
                end
            end
            
        end
    end
    
    if self.isPress then
        if self.lastPressTime == 0 then
            self.lastPressTime = os.time()
        elseif self.mapScale == self.scaleSize[1] then--在最小下支持长按拖动
            local dt = os.time() - self.lastPressTime
            if dt > 0.2 then
                --local p = self:GetNGUIPosition(UnityInput.mousePosition)
                --local dx = p.x - self.firstTouchPosition[1]
                --local dy = p.y - self.firstTouchPosition[2]
                --local d = math.sqrt(dx*dx+dy*dy)
                --if d < 10 then
                    self.longPress = true
                --end
                
            end
        end
    else
        self.longPress = false
    end

    if self.mode==2 and UICamera.hoveredObject and (UICamera.hoveredObject.name == "Panel" or string.sub(UICamera.hoveredObject.name,1,3)=="btn") then
        self.mapScale = self.mapScale + UnityInput.mouseScrollDelta.y*self.scaleStep
        
    end
    if self.mapScale < self.scaleSize[1] then
        self.mapScale = self.scaleSize[1]
    end
    if self.mapScale > self.scaleSize[2] then
        self.mapScale = self.scaleSize[2]
    end
    NGameObjectUtil.SetScale(self.bigMap,self.mapScale,self.mapScale,self.mapScale)
    
    local right = bigMapSize[1]/2*self.mapScale-self.windowSize[1]/2
    local top = bigMapSize[2]/2*self.mapScale-self.windowSize[2]/2
    
    if self.curX < -right then
        self.curX = -right
    end
    if self.curY < -top then
        self.curY = -top
    end
    if self.curX > right then
        self.curX = right
    end
    if self.curY > top then
        self.curY = top
    end
    NGameObjectUtil.SetLocalPosition(self.bigMap,self.curX,self.curY,0)
    
    NGameObjectUtil.SetScale(self.homeLocation,1/self.mapScale,1/self.mapScale,1/self.mapScale)
    NGameObjectUtil.SetScale(self.selector,1/self.mapScale,1/self.mapScale,1/self.mapScale)
    --NGameObjectUtil.SetScale(self.selectorA,1/self.mapScale,1/self.mapScale,1/self.mapScale)
    --NGameObjectUtil.SetScale(self.currentLocation,1/self.mapScale,1/self.mapScale,1/self.mapScale)
end

function BigMapPanel:UpdatePosInfo()
    self.ignoreChanged = true
    local wX = self.selectorPosition[1] - self.areaPos[1] + self.bigMapSize[1]/2
    local wY = self.selectorPosition[2] - self.areaPos[2] + self.bigMapSize[2]/2
    wX = math.floor(wX / self.bigMapSize[1] * self.realSize[1]+0.5)
    wY = math.floor(wY / self.bigMapSize[2] * self.realSize[2]+0.5)
    self.mediator.targetPosition = {wX,wY}
    self.positionX.value = wX
    self.positionY.value = wY
    self.ignoreChanged = false
end

function BigMapPanel:GetNGUIPosition(pos_)
    local pos = UICamera.currentCamera:ScreenToWorldPoint(pos_)
    pos = {x=(pos.x-self.uiRootPosition.x)/self.cameraScale-self.mapPanelPos.x,y=(pos.y-self.uiRootPosition.y)/self.cameraScale-self.mapPanelPos.y}
    return pos
end

function BigMapPanel:ButtonGotoBigMap()
    self.mode = 1
    local realPos = self.mediator.targetPosition
    self:InitPosition({x=realPos[1],y=realPos[2]},self.mediator:GetHomePosition())
    local filter = {0,0,self.realSize[1],self.realSize[2]}
    Facade:SendNotification(NotiConst.Notify_MapMarkListFilter,filter)
    --todobycn
    self:ChangeRegionName("宇宙")
    self.closeButton:SetActive(true)
    self.uiBinder.m_ButtonToBigMap.gameObject:SetActive(false)
end


function BigMapPanel:SetMarkLocation()
    local realPos = self.mediator.targetPosition
    self:InitPosition({x=realPos[1],y=realPos[2]},self.mediator:GetHomePosition())
end

return BigMapPanel