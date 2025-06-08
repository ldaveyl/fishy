local HC = require "lib.vrld-HC-eb1f285"
local CollisionPolygon = require "assets.collision_polygon"

local Collider = {}

function Collider:new(name)
    local collider = {
        collision_polygon = CollisionPolygon[name]
    }

    -- Create collider and flip if necessary
    collider.hc = HC.polygon(unpack(collider.collision_polygon))

    setmetatable(collider, self)
    self.__index = self

    return collider
end

function Collider:flip_x()
    -- Get center of collider
    local cx, _ = self.hc:center()

    -- Flip collision polygon horizontally
    for i = 1, #self.collision_polygon, 2 do
        self.collision_polygon[i] = 2 * cx - self.collision_polygon[i]
    end

    -- Replace collider
    HC.remove(self.hc)
    self.hc = HC.polygon(unpack(self.collision_polygon))
end

-- function Collider:new(verts)
--     local collider =
--         -- Vertices of collider compared to origin.
--         -- These are alternating x and y coords
--         verts = verts
--     }
--     setmetatable(collider, self)
--     self.__index = self
--     return collider
-- end

-- function Collider:get_shape(x, y, sx, sy)
--     local shape = {}
--     for i, v in ipairs(self.verts) do
--         if i % 2 == 0 then -- 1-based indexing so x is at position 1 and y at position 2
--             table.insert(shape, y + v * sy)
--         else
--             table.insert(shape, x + v * sx)
--         end
--     end
--     return shape
-- end

-- function Collider:draw(x, y, sx, sy)
--     local shape = self:get_shape(x, y, sx, sy)
--     love.graphics.polygon("line", shape)
-- end

return Collider
