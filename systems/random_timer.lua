local Timer = require "systems.timer"

local RandomTimer = {}

setmetatable(RandomTimer, { __index = Timer })

function RandomTimer:new(duration_min, duration_max, on_finish)
    local random_timer = {
        duration_min = duration_min,
        duration_max = duration_max,
        on_finish = on_finish or function() end
    }
    setmetatable(random_timer, self)
    self.__index = self
    return random_timer
end

function RandomTimer:start()
    self.active = true
    self.duration = math.random(self.duration_min, self.duration_max)
    self.time_left = self.duration
end

return RandomTimer
