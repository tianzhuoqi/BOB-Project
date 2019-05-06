local ViewComponent = class("ViewComponent")

function ViewComponent:ctor()
    self.m_coroutineMap = {}
    self.gameObject = nil
end

function ViewComponent:StartCoroutine(cor,...)
    local corId = coroutine.create(cor)
    coroutine.resume(corId,self,...)
    table.insert(self.m_coroutineMap,corId)
    return corId
end

function ViewComponent:StopCoroutine(corId)
    for i=1,#self.m_coroutineMap do
        if self.m_coroutineMap[i] == corId then
            table.remove( self.m_coroutineMap, i)
            break
        end
    end
    coroutine.stop(corId)
end

function ViewComponent:StopAllCoroutines()
    for index,cid in ipairs(self.m_coroutineMap) do
        if cid ~= nil and coroutine.status(cid) ~= "dead" then
            coroutine.stop(cid)
        end
    end
    self.m_coroutineMap = {}
end

function ViewComponent:FindGameObject(objName)
    if self.gameObject == nil then
        return nil
    end
    return self.gameObject.transform:Find(objName).gameObject
end

function ViewComponent:FindComponent(objName, componentName)
    if self.gameObject == nil then
        return nil
    end
    return self.gameObject.transform:Find(objName):GetComponent(componentName)
end

return ViewComponent