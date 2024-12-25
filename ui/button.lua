local Button = {}

function Button:new(x, y, width, height, text, on_hover, on_click)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        on_click = on_click or function() end,
        on_hover = on_hover or function() end
    }
    setmetatable(button, self)
    self.__index = self
    return button
end

function Button:draw()
    -- Background
    love.graphics.setColor(0.13, 0.24, 0.46, 1.0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Text
    local text_width = Font:getWidth(self.text)
    local text_height = Font:getHeight(self.text)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        self.text,
        Font,
        self.x + (self.width * 0.5) - (text_width * 0.5),
        self.y + (self.height * 0.5) - (text_height * 0.5)
    )
end

return Button
