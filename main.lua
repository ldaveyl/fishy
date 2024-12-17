local Player = require("player")
local Input = require("input")
local State = require("state")

-- Delegate pressed keys to Input module
function love.keypressed(key)
    Input.key_pressed(key)
end

-- function love.load()
-- end

function love.update(dt)
    Player.update(dt)
    State.update()
end

function love.draw()
    Player.draw()
end
