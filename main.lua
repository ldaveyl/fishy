local Input = require("systems.input")
local Game = require("game")

function love.load()
    -- -- Graphics parameters
    Font = love.graphics.newFont("assets/fonts/ARIALBD.TTF", 64, "none", 2)
    Window_Height = love.graphics.getHeight()
    Window_Width = love.graphics.getWidth()

    -- Create a new game
    NewGame = Game:new()
end

function love.update(dt)
    -- Update game
    NewGame:update(dt)
end

function love.draw()
    NewGame:draw()
end

-- Detect key presses
function love.keypressed(key)
    NewGame:key_pressed(key)
end

-- Detect mouse clicks
function love.mousepressed(x, y, button, istouch, presses)
    NewGame:mouse_pressed(button)
end
