local Physics = {}

function Physics.begin_contact(a, b, collision)
    local x, y = collision:getNormal()
    local text_a = a:getUserData()
    local text_b = b:getUserData()
    local text = text_a .. " colliding with " .. text_b .. " with a vector normal of: " .. x .. ", " .. y
    return text
end

return Physics
