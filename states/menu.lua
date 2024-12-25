local Button = require("ui.button")
-- local PlayState = require("states.play")

local MenuState = {}

function MenuState:new()
    local menu_state = {
        id = "menu",
        title = "Main Menu",
    }

    local button_width = Window_Width * 0.5
    local button_height = Window_Height * 0.2
    local button_margin = 0.03 * Window_Height
    local button_x = (Window_Width * 0.5) - (button_width * 0.5)
    local button_y = (Window_Height * 0.5) - (button_height * 0.5)

    local buttons = {
        Button:new(
            button_x,
            button_y - button_height - button_margin,
            button_width,
            button_height,
            "Play"
        ),
        Button:new(
            button_x,
            button_y,
            button_width,
            button_height,
            "Options"
        ),
        Button:new(
            button_x,
            button_y + button_height + button_margin,
            button_width,
            button_height,
            "Quit"
        )
    }

    menu_state.buttons = buttons

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
    -- love.graphics.printf(self.title, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

return MenuState
