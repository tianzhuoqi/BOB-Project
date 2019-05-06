local SLoadingStartCommand = class("SLoadingStartCommand", SimpleCommand)

SLoadingStartCommand.MODULE_NAME = NotiConst.Command_SLoadingStart
function SLoadingStartCommand:Execute(notice)
	local proxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
	proxy:SetCurrentScene("SLoading")
	Facade:ReplacePanel('LoadingPanel')
end

return SLoadingStartCommand