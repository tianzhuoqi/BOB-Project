local Utils = class("Utils")

function Utils:ctor()
    self.beginTime = os.time()                   	--客户端开始时刻，单位：秒
	self.serverTimeZoneSeconds = 0					--服务器的时区时间戳，单位：秒
end

function Utils.Instance()
	if Utils.m_instance == nil then
		Utils.m_instance = Utils.New()
	end

	return Utils.m_instance
end

--客户端开始时刻
function Utils:BeginTime()
	return self.beginTime
end

--服务器时间
function Utils:ServerTime()
	return self.serverTimeZoneSeconds
end

--设置服务器时间
function Utils:SetServerTime(time)
	self.serverTimeZoneSeconds = time
end

--获取客户端时区的hour值
function Utils:GetTimeZoneHour()
	local localDate = self:GetLocalDateTimeByTimestamps(0)

	local timeZone = ''
	if localDate.Day ~= 1 then
		if localDate.Minute ~= 0 then
			timeZone = string.format("%d.%d", localDate.Hour - 24 + 1, localDate.Minute)
		else
			timeZone = string.format("%d.%d", localDate.Hour - 24, localDate.Minute)
		end
	else
		timeZone = string.format('%d.%d', localDate.Hour, localDate.Minute)
	end

	return timeZone
end

--根据服务器给的时间戳，获取对应的dateTime
function Utils:GetDateTimeByTimestamps(timestamp)
	local date = System.DateTime.New(1970, 1, 1)
	date = date:AddSeconds(timestamp + self.serverTimeZoneSeconds)
	return date
end

--根据时间戳，获取对应本地时区的时间
function Utils:GetLocalDateTimeByTimestamps(timestamp)
	local date = System.DateTime.New(1970, 1, 1)
	date = date:AddSeconds(timestamp)
	date = date:ToLocalTime()
	return date
end

return Utils

