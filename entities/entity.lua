local Entity = {}

function Entity:new(x, y, sx, sy, vx, vy, img)
    local entity = {
        x = x,     -- x spawn coordinate
        y = y,     -- y spawn coordinate
        sx = sx,   -- x scale
        sy = sy,   -- y scale
        vx = vx,   -- x start velocity
        vy = vy,   -- y start velocity
        img = img, -- image
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

    -- Draw entity
    love.graphics.draw(self.img, self.x, self.y, self.angle, self.sx, self.sy, width / 2, height / 2)
end

return Entity
