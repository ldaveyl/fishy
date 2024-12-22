local PlayState = require("states.play")

local Game = {}

function Game:new()
    local game = {
        state = PlayState:new()
    }
    setmetatable(game, self)
    self.__index = self
    return game
end

function Game:update(dt)
    self.state:update(dt)
end

function Game:draw()
    self.state:draw()
end

function Game:keypressed(key)
    -- Quit if escape key was pressed, otherwise send key to state
    if key == "escape" then
        love.event.quit()
    else
        self.state:keypressed(key)
    end
end

return Game
