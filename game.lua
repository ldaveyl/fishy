local Input = require "systems.input"
local MenuState = require "states.menu"
local PlayState = require "states.play"

local Game = {}

function Game:new(state)
    local game = {
        -- Default state is the menu
        state = state or MenuState:new()
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
    -- Quit the game if Escape if pressed regardless of current state
    if key == "escape" then
        love.event.quit()
    end

    -- Send key presses to current state
    self.state:key_pressed(key)
end

function Game:mouse_pressed(button)
    Input.mouse_pressed(button)
end

function Game:change_state(state)
    self.state = state
end

return Game
