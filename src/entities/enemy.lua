local Collider = require "src.systems.collider"
local Entity = require "src.entities.entity"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

Enemy.img = love.graphics.newImage("assets/images/fishy3.png")

function Enemy:new(x, y, size, vx, vy, hearts)
    local enemy = {
        x = x,
        y = y,
        size = size,
        vx = vx,
        vy = vy,
        hearts = hearts
    }

    -- Scale is size
    enemy.sx = size
    enemy.sy = size

    -- Create collider
    enemy.collider = Collider:new("Enemy")
    enemy.collider.hc:scale(enemy.sx)

    -- Add backreference to enemy
    enemy.collider.hc.owner = enemy

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
    if DEBUG then self.collider.hc:draw() end
    love.graphics.draw(
        Enemy.img,
        self.x,
        self.y,
        0,
        self.sx,
        self.sy,
        self.img:getWidth() / 2,
        self.img:getHeight() / 2
    )
end

return Enemy
