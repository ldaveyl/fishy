local Input = require("input")

local State = {}

-- Close game
function State.update()
    if Input.was_pressed("escape") then
        love.event.quit()
    end
end

return State
