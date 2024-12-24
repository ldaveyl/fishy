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
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Button
