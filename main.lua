local Game = require "src.game"
local Push = require "lib.push"


function love.load()
    -- Settings
    DEBUG = true
    SPAWN_ENEMIES = true

    -- Seed math.random (otherwise random numbers are the same for every game)
    math.randomseed(os.time())

    -- Set font
    FONT = love.graphics.newFont("assets/fonts/ARIALBD.TTF", 64, "none", 2)

    -- Graphics parameters
    local window_width, window_height = love.window.getDesktopDimensions()
    GAME_WIDTH, GAME_HEIGHT = 1920, 1080

    -- Create virtual screen
    window_height = window_height * 0.96
    Push:setupScreen(GAME_WIDTH, GAME_HEIGHT, window_width, window_height,
        { fullscreen = false, vsync = true, resizable = true })

    -- Create a new game
    -- local Play = require "src.states.play"
    -- GAME = Game:new(Play:new())
    GAME = Game:new()
end

function love.update(dt)
    -- Update game
    GAME:update(dt)
end

function love.resize(window_width, window_height)
    Push:resize(window_width, window_height)
end

function love.draw()
    Push:start()

    -- Clear's push canvas
    -- love.graphics.clear(0.2, 0.2, 0.2)

    -- Draw game
    GAME:draw()

    -- Debug: Show mouse position in virtual coordinates
    if DEBUG then
        -- Get mouse position in virtual (game) coordinates
        local mx, my = Push:toGame(love.mouse.getPosition())

        -- Print mouse position
        love.graphics.setColor(1, 1, 1, 1) -- White
        love.graphics.print(string.format("Mouse: %.0f, %.0f", mx or 0, my or 0), 20, 20)

        -- Draw a red cross at the mouse position (if inside canvas)
        if mx and my then
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.circle("fill", mx, my, 5)
        end
    end

    -- Display FPS
    if DEBUG then
        local fps = love.timer.getFPS()
        love.graphics.print(tostring(fps) .. " fps")
    end

    Push:finish()
end

function love.keypressed(key)
    -- Detect key presses and send to game
    GAME:key_pressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    local game_x, game_y = Push:toGame(x, y)
    -- Detect mouse clicks and send to game
    GAME:mouse_pressed(button, game_x, game_y)
end
