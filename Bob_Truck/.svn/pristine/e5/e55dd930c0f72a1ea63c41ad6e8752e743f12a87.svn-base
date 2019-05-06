local UIMenuMediator = class(", ", MediatorDynamic)
ManagerScene = require("Manager/ManagerScene").Instance()
planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
function UIMenuMediator:OnRegister()
    self.uiBinder = self:GetViewComponent().uiBinder

    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_BackButton.gameObject)
    NLuaClickEvent:AddClick(self,self.OnBackToUniverseClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_Feelt.gameObject)
    NLuaClickEvent:AddClick(self,self.OnFleetClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_MapButton.gameObject)
    NLuaClickEvent:AddClick(self,self.OnMapClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_Feelt.gameObject)
    NLuaClickEvent:AddClick(self,self.OnFleetClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonOk.gameObject)
    NLuaClickEvent:AddClick(self, self.ButtonGMOKClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_TechButton.gameObject)
    NLuaClickEvent:AddClick(self, self.OnTechnologyClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_EnterPlanetaryButton.gameObject)
    NLuaClickEvent:AddClick(self, self.OnEnterPlanetaryClick)

    self:RegisterObserver("CurrentSceneName","SetButtonActive")

    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETTECH), self.GetTechCallback, self)
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GM), self.OnGmCallback, self)
    --获取科技数据
    self:SendGetTechMessage()

end

function UIMenuMediator:OpenPanel()
    
end

function UIMenuMediator:UpdateFleetListCount()
    local all = #(fleetProxy:GetFleetListInfoData())
    local use = fleetProxy:GetFleetListWorkingCount()
    self.uiBinder.m_FleetCount.text = use.."/"..all
end

function UIMenuMediator:SetButtonActive(notify)
    local scene = notify:GetBody().sceneName
    if scene == "SPlanetary" then
        self.uiBinder.m_BackButton.gameObject:SetActive(true)
        self.uiBinder.m_EnterPlanetaryButton.gameObject:SetActive(false)
    elseif scene == "SUniverse" then
        self.uiBinder.m_BackButton.gameObject:SetActive(false)
        self.uiBinder.m_EnterPlanetaryButton.gameObject:SetActive(true)
    end
end

function UIMenuMediator:OnBackToUniverseClick()
    ManagerScene:OpenSceneUseLoadingScene("SUniverse")
end

function UIMenuMediator:OnMapClick()
    if Facade:TopPanelName() == "BigMapPanel" then
        return
    end
    Facade:ReplacePanel("BigMapPanel")
end

function UIMenuMediator:OnEnterPlanetaryClick()
    local mainNodeId = userDataProxy:GetMainBaseGalaxyId()
    planetaryProxy:SetPlanetaryId(mainNodeId)
    body =
    {
        nodeId = mainNodeId
    }
    Facade:SendNotification(NotiConst.Command_RPCPlantarySystem, body)
end

function UIMenuMediator:OnTechnologyClick()
    if Facade:TopPanelName() == "SkillTreePanel" then
        return
    end
    ManagerNetMsgProcInst:AddS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETTECH), self.EnterTechCallback, self)
    self:SendGetTechMessage()
end

function UIMenuMediator:OnFleetClick()
    if Facade:TopPanelName() == "FleetPanel" then
        return
    end
    Facade:ReplacePanel("FleetPanel")
end

--添加测试数据
function UIMenuMediator:ButtonGMOKClick()
    local strInput = self.uiBinder.m_EditboxGM.value
    if string.len(strInput) < 1 then
        return
    end
    local firstbyte = string.byte(strInput,1)
    --[[if firstbyte ~= 47 then -- '/'
        return
    end]]
    local sliptLine = string.split(strInput, ';')
    for _,v in ipairs(sliptLine) do
        local str = string.trim(v)
        local split = string.split(str, ' ')
        --添加自己舰队数据
        if split[1] == "/addft" and #split >= 4 then
            local userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
            local SpaceFleet = {}
            SpaceFleet.fleetId = tonumber(split[2])
            SpaceFleet.name = split[3]
            SpaceFleet.type = tonumber(split[4])
            SpaceFleet.nodeId = userDataProxy:GetMainBaseGalaxyId()
            SpaceFleet.fromNodeId = 0
            SpaceFleet.toNodeId = 0
            SpaceFleet.uid = userDataProxy:GetUserId()
            SpaceFleet.startTime = 0
            SpaceFleet.endTime = 0
            SpaceFleet.moveSpeed = 0
            fleetProxy:SetFleetData(SpaceFleet)
            self.mediator:UpdateDynamicSpaceFleets({SpaceFleet.fleetId})
            self.uiBinder.m_EditboxGM.value = ""
            return
        elseif split[1] == "/openft" then
            Facade:ReplacePanel("ExploreFleetLstPanel")
        elseif split[1] == "/openct" then
            Facade:ReplacePanel("CreateHullTempltPanel")
        elseif split[1] == "/switchlang" and #split >= 2 then --切语言
            UnityEngine.PlayerPrefs.SetInt("CurrentLanguage", tonumber(split[2]))
        elseif split[1] == "/additem" and #split >= 3 then --添加物品
            local userDataProxy = Facade:RetrieveProxy(NotiConst.Proxy_UserData)
            local itemid = tonumber(split[2])
            local itemnum = tonumber(split[3])
            userDataProxy:ModifyBagItemCount(itemid, itemnum)
            self.uiBinder.m_EditboxGM.value = ""
            return
        elseif split[1] == "/wadditem" and #split >= 4 then --添加物品
            local storehouseProxy = Facade:RetrieveProxy(NotiConst.Proxy_Storehouse)
            local nodeId = tonumber(split[2])
            local itemid = tonumber(split[3])
            local itemnum = tonumber(split[4])
            storehouseProxy:AddItemByData(nodeId,{id=itemid,num=itemnum})
        elseif split[1] == "/openrf" then
            Facade:ReplacePanel("RefineryPanel")
        elseif split[1] == "/setplanetary" and #split >= 2 then
            local proxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
            proxy:SetPlanetaryId(tonumber(split[2]))
        elseif split[1] == "@gm" then
            Facade:SendNotification(NotiConst.Command_RPCGm,str)
        end
    end
end

function UIMenuMediator:SendGetTechMessage()
    local TCSGetTech = buildingTech_pb.TCSGetTech()
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.GETTECH, TCSGetTech:SerializeToString())
end

function UIMenuMediator:GetTechCallback(sData)
    self:UpdateTechData(sData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETTECH), self.GetTechCallback)
end

function UIMenuMediator:EnterTechCallback(sData)
    self:UpdateTechData(sData)
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GETTECH), self.EnterTechCallback)
    Facade:ReplacePanel("SkillTreePanel")
end

function UIMenuMediator:UpdateTechData(sData)
    if sData ~= nil then
        local TSCGetTech = buildingTech_pb.TSCGetTech()
        TSCGetTech:MergeFromString(sData)
        planetaryProxy:SetUnlockSkillTreeData(TSCGetTech.technology)
    else
        planetaryProxy:SetUnlockSkillTreeData({})
    end
end

function UIMenuMediator:OnGmCallback(btsData)
    local data = gm_pb.TSCGm()
    data:MergeFromString(btsData)
    OpenMessageBox(NotiConst.MessageBoxType.Confirm,data.res,"GM消息")
end

function UIMenuMediator:DestroyPanel()
    ManagerNetMsgProcInst:RmvS2CMsgListener(common_pb.NETTYPELOBBY, RpcResponseCMDID(common_pb.GM), self.OnGmCallback)
end

return UIMenuMediator