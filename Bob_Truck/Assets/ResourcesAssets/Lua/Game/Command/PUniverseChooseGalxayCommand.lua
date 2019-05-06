--[[
大世界点击某个星系
]]
local PUniverseChooseGalxayCommand = class("PUniverseChooseGalxayCommand", SimpleCommand)

PUniverseChooseGalxayCommand.MODULE_NAME = NotiConst.Command_PUniverseChooseGalxay
function PUniverseChooseGalxayCommand:Execute(notice)
    local galaxyid = notice:GetBody()
    LogDebug("PUniverseChooseGalxayCommand:{0}", tostring(galaxyid))
    local UnivProxy = Facade:RetrieveProxy(NotiConst.Proxy_Universe)
    --占领判断
    local bHasOcc = UnivProxy:IsOccupiedNode(galaxyid)
    --[[if bHasOcc then
        local planetaryProxy = Facade:RetrieveProxy(NotiConst.Proxy_Planetary)
        planetaryProxy:SetPlanetaryId(galaxyid)
        local body = {}
        body.nodeId = galaxyid
        Facade:SendNotification(NotiConst.Command_RPCPlantarySystem, body)
        return
    end]]
    --可达判断
    local bReachable = UnivProxy:IsNodeCanReachable(galaxyid)
    if not bReachable then
        return
    end
    
    --弹出界面进行探索或者移动
    local WorldMediator = Facade:RetrieveMediator(NotiConst.WorldMediator)
    WorldMediator:ShowExplorePopup(galaxyid)
end

return PUniverseChooseGalxayCommand