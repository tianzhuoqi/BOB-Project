local WorldMediator = require("Game/Module/SUniverse/WorldMediator")
local WorldPanel = register("WorldPanel", PanelBase)
local WorldPanelBinder = require("UIDef/WorldPanelBinder");
local UnityWorld3DPos2WorldUIPos = GameObjectUtil.World3DPos2WorldUIPos
local UnitySetPos = GameObjectUtil.SetPosition
local UnitySetLocalPos = GameObjectUtil.SetLocalPosition;
local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
local UnityInput = UnityEngine.Input
local UnityScreen = UnityEngine.Screen
function WorldPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView();

    self.mediator = WorldMediator.New(NotiConst.WorldMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end


function WorldPanel:OpenPanel()
    WorldPanel.super.OpenPanel(self)

    self.mediator:ShowUniverse()
    self.lstOperateInfo = nil --ref

    UpdateBeat:Add(self.Update, self);

    self.lstOperaUIComp = {}
    self.lstOperaUIComp[1]={};
    self:BindOperItem(self.uiBinder.m_ExploreInfoItem, self.lstOperaUIComp[1])
    --self:FreshOperateView()
    self:CheckLastSceneData()
end

function WorldPanel:CheckLastSceneData()
    local globalProxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
    local sceneData = globalProxy:GetSceneData("SPlanetarySystem")
    if sceneData then
        Facade:SendNotification(NotiConst.Notify_SetWorldPosition,sceneData[1])
        if sceneData[2] then
            Facade:SendNotification(NotiConst.Notify_SetWorldZoom,sceneData[2])
        end
        globalProxy:SetSceneData("SPlanetarySystem",nil)
    end
end

function WorldPanel:BindOperItem(gameObject, st)
    if st == nil or gameObject == nil then 
        return
    end
    st.gameObject = gameObject;
    local icon = gameObject.transform:Find("icon")
    if icon ~= nil then
        st.icon = icon:GetComponent("UISprite")
    end
    local title = gameObject.transform:Find("title")
    if title ~= nil then
        st.title = title:GetComponent("UILabel")
    end
    local dis = gameObject.transform:Find("dis")
    if dis ~= nil then
        st.dis = dis:GetComponent("UILabel")
    end
end

function WorldPanel:AbsGetOperItem(idx)
    local item = self.lstOperaUIComp[idx]
    if item == nil then
        local gameObject = UnityEngine.Object.Instantiate(self.uiBinder.m_ExploreInfoItem, self.uiBinder.m_ExploreInfoItem.transform.parent)
        self.lstOperaUIComp[idx]={}
        self:BindOperItem(gameObject, self.lstOperaUIComp[idx])
    end
    return self.lstOperaUIComp[idx]
end

function WorldPanel:Update()
    self.mediator:UpdateDynamicSpaceFleets()
    --self:UpdateOperateItem()
    self:CheckCancelPop()
end

function WorldPanel:CheckCancelPop()
end


function WorldPanel:DestroyPanel()
    UpdateBeat:Remove(self.Update, self)
end

function WorldPanel:ShowExplorePopup(galaxyid)
    universeProxy:SetCurrentOperationNodeId(galaxyid)
    self.CurSelGalaxyID = galaxyid
    self.uiBinder.m_GroupPopup:SetActive(galaxyid>0)
    self.uiBinder.m_NodeInfo:SetActive(galaxyid>0)
    --锁定位置
    local UnivProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    local node = UnivProxy:GetNode(galaxyid)
    if node ~= nil then
        --local posui = UnityWorld3DPos2WorldUIPos(node.position.x, 0, node.position.y)
        --UnitySetPos(self.uiBinder.m_GroupPopup, posui.x, posui.y, 0)
        self.mediator.Univ:GotoPosition(node.position.x,node.position.y,true)
    end
    
    --判断移动还是探索
    local HasExpled = UnivProxy:IsExploredNode(galaxyid) 
    local HasOcced = UnivProxy:IsOccupiedNode(galaxyid)
    local hasFleet = fleetProxy:IsHasMyFleetByNodeId(galaxyid)
    --self.uiBinder.m_ButtonExplore:SetActive(not HasExpled)
    self.uiBinder.m_B_ButtonGoto.gameObject:SetActive(true)
    self.uiBinder.m_D_ButtonView.gameObject:SetActive(HasExpled and HasOcced) --HasOcced is temp
    self.uiBinder.m_C_ButtonFleetDirectiveButton.gameObject:SetActive(hasFleet)
    local userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
    self.markStatus = userDataProxy:HasMarked(galaxyid)
    self.uiBinder.m_A_ButtonMark.gameObject:SetActive(true)
    if self.markStatus then
        self.uiBinder.m_MarkLabel.text = "取标"
        local item = userDataProxy:GetMapMarkListItem(galaxyid)
        if item.isSysNode then
            self.uiBinder.m_A_ButtonMark.gameObject:SetActive(false)
        end
    else
        self.uiBinder.m_MarkLabel.text = "标记"
    end

    local buttonList = {}
    if self.uiBinder.m_A_ButtonMark.gameObject.activeSelf then
        table.insert( buttonList, self.uiBinder.m_A_ButtonMark.gameObject)
    end
    if self.uiBinder.m_B_ButtonGoto.gameObject.activeSelf then
        table.insert( buttonList, self.uiBinder.m_B_ButtonGoto.gameObject)
    end
    if self.uiBinder.m_C_ButtonFleetDirectiveButton.gameObject.activeSelf then
        table.insert( buttonList, self.uiBinder.m_C_ButtonFleetDirectiveButton.gameObject)
    end
    table.insert( buttonList, self.uiBinder.m_D_ButtonView.gameObject)
    
    for i=1,#buttonList do
        GameObjectUtil.SetLocalPosition(buttonList[i], -236+(i-1)*113, 227,0)
    end

    self.uiBinder.m_Label_name.text = node.dynamicData.name
    self.buttonGrid:Reposition()
end
--[[
function WorldPanel:FreshOperateView()
    local setn = 0
    local lst = fleetProxy:GetOperationDataList()
    local n = #lst
    self.lstOperateInfo = lst --保存引用
    
    local fPosy = self.uiBinder.m_ExploreInfoItem.transform.localPosition.y
    for i=1, n do 
        local uiitem = self:AbsGetOperItem(i)
        if uiitem ~= nil then 
            uiitem.gameObject:SetActive(true)
            UnitySetLocalPos(uiitem.gameObject, 0, fPosy, 0)
            fPosy = fPosy - 80
        end
    end
    local lstItem = self.lstOperaUIComp
    for i=n+1, #lstItem do
        if lstItem[i] ~= nil then
            lstItem[i].gameObject:SetActive(false)
        end
    end
    self:UpdateOperateItem()
end

--每帧刷新
function WorldPanel:UpdateOperateItem()
    if self.lstOperateInfo == nil then 
        return
    end
    local tmnow = GetServerTimeStamp(true)
    for i=1, #self.lstOperateInfo do
        local oi = self.lstOperateInfo[i]
        local uiitem = self.lstOperaUIComp[i]
        if oi ~= nil and uiitem ~= nil and oi.dynamicData ~= nil then
            if oi.type == common_pb.MOVE then
                --更新进度条 & 距离
                local tmlen = oi.dynamicData.endTime - oi.dynamicData.startTime
                local cost = tmnow - oi.dynamicData.startTime
                local percent = cost/tmlen
                uiitem.title.text = oi.fleetId.." (type:"..oi.type..")"
                if percent > 1 then
                    percent = 1
                end
                uiitem.dis.text = string.format("距离 %.2f Unit", oi.dynamicData.distance*(1-percent))
                uiitem.icon.fillAmount = percent
            end
        end
    end
end
]]

function WorldPanel:ClosePopup()
    self.uiBinder.m_GroupPopup:SetActive(false)
    self.uiBinder.m_NodeInfo:SetActive(false)
end

function WorldPanel:InitView()
    self.uiBinder = WorldPanelBinder.New(self.gameObject);

    self.uiBinder.m_GroupPopup:SetActive(false);
    self.uiBinder.m_NodeInfo:SetActive(false)
    self.uiBinder.m_GroupExportInfo:SetActive(true);

    self.cameraPosLabel = self:FindGameObject('Anchor_Top/CameraPosLabel'):GetComponent("UILabel")
    self.cameraPosRegionLabel = self:FindGameObject('Anchor_Top/CameraPosRegionLabel'):GetComponent("UILabel")

    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_B_ButtonGoto.gameObject)
    NLuaClickEvent:AddClick(self, self.B_ButtonGotoClick)

    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_D_ButtonView.gameObject)
    NLuaClickEvent:AddClick(self, self.D_ButtonViewClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_C_ButtonFleetDirectiveButton.gameObject)
    NLuaClickEvent:AddClick(self,self.ButtonFleetDirectiveClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_A_ButtonMark.gameObject)
    NLuaClickEvent:AddClick(self, self.A_ButtonMarkClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonMarkList.gameObject)
    NLuaClickEvent:AddClick(self, self.A_ButtonMarkListClick)

    self.buttonGrid = self.uiBinder.m_ButtonGrid:GetComponent("UIGrid")
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_btnClickClose.gameObject)
    NLuaClickEvent:AddPress(self, self.ButtonPopupBkgndClick)
    NLuaClickEvent:AddClick(self, self.ButtonPopupBkgndClick)
end

function WorldPanel:ButtonExploreClick()
    self.uiBinder.m_GroupPopup:SetActive(false)
    self.uiBinder.m_NodeInfo:SetActive(false)
    local operationData = {
        targetGalaxyId = self.CurSelGalaxyID,
        fleetId = 0,
        type = common_pb.MOVE
    }
    fleetProxy:SetCurrentOperation(operationData)

    Facade:ReplacePanel("ExploreFleetLstPanel")

    Facade:SendNotification(NotiConst.Notify_ExploreFleetLstInit, common_pb.MOVE)
end

function WorldPanel:B_ButtonGotoClick()
    self.uiBinder.m_GroupPopup:SetActive(false)
    self.uiBinder.m_NodeInfo:SetActive(false)
    local operationData = {
        targetGalaxyId = self.CurSelGalaxyID,
        fleetId = 0,
        type = common_pb.MOVE
    }
    fleetProxy:SetCurrentOperation(operationData)

    Facade:ReplacePanel("ExploreFleetLstPanel")

    Facade:SendNotification(NotiConst.Notify_ExploreFleetLstInit, common_pb.MOVE)
end
--查看
function WorldPanel:D_ButtonViewClick()
    self.uiBinder.m_GroupPopup:SetActive(false)
    self.uiBinder.m_NodeInfo:SetActive(false)
    self.mediator:OpenPlanetary(self.CurSelGalaxyID)
end

--当前点的舰队指令 
function WorldPanel:ButtonFleetDirectiveClick()
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETFLEETINNODE), self.GetFleetInNodeCallback, self)
    local TCSGetFleetInNode = node_pb.TCSGetFleetInNode()
    TCSGetFleetInNode.nodeId = self.CurSelGalaxyID
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETFLEETINNODE, TCSGetFleetInNode:SerializeToString())
end

function WorldPanel:GetFleetInNodeCallback(sData)
    if sData ~= nil then
        local TSCGetFleetInNode = node_pb.TSCGetFleetInNode()
        TSCGetFleetInNode:MergeFromString(sData)
        fleetProxy:SaveMyCurrentNodeFleetListData(TSCGetFleetInNode.fleet)
        universeProxy:SetCurrentOperationNodeOwner(TSCGetFleetInNode.owner)
        universeProxy:SetCurrentOperationNodeCollectStatus(TSCGetFleetInNode.fleetCollect)
        Facade:ReplacePanel("FleetDirectivePanel")
    end
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETFLEETINNODE),self.GetFleetInNodeCallback)
end

function WorldPanel:ButtonPopupBkgndClick()
    Facade:SendNotification(NotiConst.Notify_UniverseCameraCtrlIgnoreUI)
    self.uiBinder.m_GroupPopup:SetActive(false)
    self.uiBinder.m_NodeInfo:SetActive(false)
end

function WorldPanel:A_ButtonMarkClick()
    self.uiBinder.m_GroupPopup:SetActive(false)
    self.uiBinder.m_NodeInfo:SetActive(false)
    if self.markStatus then
        self.mediator:RequestDelMark(self.CurSelGalaxyID)
    else
        Facade:ReplacePanel("MapMarkPanel")
    end
end
function WorldPanel:A_ButtonMarkListClick()
    if Facade:TopPanelName() == "MarkListPanel" then
        Facade:BackPanel()
    else
        Facade:OverLayerPanel("MarkListPanel")
    end
end

return WorldPanel