local UpdateMediator = class("UpdateMediator", MediatorDynamic)

function UpdateMediator:ctor(mediatorName) 
    UpdateMediator.super.ctor(self, mediatorName)
end

function UpdateMediator:OnRegister()
	UpdateMediator.super.OnRegister(self)
end

function UpdateMediator:NeedUpdate()
	ManagerScene:OpenScene("SLogin")
end

function UpdateMediator:DownLoadAssetBundleDataTableFile()
	local coCID
	for i = 1, #AssetBundle.assetBundleDataTable['BundleFileNames'] do
		coCID = StartCoroutine(UpdateMediator.DownLoadFile, AssetBundle.assetBundleDataTable['BundleFileNames'][i], AssetBundle.assetBundleDataTable['MD5'][i])
		Yield(coCID) 
	end

	ManagerScene:OpenScene("SLogin")
end

function UpdateMediator:DownLoadFile(fileName, md5)
	if ManagerResourceModule.IsPrsistentDataExists(fileName) then
		if ManagerResourceModule.CalculateMD5(ManagerResourceModule.ApplicationPersistentDataPath..'/'..fileName) == md5 then
			return
		end
	end

	local www = UnityWebRequest.Get(ManagerResourceModule.CDNPath..'/'..ManagerResourceModule.RuntimePlatformDir..'/'..ManagerResourceModule.ResourceVersion..'/'..fileName)
	www:SendWebRequest()
	while true do
		if www.isDone then
			local filePath = ManagerResourceModule.CreaterFile(fileName, www.downloadHandler.data)
			break
		else
			WaitForSeconds(0.1)
		end
	end
end

return UpdateMediator