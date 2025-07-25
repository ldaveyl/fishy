local Game = require "src.game"
local Input = require "src.systems.input"

function love.load()
    -- Settings
    DEBUG = true
    SPAWN_ENEMIES = true
    MOVE_THROUGH_BORDERS = true

    -- Seed math.random (otherwise random numbers are the same for every game)
    math.randomseed(os.time())

    -- Set font
    FONT = love.graphics.newFont("assets/fonts/ARIALBD.TTF", 24, "none", 2)

    -- Graphics parameters
    WINDOW_WIDTH, WINDOW_HEIGHT = 1920, 1080

    -- Load background
    BG = love.graphics.newImage("assets/images/notebook_cropped_lq.jpg")

    -- Create a new game
    -- local Play = require "src.states.play"
    -- GAME = Game:new(Play:new())
    GAME = Game:new()
end

function love.update(dt)
    -- Update game
    GAME:update(dt)
end

function love.draw()
    -- Draw game
    GAME:draw()

    -- Display FPS
    if DEBUG then
        local fps = love.timer.getFPS()
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(FONT)
        love.graphics.print(tostring(fps) .. " fps", 10, 10)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function love.keypressed(key)
    -- Quit the game if Escape is pressed
    if key == "escape" then
        love.event.quit()
    end

    -- Detect key presses
    Input.key_pressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Detect mouse clicks
    Input.mouse_pressed(button)
end
