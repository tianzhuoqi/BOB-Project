-- ToLua底层加载
GlobalMap = require("Core/GlobalMap")
require("misc/functions")
require("Core/class")
require("Core/Extend")
--配置文档
require("Data/Config/xlsInclude")
--全局层加载
NotiConst = require("Common/NotiConst")
--框架的接口类
Facade = require("PureMVC/Patterns/Facade/Facade").Instance()
--Panel和Widget基类
PanelBase = require("Core/UI/PanelBase")
WidgetBase = require("Core/UI/WidgetBase")

PanelRegister = require("Common/PanelRegister")
require("Common/Functions")

--proto
require("Proto/common_pb")
require("Proto/db_pb")
require("Proto/login_pb")
require("Proto/scene_pb")
require("Proto/buildingPort_pb")
require("Proto/node_pb")
require("Proto/bundleInfo_pb")
require("Proto/building_pb")
require("Proto/buildingCollectionPlant_pb")
require("Proto/buildingRefinery_pb")
require("Proto/gm_pb")
require("Proto/buildingModFact_pb")
require("Proto/buildingHullFact_pb")
require("Proto/buildingTech_pb")
require("Proto/publicPart_pb")
require("Proto/user_pb")

--管理类
ManagerLanguage = require("Manager/ManagerLanguage").Instance()
ManagerScene = require("Manager/ManagerScene").Instance()
ManagerTimer = require("Manager/ManagerTimer").Instance()
ManagerNet = require("Manager/ManagerNet").Instance()
ManagerIntro = require("Manager/ManagerIntro").Instance()
Utils = require("Core/Utils").Instance()

UnityWebRequest = require ("UnityEngine.Networking.UnityWebRequest")
ManagerResourceModule = require ("NManagerResourceModule")
AbstractResourceLoader = require ("NAbstractResourceLoader")
GameObjectUtil = require ("NGameObjectUtil")

ManagerNetMsgProcInst = require ("Manager/ManagerNetMsgProc").Instance()
NNetMgrInst = require ("NManagerNet").Instance;

require("NLuaClickEvent")
require("NLuaEventRegister")

-- 主入口函数
function Main()
	-- 关于lua断点调试的代码,这里不需要做任何操作,在发布版的时候,C#层会屏蔽掉操作的,所以这里不要做任何事情!!!
	if NDebug.iseditor == true and NDebug.isdebug == true then
		local breakInfoFun, xpcallFun = require("Core/LuaDebug")("localhost",7003)
	end
	
	StartCoroutine(UpdateVersion)
	--NNetMgrInst:CreateRpcNet(1);
	--NNetMgrInst:StartRpcConnect(1, "127.0.0.1", 6666);
	--NNetMgrInst:SendLuaNetMsg(1, 1, "hello");
	
	--[[local ClsUniverse = require("Game/World/Universe")
	local Univ = ClsUniverse.New();
	local galaxycfg = {};
	galaxycfg.stars = {};
	math.randomseed(os.time());
	for i=1, 10 do 
		galaxycfg.stars[i] = {ResPath="ModelFBX/aise.prefab", pos={(math.random()-0.5)*10, (math.random()-0.5)*10}, scale=math.random()*2};
	end
	
	local GalaxyID = 1;
	for i=0, 10 do 
		for k=0, 10 do 
			galaxycfg.pos={i*20,k*20};
			galaxycfg.Name="Galaxy_"..GalaxyID;
			GalaxyID = GalaxyID+1;
			Univ:AddGalaxy(galaxycfg);
		end
	end
	Univ:OnViewPosChanged(0,0);--]]
end


function UpdateVersion()
	local www = UnityWebRequest.Get(ManagerResourceModule.CDNPath..'/ResourceVersion.txt')
	www:SendWebRequest()
	while true do
		if www.isDone then
			break
		end
	end
	ManagerResourceModule.ResourceVersion = www.downloadHandler.text
	ManagerScene:OpenScene("SUpdate")
end