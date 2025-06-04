local Collider = {}

function Collider:new(verts)
    local collider = {
        -- Vertices of collider compared to origin.
        -- These are alternating x and y coords
        verts = verts
    }
    setmetatable(collider, self)
    self.__index = self
    return collider
end

function Collider:get_shape(x, y, sx, sy)
    local shape = {}
    for i, v in ipairs(self.verts) do
        if i % 2 == 0 then -- 1-based indexing so x is at position 1 and y at position 2
            table.insert(shape, y + v * sy)
        else
            table.insert(shape, x + v * sx)
        end
    end
    return shape
end

function Collider:draw(x, y, sx, sy)
    local shape = self:get_shape(x, y, sx, sy)
    love.graphics.polygon("line", shape)
end

return Collider
