local Button = require "src.ui.button"
local Game = require "src.game"
local Input = require "src.systems.input"

local GameOver = {}

function GameOver:new()
    local game_over = {
        title = "Game Over"
    }

    local button_width = WINDOW_WIDTH * 0.5
    local button_height = WINDOW_HEIGHT * 0.2
    local button_margin = 0.03 * WINDOW_HEIGHT
    local button_x = (WINDOW_WIDTH * 0.5) - (button_width * 0.5)
    local button_y = (WINDOW_HEIGHT * 0.5) - (button_height * 0.5)

    game_over.restart_button = Button:new(
        button_x,
        button_y + 0.5 * button_height + button_margin,
        button_width,
        button_height,
        "Play again"
    )
    game_over.main_menu_button = Button:new(
        button_x,
        button_y - 0.5 * button_height - button_margin,
        button_width,
        button_height,
        "Main Menu"
    )

    setmetatable(game_over, self)
    self.__index = self
    return game_over
end

function GameOver:update(_)
    -- Detect if the left mouse button was pressed
    local mouse_pressed = Input.mouse_was_pressed(1)

    -- Update all buttons
    self.restart_button:update(mouse_pressed)
    self.main_menu_button:update(mouse_pressed)

    -- Button actions
    if self.restart_button.pressed then
        local Play = require "src.states.play"
        GAME = Game:new(Play:new())
    elseif self.main_menu_button.pressed then
        local Menu = require "src.states.menu"
        GAME = Game:new(Menu:new())
    end

    -- Clear mouse pressed
    Input.clear_mouse_pressed(1)
end

function GameOver:key_pressed(key)
    -- Send key presses to input
    Input.key_pressed(key)
end

function GameOver:draw()
    -- Draw buttons
    self.restart_button:draw()
    self.main_menu_button:draw()
end

return GameOver
