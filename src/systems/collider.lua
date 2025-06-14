---@diagnostic disable: deprecated
local HC = require "lib.HC"
local CollisionPolygon = require "assets.collision_polygon"

local Collider = {}

local function deep_copy_collision_polygon(polygon)
    local copy = {}
    for i = 1, #polygon do
        copy[i] = polygon[i]
    end
    return copy
end

function Collider:new(name)
    local collider = {
        collision_polygon = deep_copy_collision_polygon(CollisionPolygon[name]),
    }

    -- Create collider and flip if necessary
    collider.hc = HC.polygon(unpack(collider.collision_polygon))

    -- Add type to the collider
    collider.hc.type = name

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

return Collider
