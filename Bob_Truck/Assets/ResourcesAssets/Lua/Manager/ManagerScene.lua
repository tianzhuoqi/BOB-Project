require("NLoadScene")
require("NUIPanelContainerBase")
NInstPool = require("Common/InstancesPool");

local ManagerScene = class("ManagerScene")

function ManagerScene:ctor()
	self.async = nil
	self.toSceneName = ''
end

function ManagerScene.Instance()
	if ManagerScene.m_instance == nil then
		ManagerScene.m_instance = ManagerScene.New()
	end
	return ManagerScene.m_instance
end

function ManagerScene:DestroyScene(sceneName)
	Facade:SendNotification(sceneName..'Destroy')
end

function ManagerScene:OpenScene(sceneName)
	if sceneName == self.toSceneName then
		return
	end
	self.toSceneName = sceneName
	
	self:DestroyScene(NLoadScene.ActiveSceneName)
	NInstPool.PreLoadScene();
	self.async = NLoadScene.LoadSceneAsync(sceneName)
	self.async.allowSceneActivation = false
	StartCoroutine(ManagerScene.OpenSceneAsync, self.async)
end

function ManagerScene:OpenSceneUseLoadingScene(sceneName)
	if sceneName == self.toSceneName then
		return
	end

	--切换场景时更新下bundleinfo文件
	ManagerResourceModule.BuildLocalBundleMD5File()
	
	self.toSceneName = sceneName
	self:DestroyScene(NLoadScene.ActiveSceneName)
	NInstPool.PreLoadScene();
	NLoadScene.LoadSceneAsync('SLoading')
	self.async = NLoadScene.LoadSceneAsync(sceneName)
	self.async.allowSceneActivation = false
	StartCoroutine(ManagerScene.OpenSceneAsync, self.async)
end

function ManagerScene:OpenSceneAsync(async)
	if async ~= nil then
		while true do
			if async.progress >= 0.85 then
				break
			end
			WaitForFixedUpdate()
			
		end
		CleanAllBeforeChangeScene()
		ManagerResourceModule.Collect()
		async.allowSceneActivation = true
		WaitForFixedUpdate()
		async = nil
	end
end

return ManagerScene