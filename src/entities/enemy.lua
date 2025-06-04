local Entity = require "src.entities.entity"
local HC = require "lib.vrld-HC-eb1f285"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

function Enemy:new(x, y, sx, sy, vx, vy, shapes)
    local enemy = {
        x = x,
        y = y,
        sx = sx,
        sy = sy,
        vx = vx,
        vy = vy,
        state = "idle",
        shapes = shapes,
        collider = HC.circle(x, y, 50)
    }

    setmetatable(enemy, self)
    self.__index = self
    return enemy
end

function Enemy:update(dt)
    -- Update position
    self:update_position(dt)

    -- Update collider
    self.collider:moveTo(self.x, self.y) -- There's a bug here: enemies are moving on top of each other
end

function Enemy:draw()
    -- love.graphics.setColor(1, 0, 0, 0.3)
    -- love.graphics.circle("line", self.x, self.y, 50)
    self.collider:draw()

    -- self.collider:draw()
    -- love.graphics.reset()
    -- love.graphics.polygon("line", self.colliders[self.state][self.orientation])
end

return Enemy
