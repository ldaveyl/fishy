local Button = require "src.ui.button"
local Input = require "src.systems.input"
local Timer = require "src.systems.timer"
local Utils = require "src.utils"

local Menu = {}

Menu.play_button_images = {
    love.graphics.newImage("assets/images/animations/play_button/1.png"),
    love.graphics.newImage("assets/images/animations/play_button/2.png"),
    love.graphics.newImage("assets/images/animations/play_button/3.png")
}
Menu.animation_cycle_time = 0.05

function Menu:new()
    local menu = {
        title = "Main Menu",
    }

    local button_width = WINDOW_WIDTH * 0.5
    local button_height = WINDOW_HEIGHT * 0.2
    local button_margin = 0.03 * WINDOW_HEIGHT
    local button_x = (WINDOW_WIDTH * 0.5) - (button_width * 0.5)
    local button_y = (WINDOW_HEIGHT * 0.5) - (button_height * 0.5)

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

    menu.current_image_index = 1
    -- Create timer for animation (should already start)
    menu.animation_timer = Timer:new(
        Menu.animation_cycle_time,
        function()
            menu.current_image_index = (menu.current_image_index + 1) % 3 + 1
            menu.animation_timer:start()
        end
    )
    menu.animation_timer:start()

    setmetatable(menu, self)
    self.__index = self
    return menu
end

function Menu:update(dt)
    -- Detect if the left mouse button was pressed
    local mouse_pressed = Input.mouse_was_pressed(1)

    self.play_button:update(mouse_pressed)
    self.options_button:update(mouse_pressed)
    self.quit_button:update(mouse_pressed)

    if self.play_button.pressed then
        local Play = require "src.states.play"
        GAME:change_state(Play:new())
    elseif self.quit_button.pressed then
        love.event.quit()
    end

    Input.clear_mouse_pressed(1)

    self.animation_timer:update(dt)
end

function Menu:draw()
    love.graphics.draw(BG, 0, 0, 0, 1)

    if self.play_button:is_mouse_hover() then
        print("I be hoverin")
        -- button_bg_color = button_bg_color_hover
    end
    local current_image = self.play_button_images[self.current_image_index]
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        current_image,
        self.play_button.x,
        self.play_button.y,
        0,
        0.5,
        0.5
    )
    if DEBUG then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.play_button.x, self.play_button.y, self.play_button.width,
            self.play_button.height)
    end



    -- self.options_button:draw()
    -- self.quit_button:draw()
end

return Menu
