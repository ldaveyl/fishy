local Button = {}

function Button:is_mouse_hover()
    local mouse_x, mouse_y = love.mouse.getPosition()
    if (mouse_x and mouse_y) then
        local hover = mouse_x >= self.x and mouse_x <= self.x + self.width and mouse_y >= self.y and
            mouse_y <= self.y + self.height
        return hover
    end
end

function Button:new(x, y, width, height, img)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        img = img,
    }
    setmetatable(button, self)
    self.__index = self
    return button
end

function Button:update(mouse_pressed)
    if mouse_pressed and self:is_mouse_hover() then
        self.pressed = true
    else
        self.pressed = false
    end
end

return Button
