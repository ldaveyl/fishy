local Input = require "systems.input"

local Button = {}

local button_bg_color_normal = { 0.13, 0.24, 0.46, 1.0 }
local button_bg_color_hover = { 0.26, 0.48, 0.92, 1.0 }
local button_text_color = { 1, 1, 1, 1 }

function Button:is_mouse_hover()
    local mouse_x, mouse_y = love.mouse.getPosition()
    local hover = mouse_x >= self.x and mouse_x <= self.x + self.width and mouse_y >= self.y and
        mouse_y <= self.y + self.height
    return hover
end

function Button:new(x, y, width, height, text)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
    }
    setmetatable(button, self)
    self.__index = self
    return button
end

function Button:update(mouse_pressed)
    -- Detect if button was pressed
    if mouse_pressed and self:is_mouse_hover() then
        self.pressed = true
    else
        self.pressed = false
    end
end

function Button:draw()
    -- Check if mouse is hovering over button and change background color of button
    local button_bg_color = button_bg_color_normal
    if self:is_mouse_hover() then
        button_bg_color = button_bg_color_hover
    end

    -- Background
    love.graphics.setColor(button_bg_color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Text
    local text_width = FONT:getWidth(self.text)
    local text_height = FONT:getHeight(self.text)
    love.graphics.setColor(button_text_color)
    love.graphics.print(
        self.text,
        FONT,
        self.x + (self.width * 0.5) - (text_width * 0.5),
        self.y + (self.height * 0.5) - (text_height * 0.5)
    )
end

return Button
