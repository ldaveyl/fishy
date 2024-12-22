local Game = require("game")

function love.load()
    NewGame = Game:new()
end

function love.update(dt)
    NewGame:update(dt)
end

function love.draw()
    NewGame:draw()
end

function love.keypressed(key)
    NewGame:keypressed(key)
end
