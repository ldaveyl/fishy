local CollisionShape = require "assets.collision_shape"
local Entity = require "entities.entity"
local HC = require "lib.vrld-HC-eb1f285"
local Input = require "systems.input"
local Timer = require "systems.timer"
local Utils = require "utils"

local Player = {}

setmetatable(Player, { __index = Entity })

function Player:new()
    -- Define player vars
    local x = WW / 2
    local y = WH / 2
    local sx = 1
    local sy = 1
    local vx = 0
    local vy = 0
    local shapes = CollisionShape["Player"]

    -- Create player
    local player = Entity:new(x, y, sx, sy, vx, vy, shapes)

    player:create_colliders(shapes)

    -- Add additional properties
    player.max_v = 1000         -- Max velocity
    player.max_v_boost = 2000   -- Max velocity during boost
    player.acceleration = 2000  -- Acceleration
    player.friction = 2         -- Friction
    player.boost_time = 0.1     -- Boost time
    player.boost_time_cd = 3    -- Boost time cooldown
    player.can_use_boost = true -- Track if boost can be used

    -- Create timer for boost cooldown
    player.boost_cd_timer = Timer:new(
        player.boost_time_cd,
        function()
            player.can_use_boost = true
            if DEBUG then print("Boost cooldown timer finished") end
        end)

    -- Create timer for boost activate
    player.boost_active_timer = Timer:new(
        player.boost_time,
        function()
            player.can_use_boost = false
            player.boost_cd_timer:start() -- After boost is finished immediately start boost cooldown timer
            if DEBUG then print("Boost cooldown timer started") end
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
    if Input.key_was_pressed("lshift") and self.can_use_boost then
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
    self:update_position(dt)

    -- Update collider
    self:update_collider()
    self.colliders[self.state][self.orientation]:moveTo(self.x, self.y)

    -- Update timers
    self.boost_active_timer:update(dt)
    self.boost_cd_timer:update(dt)
end

return Player
