local PUniverseLoadMapCommand = class("PUniverseLoadMapCommand", SimpleCommand)

PUniverseLoadMapCommand.MODULE_NAME = NotiConst.Command_PUniverseLoadMap
function PUniverseLoadMapCommand:Execute(notice)
    local universePackage = LoadPackage("Universe")
    Facade:RetrieveProxy(NotiConst.Proxy_Universe)
end

return PUniverseLoadMapCommand