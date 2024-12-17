local Input = {}

local keys_pressed = {}

function Input.key_pressed(key)
    keys_pressed[key] = true
end

function Input.was_pressed(key)
    if keys_pressed[key] then
        keys_pressed[key] = false
        return true
    end
    return false
end

return Input
