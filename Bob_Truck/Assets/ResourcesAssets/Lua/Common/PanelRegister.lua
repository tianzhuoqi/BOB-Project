require("NUIPanelContainerBase")

-- 注册所有Scene中的panel
local PanelRegister = {}

function PanelRegister.SUpdate(containerBase)
    Facade:SetPanelContainerBase(containerBase)
    
    Facade:RegisterPanelByPrefabPath("UIMessageBoxPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10100, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIWaitingPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10200, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UITipsPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10300, NotiConst.EAS_CENTER)
    --注册其他UI
    Facade:RegisterPanelByPrefabPath("UpdatePanel", "UIPanel/SUpdate", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER);

    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Global,NotiConst.Package_Global))

    local command = NotiConst.Command_SUpdateStart
    Facade:RegisterCommand(command, LoadCommand(command))
    Facade:SendNotification(command)
end

function PanelRegister.SLogin(containerBase)
    Facade:SetPanelContainerBase(containerBase)

    Facade:RegisterPanelByPrefabPath("UIMessageBoxPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10100, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIWaitingPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10200, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UITipsPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10300, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("LoginPanel", "UIPanel/SLogin", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER);
    
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Global,NotiConst.Package_Global))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_UserData,NotiConst.Package_UserData))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Planetary,NotiConst.Package_Planetary))

    local command = NotiConst.Command_SLoginStart
    Facade:RegisterCommand(command, LoadCommand(command))
	Facade:SendNotification(command)
	command = NotiConst.Command_RPCLogin
    Facade:RegisterCommand(command, LoadCommand(command))
end

function PanelRegister.SLoginDestroy()
    
end

function PanelRegister.SLoading(containerBase)
    Facade:SetPanelContainerBase(containerBase)
    Facade:RegisterPanelByPrefabPath("LoadingPanel", "UIPanel/SLoading", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER);

    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Global,NotiConst.Package_Global))

	local command = NotiConst.Command_SLoadingStart
    Facade:RegisterCommand(command, LoadCommand(command))
	Facade:SendNotification(command)
end

function PanelRegister.SLoadingDestroy()
    
end


function PanelRegister.SUniverse(containerBase)
    NInstPool.New()
    Facade:SetPanelContainerBase(containerBase)

    --注册3个基本UI
    Facade:RegisterPanelByPrefabPath("UIMessageBoxPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10100, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIWaitingPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10200, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UITipsPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10300, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIGuidePanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10300, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIPlayerResourcePanel", "UIPanel/UICommon", Vector3.New(0,0,0), 0, NotiConst.EAS_TOP)
    Facade:RegisterPanelByPrefabPath("UIMenuPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 0, NotiConst.EAS_BOTTOM)


    Facade:RegisterPanelByPrefabPath("WorldPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("ExploreFleetLstPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("BigMapPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("CreateHullTempltPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("ModTechListPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetDirectivePanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("MapMarkPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("MarkListPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("SkillTreePanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    
    -- Proxy注册
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Global,NotiConst.Package_Global))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_UserData,NotiConst.Package_UserData))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Fleet,NotiConst.Package_Fleet))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Universe,NotiConst.Package_Universe))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Storehouse,NotiConst.Package_Storehouse))--仓库
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Planetary,NotiConst.Package_Planetary))
    
    --containerBase:RegisterUITips()
    --containerBase:RegisterUIMessageBox()
    --containerBase:RegisterUIWaiting()

    

    -- Command注册
    -- RPCCommand
    Facade:RegisterCommand(NotiConst.Command_RPCGm, LoadCommand(NotiConst.Command_RPCGm))
    Facade:RegisterCommand(NotiConst.Command_RPCSCENEN_NODE_DATA, LoadCommand(NotiConst.Command_RPCSCENEN_NODE_DATA))
    Facade:RegisterCommand(NotiConst.Command_RPCPlantarySystem, LoadCommand(NotiConst.Command_RPCPlantarySystem))
    Facade:RegisterCommand(NotiConst.Command_RPCLogin, LoadCommand(NotiConst.Command_RPCLogin))
    Facade:RegisterCommand(NotiConst.Command_RPCFleetMove, LoadCommand(NotiConst.Command_RPCFleetMove))
    Facade:RegisterCommand(NotiConst.Command_RPCFleetSpeedUp, LoadCommand(NotiConst.Command_RPCFleetSpeedUp))
    Facade:RegisterCommand(NotiConst.Command_RPCGetStorehouse, LoadCommand(NotiConst.Command_RPCGetStorehouse))
    -- proxyCommand
    --Facade:RegisterCommand(NotiConst.Command_PUniverseLoadMap, LoadCommand(NotiConst.Command_PUniverseLoadMap))
    --Facade:RegisterCommand(NotiConst.Command_PUniverseGetCameraData, LoadCommand(NotiConst.Command_PUniverseGetCameraData))
    Facade:RegisterCommand(NotiConst.Command_PUniverseChooseGalxay, LoadCommand(NotiConst.Command_PUniverseChooseGalxay))


    Facade:RegisterCommand(NotiConst.Command_SUniverseStart, LoadCommand(NotiConst.Command_SUniverseStart))
    Facade:SendNotification(NotiConst.Command_SUniverseStart)
end

function PanelRegister.SUniverseDestroy()
    
end

function PanelRegister.SPlanetarySystem(containerBase)
    Facade:SetPanelContainerBase(containerBase)
    Facade:RegisterPanelByPrefabPath("UIMessageBoxPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10100, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIWaitingPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10200, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UITipsPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10300, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIGuidePanel", "UIPanel/UICommon", Vector3.New(0,0,0), 10300, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("RenamePanel", "UIPanel/UICommon", Vector3.New(0,0,0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("UIPlayerResourcePanel", "UIPanel/UICommon", Vector3.New(0,0,0), 0, NotiConst.EAS_TOP)
    Facade:RegisterPanelByPrefabPath("UIMenuPanel", "UIPanel/UICommon", Vector3.New(0,0,0), 0, NotiConst.EAS_BOTTOM)

    Facade:RegisterPanelByPrefabPath("PlanetaryPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("ExplorationResultPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("ExploreFleetLstPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("RefineryPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    
    Facade:RegisterPanelByPrefabPath("FleetPortPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    --Facade:RegisterPanelByPrefabPath("HullFactPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("ShipBodyPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("FleetCombinePanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetDisbandPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetMemberPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetShipEditPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetGoodsPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FleetShipQueueEditPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("CreateSpaceBasePanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("WarehousePanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("BuildingListPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("BuildingUpgradePanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("BuildingDismantlePanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("BuildingCancelPanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("BuildingInteractivePanel", "UIPanel/SPlanetary", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("CollectPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("FormMainPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("FormModelPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FormShowPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("FormRefitPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("SkillTreePanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("HullFilterPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("BuildingInfoPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("FittingPanel","UIPanel/SPlanetary",Vector3.New(0,0,0),0,NotiConst.EAS_CENTER,NotiConst.EPanelActiveType.EPAT_PlayerAndMenu)
    Facade:RegisterPanelByPrefabPath("FleetPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)
    Facade:RegisterPanelByPrefabPath("BigMapPanel", "UIPanel/SUniverse", Vector3.New(0, 0, 0), 0, NotiConst.EAS_CENTER)

    Facade:RegisterCommand(NotiConst.Command_RPCGetStorehouse, LoadCommand(NotiConst.Command_RPCGetStorehouse))
    Facade:RegisterCommand(NotiConst.Command_RPCGm, LoadCommand(NotiConst.Command_RPCGm))
    -- Proxy注册
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Global,NotiConst.Package_Global))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_UserData,NotiConst.Package_UserData))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Fleet,NotiConst.Package_Fleet))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Universe,NotiConst.Package_Universe))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Planetary,NotiConst.Package_Planetary))
    Facade:RegisterProxy(LoadProxy(NotiConst.Proxy_Storehouse,NotiConst.Package_Storehouse))--仓库

    Facade:RegisterCommand(NotiConst.Command_RPCPlantarySystem, LoadCommand(NotiConst.Command_RPCPlantarySystem))
    
    local command = NotiConst.Command_SPlanetarySystemStart
    Facade:RegisterCommand(command, LoadCommand(command))
    Facade:SendNotification(command)
    command = NotiConst.Command_PPlanetaryChoosePlanet
    -- Facade:RegisterCommand(command, LoadCommand(command))
    -- Facade:SendNotification(command)
end

function PanelRegister.SPlanetarySystemDestroy()
    
end

function PanelRegister.RegisterUITips()
    
end

return PanelRegister