local Utils = {}

function Utils.sign(val)
    return val > 0 and 1 or val < 0 and -1 or 0
end

function Utils.clamp(val, lower, upper)
    return math.max(lower, math.min(upper, val))
end

function Utils.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Utils.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

return Utils
