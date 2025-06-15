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

function Game:change_state(state)
    self.state = state
end

return Game
