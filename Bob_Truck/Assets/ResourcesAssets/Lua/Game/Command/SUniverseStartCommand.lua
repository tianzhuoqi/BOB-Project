local SUniverseStartCommand = class("SUniverseStartCommand", SimpleCommand)

SUniverseStartCommand.MODULE_NAME = NotiConst.Command_SUniverseStart
function SUniverseStartCommand:Execute(notice)
	local proxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
	proxy:SetCurrentScene("SUniverse")
	Facade:OverLayerPanel("UIPlayerResourcePanel")
	Facade:OverLayerPanel("UIMenuPanel")
	Facade:OverLayerPanel("WorldPanel")
	Facade:SetHomePagePoint()
	Facade:SendNotification("CurrentSceneName",{sceneName = "SUniverse"})
end


return SUniverseStartCommand