local Button = require("ui.button")
local Input = require("systems.input")

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

    menu_state.play_button = Button:new(
        button_x,
        button_y - button_height - button_margin,
        button_width,
        button_height,
        "Play"
    )
    menu_state.options_button = Button:new(
        button_x,
        button_y,
        button_width,
        button_height,
        "Options"
    )
    menu_state.quit_button = Button:new(
        button_x,
        button_y + button_height + button_margin,
        button_width,
        button_height,
        "Quit"
    )



    setmetatable(menu_state, self)
    self.__index = self
    return menu_state
end

function MenuState:update(_)
    -- Detect if the left mouse button was pressed this frame
    local mouse_pressed = Input.mouse_was_pressed(1)

    -- Update all buttons
    self.play_button:update(mouse_pressed)
    self.options_button:update(mouse_pressed)
    self.quit_button:update(mouse_pressed)

    -- Clear mouse pressed state after processing all updates
    Input.clear_mouse_pressed(1)
end

function MenuState:key_pressed(key)
    Input.key_pressed(key)
end

function MenuState:draw()
    self.play_button:draw()
    self.options_button:draw()
    self.quit_button:draw()
end

return MenuState
