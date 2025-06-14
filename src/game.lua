local Input = require "src.systems.input"
local Menu = require "src.states.menu"

local Game = {}

function Game:new(state)
    local game = {
        -- Default state is the menu
        state = state or Menu:new()
    }
    setmetatable(game, self)
    self.__index = self
    return game
end

function Game:update(dt)
    -- Update current state
    self.state:update(dt)
end

function Game:draw()
    -- Draw game
    self.state:draw()
end

function Game:key_pressed(key)
    -- Quit the game if Escape is pressed regardless of current state
    if key == "escape" then
        love.event.quit()
    end

    -- Send key presses to current state
    self.state:key_pressed(key)
end

function Game:mouse_pressed(button, x, y)
    Input.mouse_pressed(button)
end

function Game:change_state(state)
    self.state = state
end

return Game
