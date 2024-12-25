local Game = require("game")

function love.load()
    -- -- Graphics parameters
    Font = love.graphics.newFont("assets/fonts/ARIALBD.TTF", 64)
    Window_Height = love.graphics.getHeight()
    Window_Width = love.graphics.getWidth()

    -- Create a new game
    NewGame = Game:new()
end

function love.update(dt)
    NewGame:update(dt)
end

function love.draw()
    NewGame:draw()
end

function love.keypressed(key)
    NewGame:key_pressed(key)
end
