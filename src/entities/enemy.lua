local Collider = require "src.systems.collider"
local Entity = require "src.entities.entity"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

function Enemy:new(x, y, s, vx, vy)
    local enemy = {
        x = x,
        y = y,
        s = s,
        vx = vx,
        vy = vy
    }

    -- Create collider
    enemy.collider = Collider:new("Enemy")
    enemy.collider.hc:scale(s)

    setmetatable(enemy, self)
    self.__index = self

    return enemy
end

function Enemy:update(dt)
    -- Update position
    self:update_position(dt)

    -- Update collider
    self.collider.hc:moveTo(self.x, self.y)
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0, 1)
    self.collider.hc:draw()
    -- love.graphics.clear()
    -- love.graphics.circle("line", self.x, self.y, 50)

    -- self.collider:draw()
    -- love.graphics.reset()
    -- love.graphics.polygon("line", self.colliders[self.state][self.orientation])
end

return Enemy
