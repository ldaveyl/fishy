local Entity = {}

function Entity:new(x, y, sx, sy, vx, vy, img)
    local entity = {
        x = x,
        y = y,
        sx = sx,
        sy = sy,
        vx = vx,
        vy = vy,
        img = img
    }
    setmetatable(entity, self)
    self.__index = self
    return entity
end

return Entity
