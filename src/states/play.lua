local CooldownBar = require "src.ui.cooldown_bar"
local Enemy = require "src.entities.enemy"
local EnemySpawner = require "src.systems.enemy_spawner"
local HC = require "lib.HC"
local Hearts = require "src.ui.hearts"
local Player = require "src.entities.player"
local Score = require "src.ui.score"
local Utils = require "src.utils"

local Play = {}


function Play:new()
    local play = {}

    play.player = Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 1, 0, 0, 1)

    play.cooldown_bar = CooldownBar:new()
    play.hearts = Hearts:new()
    play.score = Score:new()

    local spawn_margin = 0.05 * WINDOW_HEIGHT -- Margin from top and bottom of screen
    play.enemy_spawner = EnemySpawner:new(40, spawn_margin, 100,
        WINDOW_HEIGHT - (2 * spawn_margin), 0.5, 3.0,
        Enemy, 200)
    play.enemies_to_remove = {}
    play.player.owner = play

    setmetatable(play, self)
    self.__index = self
    return play
end

function Play:update(dt)
    self.player:update(dt)

    if SPAWN_ENEMIES then
        self.enemy_spawner:update(dt)
        for _, enemy in ipairs(self.enemy_spawner.enemies) do
            enemy:update(dt)
        end
    end

    local frac = self.cooldown_bar.max_value
    if self.player.boost_active_timer.active then
        frac = Utils.clamp(self.player.boost_active_timer.time_left / self.player.boost_active_timer.duration, 0, 1)
    elseif self.player.boost_cd_timer.active then
        frac = 1 - Utils.clamp(self.player.boost_cd_timer.time_left / self.player.boost_cd_timer.duration, 0, 1)
    end
    self.cooldown_bar:update(frac)

    self.hearts.current_value = self.player.hearts

    for _, enemy in ipairs(self.enemies_to_remove) do
        HC.remove(enemy.collider.hc)

        for i = #self.enemy_spawner.enemies, 1, -1 do
            if self.enemy_spawner.enemies[i] == enemy then
                table.remove(self.enemy_spawner.enemies, i)
                break
            end
        end
    end

    -- If no lives are left, game over
    if self.player.hearts == 0 then
        if DEBUG then print("No hearts left. Game Over.") end

        self:clean()

        local GameOver = require "src.states.game_over"
        GAME:change_state(GameOver:new())
    end
end

function Play:draw()
    love.graphics.draw(BG, 0, 0, 0, 1)

    if DEBUG then self.enemy_spawner:draw() end

    if SPAWN_ENEMIES then
        for _, enemy in ipairs(self.enemy_spawner.enemies) do
            enemy:draw()
        end
    end

    self.player:draw()
    self.cooldown_bar:draw()
    self.hearts:draw()
    self.score:draw()
end

function Play:clean()
    for i = #self.enemy_spawner.enemies, 1, -1 do
        HC.remove(self.enemy_spawner.enemies[i].collider.hc)
    end
    HC.remove(self.player.collider.hc)
end

return Play
