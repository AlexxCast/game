local composer = require("composer")
local scene = composer.newScene()

-- Variabili condivise nella scena
local playButtonGroup
local textTiket, timerText
local tiket = 1 

-- Funzione per tornare alla scena principale (spostata a livello di scena)
local function startGame(event)
    composer.removeScene("gioco_1.end")
    _G.sharedData.point = 0
    composer.gotoScene("scene1", { effect = "fade", time = 800, isOverlay = false })
end

-- Funzione per creare il contorno del testo
local function createOutlinedText(text, x, y, fontSize, color, outlineColor, sceneGroup)
    local offsets = { {-2, -2}, {2, -2}, {-2, 2}, {2, 2} }

    -- Crea il contorno
    for i = 1, #offsets do
        local shadow = display.newText({
            text = text,
            x = x + offsets[i][1],
            y = y + offsets[i][2],
            font = native.systemFontBold,
            fontSize = fontSize
        })
        shadow:setFillColor(unpack(outlineColor)) 
        sceneGroup:insert(shadow)
    end

    -- Crea il testo principale sopra il contorno
    local mainText = display.newText({
        text = text,
        x = x,
        y = y,
        font = native.systemFontBold,
        fontSize = fontSize
    })
    mainText:setFillColor(unpack(color))
    sceneGroup:insert(mainText)

    return mainText
end

-- Funzione per creare la scena
function scene:create(event)
    local sceneGroup = self.view

    -- Inizializza il background
    local homeImage = display.newImageRect(sceneGroup, "gioco_1/Images/Ambiente/home.jpg", display.contentWidth, display.contentHeight)
    homeImage.x = display.contentWidth / 2
    homeImage.y = display.contentHeight / 2

    -- Gruppo per il pulsante
    playButtonGroup = display.newGroup()
    sceneGroup:insert(playButtonGroup)

    local buttonBackground = display.newRoundedRect(playButtonGroup, 0, 0, 200, 60, 30)
    buttonBackground:setFillColor(1, 1, 1, 0.8)

    -- Aggiorna i punti e i gettoni
    local punti = _G.sharedData.point or 0
    if punti >= 30 then
        tiket = 1 
    else 
        tiket = 0
        _G.sharedData.pop= _G.sharedData.pop-1;
    end

    _G.sharedData.gettoni = (_G.sharedData.gettoni or 0) + tiket

    -- Testi con contorno
    textTiket = createOutlinedText("Gettoni: " .. tiket, display.contentWidth / 2, display.contentHeight / 3, 50, {1, 1, 1}, {0, 0, 0}, sceneGroup)
    timerText = createOutlinedText("Punti: " .. punti, display.contentWidth / 2, display.contentHeight / 4, 50, {1, 1, 1}, {0, 0, 0}, sceneGroup)

    local playButton = display.newText({
        parent = playButtonGroup,
        text = "Torna al cinema",
        x = 0,
        y = 0,
        font = native.systemFontBold,
        fontSize = 25
    })
    playButton:setFillColor(0, 0, 0)

    playButtonGroup.x = display.contentCenterX
    playButtonGroup.y = display.contentCenterY

    -- Aggiungi Event Listener
    playButtonGroup:addEventListener("tap", startGame)
end

-- Funzione per distruggere la scena
function scene:destroy(event)
    if playButtonGroup then
        playButtonGroup:removeEventListener("tap", startGame)
        display.remove(playButtonGroup)
        playButtonGroup = nil
    end

    if textTiket then
        display.remove(textTiket)
        textTiket = nil
    end

    if timerText then
        display.remove(timerText)
        timerText = nil
    end
end

-- Listener del ciclo di vita della scena
scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)

return scene  
