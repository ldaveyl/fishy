local Enemy = {}

function Enemy:new(x, y)
    local t = {

    }
    setmetatable(t, self)
    self.__index = self
    return t
end

return Enemy
