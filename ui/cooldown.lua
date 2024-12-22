local Bar = require("ui.bar")
local Utils = require("utils")

local Cooldown = {}

setmetatable(Cooldown, { __index = Bar })

function Cooldown:new()
    local cooldown = Bar:new(50, 50, 200, 20, 1, 1)
    setmetatable(cooldown, self)
    self.__index = self
    return cooldown
end

function Cooldown:update(current_value)
    -- Clamp cooldown values
    self.current_value = Utils.clamp(current_value, 0, self.max_value)
end

function Cooldown:draw()
    -- Draw background
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Calculate current width
    local cooldown_percentage = self.current_value / self.max_value
    local current_width = cooldown_percentage * self.width

    -- Draw cooldown bar
    love.graphics.setColor(1, 1, 1) -- Gradient from red to green
    love.graphics.rectangle("fill", self.x, self.y, current_width, self.height)
end

return Cooldown



-- -- Create cooldown ui table
-- local Cooldown = {
--     x = 50,
--     y = 50,
--     width = 200,
--     height = 20,
--     max_cooldown = 1,
--     current_value = 1,
-- }

-- function Cooldown.update(new_cooldown)
--     -- Clamp cooldown values
--     Cooldown.current_value = math.max(0, math.min(new_cooldown, Cooldown.max_cooldown))
-- end

-- function Cooldown.draw()
--     -- Draw background
--     love.graphics.setColor(0.5, 0.5, 0.5)
--     love.graphics.rectangle("fill", Cooldown.x, Cooldown.y, Cooldown.width, Cooldown.height)

--     -- Calculate current width
--     local cooldown_percentage = Cooldown.current_value / Cooldown.max_cooldown
--     local current_width = cooldown_percentage * Cooldown.width

--     -- Draw cooldown bar
--     love.graphics.setColor(1, 1, 1) -- Gradient from red to green
--     love.graphics.rectangle("fill", Cooldown.x, Cooldown.y, current_width, Cooldown.height)
-- end

-- return Cooldown


-- local Cooldown = {}

-- function Cooldown:new(x, y, width, height, max_value)
