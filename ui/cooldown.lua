local Cooldown = {}

function Cooldown:new(x, y, width, height, max_cooldown)
    local t = {
        x = x,
        y = y,
        width = width,
        height = height,
        max_cooldown = max_cooldown,
        current_cooldown = max_cooldown
    }
    setmetatable(t, self)
    self.__index = self
    return t
end

return Cooldown
