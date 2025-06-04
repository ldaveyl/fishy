local Bar = require "src.ui.bar"
local Utils = require "src.utils"

local CooldownBar = {}

setmetatable(CooldownBar, { __index = Bar })

function CooldownBar:new()
    local cooldown_bar = Bar:new(50, 50, 200, 20, 1, 1)
    setmetatable(cooldown_bar, self)
    self.__index = self
    return cooldown_bar
end

function CooldownBar:update(current_value)
    -- Clamp CooldownBar values
    self.current_value = Utils.clamp(current_value, 0, self.max_value)
end

function CooldownBar:draw()
    -- Draw background
    love.graphics.setColor(0.5, 0.5, 0.5) -- Cooldown bar bg
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Calculate current width
    local frac = self.current_value / self.max_value
    local current_width = frac * self.width

    -- Draw CooldownBar bar
    -- local canvas = love.graphics.newCanvas(width, height)
    love.graphics.setColor(1, 1, 1) -- Cooldown bar color
    love.graphics.rectangle("fill", self.x, self.y, current_width, self.height)
end

return CooldownBar
