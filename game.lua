local Input = require("systems.input")
local MenuState = require("states.menu")
local PlayState = require("states.play")

local Game = {}

function Game:new(state)
    local game = {
        -- Create a new game, by default starts in Menu
        state = state or MenuState:new()
    }
    setmetatable(game, self)
    self.__index = self
    return game
end

function Game:update(dt)
    self.state:update(dt)

    -- Start playing game
    if self.state.id == "menu" and self.state.play_button.pressed then
        self:change_state(PlayState:new())
    end
end

function Game:draw()
    self.state:draw()
end

function Game:key_pressed(key)
    if key == "escape" then
        love.event.quit()
    end
    self.state:key_pressed(key)
end

function Game:mouse_pressed(button)
    Input.mouse_pressed(button)
end

function Game:change_state(state)
    self.state = state
end

return Game
