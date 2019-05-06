require("NLanguage")
require("UIFont")

local ManagerLanguage = class("ManagerLanguage")

function ManagerLanguage:ctor()
    self.LanguagePath = "Data/Language/"
    self.loaded = {}
    self.currentLanguage = NLanguage.GetCurrentLanguage()
    self.languageMap = {}
end

function ManagerLanguage.Instance()
	if ManagerLanguage.m_instance == nil then
		ManagerLanguage.m_instance = ManagerLanguage.New()
	end
	return ManagerLanguage.m_instance
end

function ManagerLanguage:Release()
    self.languageMap = {}
    for i,v in ipairs(self.loaded) do
        package.loaded[v] = nil
    end
    self.loaded = {}

    --不要轻易调用GC
    --collectgarbage("collect")
end

function ManagerLanguage:GetLanguageName(type)
    for k,v in pairs(NotiConst.Language) do
        if v == type then
            return k
        end
    end
    return nil
end

function ManagerLanguage:LoadTextAsset(type)
    local file = self.LanguagePath..type.."_"..self:GetLanguageName(self.currentLanguage)
    local moduleName = string.gsub(file,"/",".")
    table.insert(self.loaded,moduleName)
    self.languageMap[type] = require(file)
end

function ManagerLanguage:GetText(type, key, ...)
    if not self.languageMap[type] then
        self:LoadTextAsset(type)
    end
    local text = self.languageMap[type][key]
    if text == nil then
        LogError("TextKey:"..key.." in "..type.." at lang "..self.currentLanguage.." not exist!")
        return key
    end
    return StringFormat(text,...)
end

function ManagerLanguage:ChangeLanguage(languageType)
    self:Release()
    self.currentLanguage = languageType
end

return ManagerLanguage