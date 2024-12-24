local Button = require("ui.button")
local PlayState = require("states.play")

local MenuState = {}

function MenuState:new()
    local menu_state = {
        id = "menu",
        title = "Main Menu",
    }

    -- Add buttons to menu
    local window_height = love.graphics.getHeight()
    local window_width = love.graphics.getWidth()


    -- Button:new(
    --     window_width * 0.5,
    --     window_height * 0.5
    -- )



    setmetatable(menu_state, self)
    self.__index = self
    return menu_state
end

function MenuState:update(dt)
end

function MenuState:key_pressed(key)
    if key == "return" then
        print("YES")
    end
end

function MenuState:draw()
    love.graphics.printf(self.title, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")

    -- Create buttons
    -- local buttons = {
    --     Button:new()
    -- }
end

return MenuState
