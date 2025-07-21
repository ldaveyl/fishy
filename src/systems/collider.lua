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
    collider.hc = HC.polygon(unpack(collider.collision_polygon))
    collider.hc.type = name

    setmetatable(collider, self)
    self.__index = self

    return collider
end

function Collider:flip_x()
    for i = 1, #self.collision_polygon, 2 do
        self.collision_polygon[i] = -self.collision_polygon[i]
    end
    HC.remove(self.hc)
    self.hc = HC.polygon(unpack(self.collision_polygon))
end

return Collider
