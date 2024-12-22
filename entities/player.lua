-- local Cooldown = require("ui/cooldown")
local Entity = require("entities.entity")
local Input = require("input")
local Timer = require("systems.timer")
local Utils = require("utils")

local Player = {}

setmetatable(Player, { __index = Entity })

function Player:new()
    -- Instance player as new entity
    local player = Entity:new(400, 200, 0.2, 0.2, 0, 0, love.graphics.newImage("assets/images/fish2.png"))

    -- Add additional properties
    player.max_v = 1000
    player.max_v_boost = 2000
    player.acceleration = 2000
    player.friction = 2
    player.boost_time = 0.1
    player.boost_time_cd = 3
    player.can_use_boost = true

    -- Create timer for boost cooldown
    player.boost_cd_timer = Timer:new(
        player.boost_time_cd,
        function()
            player.can_use_boost = true
            print("Boost cooldown timer finished!")
        end)

    -- Create timer for boost activate
    player.boost_active_timer = Timer:new(
        player.boost_time,
        function()
            player.can_use_boost = false
            player.boost_cd_timer:start()
            print("Boost cooldown timer started!")
        end
    )

    setmetatable(player, self)
    self.__index = self

    return player
end

function Player:update(dt)
    -- Reset acceleration
    local ax, ay = 0, 0

    -- Update acceleration. Also flip image for left and right movement
    if love.keyboard.isDown("w") then ay = ay - self.acceleration end
    if love.keyboard.isDown("s") then ay = ay + self.acceleration end
    if love.keyboard.isDown("a") then
        ax = ax - self.acceleration
        if self.sx > 0 then self.sx = -1 * self.sx end
    end
    if love.keyboard.isDown("d") then
        ax = ax + self.acceleration
        if self.sx < 0 then self.sx = -1 * self.sx end
    end

    -- If no movement is provided, apply friction so the player slows down
    if not (love.keyboard.isDown("w") or
            love.keyboard.isDown("s") or
            love.keyboard.isDown("a") or
            love.keyboard.isDown("d")) then
        local friction_factor = 1 - math.min(self.friction * dt, 1)
        self.vx = self.vx * friction_factor
        self.vy = self.vy * friction_factor
    end

    -- Update velocity with acceleration
    self.vx = self.vx + ax * dt
    self.vy = self.vy + ay * dt

    -- Calculate velocity
    local velocity = math.sqrt(self.vx ^ 2 + self.vy ^ 2)

    -- Trigger boost
    if Input.was_pressed("lshift") and self.can_use_boost then
        self.boost_active_timer:start()
        print("Boost activate timer started!")
    end

    -- Clamp velocity to maximum velocity
    if velocity > self.max_v then
        local scale = self.max_v / velocity
        self.vx = self.vx * scale
        self.vy = self.vy * scale
    end

    -- Apply boost (overrides max velocity)
    if self.boost_active_timer.active then
        self.vx = Utils.sign(self.sx) * self.max_v_boost
    end

    -- Update position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Update timers
    self.boost_active_timer:update(dt)
    self.boost_cd_timer:update(dt)
end

function Player:draw()
    -- Get width and height of image
    local width = self.img:getWidth()
    local height = self.img:getHeight()

    -- Draw Player
    love.graphics.draw(self.img, self.x, self.y, self.angle, self.sx, self.sy, width / 2, height / 2)
end

return Player


--     -- Update boost timer UI
--     local cooldown_fraction = 1 - (boost_cooldown_timer.time_left / boost_cooldown_timer.duration)
--     Cooldown.update(cooldown_fraction)
-- end

-- function Player:draw()
--     print("x " .. self.x)
--     -- Get width and height of image
--     local width = self.img:getWidth()
--     local height = self.img:getHeight()

-- -- Draw Player
-- love.graphics.draw(self.img, self.x, self.y, self.angle,
--     self.sx, self.sy, width / 2, height / 2)
-- end

-- return Player
