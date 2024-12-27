local Input = {}

local keys_pressed = {}
local mouse_buttons_pressed = {}

function Input.key_pressed(key)
    keys_pressed[key] = true
end

function Input.key_was_pressed(key)
    if keys_pressed[key] then
        keys_pressed[key] = false
        return true
    end
    return false
end

function Input.mouse_pressed(button)
    mouse_buttons_pressed[button] = true
end

function Input.mouse_was_pressed(button)
    return mouse_buttons_pressed[button] or false
end

function Input.clear_mouse_pressed(button)
    mouse_buttons_pressed[button] = false
end

return Input
