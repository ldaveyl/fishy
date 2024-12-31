local Game = require "game"
local PlayState = require "states.play"

function love.load()
    -- Set debug mode
    DEBUG = true

    -- Seed math.random (otherwise random numbers are the same for every game)
    math.randomseed(os.time())

    -- Graphics parameters
    FONT = love.graphics.newFont("assets/fonts/ARIALBD.TTF", 64, "none", 2)
    WH = love.graphics.getHeight()
    WW = love.graphics.getWidth()

    -- Set up physics
    love.physics.setMeter(64) -- 64 px is 1m

    -- Create a new game
    GAME = Game:new(PlayState:new())
end

function love.update(dt)
    -- Update game
    GAME:update(dt)
end

function love.draw()
    -- Draw game
    GAME:draw()

    -- Display FPS
    local fps = love.timer.getFPS()
    if DEBUG then love.graphics.print(tostring(fps) .. " fps") end
end

function love.keypressed(key)
    -- Detect key presses and send to game
    GAME:key_pressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Detect mouse clicks and send to game
    GAME:mouse_pressed(button)
end
