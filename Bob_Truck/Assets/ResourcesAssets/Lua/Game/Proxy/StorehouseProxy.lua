--仓库Proxy
local StorehouseProxy = class("StorehouseProxy",Proxy)
local UserDataPackage = LoadPackage(NotiConst.Package_UserData)
local UniversePackage = LoadPackage(NotiConst.Package_Universe)

--配置数据
local configData = {
    [22] = {data = DATA_ITEM_RES, relation = {["name_s"] = "res_name_s"}},
    [21] = {data = DATA_ITEM_MIN, relation = {["name_s"] = "min_name_s"}},
    [2] = {data = DATA_SHIP_HULL_TECH, relation = {["name_s"] = "hull_name_s"}},
    [3] = {data = DATA_SHIP_CPNT_TECH, relation = {["name_s"] = "cpnt_name_s"}}
 }

 --背包配置
 local packageConfig = {
    [0] = {21},
    [1] = {22},
    [2] = {2, 3},
    [3] = {}
 }

function StorehouseProxy:OnRegister()
    
end

function StorehouseProxy:OnRemove()

end

function StorehouseProxy:GetStorehouseByNodeId(nodeId)
    local whouse = self.m_data.storehouseData[nodeId]
    if whouse == nil then
        self.m_data.storehouseData[nodeId] = {
            all = {}, 
            byType = {},
            restOfCap = 0,
            totalCap = 0
        }
    end
    return self.m_data.storehouseData[nodeId]
end

function StorehouseProxy:GetItemListByType(nodeId,itemType)
    local whouse = self:GetStorehouseByNodeId(nodeId)
    local list = whouse.byType[itemType]
    if list == nil then
        whouse.byType[itemType] = {}
    end
    return whouse.byType[itemType]
end

--设置仓库的数据，用于初始化数据
function StorehouseProxy:SetStorehouse(nodeId,items,restOfCap,totalCap)
    self:SetItems(nodeId,items)
    local storehouse = self:GetStorehouseByNodeId(nodeId)
    if restOfCap ~= nil then
        storehouse.totalCap = totalCap
    else
        storehouse.totalCap = 0
    end
    if totalCap ~= nil then 
        storehouse.restOfCap = restOfCap
    else
        storehouse.totalCap = 0
    end
end


--设置item
function StorehouseProxy:SetItems(nodeId,items)
    --重置数据
    self.m_data.storehouseData[nodeId] = {
        all = {},
        byType ={},
        restOfCap = 0,
        totalCap = 0
    }

    for i,v in ipairs(items) do
        self:SetItem(nodeId,v)
    end
end

function StorehouseProxy:AddCap(nodeId, num)
    local storehouse = self:GetStorehouseByNodeId(nodeId)
    storehouse.totalCap = storehouse.totalCap + num
    storehouse.restOfCap = storehouse.restOfCap + num
end

--获取仓库的容量
function StorehouseProxy:GetStorehouseTotalCap(nodeId)
    local storehouse = self:GetStorehouseByNodeId(nodeId)
    return storehouse.totalCap
end

--获取仓库的剩余容量
function StorehouseProxy:GetStorehouseRestOfCap(nodeId)
    local storehouse = self:GetStorehouseByNodeId(nodeId)
    return storehouse.restOfCap
end

--是否仓库已满
function StorehouseProxy:IsStorehouseFull( nodeId)
    local restOfCap = self:GetStorehouseRestOfCap(nodeId)
    if restOfCap <= 0 then
        return true
    else
        return false
    end
end

function StorehouseProxy:GetItemType(itemId)
    return math.floor(itemId/10000000)
end

function StorehouseProxy:SetItem(nodeId,item)
    if item == nil then
        return
    end
    local whouse = self:GetStorehouseByNodeId(nodeId)
    local type = self:GetItemType(item.id)
    local wid = 0
    for i,v in ipairs(whouse.all) do
        if v.id == item.id then
            wid = i
            break
        end
    end
    if wid == 0 then
        table.insert(whouse.all,item)
        wid = #whouse.all
        self:SetStorehouseRestOfCap(nodeId,item.id,0,item.num)
    else
        self:SetStorehouseRestOfCap(nodeId,item.id,whouse.all[wid].num,item.num)
        whouse.all[wid] = item
    end

    local wlist = self:GetItemListByType(nodeId,type)
    local iid = 0
    for i,v in ipairs(wlist) do
        if v.id == item.id then
            iid = i
            break
        end
    end
    if iid == 0 then
        table.insert(wlist,whouse.all[wid])
    else
        wlist[iid] = whouse.all[wid]
    end

    return whouse.all[wid]
end

--获取物品数据
function StorehouseProxy:GetItem(nodeId,itemId)
    local type = self:GetItemType(itemId)
    local whouse = self:GetItemListByType(nodeId, type)
    local oldItem = nil
    for i,v in ipairs(whouse) do
        if v.id == itemId then
            oldItem = v
        end
    end
    return oldItem
end

--移除item
function StorehouseProxy:RemoveItem(nodeId,itemId)
    local whouse = self:GetStorehouseByNodeId(nodeId)
    local type = math.floor(itemId/10000000)
    local wid = 0
    for i,v in ipairs(whouse.all) do
        if v.id == itemId then
            self:SetStorehouseRestOfCap(nodeId,itemId,v.num,0)
            table.remove(whouse.all,i)
            break
        end
    end
    local wlist = self:GetItemListByType(nodeId,type)
    for i,v in ipairs(wlist) do
        if v.id == itemId then
            table.remove(wlist,i)
            break
        end
    end
end

--改变添加物品
function StorehouseProxy:AddItemByDatas(nodeId,items)
    if items ~= nil then
        for i,v in ipairs(items) do
            self:AddItemByData(nodeId,v)
        end
    end
end

function StorehouseProxy:AddItemByData(nodeId,item)
    local oldItem = self:GetItem(nodeId,item.id)
    if oldItem then
        self:SetStorehouseRestOfCap(nodeId,item.id,oldItem.num,oldItem.num + item.num)
        oldItem.num = oldItem.num + item.num
    else
        oldItem = self:SetItem(nodeId,item)
    end
    return oldItem
end

function StorehouseProxy:AddItemByNum(nodeId,itemId,num)
    local volume = self:GetItemVolume(itemId)
    local whouse = self:GetStorehouseByNodeId(nodeId)
    local newCap = whouse.restOfCap - num * volume
    if newCap < 0 then
        return nil
    end

    local oldItem = self:GetItem(nodeId,itemId)
    if oldItem then
        self:SetStorehouseRestOfCap(nodeId,itemId,oldItem.num,oldItem.num + num)
        oldItem.num = oldItem.num + num
    else
        LogDebug("ItemId:"..itemId.." dose not exist! Will auto Add")
        oldItem = self:SetItem(nodeId,{
            id = itemId,
            num = num
        })
    end
    return oldItem
end

function StorehouseProxy:UseItemByDatas(nodeId,items)
    if items ~= nil then
        for i,v in ipairs(items) do
            self:UseItemByData(nodeId,v)
        end
    end
end

--改变减少or使用物品
function StorehouseProxy:UseItemByData(nodeId,item)
    local oldItem = self:GetItem(nodeId,item.id)
    if oldItem then
        self:SetStorehouseRestOfCap(nodeId,item.id,oldItem.num,oldItem.num - item.num)
        oldItem.num = oldItem.num - item.num
    else
        LogError("ItemId:"..item.id.." dose not exist!")
    end
    if oldItem.num <= 0 then
        self:RemoveItem(nodeId,item.id)
    end
    return oldItem
end

function StorehouseProxy:UseItemByNum(nodeId,itemId,num)
    local oldItem = self:GetItem(nodeId,itemId)
    if oldItem then
        local oldNum = oldItem.num
        local restNum = oldItem.num - num
        if restNum <= 0 then
            self:RemoveItem(nodeId,itemId)
        else
            oldItem.num = oldItem.num - num
            self:SetStorehouseRestOfCap(nodeId,itemId,oldNum,oldNum - num)
        end
    else
        LogError("ItemId:"..itemId.." dose not exist!")
        --oldItem = self:SetItem(nodeId,item)
    end
    return oldItem
end

function StorehouseProxy:GetResourceInfo(itemId)
    local floor = math.floor
    local value = floor(itemId/100)-floor(itemId/10000)*100
    local id = itemId-value*100
    return id,value
end

--加载仓库背包数据
function StorehouseProxy:InitPackageData(nodeId, index)
    local packageData = packageConfig[index]
    local list = {}
    for i,v in ipairs(packageData) do
        local wlist = self:GetItemListByType(nodeId, v)
        for ii,vv in ipairs(wlist) do
            table.insert(list,vv)
        end
    end
    self.m_data.curRefinedResList = list
    return self.m_data.curRefinedResList
end

--加载提炼厂数据
function StorehouseProxy:InitRefineryData(nodeId, mode)
    local list = {}

    if mode ~= 1 then
        local wlist = self:GetItemListByType(nodeId, 22)
        for ii,vv in ipairs(wlist) do
            table.insert(list,vv)
        end
    end

    if mode ~= 2 then
        wlist = self:GetItemListByType(nodeId, 21)
        for ii,vv in ipairs(wlist) do
            table.insert(list,vv)
        end
    end
    
    self.m_data.curRefinedResList = list
    return self.m_data.curRefinedResList
end

function StorehouseProxy:GetPackageData()
    return self.m_data.curRefinedResList
end

function StorehouseProxy:GetPackageDataByIndex(index)
    return self.m_data.curRefinedResList[index]
end

--获取物品在对应表中的数据
function StorehouseProxy:GetItemConfigData(itemId)
    local type = self:GetItemType(itemId)
    local configData = configData[type]
    if configData == nil then
        return nil
    end
    if configData.data[itemId] == nil then
        LogError("have no item data in config table by id:{0}",itemId)
        return nil
    end
    return { data = configData.data[itemId], EVar = configData.data.EVar, type = type, relation = configData.relation }
end

--物品的基本信息，名字，品质框，icon
function StorehouseProxy:GetItemBaseData(itemId)
    local itemData = self:GetItemConfigData(itemId)
    if itemData ~= nil then
        local level = itemData.data[itemData.EVar["res_lvl_n"]]
        local frame = "c1icbg30"
        local name = itemData.data[itemData.EVar[itemData.relation["name_s"]]]
        local iconName = itemData.data[itemData.EVar["icon_name_s"]]
        local icon = ManagerResourceModule.LuaLoadBundleTexture(iconName)
        local cnType = itemData.data[itemData.EVar["transl_table_name_s"]]
        return name,frame,icon,cnType
    end
    return nil,nil,nil
end

--物品产出时的倍率
function StorehouseProxy:GetItemProduceMultiplier(itemId)
    local itemData = self:GetItemConfigData(itemId)
    if itemData ~= nil then
        local multiplier = itemData.data[itemData.EVar["multiplier_n"]]
        return multiplier
    end
    return 0
end

--读表获取物品在仓库中的体积
function StorehouseProxy:GetItemVolume(itemId)
    local itemConfig = self:GetItemConfigData(itemId)
    if itemConfig == nil then
        LogError("Can not find configData by item:{0}",itemId)
        return 0
    end
    local volume = itemConfig.data[itemConfig.EVar["stor_unit_n"]]
    volume = volume == nil and 1 or volume
    return volume
end

--计算物品数量改变后仓库剩余容量
function StorehouseProxy:SetStorehouseRestOfCap(nodeId,itemId,oldItemCount,newItemCount)
    local volume = self:GetItemVolume(itemId)
    local storehouse = self:GetStorehouseByNodeId(nodeId)
    local newCap = storehouse.restOfCap - (newItemCount - oldItemCount) * volume
    storehouse.restOfCap = math.max(newCap,0)
end

--节点仓库货物数据
function StorehouseProxy:SetStorehouseNodeData(itemsData)
    self.m_data.storehouseNodeData = itemsData
end

function StorehouseProxy:GetStorehouseNodeData()
    return self.m_data.storehouseNodeData
end

function StorehouseProxy:GetStorehouseNodeByIndex(index)
    return self.m_data.storehouseNodeData[index]
end

return StorehouseProxy