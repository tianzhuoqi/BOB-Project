local PanelBase = class("PanelBase", ViewComponent)

function PanelBase:Awake(gameObject) 
    self.gameObject = gameObject
end

function PanelBase:OpenPanel()
    ManagerIntro:TriggerIntro()
end

function PanelBase:ClosePanel()
end

function PanelBase:ReopenPanel()
end

function PanelBase:Update()
end

function PanelBase:DestroyPanel()
end

--模糊背景
function PanelBase:DoBlur()
    local blur = self.uiBinder.m_bkgnd:GetComponent("NUIMsgBoxStaticBlur")
    if blur ~= nil then 
        blur:GaussianBlur()
    end
end

return PanelBase