require("NDebug")

local math_floor = math.floor
--全局函数
--==============================--
-- c#加载lua,统一用require,不使用c#的dofile
function LoadClass(path)
    require(path)
end

function LoadCommand(commandName)
	return require("Game/Command/"..commandName.."Command")
end

function LoadProxy(proxyName,packageName)
	local proxyClass = require("Game/Proxy/"..proxyName.."Proxy")
	if packageName then
		local package = LoadPackage(packageName)
		local proxy = proxyClass.New(proxyName,package)
		return proxy
	end
	return proxyClass
end



function LoadPackage(packageName)
	return require("Game/Package/"..packageName.."Package")
end

function InstantiateObject(className, ...)
	local class = GlobalMap:Class(className)
	if class ~= nil then
		local object = class.New(...)
		local handle = GlobalMap:AddObject(object)
		return handle
	end
	return 0
end

function CallObjectFunction(handle, funcName, ...)
	local object = GlobalMap:Object(handle)
	if object ~= nil then
		local func = object[funcName]
		if func ~= nil then
			return func(object, ...)
		else
			LogError("CallObjectFunction {0}.{1} not Exist!", object.__cname, funcName)
		end
	end
	return nil
end

--位移操作
function IntMoveToLeft(num,n)
    local re = tonumber(num)
    for i=1,n do
        re = math_floor(re*2)
    end
    return re
end
function IntMoveToRight(num,n)
    local re = tonumber(num)
    for i=1,n do
        re = math_floor(re/2)
    end
    return re
end

--table拓展
function table.indexOf( t, value, iBegin )
    for i = iBegin or 1, #t do
        if t[i] == value then
            return i
        end
    end
    return false
end
--string拓展
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function string.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--一个rpc请求对应的回复消息id
function RpcResponseCMDID(cmdid)
	return cmdid+1000
end
--response对应请求
function RpcReqCMDID(respid)
	return respid-1000
end

--获取服务器时间
--
function GetServerTimeStamp(isExact)
	local globalPackage = LoadPackage(NotiConst.Package_Global)
	local time = globalPackage.systemTimestamp + UnityEngine.Time.time - globalPackage.timestampOffset
	if isExact then
		return time
	end
	return time
end

--检测NumberValue非0
function CheckNumNoZeroValue(n)
	return n~=nil and tonumber(n)~=0
end

--物品id计算物品类型
function GetItemTypeByID(id)
	return math_floor(id/10000000)
end

--计算两个transform距离平方
function CalDisSqrMWithTransf(t1,t2)
	if t1 == nil or t2 == nil then
		return 10000000
	end
	local pos1 = t1.position
	local pos2 = t2.position
	local dx = pos2.x-pos1.x
	local dy = pos2.y-pos1.y
	local dz = pos2.z-pos1.z
	return dx*dx + dy*dy + dz*dz
end

function PrintVector3(v3)
	print(string.format("%.2f, %.2f, %.2f", v3.x, v3.y, v3.z))
end

--==============================--
--在切换场景的前,NManagerScene会优先做一次清理
function CleanAllBeforeChangeScene()
	Facade:CleanAll()
	GlobalMap:CleanAll()
end

--==============================--
--多国语言部分
function GetLanguageText(type, key, ...)
	return ManagerLanguage:GetText(type, key, ...)
end

function AddUnit(data)
    if data >= 1000000000 then
        data = (data - data % 100000000) / 1000000000
        return data..'b'
    elseif data >= 1000000 then
        data = (data - data % 100000) / 1000000
        return data..'m'
    elseif data >= 1000 then
        data = (data - data % 100) / 1000
        return data..'k'
    elseif data >= 0 then
        return data
    end
end

--==============================--
--string部分
function StringFormat(str, ...)
	local args = {...}
	local re = str
	for i,v in ipairs(args) do
		local ned = "{"..(i-1).."}"
		re = string.gsub(re,ned,tostring(v))
	end
	return re
end

function OnApplicationStateChange(isPause)
	if not isPause then
		ManagerNet:SycnServerTimestamp()
	else
		ManagerResourceModule.BuildLocalBundleMD5File()
	end
end

--==============================--
--全局UI接口
function RunWaiting()
    Facde:OpenUtilityPanel("UIWaitingPanel")
end

function CloseWaiting()
	Facde:CloseUtilityPanel("UIWaitingPanel")
end

-- type见NotiConst.MessageBoxType
-- args = {			args结构说明
-- 	centerTitle, 		单个按键
-- 	leftTitle,rightTitle,		双个按键
-- 	enterCallback, cancelCallback	--回调函数
-- }
-- 关于callback， 如果是确认或tips，则会调用enterCallback；如果是确认或取消，则分别调用enter和cancel
function OpenMessageBox(type, content, title, args)
	body = {}
	body.content = content
	body.title = title
	body.type = type
	if args ~= nil then
		body.centerTitle = args.centerTitle
		body.leftTitle = args.leftTitle
		body.rightTitle = args.rightTitle
		body.enterCallback = args.enterCallback
		body.cancelCallback = args.cancelCallback
	end
	Facade:OpenUtilityPanel("UIMessageBoxPanel")
	Facade:SendNotification(NotiConst.Utility_OpenMessageBox, body)
end

function CloseMessageBox()
	Facade:CloseUtilityPanel("UIMessageBoxPanel")
end

function OpenTips(content)
	body = {}
	body.content = content
	Facade:OpenUtilityPanel("UITipsPanel")
	Facade:SendNotification(NotiConst.Utility_OpenTips, body)
end

--==============================--
--日志部分,一共5级
function LogDebug(content, ...)
	NDebug.LogDebug(content, ...)
end

function LogInfo(content, ...)
	NDebug.LogInfo(content, ...)
end

function LogWarn(content, ...)
	NDebug.LogWarn(content, ...)
end

function LogError(content, ...)
	NDebug.LogError(content, ...)
end

function LogFatal(content, ...)
	NDebug.LogFatal(content, ...)
end

--==============================--
-- 时间格式转换

--时间戳转 分钟：秒
function SecondToMinutes(time)
    local minutes = time / 60
	local second = time % 60
    return string.format("%d:%02d",math.floor(minutes),math.floor(second))
end

function SecondToHours(time)
	local h = math.floor(time / 3600)
	local m = math.floor(time / 60) % 60
	local s = time % 60
	return string.format( "%d:%02d:%02d",h,m,s)
end


-- 时间格式标准 ， 最多只显示2个单位的时间
-- 5d:10h, 4h:30min, 30min:45s, 45s
-- 如果冒号后面的时间不满1个单位，就不显示。比如5d5s，就只显示5d
function SecondFormat(time)
	if time <= 0 then return string.format("0s") end

	if time >= 86400 then		--大于1天
		local d = math.floor(time / 86400)
		local h = math.floor((time % 86400) / 3600)
		if h > 0 then
			return string.format("%dd %dh", d, h)
		else
			return string.format("%dd", d)
		end
	elseif time >= 3600 then		--大于1小时
		local h = math.floor(time / 3600)
		local m = math.floor((time % 3600) / 60)
		if m > 0 then
			return string.format("%dh %dm", h, m)
		else
			return string.format("%dh", h)
		end
	elseif time >= 60 then		--大于1分钟
		local m = math.floor(time / 60)
		local s = math.floor(time % 60)
		if s > 0 then
			return string.format("%dm %ds", m, s)
		else
			return string.format("%dm", m)
		end
	else
		return string.format("%ds", time)
	end
end
--==============================--
AssetBundle = {
	assetBundleDataTable = nil,
}

--数字转string
function NumberToString(num)
	if type(num) ~= "number" then
		return num
	end

	if num >= 1000000 then
		local temp = math.floor(num/100000)
		return string.format("%.1fM", temp/10):gsub(".0", "")
	elseif num >= 1000 then
		local temp = math.floor(num/100)
		return string.format("%.1fK", temp/10):gsub(".0", "")
	else
		return ""..num
	end
end