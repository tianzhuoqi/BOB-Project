local SPlanetarySystemStartCommand = class("SPlanetarySystemStartCommand", SimpleCommand)


SPlanetarySystemStartCommand.MODULE_NAME = NotiConst.Command_SPlanetarySystemStart
function SPlanetarySystemStartCommand:Execute(notice)
	local proxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
	proxy:SetCurrentScene("SPlanetarySystem")
	-- send rpc command
	Facade:OverLayerPanel("UIPlayerResourcePanel")
	Facade:OverLayerPanel("UIMenuPanel")
	Facade:OverLayerPanel("PlanetaryPanel")
	Facade:SetHomePagePoint()
	Facade:SendNotification("CurrentSceneName",{sceneName = "SPlanetary"})
	
end


return SPlanetarySystemStartCommand