local Entity = require "entities.entity"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

function Enemy:new(x, y, sx, sy, vx, vy, img)
    local enemy = Entity:new(x, y, sx, sy, vx, vy, img)
    setmetatable(enemy, self)
    self.__index = self
    return enemy
end

function Enemy:update(dt)
    -- Set position
    self:update_position(dt)
end

return Enemy
