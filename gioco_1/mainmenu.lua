
local composer = require("composer")

local scene = composer.newScene()



-- Main menu scene

local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

-- Remove unused variables
-- local redCircle, blueCircle
-- local color, size, density, bounce, friction, speed
-- local randomColor
local background

-- Funzione per creare la scena
function scene:create(event)
    local sceneGroup = self.view

    -- Aggiungi l'immagine home.jpg al centro dello schermo
    local homeImage = display.newImageRect(sceneGroup,"gioco_1/Images/Ambiente/home.jpg", screenWidth, screenHeight)
    homeImage.x =  screenWidth / 2
    homeImage.y =  screenHeight / 2

    -- Crea un gruppo per il pulsante
    local playButtonGroup = display.newGroup()
    
    sceneGroup:insert(playButtonGroup)

    -- Crea uno sfondo stondato per il pulsante
    local buttonBackground = display.newRoundedRect(playButtonGroup, 0, 0, 200, 60, 30) -- 30 è il raggio degli angoli
    buttonBackground:setFillColor(1, 1, 1, 0.8) -- Bianco con 80% di trasparenza

    -- Crea il pulsante con testo "Gioca!" in grassetto
    local playButton = display.newText({
        parent = playButtonGroup,
        text = "Gioca!",
        x = 0,
        y = 0,
        font = native.systemFontBold, -- Font grassetto
        fontSize = 48
    })

    local text = "Resisti 30 secondi"
    local x, y = display.contentCenterX, display.contentCenterY / 2
    local fontSize = 30
    
    -- Crea il contorno nero
    local offsets = { {-2, -2}, {2, -2}, {-2, 2}, {2, 2} } -- Angoli per il contorno
    for i = 1, #offsets do
        local shadow = display.newText({
            text = text,
            x = x + offsets[i][1],
            y = y + offsets[i][2],
            font = native.systemFontBold,
            fontSize = fontSize
        })
        shadow:setFillColor(1, 1, 1) -- Contorno nero
        sceneGroup:insert(shadow)
    end
    
    -- Crea il testo principale bianco sopra il contorno
    local playtext = display.newText({
        text = text,
        x = x,
        y = y,
        font = native.systemFontBold,
        fontSize = fontSize
    })
    playtext:setFillColor(1, 1, 1) -- Testo bianco
    sceneGroup:insert(playtext)

playtext:setFillColor(0, 0, 0)
   
    playButton:setFillColor(0, 0, 0) -- Nero
    
    -- Center the button group


    playButtonGroup.x = display.contentCenterX
    playButtonGroup.y = display.contentCenterY
   -- sceneGroup:insert(playtext)
    -- Funzione per avviare il gioco
    local function startGame(event) 
        composer.gotoScene("gioco_1.gameScene", { effect = "fade", time = 800, isOverlay = false})  -- Passa alla scena di gioco con effetto fade
    end

    -- Aggiungi il listener per il "tap" SOLO sul pulsante (o sul gruppo del pulsante)
    playButtonGroup:addEventListener("tap", startGame)
end

-- Funzione per distruggere gli oggetti quando la scena viene distrutta
function scene:destroy(event)
    local sceneGroup = self.view

    -- Remove event listeners to prevent issues
    if playButtonGroup then
        playButtonGroup:removeEventListener("tap", startGame)
    end

    -- Set references to nil to help with garbage collection (important!)
    playButton = nil
    buttonBackground = nil
    playButtonGroup = nil
    homeImage = nil
    background = nil -- If you had a background object

    print("Main Menu Scene Destroyed") -- Optional: For debugging
end

-- Aggiungi i listener per il ciclo di vita della scena
scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)

return scene