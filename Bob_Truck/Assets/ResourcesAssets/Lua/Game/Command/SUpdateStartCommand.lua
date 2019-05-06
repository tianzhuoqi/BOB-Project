local SUpdateStartCommand = class("SUpdateStartCommand", SimpleCommand)

SUpdateStartCommand.MODULE_NAME = NotiConst.Command_SUpdateStart
function SUpdateStartCommand:Execute(notice)
	local proxy = Facade:RetrieveProxy(NotiConst.Proxy_Global)
	proxy:SetCurrentScene("SUpdate")
	Facade:ReplacePanel('UpdatePanel')
	--OpenMessageBox(NotiConst.MessageBoxType.EnterCancel, "content 2333", "title2333")
	-- OpenMessageBox(body)
	-- --Facade:OpenUtilityPanel("UITipsPanel")
	-- --for i =1, 2 do 
	-- --	local body = {content = tostring(i)}
	-- --	Facade:SendNotification(NotiConst.Command_OpenTips, body)
	-- --end
end
 
return SUpdateStartCommand