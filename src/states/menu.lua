local Button = require "src.ui.button"
local Input = require "src.systems.input"
local Play = require "src.states.play"

local Menu = {}

function Menu:new()
    local menu = {
        title = "Main Menu",
    }

    local button_width = WW * 0.5
    local button_height = WH * 0.2
    local button_margin = 0.03 * WH
    local button_x = (WW * 0.5) - (button_width * 0.5)
    local button_y = (WH * 0.5) - (button_height * 0.5)

    menu.play_button = Button:new(
        button_x,
        button_y - button_height - button_margin,
        button_width,
        button_height,
        "Play"
    )
    menu.options_button = Button:new(
        button_x,
        button_y,
        button_width,
        button_height,
        "Options"
    )
    menu.quit_button = Button:new(
        button_x,
        button_y + button_height + button_margin,
        button_width,
        button_height,
        "Quit"
    )

    setmetatable(menu, self)
    self.__index = self
    return menu
end

function Menu:update(_)
    -- Detect if the left mouse button was pressed
    local mouse_pressed = Input.mouse_was_pressed(1)

    -- Update all buttons
    self.play_button:update(mouse_pressed)
    self.options_button:update(mouse_pressed)
    self.quit_button:update(mouse_pressed)

    -- Button actions
    if self.play_button.pressed then
        GAME:change_state(Play:new())
    elseif self.quit_button.pressed then
        love.event.quit()
    end

    -- Clear mouse pressed
    Input.clear_mouse_pressed(1)
end

function Menu:key_pressed(key)
    -- Send key presses to input
    Input.key_pressed(key)
end

function Menu:draw()
    -- Draw buttons
    self.play_button:draw()
    self.options_button:draw()
    self.quit_button:draw()
end

return Menu
