local MapMarkMediator = require("Game/Module/SUniverse/MapMarkMediator")
local MapMarkPanel = register("MapMarkPanel", PanelBase)
local MapMarkPanelBinder = require("UIDef/MapMarkPanelBinder");

function MapMarkPanel:Awake(gameObject)
    self.gameObject = gameObject
    self:InitView()

    self.mediator = MapMarkMediator.New(NotiConst.MapMarkMediator)
    self.mediator:SetViewComponent(self)
	Facade:RegisterMediator(self.mediator)
end

function MapMarkPanel:InitView()
    self.uiBinder = MapMarkPanelBinder.New(self.gameObject)
    local NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonClose.gameObject)
    NLuaClickEvent:AddClick(self, MapMarkPanel.ButtonCloseClick)
    NLuaClickEvent = NLuaClickEvent.Get(self.uiBinder.m_ButtonSave.gameObject)
    NLuaClickEvent:AddClick(self, MapMarkPanel.ButtonSaveClick)
    self:BindTypeSelector()
end

function MapMarkPanel:ButtonCloseClick()
    Facade:BackPanel()
end

function MapMarkPanel:ResetSelector()
    for i = 1,5 do
        local bg = self.uiBinder["m_typeBg"..i].gameObject
        bg:SetActive(false)
    end
end

function MapMarkPanel:BindTypeSelector()
    for i = 1,5 do
        local go = self.uiBinder["m_type"..i].gameObject
        local struct = {
            parent = self,
            type = i,
            OnClick = function(self)
                self.parent:SelectedType(self.type)
            end
        }
        NLuaClickEvent.Get(go):AddClick(struct,struct.OnClick)
    end
end

function MapMarkPanel:SelectedType(type)
    self:ResetSelector()
    self.type = type
    self:ButtonSaveClick()
end

function MapMarkPanel:ButtonSaveClick()
    local name = self.uiBinder.m_InputName.value
    --if name ~= "" then
        self.mediator:RequestSave(self.nodeId,name,self.type)
    --else
    --    OpenMessageBox(NotiConst.MessageBoxType.Confirm,"名称不能为空")
    --end
    
end

function MapMarkPanel:UpdateInfo()
    
    local univProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    self.nodeId = univProxy:GetCurrentOperationNodeId()
    local node = univProxy:GetNode(self.nodeId)
    self.uiBinder.m_Position.text = StringFormat(self.uiBinder.m_Position.text, node.position.x, node.position.y)
    --self.uiBinder.m_Position.text = "坐标 X:"..node.position.x..", Y:"..node.position.y
    self.uiBinder.m_InputName.value = univProxy:GetNodeName(node.id)
end


function MapMarkPanel:OpenPanel()
    MapMarkPanel.super.OpenPanel(self)
    self.type = 0
    self:ResetSelector()
    self:DoBlur()
    self:UpdateInfo()
end

return MapMarkPanel