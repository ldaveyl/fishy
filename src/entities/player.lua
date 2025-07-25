local Collider = require "src.systems.collider"
local Entity = require "src.entities.entity"
local HC = require "lib.HC"
local Input = require "src.systems.input"
local Timer = require "src.systems.timer"
local Utils = require "src.utils"

local Player = {}

setmetatable(Player, { __index = Entity })

local function image_with_offset(image_path, x_offset, y_offset)
    return {
        image = love.graphics.newImage(image_path),
        x_offset = x_offset,
        y_offset = y_offset
    }
end

local x_offset = 150
local y_offset = -70

Player.images = {
    image_with_offset("assets/images/animations/player/idle/1.png", x_offset, y_offset),
    image_with_offset("assets/images/animations/player/idle/2.png", x_offset, y_offset),
    image_with_offset("assets/images/animations/player/idle/3.png", x_offset, y_offset),
}
Player.animation_cycle_time = 0.05
Player.size_gain_multiplier = 0.1
Player.score_gain_multiplier = 100
Player.image_size_multiplier = 0.188

function Player:new(x, y, size, vx, vy, hearts)
    local player = {
        x = x,
        y = y,
        size = size,
        vx = vx,
        vy = vy,
        hearts = hearts,
    }
    player.image_size = Player.image_size_multiplier * player.size

    -- Scale is size
    player.sx = size
    player.sy = size

    -- Create collider
    player.collider = Collider:new("Player")
    player.collider.hc:scale(size)

    -- Add additional properties
    player.max_v = 5000            -- Max velocity
    player.max_v_boost = 2000      -- Max velocity during boost
    player.acceleration = 2000     -- Acceleration
    player.friction = 2            -- Friction
    player.boost_time = 0.1        -- Boost time
    player.boost_time_cd = 3       -- Boost time cooldown
    player.can_use_boost = true    -- Track if boost can be used
    player.is_invinsible = false   -- Can player take damage
    player.invinsibility_time = 2  -- How long is player invibsible after taking damage
    player.score = 0               -- Score for highscores
    player.current_image_index = 1 -- Current image to use for animation

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

    -- Create timer for animation (should already start)
    player.animation_timer = Timer:new(
        Player.animation_cycle_time,
        function()
            player.current_image_index = (player.current_image_index + 1) % #Player.images + 1
            player.animation_timer:start()
        end
    )
    player.animation_timer:start()

    setmetatable(player, self)
    self.__index = self

    return player
end

function Player:update(dt)
    -- Reset acceleration
    local ax, ay = 0, 0
    local flip = false

    -- Define movement
    local moving_left = love.keyboard.isDown(Input.left_key)
    local moving_right = love.keyboard.isDown(Input.right_key)
    local moving_up = love.keyboard.isDown(Input.up_key)
    local moving_down = love.keyboard.isDown(Input.down_key)

    -- Update acceleration. Also flip image for left and right movement
    if moving_up then ay = -self.acceleration end
    if moving_down then ay = self.acceleration end
    if moving_left and not moving_right then
        ax = -self.acceleration
        if self.sx > 0 then flip = true end
    end
    if moving_right and not moving_left then
        ax = self.acceleration
        if self.sx < 0 then flip = true end
    end

    -- If no movement is provided, apply friction so the player slows down
    if not (moving_up or moving_down or moving_left or moving_right) then
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

    if flip == true then
        -- Update scale
        self.sx = -1 * self.sx

        -- flip collider horizontally
        self.collider:flip_x()
        self.collider.hc:scale(math.abs(self.size))
    end

    -- Update position
    self:update_position(dt)

    -- Update collider
    self.collider.hc:moveTo(self.x, self.y)

    -- Check for collisions
    for collider, _ in pairs(HC.collisions(self.collider.hc)) do
        if collider.type == "Enemy" and not self.is_invinsible then
            if self.size >= collider.owner.size then
                -- Mark enemy for removal
                table.insert(self.owner.enemies_to_remove, collider.owner)

                -- Update size and collider
                local gain = collider.owner.size * Player.size_gain_multiplier
                local original_size = self.size
                self.size = self.size + gain
                self.image_size = Player.image_size_multiplier * self.size
                self.collider.hc:scale((original_size + gain) / original_size)

                -- Update scale
                self.sx = self.size * Utils.sign(self.sx)
                self.sy = self.size * Utils.sign(self.sy)

                -- Update score
                local score_increase = collider.owner.size * Player.score_gain_multiplier
                self.owner.score:increase_score(score_increase)
            else
                self.hearts = self.hearts - 1
                if DEBUG then print("1 heart taken! " .. self.hearts .. " hearts left.") end
                self.invinsibility_timer:start()
                self.is_invinsible = true
                if DEBUG then print("Invinsibility timer started!") end
            end
        end
    end

    -- Clamp player to screen bounds and reset velocity based on collider
    local bound_left, bound_top, bound_right, bound_bottom = self.collider.hc:bbox()

    local half_player_width = (bound_right - bound_left) / 2

    -- Left and right borders
    -- Player teleports to other side if specified
    if not MOVE_THROUGH_BORDERS then
        if self.x < half_player_width then
            self.x = half_player_width
            self.vx = 0
        elseif self.x > WINDOW_WIDTH - half_player_width then
            self.x = WINDOW_WIDTH - half_player_width
            self.vx = 0
        end
    else
        if self.x < 0 then
            self.x = WINDOW_WIDTH
        elseif self.x > WINDOW_WIDTH then
            self.x = 0
        end
    end

    -- Upper and lower borders
    if bound_top < 0 then
        self.y = self.y - bound_top
        self.vy = 0
    elseif bound_bottom > WINDOW_HEIGHT then
        self.y = self.y + WINDOW_HEIGHT - bound_bottom
        self.vy = 0
    end

    -- Update timers
    self.boost_active_timer:update(dt)
    self.boost_cd_timer:update(dt)
    self.invinsibility_timer:update(dt)
    self.animation_timer:update(dt)
end

function Player:draw()
    local current_image = Player.images[self.current_image_index]
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
    if DEBUG then
        self.collider.hc:draw()
        local cx, cy = self.collider.hc:center()
        love.graphics.circle("fill", cx, cy, 8)         -- small red dot at center
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.circle("fill", self.x, self.y, 4) -- small black dot at center

        local bound_left, bound_top, bound_right, bound_bottom = self.collider.hc:bbox()
        love.graphics.rectangle('line', bound_left, bound_bottom, bound_right - bound_left, bound_top - bound_bottom)

        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.circle("fill", (bound_left + bound_right) / 2, (bound_bottom + bound_top) / 2, 8) -- small green dot at center
    end
end

return Player
