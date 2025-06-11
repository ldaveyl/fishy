local Collider = require "src.systems.collider"
local Entity = require "src.entities.entity"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

Enemy.img = love.graphics.newImage("assets/images/fish2.png")

function Enemy:new(x, y, s, vx, vy)
    local enemy = {
        x = x,
        y = y,
        s = s,
        vx = vx,
        vy = vy,
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
    -- love.graphics.draw(
    --     Enemy.img,
    --     self.x,
    --     self.y,
    --     0,
    --     self.s,
    --     self.s,
    --     self.img:getWidth() / 2,
    --     self.img:getHeight() / 2
    -- )

    self.collider.hc:draw()
end

return Enemy
