local SLoginStartCommand = class("SLoginStartCommand", SimpleCommand)

SLoginStartCommand.MODULE_NAME = NotiConst.Command_SLoginStart
function SLoginStartCommand:Execute(notice)
	local proxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
	proxy:SetCurrentScene("SLogin")
	Facade:ReplacePanel('LoginPanel')
	
end

return SLoginStartCommand