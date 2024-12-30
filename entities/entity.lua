local Entity = {}

function Entity:new(x, y, sx, sy, vx, vy, img)
    local entity = {
        x = x,
        y = y,
        sx = sx,
        sy = sy,
        vx = vx,
        vy = vy,
        img = img
    }
    setmetatable(entity, self)
    self.__index = self
    return entity
end

function Entity:update_position(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Entity:draw()
    -- Get width and height of image
    local width = self.img:getWidth()
    local height = self.img:getHeight()

    -- Draw Entity
    love.graphics.draw(self.img, self.x, self.y, self.angle, self.sx, self.sy, width / 2, height / 2)
end

return Entity
