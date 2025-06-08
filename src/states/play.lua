local CooldownBar = require "src.ui.cooldown_bar"
local Enemy = require "src.entities.enemy"
local EnemySpawner = require "src.systems.enemy_spawner"
local Input = require "src.systems.input"
local Player = require "src.entities.player"
local Utils = require "src.utils"


local PlayState = {}

function PlayState:new()
    -- Inititate play state table
    local play_state = {}

    -- Create player
    local x = WW / 2
    local y = WH / 2
    local s = 2
    local vx = 0
    local vy = 0
    play_state.player = Player:new(x, y, s, vx, vy)

    -- Add cooldown bar ui
    play_state.cooldown_bar = CooldownBar:new()

    -- Create enemy spawner
    local spawn_margin = 0.05 * WH -- Margin form top and bottom of screen
    play_state.enemy_spawner = EnemySpawner:new(40, spawn_margin, 20, WH - (2 * spawn_margin), 0.5, 3.0, Enemy, 200)

    setmetatable(play_state, self)
    self.__index = self
    return play_state
end

function PlayState:update(dt)
    -- Update player
    self.player:update(dt)

    -- Update enemy spawner
    if SPAWN_ENEMIES then
        self.enemy_spawner:update(dt)

        -- Update enemies
        for _, enemy in ipairs(self.enemy_spawner.enemies) do
            enemy:update(dt)
        end
    end

    -- Update cooldown bar
    local frac = self.cooldown_bar.max_value
    if self.player.boost_active_timer.active then
        frac = Utils.clamp(self.player.boost_active_timer.time_left / self.player.boost_active_timer.duration, 0, 1)
    elseif self.player.boost_cd_timer.active then
        frac = 1 - Utils.clamp(self.player.boost_cd_timer.time_left / self.player.boost_cd_timer.duration, 0, 1)
    end
    self.cooldown_bar:update(frac)
end

function PlayState:draw()
    -- Draw spawner region
    if DEBUG then self.enemy_spawner:draw() end

    -- Draw UI
    self.cooldown_bar:draw()

    -- Draw enemies
    if SPAWN_ENEMIES then
        for _, enemy in ipairs(self.enemy_spawner.enemies) do
            enemy:draw()
        end
    end

    -- Draw player
    self.player:draw()
end

function PlayState:key_pressed(key)
    Input.key_pressed(key)
end

return PlayState
