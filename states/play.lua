local Input = require("input")
local Player = require("entities.player")
local Cooldown = require("ui.cooldown")
local Utils = require("utils")

local PlayState = {}

function PlayState:new()
    local play_state = {
        player = Player:new(),
        cooldown = Cooldown:new()
    }
    setmetatable(play_state, self)
    self.__index = self
    return play_state
end

function PlayState:update(dt)
    -- Update player
    self.player:update(dt)

    -- Update cooldown UI
    local frac = self.cooldown.max_value
    if self.player.boost_active_timer.active then
        frac = Utils.clamp(self.player.boost_active_timer.time_left / self.player.boost_active_timer.duration, 0, 1)
    elseif self.player.boost_cd_timer.active then
        frac = 1 - Utils.clamp(self.player.boost_cd_timer.time_left / self.player.boost_cd_timer.duration, 0, 1)
    end

    -- Clamp fraction
    self.cooldown:update(frac)
end

function PlayState:draw()
    self.player:draw()
    self.cooldown:draw()
end

function PlayState:keypressed(key)
    Input.key_pressed(key)
end

return PlayState
