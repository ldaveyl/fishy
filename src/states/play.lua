local CooldownBar = require "src.ui.cooldown_bar"
local Enemy = require "src.entities.enemy"
local EnemySpawner = require "src.systems.enemy_spawner"
local HC = require "lib.HC"
local Hearts = require "src.ui.hearts"
local Player = require "src.entities.player"
local Utils = require "src.utils"

local Play = {}

function Play:new()
    -- Inititate play state table
    local play = {}

    -- Create player
    play.player = Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 1, 1, 0, 0, 1)

    -- Add cooldown bar ui
    play.cooldown_bar = CooldownBar:new()

    -- Add health bar ui
    play.hearts = Hearts:new()

    -- Create enemy spawner
    local spawn_margin = 0.05 * WINDOW_HEIGHT -- Margin from top and bottom of screen
    play.enemy_spawner = EnemySpawner:new(40, spawn_margin, 20,
        WINDOW_HEIGHT - (2 * spawn_margin), 0.5, 3.0,
        Enemy, 200)

    setmetatable(play, self)
    self.__index = self
    return play
end

function Play:update(dt)
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

    -- Update hearts UI
    self.hearts.current_value = self.player.hearts

    -- If no lives are left, game over
    if self.player.hearts == 0 then
        -- Clean player environment
        self:clean()

        -- Switch to game over state
        local GameOver = require "src.states.game_over"
        GAME:change_state(GameOver:new())
    end
end

function Play:draw()
    -- Draw spawner region
    if DEBUG then self.enemy_spawner:draw() end

    -- Draw enemies
    if SPAWN_ENEMIES then
        for _, enemy in ipairs(self.enemy_spawner.enemies) do
            enemy:draw()
        end
    end

    -- Draw player
    self.player:draw()

    -- Draw UI
    self.cooldown_bar:draw()
    self.hearts:draw()
end

function Play:clean()
    -- Remove all enemy colliders
    for i = #self.enemy_spawner.enemies, 1, -1 do
        HC.remove(self.enemy_spawner.enemies[i].collider.hc)
    end

    -- Remove player collider
    HC.remove(self.player.collider.hc)
end

return Play
