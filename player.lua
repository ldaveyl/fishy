local Input = require("input")
local Timer = require("timer")

-- Create player table
local Player = {
    x = 400,
    y = 200,
    max_velocity = 1000,
    max_velocity_boost = 2000,
    acceleration = 2000,
    friction = 2,
    boost_velocity = 1000,
    vx = 0,
    vy = 0,
    sx = 0.2,
    sy = 0.2,
    img = love.graphics.newImage("assets/images/fish2.png"),
    boost_time = 0.1,
    boost_time_cooldown = 3,
}

-- Boost variables
local boost_active_timer = nil
local boost_cooldown_timer = nil
local can_use_boost = true

-- Boost timers
boost_cooldown_timer = Timer:new(Player.boost_time_cooldown, function()
    can_use_boost = true
    print("Boost cooldown timer finished!")
end)
boost_active_timer = Timer:new(Player.boost_time, function()
    can_use_boost = false
    boost_cooldown_timer:start()
    print("Boost activate timer finished, boost cooldown timer started.")
end)

function sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function Player.update(dt)
    -- Reset acceleration
    local ax, ay = 0, 0

    -- Update acceleration. Also flip image for left and right movement
    if love.keyboard.isDown("w") then ay = ay - Player.acceleration end
    if love.keyboard.isDown("s") then ay = ay + Player.acceleration end
    if love.keyboard.isDown("a") then
        ax = ax - Player.acceleration
        if Player.sx > 0 then Player.sx = -1 * Player.sx end
    end
    if love.keyboard.isDown("d") then
        ax = ax + Player.acceleration
        if Player.sx < 0 then Player.sx = -1 * Player.sx end
    end

    -- If no movement is provided, apply friction so the Player slows down
    if not (love.keyboard.isDown("w") or
            love.keyboard.isDown("s") or
            love.keyboard.isDown("a") or
            love.keyboard.isDown("d")) then
        local friction_factor = 1 - math.min(Player.friction * dt, 1)
        Player.vx = Player.vx * friction_factor
        Player.vy = Player.vy * friction_factor
    end

    -- Update velocity with acceleration
    Player.vx = Player.vx + ax * dt
    Player.vy = Player.vy + ay * dt

    -- Calculate velocity
    local velocity = math.sqrt(Player.vx ^ 2 + Player.vy ^ 2)

    -- Trigger boost
    if Input.was_pressed("lshift") and can_use_boost then
        boost_active_timer:start()
        print("Boost activate timer started!")
    end

    -- Clamp velocity to maximum velocity
    if velocity > Player.max_velocity then
        local scale = Player.max_velocity / velocity
        Player.vx = Player.vx * scale
        Player.vy = Player.vy * scale
    end

    -- Apply boost (overrides max velocity)
    if boost_active_timer.active then
        Player.vx = sign(Player.sx) * Player.max_velocity_boost
    end

    -- Update position
    Player.x = Player.x + Player.vx * dt
    Player.y = Player.y + Player.vy * dt

    -- Update boost timers
    boost_active_timer:update(dt)
    boost_cooldown_timer:update(dt)
end

function Player.draw()
    -- Get width and height of image
    local width = Player.img:getWidth()
    local height = Player.img:getHeight()

    -- Draw Player
    love.graphics.draw(Player.img, Player.x, Player.y, Player.angle,
        Player.sx, Player.sy, width / 2, height / 2)

    -- Boost timer draw
    -- love.graphics.print(string.format("Time left: %.2f seconds", Player.boost_timer), 10, 10)
end

return Player
