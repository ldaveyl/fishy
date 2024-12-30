local Input = require "systems.input"
local Enemy = require "entities.enemy"
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
end

function love.keypressed(key)
    -- Detect key presses and send to game
    GAME:key_pressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Detect mouse clicks and send to game
    GAME:mouse_pressed(button)
end
