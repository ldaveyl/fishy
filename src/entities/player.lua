local Collider = require "src.systems.collider"
local Entity = require "src.entities.entity"
local HC = require "lib.HC"
local Input = require "src.systems.input"
local Timer = require "src.systems.timer"
local Utils = require "src.utils"

local Player = {}

setmetatable(Player, { __index = Entity })

Player.img = love.graphics.newImage("assets/images/fish2.png")

function Player:new(x, y, sx, sy, vx, vy, hearts)
    local player = {
        x = x,
        y = y,
        sx = sx,
        sy = sy,
        vx = vx,
        vy = vy,
        hearts = hearts
    }

    -- Create collider
    player.collider = Collider:new("Player")
    player.collider.hc:scale(sx)

    -- Add additional properties
    player.max_v = 5000           -- Max velocity
    player.max_v_boost = 2000     -- Max velocity during boost
    player.acceleration = 2000    -- Acceleration
    player.friction = 2           -- Friction
    player.boost_time = 0.1       -- Boost time
    player.boost_time_cd = 3      -- Boost time cooldown
    player.can_use_boost = true   -- Track if boost can be used
    player.is_invinsible = false  -- Can player take damage
    player.invinsibility_time = 2 -- How long is player invibsible after taking damage

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

    -- Create timer for invisibility
    player.invinsibility_timer = Timer:new(
        player.invinsibility_time,
        function()
            if DEBUG then print("Invinsibility timer ended") end
            player.is_invinsible = false
        end
    )

    setmetatable(player, self)
    self.__index = self

    return player
end

function Player:update(dt)
    -- Reset acceleration
    local ax, ay = 0, 0
    local flip = false

    -- Update acceleration. Also flip image for left and right movement
    if love.keyboard.isDown("w") then ay = ay - self.acceleration end
    if love.keyboard.isDown("s") then ay = ay + self.acceleration end
    if love.keyboard.isDown("a") then
        ax = ax - self.acceleration
        if self.sx > 0 then flip = true end
    end
    if love.keyboard.isDown("d") then
        ax = ax + self.acceleration
        if self.sx < 0 then flip = true end
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
        if DEBUG then print("Boost activate timer started!") end
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
    self.collider.hc:moveTo(self.x, self.y)

    if flip == true then
        -- Update scale
        self.sx = -1 * self.sx

        -- flip collider horizontally
        self.collider:flip_x()
        self.collider.hc:scale(math.abs(self.sx))
    end


    -- Check for collisions
    for collider, _ in pairs(HC.collisions(self.collider.hc)) do
        if collider.type == "Enemy" and self.is_invinsible == false then
            if DEBUG then print("1 heart taken!") end
            self.hearts = self.hearts - 1
            self.invinsibility_timer:start()
            self.is_invinsible = true
            if DEBUG then print("Invinsibility timer started!") end
        end
    end

    -- Clamp player to screen bounds and reset velocity
    local half_player_width = math.abs(self.sx) * Player.img:getWidth() / 2
    local half_player_height = math.abs(self.sy) * Player.img:getHeight() / 2

    -- Left border
    if self.x < half_player_width then
        self.x = half_player_width
        if self.vx < 0 then self.vx = 0 end

        -- Right border
    elseif self.x > WINDOW_WIDTH - half_player_width then
        self.x = WINDOW_WIDTH - half_player_width
        if self.vx > 0 then self.vx = 0 end
    end

    -- Upper border
    if self.y < half_player_height then
        self.y = half_player_height
        if self.vy < 0 then self.vy = 0 end

        -- Lower border
    elseif self.y > WINDOW_HEIGHT - half_player_height then
        self.y = WINDOW_HEIGHT - half_player_height
        if self.vy > 0 then self.vy = 0 end
    end

    -- Update timers
    self.boost_active_timer:update(dt)
    self.boost_cd_timer:update(dt)
    self.invinsibility_timer:update(dt)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    self.collider.hc:draw()
    love.graphics.draw(
        Player.img,
        self.x,
        self.y,
        0,
        self.sx,
        self.sy,
        self.img:getWidth() / 2,
        self.img:getHeight() / 2
    )
end

return Player
