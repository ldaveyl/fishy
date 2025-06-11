local Entity = {}

function Entity:update_position(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return Entity
