-- gameScene.lua
local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.start()
physics.setGravity(0, 2)
-- Game settings and constants
local BLUE_CIRCLE_RADIUS = 10
local RED_CIRCLE_RADIUS = 30
local TIMER_INTERVAL = 100 -- Update interval in milliseconds
local WHITE_SPEED_INCREMENT = 0.1
local GREEN_SPEED_INCREMENT = 0.2
local YELLOW_SPEED_INCREMENT = 0.3

-- Game state variables
local fallingObjects = {}
local isSceneDestroyed = false
local customTimer = 0
local timerHandle
local createFallingObjectTimer

-- Display objects
local redCircle
local blueCircle
local timerText

-- Seed the random number generator
math.randomseed(os.time())

-- Function to update the custom timer
local function updateCustomTimer()
    customTimer = customTimer + TIMER_INTERVAL
    -- Update the timer text display
    timerText.text = "Punteggio: " .. math.floor(customTimer / 1000)
    _G.sharedData.point= math.floor(customTimer / 1000)
    print(_G.sharedData.point)
end

-- Function to move the blue circle with touch input
local function moveBlueCircle(event)
    if event.phase == "moved" then
        local newY = event.y
        -- Prevent the blue circle from going above the red circle
        if newY <= redCircle.y - RED_CIRCLE_RADIUS - BLUE_CIRCLE_RADIUS then
            blueCircle.x = event.x
            blueCircle.y = newY
        else
            blueCircle.x = event.x
            blueCircle.y = redCircle.y - RED_CIRCLE_RADIUS - BLUE_CIRCLE_RADIUS
        end
    end
    return true
end

-- Function to create a falling object
local function createFallingObject()
    if isSceneDestroyed then return end

    local timePassed = customTimer

    local image, size, density, bounce, friction, speed

    -- Define falling object properties based on game time
    if timePassed <= 10000 then -- White phase (0-10 seconds)
        image = "gioco_1/Images/Polpette/p1.jpg"
        size = math.random(50, 70)
        density = math.random(1, 2) * 0.5
        bounce = math.random(0, 0.2)
        friction = math.random(0, 0.1)
        speed = math.random(5000, 8000)
    elseif timePassed <= 20000 then -- Green phase (10-20 seconds)
        local randomColor = math.random(1, 3)
        if randomColor == 1 then
            image = "gioco_1/Images/Polpette/p1.jpg"
            size = math.random(50, 70)
            density = math.random(1, 2) * 0.5
            bounce = math.random(0, 0.2)
            friction = math.random(0, 0.1)
            speed = math.random(5000, 8000)
        else
            image = "gioco_1/Images/Polpette/p2.jpg"
            size = math.random(40, 60)
            density = math.random(0.5, 1.5)
            bounce = math.random(0.2, 0.4)
            friction = math.random(0, 0.2)
            speed = math.random(3000, 5000)
        end
    else -- Yellow phase (after 20 seconds)
        local randomColor = math.random(1, 5)
        if randomColor == 1 then
            image = "gioco_1/Images/Polpette/p1.jpg"
            size = math.random(50, 70)
            density = math.random(1, 2) * 0.5
            bounce = math.random(0, 0.2)
            friction = math.random(0, 0.1)
            speed = math.random(5000, 8000)
        elseif randomColor == 2 then
            image = "gioco_1/Images/Polpette/p2.jpg"
            size = math.random(40, 60)
            density = math.random(0.5, 1.5)
            bounce = math.random(0.2, 0.4)
            friction = math.random(0, 0.2)
            speed = math.random(3000, 5000)
        else
            image = "gioco_1/Images/Polpette/p3.jpg"
            size = math.random(30, 50)
            density = math.random(1, 2)
            bounce = math.random(0.4, 0.6)
            friction = math.random(0.1, 0.3)
            speed = math.random(2000, 4000)
        end
    end

    -- Create the falling object
    local fallingObj = display.newImageRect(image, size, size)
    fallingObj.x = math.random(size / 2, display.contentWidth - size / 2)
    fallingObj.y = -size
    physics.addBody(fallingObj, "dynamic", {
        density = density,
        friction = friction,
        bounce = bounce,
        shape = { -size / 2, -size / 2, size / 2, -size / 2, size / 2, size / 2, -size / 2, size / 2 }
    })
    fallingObj.rotation = math.random(0, 360)
    table.insert(fallingObjects, fallingObj)
end

-- Function to determine when to create a falling object based on game time
local function beforeCreation()
    local timePassed = customTimer
    local randomNumber = math.random(0, 100)

    if timePassed <= 10000 then -- White phase
        if randomNumber > 90 then
            createFallingObject()
        end
    elseif timePassed <= 20000 then -- Green phase
        if randomNumber > 80 then
            createFallingObject()
        end
    else -- Yellow phase
        if randomNumber > 70 then
            createFallingObject()
        end
    end
end

-- Function to handle collisions
local function onCollision(event)
    if event.phase == "began" then
        local obj1 = event.object1
        local obj2 = event.object2

        if obj1 == redCircle or obj2 == redCircle then
            -- Red circle was hit, game over
            print("Game Over! Il cerchio rosso è stato colpito!")
            composer.removeScene("gioco_1.gameScene")
            if timerText then
                timerText:removeSelf()
                timerText = nil
            end
            composer.gotoScene("gioco_1.end", { time = 800, effect = "fade" , isOverlay = true })
        elseif obj1 == blueCircle then
            -- Blue circle hit a falling object
            local fallingObj = obj2
            local dx = fallingObj.x - blueCircle.x
            local dy = fallingObj.y - blueCircle.y
            local angle = math.atan2(dy, dx)
            local force = 500
            fallingObj:applyForce(force * math.cos(angle), force * math.sin(angle), fallingObj.x, fallingObj.y)
        elseif obj2 == blueCircle then
            -- A falling object hit the blue circle
            local fallingObj = obj1
            local dx = fallingObj.x - blueCircle.x
            local dy = fallingObj.y - blueCircle.y
            local angle = math.atan2(dy, dx)
            local force = 500
            fallingObj:applyForce(force * math.cos(angle), force * math.sin(angle), fallingObj.x, fallingObj.y)
        end
    end
end

-- Scene lifecycle functions
function scene:create(event)
    local sceneGroup = self.view
    physics.start()

    -- Background
    local background = display.newImageRect(sceneGroup, "gioco_1/Images/Ambiente/city.jpg", display.contentWidth, display.contentHeight)
    background.x = display.contentWidth / 2
    background.y = display.contentHeight / 2

    -- Red circle (truck)
    redCircle = display.newImageRect("gioco_1/Images/Main/camion_rosso.jpg", 180, 200)
    redCircle.x = display.contentWidth / 2
    redCircle.y = display.contentHeight - 50
    physics.addBody(redCircle, "static", { radius = RED_CIRCLE_RADIUS +10 })

    -- Blue circle (umbrella)
    blueCircle = display.newImageRect("gioco_1/Images/Main/ombrello.jpg", 50, 50)
    blueCircle.x = display.contentWidth / 2
    blueCircle.y = display.contentHeight / 2
    physics.addBody(blueCircle, "kinematic")

    -- Timer text
    timerText = display.newText("", display.contentWidth - 100, 20, native.systemFont, 20)
    timerText:setFillColor(0, 0, 0)
    sceneGroup:insert(timerText)

    -- Event listeners
    Runtime:addEventListener("touch", moveBlueCircle)
    Runtime:addEventListener("collision", onCollision)

    -- Start the timer for creating falling objects
    createFallingObjectTimer = timer.performWithDelay(250, beforeCreation, 0)
end

function scene:show(event)
    if event.phase == "did" then
        customTimer = 0 -- Reset timer on scene show
        timerHandle = timer.performWithDelay(TIMER_INTERVAL, updateCustomTimer, 0)
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Stop the timer for creating falling objects
        if createFallingObjectTimer then
            timer.cancel(createFallingObjectTimer)
            createFallingObjectTimer = nil
        end
        -- Stop the custom timer
        if timerHandle then
            timer.cancel(timerHandle)
            timerHandle = nil
        end
    end
end

function scene:destroy(event)
    isSceneDestroyed = true

    -- Remove display objects
    if redCircle then
        redCircle:removeSelf()
        redCircle = nil
    end
    if blueCircle then
        blueCircle:removeSelf()
        blueCircle = nil
    end
    if timerText then
        timerText:removeSelf()
        timerText = nil
    end

    -- Remove falling objects
    for i = #fallingObjects, 1, -1 do
        local obj = fallingObjects[i]
        if obj then
            obj:removeSelf()
        end
    end
    fallingObjects = {}

    -- Stop physics
    timer.performWithDelay(100, physics.stop)

    -- Remove event listeners
    Runtime:removeEventListener("touch", moveBlueCircle)
    Runtime:removeEventListener("collision", onCollision)

    -- Stop the timer for creating falling objects (redundant check, but safe)
    if createFallingObjectTimer then
        timer.cancel(createFallingObjectTimer)
        createFallingObjectTimer = nil
    end
     -- Stop the custom timer (redundant check, but safe)
    if timerHandle then
        timer.cancel(timerHandle)
        timerHandle = nil
    end
end

-- Add the scene's event listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene