local Collider = require "src.systems.collider"
local Entity = require "src.entities.entity"
local Timer = require "src.systems.timer"
local Utils = require "src.utils"

local Enemy = {}

setmetatable(Enemy, { __index = Entity })

local function image_with_offset(image_path, x_offset, y_offset)
    return {
        image = love.graphics.newImage(image_path),
        x_offset = x_offset,
        y_offset = y_offset
    }
end

local x_offset = 15
local y_offset = -20

Enemy.images = {
    image_with_offset("assets/images/animations/clownfish/idle/1.png", x_offset, y_offset),
    image_with_offset("assets/images/animations/clownfish/idle/2.png", x_offset, y_offset),
    image_with_offset("assets/images/animations/clownfish/idle/3.png", x_offset, y_offset),
}
Enemy.animation_cycle_time = 0.05

function Enemy:new(x, y, size, vx, vy, hearts)
    local enemy = {
        x = x,
        y = y,
        size = size,
        vx = vx,
        vy = vy,
        hearts = hearts
    }
    enemy.image_size = 0.188 * enemy.size
    enemy.current_image_index = 1 -- Current image to use for animation

    -- Scale is size
    enemy.sx = size
    enemy.sy = size

    -- Create collider
    enemy.collider = Collider:new("Enemy")
    enemy.collider.hc:scale(enemy.sx)

    -- Add backreference to enemy
    enemy.collider.hc.owner = enemy

    -- Create timer for animation (should already start)
    enemy.animation_timer = Timer:new(
        Enemy.animation_cycle_time,
        function()
            enemy.current_image_index = (enemy.current_image_index + 1) % #Enemy.images + 1
            enemy.animation_timer:start()
        end
    )
    enemy.animation_timer:start()

    setmetatable(enemy, self)
    self.__index = self

    return enemy
end

function Enemy:update(dt)
    -- Update position
    self:update_position(dt)

    -- Update collider
    self.collider.hc:moveTo(self.x, self.y)

    self.animation_timer:update(dt)
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0, 1)

    local current_image = Enemy.images[self.current_image_index]
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.draw(
        current_image.image,
        self.x,
        self.y,
        0,
        Utils.sign(self.sx) * self.image_size,
        Utils.sign(self.sy) * self.image_size,
        current_image.image:getWidth() / 2 + current_image.x_offset,
        current_image.image:getHeight() / 2 + current_image.y_offset
    )

    if DEBUG then self.collider.hc:draw() end
end

return Enemy
