local MediatorDynamic = class("MediatorDynamic", Mediator)

--动态加载
function MediatorDynamic:LoadResources()
--[[
	resourcesManager:Load(xxxx)
	call back function : LoadComplete
]]
end

function MediatorDynamic:LoadComplete(gameObject)
	self:SetViewComponent(gameObject)
end

return MediatorDynamic