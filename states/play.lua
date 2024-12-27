local CooldownBar = require("ui.cooldown")
local Input = require("systems.input")
local Player = require("entities.player")
local Utils = require("utils")

local PlayState = {}

function PlayState:new()
    local play_state = {
        id = "play",
        player = Player:new(),
        cooldown_bar = CooldownBar:new()
    }
    setmetatable(play_state, self)
    self.__index = self
    return play_state
end

function PlayState:update(dt)
    -- Update player
    self.player:update(dt)

    -- Update cooldown UI
    local frac = self.cooldown_bar.max_value
    if self.player.boost_active_timer.active then
        frac = Utils.clamp(self.player.boost_active_timer.time_left / self.player.boost_active_timer.duration, 0, 1)
    elseif self.player.boost_cd_timer.active then
        frac = 1 - Utils.clamp(self.player.boost_cd_timer.time_left / self.player.boost_cd_timer.duration, 0, 1)
    end

    -- Clamp fraction
    self.cooldown_bar:update(frac)
end

function PlayState:draw()
    self.player:draw()
    self.cooldown_bar:draw()
end

function PlayState:key_pressed(key)
    Input.key_pressed(key)
end

return PlayState
