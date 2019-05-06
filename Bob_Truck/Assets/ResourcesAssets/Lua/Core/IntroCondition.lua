local IntroConditionType = {
    None = 0,
    Test = 1,  --
}

local IntroCondition = class("IntroCondition")

function IntroCondition:ctor()
    self.functionMap = {}

    self.functionMap[IntroConditionType.Test] = self.Test
end

function IntroCondition.Instance()
	if IntroCondition.m_instance == nil then
		IntroCondition.m_instance = IntroCondition.New()
	end
	return IntroCondition.m_instance
end

function IntroCondition:CheckCondition(introId, condData)
    local result = false
    local check = self.functionMap[tonumber(condData[1])]
    if check ~= nil and type(check) == "function" then
        result = check(self, introId, condData)
    end
    return result
end

function IntroCondition:Test(introId, condData)
    LogDebug("IntroCondition:Test {0}", #condData)
    return true
end

return IntroCondition