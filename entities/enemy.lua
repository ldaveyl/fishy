local Entity = require "entities.entity"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

function Enemy:new(x, y, sx, sy, vx, vy, shape)
    local enemy = Entity:new(x, y, sx, sy, vx, vy, shape)
    setmetatable(enemy, self)
    self.__index = self
    return enemy
end

function Enemy:update(dt)
    -- Set position
    self:update_position(dt)
end

function Enemy:draw()
    local shape = self:get_shape(self.x, self.y, self.sx, self.sy)
    love.graphics.setLineWidth(2)
    love.graphics.setColor(1, 0, 0)
    love.graphics.polygon("line", shape)
    love.graphics.reset()
end

return Enemy
