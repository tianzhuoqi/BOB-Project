local NotiConst = {}

-- UI层的9个锚点
NotiConst.EAS_TOP = 0
NotiConst.EAS_CENTER = 1
NotiConst.EAS_BOTTOM = 2 
NotiConst.EAS_LEFT = 3
NotiConst.EAS_RIGHT = 4
NotiConst.EAS_LEFTTOP = 5
NotiConst.EAS_LEFTBOTTOM = 6
NotiConst.EAS_RIGHTTOP = 7
NotiConst.EAS_RIGHTBOTTOM = 8

--场景相关
NotiConst.Command_SUpdateStart = "SUpdateStart"
NotiConst.Command_SLoginStart = "SLoginStart"
NotiConst.Command_SUniverseStart = "SUniverseStart"
NotiConst.Command_SUniverseDestroy = "SUniverseDestroy"
NotiConst.Command_SLoadingStart = "SLoadingStart"
NotiConst.Command_SPlanetarySystemStart = "SPlanetarySystemStart"
NotiConst.Command_SPlanetarySystemDestroy = "SPlanetarySystemDestroy"


--通用UI
NotiConst.Utility_OpenTips = "OpenTips"
NotiConst.Utility_OpenMessageBox = "OpenMessageBox"
NotiConst.Utility_OpenGuide = "OpenGuide"
NotiConst.Utility_IntroWidget = "IntroWidget"

--RPC相关
NotiConst.Command_RPCLogin = "RPCLogin"
NotiConst.Command_RPCSCENEN_NODE_DATA = "RPC_SCENEN_NODE_DATA_"
NotiConst.Command_RPCFleetMove = "RPCFleetMove"
NotiConst.Command_RPCFleetSpeedUp = "RPCFleetSpeedUp"
NotiConst.Command_RPCFleetMoveStart = "RPCFleetMoveStart"
NotiConst.Command_RPCFleetMoveCompleted = "RPCFleetMoveCompleted"
NotiConst.Command_RPCFleetOpenMap = "RPCFleetOpenMap"
NotiConst.Command_RPCPlantarySystem = "RPCPlanetarySystem"
NotiConst.Command_RPCExplore = "RPCExplore"
NotiConst.Command_RPCGm = "RPCGm"
NotiConst.Command_RPCGetStorehouse = "RPCGetStorehouse"

--Proxy相关
NotiConst.Command_PUniverseLoadMap = "PUniverseLoadMap"
NotiConst.Command_PUniverseGetCameraData = "PUniverseGetCameraData"
NotiConst.Command_PUniverseChooseGalxay = "PUniverseChooseGalxay"
NotiConst.Command_PUniverseFleetOperUpdate = "PUniverseFleetOperUpdate"
NotiConst.Command_PUniverseCameraUpdate = "PUniverseCameraUpdate"
NotiConst.Command_FleetProtGetFleetData = "FleetProtGetFleetData"

--Proxy
NotiConst.Proxy_Global = "Global"
NotiConst.Proxy_UserData = "UserData"
NotiConst.Proxy_Universe = "Universe"
NotiConst.Proxy_Planetary = "Planetary"
NotiConst.Proxy_Fleet = "Fleet"
NotiConst.Proxy_Storehouse = "Storehouse"

--Package
NotiConst.Package_Global = "Global"
NotiConst.Package_UserData = "UserData"
NotiConst.Package_Universe = "Universe"
NotiConst.Package_Planetary = "Planetary"
NotiConst.Package_Fleet = "Fleet"
NotiConst.Package_Storehouse = "Storehouse"

--网络异常
NotiConst.Net_Exception = "NetException"

--Mediator名称
NotiConst.WorldMediator = "WorldMediator"
NotiConst.FleetMediator = "FleetMediator"
NotiConst.FleetPortMediator = "FleetPortMediator"
NotiConst.FleetCombineMediator = "FleetCombineMediator"
NotiConst.FleetDisbandMediator = "FleetDisbandMediator"
NotiConst.FleetMemberMediator = "FleetMemberMediator"
NotiConst.FleetShipEditMediator = "FleetShipEditMediator"
NotiConst.FleetGoodsMediator = "FleetGoodsMediator"
NotiConst.FleetShipQueueEditMediator = "FleetShipQueueEditMediator"
NotiConst.CreateSpaceBaseMediator = "CreateSpaceBaseMediator"
NotiConst.CollectMediator = "CollectMediator"
NotiConst.WarehouseMediator = "WarehouseMediator"
NotiConst.BuildingListMediator = "BuildingListMediator"
NotiConst.BuildingUpgradeMediator = "BuildingUpgradeMediator"
NotiConst.BuildingInteractiveMediator = "BuildingInteractiveMediator"
NotiConst.BuildingDismantleMediator = "BuildingDismantleMediator"
NotiConst.BuildingCancelMediator = "BuildingCancelMediator"
NotiConst.ShipBodyMediator = "ShipBodyMediator"
NotiConst.FormMainMediator = "FormMainMediator"
NotiConst.FormModelMediator = "FormModelMediator"
NotiConst.FormShowMediator = "FormShowMediator"
NotiConst.FormRefitMediator = "FormRefitMediator"
NotiConst.SkillTreeMediator = "SkillTreeMediator"
NotiConst.HullFilterMediator = "HullFilterMediator"
NotiConst.BuildingInfoMediator = "BuildingInfoMediator"
NotiConst.UIPlayerResourceMediator = "UIPlayerResourceMediator"
NotiConst.UIMenuMediator = "UIMenuMediator"
NotiConst.RenameMediator = "RenameMediator"
NotiConst.FleetDirectiveMediator = "FleetDirectiveMediator"
NotiConst.CloseUniversePop = "CloseUniversePop" --关闭宇宙弹出操作页面
--Notification名称
--设置世界地图点
NotiConst.Notify_SetWorldPosition = "SetWorldPosition"
NotiConst.Notify_SetWorldZoom = "SetWorldZoom"
NotiConst.Notify_SystemTimestampUpdated = "SystemTimestampUpdated"
NotiConst.Notify_FleetTargetChanged = "FleetTargetChanged"
NotiConst.Notify_FleetDataChanged = "FleetDataChanged" --fleetProxy通知舰队数据改变
NotiConst.Notify_MapMarkListChanged = "MapMarkListChanged"
NotiConst.Notify_MapMarkListSelected = "MapMarkListSelected"
NotiConst.Notify_MapMarkListFilter = "MapMarkListFilter"
NotiConst.Notify_UniverseCameraCtrlIgnoreUI = "UniverseCameraCtrlIgnoreUI"

--Planetary System 
NotiConst.Notify_PlanetaryChoosePlanet = "PlanetaryChoosePlanet"
NotiConst.Notify_PlanetaryStartExplore = "PlanetaryStartExplore"
NotiConst.Notify_PlanetaryStartMine = "PlanetaryStartMine"
NotiConst.Notify_PlanetShowExploreResult = "PlanetShowExploreResult"
NotiConst.Notify_PlanetShowMineResult = "PlanetShowMineResult"
NotiConst.Notify_PlanetShowInfo = "PlanetShowInfo"
NotiConst.Notify_PlanetShowCollect = "PlanetShowCollect"
NotiConst.Notify_PlanetShowBuildingList = "PlanetShowBuildingList"
NotiConst.Notify_PlanetChooseBuilding = "PlanetChooseBuilding"
NotiConst.Notify_SetPlanetCameraEnable = "SetPlanetCameraEnable"
NotiConst.Notify_PlanetaryUpdateNodeData = "PlanetaryUpdateNodeData"
NotiConst.Notify_PlanetaryChooseHexe = "PlanetaryChooseHexe"
NotiConst.Notify_PlanetCloseGroupPopup = "PlanetCloseGroupPopup"
NotiConst.Notify_CloseBuildingObjMod = "CloseBuildingObjMod"

NotiConst.Notify_RefinerySelectMine = "RefinerySelectMine"

NotiConst.Notify_RefinerySelectMineAdd = "RefinerySelectMineAdd"
NotiConst.Notify_RefinerySelectMineReduce = "RefinerySelectMineReduce"
NotiConst.Notify_RefinerySelectMineOK = "RefinerySelectMineOK"
NotiConst.Notify_RefinerySelectMineMax = "RefinerySelectMineMax"
NotiConst.Notify_RefinerySelectMineChange = "RefinerySelectMineChange"

NotiConst.Notify_StorehouseTabChange = "StorehouseTabChange"

NotiConst.Notify_ProtFleetGetProtFleetsData = "ProtFleetGetProtFleetsData"
NotiConst.Notify_ProtFleetGetProtShipsData = "ProtFleetGetProtShipsData"
NotiConst.Notify_ProtFleetGetFleetShipsData = "ProtFleetGetFleetShipsData"
NotiConst.Notify_ProtFleetDeleteShip = "ProtFleetDeleteShip"
NotiConst.Notify_UpdatePortShipPoint = "UpdatePortShipPoint"

NotiConst.Notify_ProtFleetListCellChangeSelect = "ProtFleetListCellChangeSelect"
NotiConst.Notify_FleetProtOpenTabItem = "FleetProtOpenTabItem"
NotiConst.Notify_FleetProtInitTabItemView = "FleetProtInitTabItemView"
NotiConst.Notify_FleetMemberListCellChangeSelect = "FleetMemberListCellChangeSelect"
NotiConst.Notify_FleetMemberDeleteShip = "FleetMemberDeleteShip"
NotiConst.Notify_FleetDisbandListCellChangeSelect = "FleetDisbandListCellChangeSelect"
NotiConst.Notify_FleetCombineListCellChangeSelect = "FleetCombineListCellChangeSelect"
NotiConst.Notify_FleetShipEditRefreshView = "FleetShipEditRefreshView"
NotiConst.Notify_FleetGoodsOpenTabItem = "FleetGoodsOpenTabItem"
NotiConst.Notify_FleetGoodsInstallGoods = "FleetGoodsInstallGoods"
NotiConst.Notify_FleetGoodsUnInstallGoods = "FleetGoodsUnInstallGoods"
NotiConst.Notify_FleetGoodsSetGoodsNum = "FleetGoodsSetGoodsNum"
NotiConst.Notify_FleetGoodsDropUp = "FleetGoodsDropUp"
NotiConst.Notify_FleetShipQueueEditAdd = "FleetShipQueueEditAdd"
NotiConst.Notify_FleetShipQueueEditDelete = "FleetShipQueueEditDelete"
NotiConst.Notify_WarehouseOpenTabItem = "WarehouseOpenTabItem"
NotiConst.Notify_WarehouseListItemChangeSelect = "WarehouseListItemChangeSelect"
NotiConst.Notify_WarehouseListItemUse = "WarehouseListItemUse"
NotiConst.Notify_WarehouseListItemSell = "WarehouseListItemSell"
NotiConst.Notify_RefreshCap = "RefreshCap "

NotiConst.Notify_BuildingListOpenTabItem = "BuildingListOpenTabItem"
NotiConst.Notify_BuildingListListItemChangeSelect = "BuildingListListItemChangeSelect"
NotiConst.Notify_BuildingListListItemSelectBuild = "BuildingListListItemSelectBuild"
NotiConst.Notify_BuildingUpgrade = "BuildingUpgrade"
NotiConst.Notify_BuildingCancel = "BuildingCancel"
NotiConst.Notify_BuildingDismantle = "BuildingDismantle"

NotiConst.Notify_InitFleetPortShip = "InitFleetPortShip"
NotiConst.Notify_InitCameraPos = "InitCameraPos"
NotiConst.Notify_UpdatElecInfo = "UpdatElecInfo"
NotiConst.Notify_CloseEditBuildingMod = "CloseEditBuildingMod"

NotiConst.Notify_BuildingInteractiveRefreshView = "BuildingInteractiveRefreshView"
NotiConst.Notify_FormMainDelModel = "FormMainDelModel"
NotiConst.Notify_FormMainEditModel = "FormMainEditModel"
NotiConst.Notify_FormMainRefit = "FormMainRefit"
NotiConst.Notify_FormMainMake = "FormMainMake"
NotiConst.Notify_FormMainClose = "FormMainClose"
NotiConst.Notify_FormModelOpenTabItem = "FormModelOpenTabItem"
NotiConst.Notify_FormModelChangeMod = "FormModelChangeMod"
NotiConst.Notify_FormModelAddCpnt = "FormModelAddCpnt"
NotiConst.Notify_FormModelOnDrag = "FormModelOnDrag"
NotiConst.Notify_FormModelOnDragStart = "FormModelOnDragStart"
NotiConst.Notify_FormModelOnDragEnd = "FormModelOnDragEnd"
NotiConst.Notify_FormModelInputName = "FormModelInputName"

NotiConst.Notify_ExploreFleetLstInit = "ExploreFleetLstInit"

NotiConst.Notify_FleetPortFleetDetails = "FleetPortFleetDetails"
NotiConst.Notify_FleetPortInputName = "FleetPortInputName"
NotiConst.Notify_UpdateFleetName = "UpdateFleetName"


NotiConst.Notify_ShipBodyEditHullProductClick = "ShipBodyEditHullProductClick"
NotiConst.Notify_ShipBodyEditHullProductLine = "ShipBodyEditHullProductLine"
NotiConst.Notify_ShipBodyOpenTabItem = "ShipBodyOpenTabItem"
NotiConst.Notify_ShipBodyGetHullFactData = "ShipBodyGetHullFactData"
NotiConst.Notify_ShipBodyRefreshTime = "ShipBodyRefreshTime"
NotiConst.Notify_ShipBodyRefreshView = "ShipBodyRefreshView"

NotiConst.Notify_FittintEditHullProductClick = "FittintEditHullProductClick"
NotiConst.Notify_FittintEditHullProductLine = "FittintEditHullProductLine"
NotiConst.Notify_FittintOpenTabItem = "FittintOpenTabItem"
NotiConst.Notify_FittintGetHullFactData = "FittintGetHullFactData"
NotiConst.Notify_FittintRefreshTime = "FittintRefreshTime"
NotiConst.Notify_FittintRefreshView = "FittintRefreshView"

NotiConst.Notify_HullFilterMake = "HullFilterMake"
NotiConst.Notify_HullFilterMakeDataKey = "HullFilterMakeKey"

--ModTech
NotiConst.Notify_SelectModTech = "SelectModTech"
NotiConst.Notify_BeginModifyMod = "BeginModifyMod"

NotiConst.ModelFBX_ResPath = 'ModelFBX/Solarsystem/Buildings/'

--MsgBox类型
NotiConst.MessageBoxType = 
{
	Confirm = 1,				--确认
	EnterCancel = 2,			--确认和取消
	Tip = 3,					--提示，自动消失
}

--网络异常枚举
NotiConst.NetException = 
{
	OnConnectSucceed = 0,         --连接成功

    ConnectFailed  = 1,         --连接失败（客户端问题为主）
    OnConnectFailed = 2,            --无法连接（服务器问题为主）
    SendRequestFailed = 3,          --发送失败
    Disconnect = 4,                --断开（各种原因连接后又断开连接了）
    ReceivedError = 5,             --收到错误的包，无法解析
    SendTimeout = 6,               --发送超时

    --提示
    StartWait = 1000,           --开始跑小人
    StopWait = 1001,                  --停止跑小人
}

--语言相关
NotiConst.Language = {
    Afrikaans = 0,
	Arabic = 1,
	Basque = 2,
	Belarusian = 3,
	Bulgarian = 4,
	Catalan = 5,
	Chinese = 6,
	Czech = 7,
	Danish = 8,
	Dutch = 9,
	English = 10,
	Estonian = 11,
	Faroese = 12,
	Finnish = 13,
	French = 14,
	German = 15,
	Greek = 16,
	Hebrew = 17,
	Hugarian = 18,
	Icelandic = 19,
	Indonesian = 20,
	Italian = 21,
	Japanese = 22,
	Korean = 23,
	Latvian = 24,
	Lithuanian = 25,
	Norwegian = 26,
	Polish = 27,
	Portuguese = 28,
	Romanian = 29,
	Russian = 30,
	SerboCroatian = 31,
	Slovak = 32,
	Slovenian = 33,
	Spanish = 34,
	Swedish = 35,
	Thai = 36,
	Turkish = 37,
	Ukrainian = 38,
	Vietnamese = 39,
	ChineseSimplified = 40,
	ChineseTraditional = 41,
	Unknown = 42,
}

--panel显示时遮挡类型(遮挡个人信息、菜单和聊天栏)
NotiConst.EPanelActiveType =
{
    EPAT_None = 0,  --//遮挡全部，都不显示
    EPAT_Player = 1,--//显示顶部的个人信息panel
    EPAT_Menu = 2,  --//显示下方的菜单panel
    EPAT_Chat = 3,  --//显示聊天栏panel
    EPAT_PlayerAndMenu = 4,--//显示顶部的个人信息panel和下方的菜单panel
    EPAT_PlayerAndChat = 5,
    EPAT_ChatAndMenu = 6,
    EPAT_All = 7,	--//全部显示
}

--舰船功能类型
NotiConst.FleetType = 
{
	eFT_Move    = 1, --移动
	eFT_Explore = 2, --探索
	eFT_Detect = 3, --侦查
	eFT_Occupy = 4, --占领殖民
	eFT_Collect = 5, --采集
	eFT_Trade = 6, --贸易
	eFT_Battle = 7, --战斗
}
--舰队默认速度
NotiConst.FleetDefaultSpeed = 3

-- 
NotiConst.PlanetStatus = 
{
	pStatus_empty = 1,					--空闲状态
	pStatus_exploring = 2,				--探索中
	pStatus_exploreResult =3,			--探索结束，查看结果
	pStatus_mining = 4,					--采集中
	pStatus_mineResult = 5,				--采集结束，查看结果
}

--物品类型 
NotiConst.ItemType = 
{
	eIT_ShipModTech = 1,				--舰船组装技术
	eIT_ShipHull	= 2,				--舰体部件
	eIT_ShipCompnt	= 3,				--舰体配件
	eIT_Trait		= 4,				--特性
}

--舰体子类型
NotiConst.ShipHullType =  				
{
	eSHT_Head		= 1,				--舰首
	eSHT_Body		= 2,				--舰中
	eSHT_Tail		= 3,				--舰尾
}

--配件子类型
NotiConst.ShipCompntType =
{
	eSCT_Att		= 1,				--攻击型
	eSCT_Def		= 2,				--防御型
	eSCT_Subsys		= 3,				--子系统
}

--拼装附着点部位
NotiConst.ShipHullAttachPart = 
{
	eSHAP_Head		= 1,				--头
	eSHAP_Tail		= 2,				--尾
	eSHAP_Left		= 3,				--左
	eSHAP_Right		= 4,				--右
	eSHAP_Top		= 5,				--上
	eSHAP_Bottom    = 6,				--下
	eSHAP_Err		= 7,
}

--科技类型
NotiConst.SkillTreeType = 
{
	eSKILLTREE_Building = 31,	--建筑科技
	eSKILLTREE_Production = 32,	--生产效率
	eSKILLTREE_Ship = 33,		--舰船
	eSKILLTREE_Fighting = 34,	--战斗
}

NotiConst.AdditionType = 
{
	eAddition_Percentage = 1,	--百分比加成
	eAddition_Absolute = 2,		--绝对值加成
}

--舰队指令类型
NotiConst.FleetDirectiveType =
{
	eFleetDirective_Collect = 1,	--舰队采集
}
return NotiConst