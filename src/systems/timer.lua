local Timer = {}

function Timer:new(duration, on_finish)
    local timer = {
        duration = duration,
        time_left = duration,
        on_finish = on_finish or function() end
    }
    setmetatable(timer, self)
    self.__index = self
    return timer
end

function Timer:start()
    self.active = true
    self.time_left = self.duration
end

function Timer:update(dt)
    if self.active and self.time_left > 0 then
        self.time_left = self.time_left - dt
        if self.time_left <= 0 then
            self.active = false
            self.on_finish()
        end
    end
end

return Timer
