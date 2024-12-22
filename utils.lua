local Utils = {}

function Utils.sign(val)
    return val > 0 and 1 or val < 0 and -1 or 0
end

function Utils.clamp(val, lower, upper)
    return math.max(lower, math.min(upper, val))
end

return Utils
