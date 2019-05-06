local ListCell = require("Game/Module/UICommon/ListCell")

local FleetPanelAllListCell = register("FleetPanelAllListCell", ListCell)

function FleetPanelAllListCell:Awake(gameObject)
    FleetPanelAllListCell.super.Awake(self, gameObject)
    self.panelMediator = Facade:RetrieveMediator("FleetMediator")
    self.icon = self:FindComponent("Icon","UISprite")
    self.name = self:FindComponent("g2/Name","UILabel")
    self.state = self:FindComponent("g2/State","UILabel")
    self.process = self:FindComponent("g2/Process","UIProgressBar")
    self.timer = self:FindComponent("g2/Process/Timer","UILabel")
    self.gotoBtn = self:FindGameObject("SubView/Opers/g3/Goto")
    self.moveSpeedUpBtn = self:FindGameObject("SubView/Opers/g4/SpeedUp")--暂不用
    self.moveUndoBtn = self:FindGameObject("SubView/Opers/g4/Undo")--暂不用
    self.funcUndoBtn = self:FindGameObject("SubView/Opers/g5/Undo")
    self.operButton = self:FindGameObject("n_Button_operate")
    self.operButtonLabel = self:FindComponent("n_Button_operate/Label","UILabel")
    self.shipSprite = self:FindComponent("n_Sprite_ship", "UITexture")
    self.labelMarshalling = self:FindComponent("g2/bg_marshalling/Label_marshalling", "UILabel")
    self.fleetInfo = nil
    self.corId = nil
    self.universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.globalProxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
    self.fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
    local NLuaClickEvent = NLuaClickEvent.Get(self.gotoBtn)
    NLuaClickEvent:AddClick(self, self.OnGotoBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.moveSpeedUpBtn)
    NLuaClickEvent:AddClick(self, self.OnMoveSpeedUpBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.moveUndoBtn)
    NLuaClickEvent:AddClick(self, self.OnMoveUndoBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.funcUndoBtn)
    NLuaClickEvent:AddClick(self, self.OnFuncUndoBtnClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.operButton)
    NLuaClickEvent:AddClick(self, self.OnClick)
    self.stateIconName = {
        [0] = "c1icj01",
        [common_pb.BERTH] = "c1icj01",
        [common_pb.MOVE] = "c1icj02",
        [common_pb.EXPLORE] = "c1icj03",
        [common_pb.COLLECT] = "c1icj04",
    }
    self.stateName = {
        [0] = "停靠中",
        [common_pb.BERTH] = "停靠中",
        [common_pb.MOVE] = "移动中",
        [common_pb.EXPLORE] = "探索中",
        [common_pb.COLLECT] = "采集中",
    }
    self.isOpenSub = false
end

function FleetPanelAllListCell:OnClick()
    self.isOpenSub = not self.isOpenSub
    self:UpdateOperState()
end

function FleetPanelAllListCell:DrawCell(index,isOpenSub)
    self.isOpenSub = isOpenSub
    self.dataIndex = index + 1 
    self.fleetInfo = self.panelMediator.allFleetList[self.dataIndex]
    self.name.text = self.fleetInfo.fleetName
    --self.name.text = "Flt"..self.fleetInfo.fleetId
    self.icon.spriteName = self.stateIconName[self.fleetInfo.status]
    self.state.text = self.stateName[self.fleetInfo.status]
    self:StopTimer()
    if self.fleetInfo.status == 0 or self.fleetInfo.status == common_pb.BERTH then
        self.timer.text = ""
        self.process.value = 0
        --self.moveSpeedUpBtn:SetActive(false)
        --self.moveUndoBtn:SetActive(false)
        self.funcUndoBtn:SetActive(false)
    elseif self.fleetInfo.status == common_pb.MOVE then
        --self.moveSpeedUpBtn:SetActive(true)
        --self.moveUndoBtn:SetActive(true)
        self.funcUndoBtn:SetActive(true)
        self:SetTimer()
    else
        --self.moveSpeedUpBtn:SetActive(false)
        --self.moveUndoBtn:SetActive(false)
        self.funcUndoBtn:SetActive(true)
        self:SetTimer()
    end

    --self.shipSprite
    self.labelMarshalling.text = StringFormat(self.labelMarshalling.text, #self.fleetInfo.userShips, 45)
    local mostTechID = self.fleetProxy:GetMostShipsType(self.fleetInfo.userShips)

    self.shipSprite.mainTexture = ManagerResourceModule.LuaLoadBundleTexture(DATA_SHIP_MOD_TECH[mostTechID][DATA_SHIP_MOD_TECH.EVar["ship_icon_name_s"]])
    self:UpdateOperState()
end

function FleetPanelAllListCell:UpdateOperState()
    if self.isOpenSub then
        self.operButtonLabel.text = GetLanguageText("Fleet", "FListFoldBtn")
    else
        self.operButtonLabel.text = GetLanguageText("Fleet", "FListOperateBtn")
    end
end

function FleetPanelAllListCell:OnGotoBtnClick()
    local p = self.universeProxy:GetNode(self.fleetInfo.nodeId).position
    if self.fleetInfo.status == common_pb.MOVE then
        local node1 = self.universeProxy:GetNode(self.fleetInfo.fromNodeId)
        local node2 = self.universeProxy:GetNode(self.fleetInfo.toNodeId)
        p = {
            x = (node1.position.x + node2.position.x)/2,
            y = (node1.position.y + node2.position.y)/2,
        }
    end
    --点线层定位
    Facade:SendNotification(NotiConst.Notify_SetWorldPosition,p)
    Facade:SendNotification(NotiConst.Notify_SetWorldZoom,1)
    Facade:BackPanel()
    if self.globalProxy:GetCurrentScene() == "SPlanetarySystem" then
        self.globalProxy:SetSceneData("SPlanetarySystem",{p,1})
        ManagerScene:OpenSceneUseLoadingScene("SUniverse")
    end
end

function FleetPanelAllListCell:OnMoveSpeedUpBtnClick()
end

function FleetPanelAllListCell:OnMoveUndoBtnClick()
end

function FleetPanelAllListCell:OnFuncUndoBtnClick()
    if self.fleetInfo.status == common_pb.COLLECT then
        self:RequestEndCollect()
    elseif self.fleetInfo.status == common_pb.MOVE then
    end
end

function FleetPanelAllListCell:StopTimer()
    if self.corId then
        self:StopCoroutine(self.corId)
        self.corId = nil
    end
end

function FleetPanelAllListCell:SetTimer()
    if self.fleetInfo and self.fleetInfo.startTime < self.fleetInfo.endTime then
        self.corId = self:StartCoroutine(self.Timer,self.fleetInfo.startTime,self.fleetInfo.endTime)
    end
end

function FleetPanelAllListCell:Timer(startTime,endTime)
    local tNow = GetServerTimeStamp()
    local s = endTime - tNow
    local sa = tNow - startTime
    local all = endTime - startTime
    while tNow <= endTime do
        if self.timer and self.process then
            self.timer.text = SecondToMinutes(endTime - tNow)
            local per = (tNow-startTime)/all
            self.process.value = per
            coroutine.wait(1)
            tNow = GetServerTimeStamp()
        else
            break
        end
    end
    coroutine.wait(0.1)
    self.panelMediator:UpdateListData()
end


function FleetPanelAllListCell:RequestEndCollect()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ENDFLEETCOLLECT), self.OnEndCollect, self)
    local TCSEndFleetCollect = node_pb.TCSEndFleetCollect()
    TCSEndFleetCollect.nodeId = self.fleetInfo.nodeId
    TCSEndFleetCollect.fleetId = self.fleetInfo.fleetId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.ENDFLEETCOLLECT, TCSEndFleetCollect:SerializeToString())
end


function FleetPanelAllListCell:OnEndCollect(sData)
    if sData ~= nil then
        local TSCEndFleetCollect = node_pb.TSCEndFleetCollect()
        TSCEndFleetCollect:MergeFromString(sData)
        local storeHouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
        storeHouseProxy:AddItemByDatas(TSCEndFleetCollect.nodeId,TSCEndFleetCollect.item)
        self.fleetInfo.startTime = 0
        self.fleetInfo.endTime = 0
        self.fleetInfo.status = common_pb.BERTH
        self.panelMediator:UpdateList()
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.ENDFLEETCOLLECT), self.OnEndCollect)
end
return FleetPanelAllListCell