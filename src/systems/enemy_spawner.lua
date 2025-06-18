local Enemy = require "src.entities.enemy"
local RandomTimer = require "src.systems.random_timer"

local EnemySpawner = {}

function EnemySpawner:new(x, y, width, height, min_spawn_rate, max_spawn_rate, enemy_types, max_v)
    local enemy_spawner = {
        x = x,
        y = y,
        width = width,
        height = height,
        min_spawn_rate = min_spawn_rate,
        max_spawn_rate = max_spawn_rate,
        enemy_types = enemy_types,
        max_v = max_v,
        enemies = {},
    }

    -- Create spawn timer
    enemy_spawner.spawn_timer = RandomTimer:new(0.5, 3, function()
        enemy_spawner:spawn()
        if DEBUG then print("Spawned Enemy!") end
        enemy_spawner.spawn_timer:start()
        if DEBUG then print(string.format("Enemy spawner timer started (%ss)", enemy_spawner.spawn_timer.duration)) end
    end)
    enemy_spawner.spawn_timer:start()

    setmetatable(enemy_spawner, self)
    self.__index = self
    return enemy_spawner
end

function EnemySpawner:update(dt)
    -- Update spawn timer
    self.spawn_timer:update(dt)
end

function EnemySpawner:spawn()
    -- Get random coordinates in spawn region (rectangle)
    local x_random = math.random(self.x, self.x + self.width)
    local y_random = math.random(self.y, self.y + self.height)

    -- Get random velocity and size. We use size also for scale
    -- As they are directly correlated.
    local v_random = math.random(100, self.max_v)
    local size_random = math.random(0.5, 2.00)

    -- Spawn enemy at coordinates
    local enemy = Enemy:new(x_random, y_random, size_random, v_random, 0, 1)
    table.insert(self.enemies, 1, enemy)
end

function EnemySpawner:draw()
    -- Show spawn region
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.reset()
end

return EnemySpawner
