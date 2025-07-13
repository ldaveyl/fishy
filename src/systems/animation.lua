-- local Timer = require "src.systems.timer"

-- local Animation = {}

-- function Animation:new(images, timer)
--     local animation = {
--         images = images,
--         current_image_index = 0
--     }

--     animation.timer = Timer:new(0.1, function() end)

--     setmetatable(animation, self)
--     self.__index = self

--     return animation
-- end

-- function Animation:update()

-- end

-- player.boost_cd_timer = Timer:new(
--     player.boost_time_cd,
--     function()
--         player.can_use_boost = true
--         if DEBUG then print("Boost cooldown timer finished") end
--     end)
