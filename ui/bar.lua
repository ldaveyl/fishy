local Bar = {}

function Bar:new(x, y, width, height, current_value, max_value)
    local bar = {
        x = x,
        y = y,
        width = width,
        height = height,
        current_value = current_value,
        max_value = max_value
    }
    setmetatable(bar, self)
    self.__index = self
    return bar
end

return Bar
