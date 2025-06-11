local Hearts = {}

function Hearts:new()
    local hearts = {
        x = 0.95 * WW, -- x and y of right-most heart
        y = 0.05 * WH,
        s = 0.5,
        current_value = 3,
        max_value = 3,
        padding = 150,
        img = love.graphics.newImage("assets/images/fish2.png")
    }
    setmetatable(hearts, self)
    self.__index = self
    return hearts
end

function Hearts:draw()
    for i = 0, self.current_value - 1 do
        love.graphics.draw(
            self.img,
            self.x - i * self.padding,
            self.y,
            0,
            self.s,
            self.s,
            self.img:getWidth() / 2,
            self.img:getHeight() / 2
        )
    end
end

return Hearts
