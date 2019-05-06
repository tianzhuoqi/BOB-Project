-- 最小数值和最大数值指定返回值的范围。
-- @function [parent=#math] clamp
function math.clamp(v, minValue, maxValue)  
    if v < minValue then
        return minValue
    elseif v > maxValue then
        return maxValue
    end
    return v 
end

--字符串分割
function string:split(sep)  
    local sep, fields = sep or ":", {}  
    local pattern = string.format("([^%s]+)", sep)  
    self:gsub(pattern, function (c) fields[#fields + 1] = c end)  
    return fields  
end
