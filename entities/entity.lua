local HC = require "lib.vrld-HC-eb1f285"

local Entity = {}

function Entity:flip_shape_horizontal(shape)
    local shape_flip = {}
    for i, v in ipairs(shape) do
        if i % 2 ~= 0 then -- 1-based indexing so x is at position 1 and y at position 2
            v = -1 * v
        end
        table.insert(shape_flip, v)
    end
    return shape_flip
end

function Entity:create_colliders(shapes)
    local colliders = {}
    for state in pairs(shapes) do
        -- Get shapes
        local shape_fwd = shapes[state]
        local shape_rev = self:flip_shape_horizontal(shapes[state])

        -- Create colliders
        local collider_fwd = HC.polygon(unpack(shape_fwd))
        local collider_rev = HC.polygon(unpack(shape_rev))
        colliders[state] = {
            fwd = collider_fwd,
            rev = collider_rev
        }
    end
    return colliders
end

function Entity:new(x, y, sx, sy, vx, vy, shapes)
    local entity = {
        x = x,                                     -- x spawn coordinate
        y = y,                                     -- y spawn coordinate
        sx = sx,                                   -- x scale
        sy = sy,                                   -- y scale
        vx = vx,                                   -- x start velocity
        vy = vy,                                   -- y start velocity
        shapes = shapes,                           -- Polygon shape
        state = "idle",                            -- State
        orientation = "fwd"                        -- Orientation (fwd or rev)
    }
    self.colliders = self:create_colliders(shapes) -- Create colliders from shapes
    setmetatable(entity, self)
    self.__index = self
    return entity
end

function Entity:update_collider()
    if self.sx > 0 then
        self.orientation = "fwd"
    else
        self.orientation = "rev"
    end
end

function Entity:update_position(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Entity:draw()
    love.graphics.setColor(0, 1, 0)
    self.colliders[self.state][self.orientation]:draw()
    love.graphics.reset()
end

return Entity
