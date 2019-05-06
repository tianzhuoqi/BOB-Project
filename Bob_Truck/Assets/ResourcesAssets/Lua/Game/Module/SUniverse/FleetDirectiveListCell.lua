local ListCell = require("Game/Module/UICommon/ListCell")
local TableCell = register("FleetDirectiveListCell", ListCell)
local universeProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
local fleetProxy = Facade:RetrieveProxy(NotiConst.Proxy_Fleet)
function TableCell:Awake(gameObject)
    TableCell.super.Awake(self, gameObject)
    
    self.n_Label_DirectiveName = self:FindComponent("n_Label_DirectiveName", "UILabel")
    self.n_Label_DirectiveDescription = self:FindComponent("n_Label_DirectiveDescription", "UILabel")
    self.n_FleetStateObj = self:FindGameObject("n_FleetStateObj")
    self.n_Label_FleetName = self:FindComponent("n_FleetStateObj/n_Label_FleetName", "UILabel")
    self.n_Label_State = self:FindComponent("n_FleetStateObj/n_Label_State", "UILabel")
    self.n_Label_Time = self:FindComponent("n_FleetStateObj/n_Label_Time", "UILabel")
    self.n_Slider = self:FindComponent("n_FleetStateObj/n_Slider", "UISlider")
    self.n_Button_Stop = self:FindComponent("n_FleetStateObj/n_Button_Stop", "UIButton")
    
    self.gameObject = gameObject
    self.n_Grid_FleetInformation = self:FindGameObject("SubView/n_Grid_FleetInformation")
  
    self.stopLuaClickEvent = NLuaClickEvent.Get(self.n_Button_Stop.gameObject)
    self.boxCollider = gameObject:GetComponent("BoxCollider")
    self.childGrid = self.n_Grid_FleetInformation:GetComponent("UIGrid")

    self.fleetInfomationObjTable = {}
    self.fleetInfomationComponentTable = {}
    self:AddFleetInfomationObj()

    self:SetBoxColliderStatus(false)
end

--保存舰队详情各子节点相关的引用
function TableCell:AddFleetInfomationObj()
    local saveData = function(fleetTransform)
        local childFleetCollect_nameLabel = fleetTransform:Find("Label_Child_FleetName"):GetComponent("UILabel")
        local childFleetCollect_fightLabel  = fleetTransform:Find("Label_Child_Fight"):GetComponent("UILabel")
        local childFleetCollect_marshallingLabel = fleetTransform:Find("n_Label_Marshalling"):GetComponent("UILabel")
        local childFleetCollectTransform = fleetTransform:Find("Child_FleetCollectObj")
        local childFleetCollect_speedLabel  = childFleetCollectTransform:Find("Label_Child_CollectSpeed"):GetComponent("UILabel")
        local childFleetCollect_capticalLabel  = childFleetCollectTransform:Find("Label_Child_TotalCaptical"):GetComponent("UILabel")
        local childFleetCollect_totalTimeLabel  = childFleetCollectTransform:Find("Label_Child_TotalTime"):GetComponent("UILabel")
        local childFleetCollect_startButtonObj = childFleetCollectTransform:Find("Button_Child_Start").gameObject
        local childFleetCollect_startClickEvent = NLuaClickEvent.Get(childFleetCollect_startButtonObj)
        local infomationObj = {
            childFleetObj = fleetTransform.gameObject,
            childFleetCollect_nameLabel = childFleetCollect_nameLabel,
            childFleetCollect_fightLabel = childFleetCollect_fightLabel,
            childFleetCollectObj = childFleetCollectTransform.gameObject,
            childFleetCollect_speedLabel = childFleetCollect_speedLabel,
            childFleetCollect_capticalLabel = childFleetCollect_capticalLabel,
            childFleetCollect_totalTimeLabel = childFleetCollect_totalTimeLabel,
            childFleetCollect_startClickEvent = childFleetCollect_startClickEvent,
            childFleetCollect_marshallingLabel = childFleetCollect_marshallingLabel
        }
        table.insert(self.fleetInfomationComponentTable,infomationObj)
    end

    local fleetTransform = self.n_Grid_FleetInformation.transform
    local childCount = fleetTransform.childCount
    for i=1,childCount do
        local childFleet = fleetTransform:GetChild(i - 1)
        saveData(childFleet)
    end
end

function TableCell:DrawCell(index)
    self.fleetDirectiveType = self:GetDirectiveType(index + 1)
    self.nodeId = universeProxy:GetCurrentOperationNodeId()
    self:SetBoxColliderStatus(false)
    self:StopAllCoroutines()
    if self.fleetDirectiveType == NotiConst.FleetDirectiveType.eFleetDirective_Collect then
        self.n_Label_DirectiveName.text = GetLanguageText("Fleet", "FDirectiveListName")
        self:ShowCollectFleet()
    end
end

--显示采集舰队具体信息
function TableCell:ShowCollectFleet()
    local myCollectingFleet = fleetProxy:GetMyCollectingFleet(self.nodeId)
    
    local isCollectingByMe = false
    if myCollectingFleet ~= nil then
        isCollectingByMe = true
    end
    if isCollectingByMe then
        self.n_FleetStateObj:SetActive(true)
        self.n_Label_DirectiveDescription.gameObject:SetActive(false)
        self.n_Label_FleetName.text = tostring(myCollectingFleet.fleetId)
        self.n_Label_State.text = GetLanguageText("Fleet", "FDirectiveIngFleetWorking")
        self.stopLuaClickEvent:AddClick(self,self.StopCollectClickEvent,{fleetId = myCollectingFleet.fleetId})
        self:StartCoroutine(self.UpdateCollectTime,myCollectingFleet.endTime,myCollectingFleet.time)
        return
    end
    self.n_FleetStateObj:SetActive(false)
    local isHaveOwner = universeProxy:GetCurrentOperationNodeIsHaveOwner()
    if isHaveOwner then
        self.n_Label_DirectiveDescription.text = GetLanguageText("Fleet", "FDirectiveLim")
        self.n_Label_DirectiveDescription.gameObject:SetActive(true)
        return
    end
    local isCollectingByOthers = universeProxy:GetCurrentOperationNodeIsCollecting()
    if isCollectingByOthers then
        self.n_Label_DirectiveDescription.text = GetLanguageText("Fleet", "FTip01 ")
        self.n_Label_DirectiveDescription.gameObject:SetActive(true)
        return
    end
    local myCanCollectFleets = fleetProxy:GetMyCanCollectFleetList(self.nodeId)
    if myCanCollectFleets == nil or (myCanCollectFleets ~= nil and #myCanCollectFleets < 1) then
        self.n_Label_DirectiveDescription.text = GetLanguageText("Fleet", "FTip02 ")
        self.n_Label_DirectiveDescription.gameObject:SetActive(true)
        return
    end
    self:SetBoxColliderStatus(true)
    self.n_Label_DirectiveDescription.gameObject:SetActive(false)

    local count = #myCanCollectFleets
    for i,fleetInfomation in ipairs(self.fleetInfomationComponentTable) do
        if i <= count then
            fleetInfomation.childFleetObj:SetActive(true)
            self:ShowFleetInfomationUI(fleetInfomation,myCanCollectFleets[i])
        else
            fleetInfomation.childFleetObj:SetActive(false)
        end
    end
    self.childGrid:Reposition()
end

--更新显示采集中倒计时
function TableCell:UpdateCollectTime(endTime,totalTime)
    while true do
        local serverTime = GetServerTimeStamp()
        local time = math.floor(endTime - serverTime)
        time = math.max(time,0)
        if time <= 0 then
            break
        else
            self.n_Slider.value = 1 - time / totalTime
            self.n_Label_Time.text = SecondToHours(time)
        end
        coroutine.wait(1)
    end
end

--显示二级菜单
function TableCell:ShowFleetInfomationUI(fleetInfoComponents,fleetData)
    fleetInfoComponents.childFleetCollect_nameLabel.text = GetLanguageText("Fleet", "FDirectiveSubName",fleetData.fleetName)
    -- TODO 暂时没数据
    fleetInfoComponents.childFleetCollect_marshallingLabel.text = GetLanguageText("Fleet", "FDirectiveSubNum",#fleetData.userShips,45)
    fleetInfoComponents.childFleetCollect_fightLabel.text = GetLanguageText("Fleet", "FExploreCCapabilities",0)

    fleetInfoComponents.childFleetCollect_speedLabel.text = GetLanguageText("Fleet", "FDirectiveSubMiningSpeed",fleetData.collectSpeed)
    fleetInfoComponents.childFleetCollect_totalTimeLabel.text = SecondToHours(fleetData.time)
    local str = string.format("%d/%d",fleetData.resourceCapacity,fleetData.fleetCapacity)
    if fleetData.resourceCapacity >= fleetData.fleetCapacity then
        fleetInfoComponents.childFleetCollect_startClickEvent.gameObject:SetActive(false)
        str = string.format("[fd3030]%s",str)
    else
        fleetInfoComponents.childFleetCollect_startClickEvent.gameObject:SetActive(true)
        fleetInfoComponents.childFleetCollect_startClickEvent:AddClick(self,self.StartCollectClickEvent,{fleetId = fleetData.fleetId})
    end
    fleetInfoComponents.childFleetCollect_capticalLabel.text = GetLanguageText("Fleet", "FDirectiveSubMiningCap")..str
end

--点击一级菜单的回调
function TableCell:OnClick()

end

--停止采集 
function TableCell:StopCollectClickEvent(data)
    local TCSEndFleetCollect = node_pb.TCSEndFleetCollect()
    TCSEndFleetCollect.nodeId = self.nodeId
    TCSEndFleetCollect.fleetId = data.fleetId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.ENDFLEETCOLLECT, TCSEndFleetCollect:SerializeToString())
end

--开始采集
function TableCell:StartCollectClickEvent(data)
    local TCSFleetCollect  = node_pb.TCSFleetCollect()
    TCSFleetCollect.nodeId = self.nodeId
    TCSFleetCollect.fleetId = data.fleetId
    NNetMgrInst:SendLuaNetMsg(common_pb.NETTYPELOBBY, common_pb.FLEETCOLLECT, TCSFleetCollect:SerializeToString())
end

function TableCell:SetBoxColliderStatus(isEnabled)
   self.boxCollider.enabled = isEnabled
end

function TableCell:GetDirectiveType(index)
    local count = 1
    for i,v in pairs(NotiConst.FleetDirectiveType) do
        if count == index then
            return v
        end
        count = count + 1
    end
    return 1
end

return FleetDirectiveListCell