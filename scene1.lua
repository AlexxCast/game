local composer = require("composer")
local scene1 = composer.newScene()
local centerX, centerY = display.contentCenterX, display.contentCenterY
local screenWidth, screenHeight = display.contentWidth, display.contentHeight

--local background
function scene1:create(event)

    if _G.sharedData.pop == 0 then
        _G.sharedData.gettoni = 1
        _G.sharedData.ticketCount=0 
        _G.sharedData.pop=1

    end
    physics.start()
local physics = require("physics")
if not physics then
    print("Errore: il modulo physics non è caricato correttamente.")
else
    print("Modulo physics caricato correttamente.")
end

print("Versione di Solar2D:", _VERSION)

-- Inizia la fisica
local sceneGroup = self.view

physics.setGravity(0, 0)
   
local moveSpeed = 4
local isMoving = false
local mover=false
local var_temp = nil
local currentDirection = nil
local varDirecction = nil
local count_obj = 2;
local cont_p = 0
local ticket_sensor = true
local background = display.newImageRect(sceneGroup,"tapetto.png", screenWidth * 10, screenHeight * 5)
background.x = display.contentCenterX
background.y = display.contentCenterY
--local _G.sharedData.ticketCount = 0;
local id_porta=nil;
-- Creazione del testo
local gioco= {"gioco_1", "gioco_2"}


   
if event.phase == "will" then
end

local sheetOptions = {
    width = 60*2,  -- larghezza di ogni frame
    height = 130*2, -- altezza di ogni frame
    numFrames = 4  -- numero totale di frame nello spritesheet
}

-- Carica lo spritesheet
local spriteSheet = graphics.newImageSheet("pg_statik_fron.png", sheetOptions)

-- Definisce la sequenza dell'animazione
local sequenceData = {
    {
        name = "idle",  -- Nome dell'animazione
        start = 1,      -- Frame iniziale
        count = 4,      -- Numero totale di frame
        time = 333,     -- Tempo per ciclo (12 FPS)
        loopCount = 0   -- Loop infinito
    }
}

-- Crea l'oggetto come sprite animato
local object = display.newSprite(sceneGroup, spriteSheet, sequenceData)

-- Se l'oggetto non viene caricato, mostra un errore
if not object then
    print("Errore: Immagine non trovata!")
end

-- Imposta la posizione
object.x = centerX
object.y = centerY 

-- Aggiunge la fisica
physics.addBody(object, "static", { isSensor = true })

-- Avvia l'animazione
object:setSequence("idle")
object:play()
-- Aggiungi gli ostacoli e attivatori di eventi
--timer.performWithDelay(500, function()
    local ticketer = display.newImageRect(sceneGroup, "tickets.png", 170*2, 170*2)
    if not ticketer then
        print("Errore: Immagine non trovata!")
    end
    ticketer.x = centerX + 260+85
    ticketer.y = centerY - 305 -85
    physics.addBody(ticketer, physics.Static, { isSensor = true })
--end)
--ticketer.rotation = 90
--ticketer.yScale = -1 


local popcorn= display.newImageRect(sceneGroup,"popcorn.png", 150*2, 170*2) 
if not popcorn then
    print("Errore: Immagine non trovata!")
end
popcorn.x = centerX - 250- 75
popcorn.y = centerY - 305 - 85
physics.addBody(popcorn, physics.Static, { isSensor = true })


local popcorn_area = {sceneGroup,popcorn.x + 400, popcorn.y + 300}
--end 
-- Posizioni relative per le porte
-- Configurazioni

local altezzaDesiderata = centerY - 1155 -- Altezza fissa per tutte le porte
local xMin = -1276 -- Posizione minima sull'asse X
local xMax = 1602 -- Posizione massima sull'asse X
local numeroPorte = 5 -- Numero di porte da generare

-- Calcola la distanza tra le porte
local distanza = (xMax - xMin) / (numeroPorte - 1)

-- Array per memorizzare le porte
local porte = {}

-- Funzione per creare una porta
local function creaPorta(nome, x, y)
    local porta = display.newRect(sceneGroup,x, y, 200, 20) -- Dimensioni standard
    porta:setFillColor(0.5, 0.25, 0) -- Colore specificato
    physics.addBody(porta, {
        isSensor = true -- Corpo fisico "sensor"
    })
    porta.nome = nome -- Assegna un nome unico alla porta
    return porta
end
-- Creazione delle porte
for i = 1, numeroPorte do
    if (cont_p < numeroPorte) then

        local xPos = xMin + (i - 1) * distanza -- Calcola la posizione X equidistante
        local nomePorta = "porta_" .. i -- Nome unico per ogni porta
        -- Colore casuale
        porte[i] = creaPorta(nomePorta, xPos, altezzaDesiderata)
        cont_p = cont_p + 1;
    end -- Crea la porta e la salva nel vettore
end

-- Debug: Stampa i nomi delle porte create
for i, porta in ipairs(porte) do
  --  print("Porta creata:", porta.nome, "Posizione:", porta.x, porta.y)
end

local buttonSize = 50
-- Su
local upButton = display.newImageRect(sceneGroup, "freccia.png", buttonSize, buttonSize+20)
upButton.x = centerX 
upButton.y = centerY + screenHeight / 2 - buttonSize +5


-- Giù
local downButton = display.newImageRect(sceneGroup, "freccia.png", buttonSize, buttonSize+20)
downButton.x = centerX 
downButton.y = centerY + screenHeight / 2 + buttonSize -5
downButton.rotation=180

-- Sinistra
local leftButton = display.newImageRect(sceneGroup, "freccia.png", buttonSize, buttonSize+20)
leftButton.x = centerX - screenWidth / 4
leftButton.y = centerY + screenHeight / 2
leftButton.rotation=-90

-- Destra
local rightButton = display.newImageRect(sceneGroup, "freccia.png", buttonSize, buttonSize+20)
rightButton.x = centerX + screenWidth / 4 
rightButton.y = centerY + screenHeight / 2
rightButton.rotation=90

local ticket_Button = display.newRect(sceneGroup,centerX, centerY, 200, 100)
ticket_Button:setFillColor(0, 1, 0)

ticket_Button.isVisible = false
ticket_Button.isHitTestable = false

local popcorn_Button = display.newRect(sceneGroup,centerX, centerY, 200, 100)
popcorn_Button:setFillColor(1, 1, 0)

popcorn_Button.isVisible = false
popcorn_Button.isHitTestable = false

local porta_Button = display.newRect(sceneGroup,centerX, centerY, 200, 100)
porta_Button:setFillColor(1, 1, 0)
porta_Button.isVisible = false
porta_Button.isHitTestable = false

local textOptions = {
    text = "ticket:" .. _G.sharedData.ticketCount, -- Il contenuto del testo
    x = screenWidth - 5, -- Posizionato a 10 pixel dal bordo destro
    y = -screenHeight / 6, -- Posizionato a 20 pixel dal bordo superiore
    font = native.systemFont, -- Font di default
    fontSize = 16, -- Dimensione del font
    align = "right" -- Allineamento del testo
}

local textOptionspoint = {
    text = "gettoni:" .. _G.sharedData.gettoni, -- Il contenuto del testo
    x =(screenWidth / 5) +5,  -- Posizionato a 10 pixel dal bordo destro
    y = -screenHeight / 6, -- Posizionato a 20 pixel dal bordo superiore
    font = native.systemFont, -- Font di default
    fontSize = 16, -- Dimensione del font
    align = "right" -- Allineamento del testo
}

local textOptionspop = {
    text = "popcorn:" .. _G.sharedData.pop, -- Il contenuto del testo
    x =centerX+40,  -- Posizionato a 10 pixel dal bordo destro
    y = -screenHeight / 6, -- Posizionato a 20 pixel dal bordo superiore
    font = native.systemFont, -- Font di default
    fontSize = 16, -- Dimensione del font
    align = "right" -- Allineamento del testo
}

local topRightText = display.newText(textOptions)
topRightText:setFillColor(1, 1, 1) -- Colore bianco

local topRightTextgettoni = display.newText(textOptionspoint )
--topRightText:setFillColor(1, 1, 1)

local topRightpop = display.newText(textOptionspop)
--topRightText:setFillColor(1, 1, 1)

sceneGroup:insert(topRightText)
sceneGroup:insert(topRightTextgettoni)
sceneGroup:insert(topRightpop)
-- Assicurati che il testo sia allineato a destra
topRightText.anchorX = 1
topRightTextgettoni .anchorX = 1
topRightpop .anchorX = 1
-- Aree di movimento definite
local topArea = {
    xMin = 1702,
    xMax = -1376,
    yMin = 478,
    yMax = 1390
}
local middleArea = {
    xMin = 334,
    xMax = -10,
    yMin = -220,
    yMax = 478
}
--nzione per verificare se lo sfondo è dentro i limiti
local function canMove()
    local inTopArea = (background.x <= topArea.xMin and background.x >= topArea.xMax) and
                          (background.y >= topArea.yMin and background.y <= topArea.yMax)
    local inMiddleArea = (background.x <= middleArea.xMin and background.x >= middleArea.xMax) and
                             (background.y >= middleArea.yMin and background.y <= middleArea.yMax)
    return inTopArea or inMiddleArea 
end


function isObjectInRange(referenceObject, targetObject, xRange, yRange)
    return (referenceObject.x - xRange < targetObject.x and targetObject.x < referenceObject.x + xRange) and
               (referenceObject.y - yRange < targetObject.y and targetObject.y < referenceObject.y + yRange)
end

local function onCollision(event)
    print("Collisione rilevata!")
    print(event.phase)
    if event.phase == "began" then
        varDirecction = currentDirection
        if isObjectInRange(ticketer, object, 400, 300) then
            print("Hai toccato il ticketer!")
            --ticketer:setFillColor(1, 0, 0)
            grabticket(ticket_Button)
            
            var_temp = ticket_Button -- Cambia colore
        elseif isObjectInRange(popcorn, object, 300, 400) then
            print("Hai toccato il popcorn!")
           -- popcorn:setFillColor(1, 1, 0)
            grabticket(popcorn_Button)
            var_temp = popcorn_Button
        else
            for i = 1, numeroPorte do
                if isObjectInRange(porte[i], object, 300, 400) then
                   -- print("Hai toccato il popcorn!")
                    grabticket(porta_Button)
                    var_temp = porta_Button
                    id_porta=i;
                end
                -- Cambia colore
            end
         end
        end
            if event.phase == "ended" then
                print(var_temp)
                disgrabticket(var_temp)
                varDirecction = nil

          
          end
        end 
       print(_G.sharedData.gettoni)
        -- Assegna il listener di collisione
        object:addEventListener("collision", onCollision)

        function grabticket(tocco)
            print(mover)
            if tocco and mover== true then
                tocco.isVisible = true
                tocco.isHitTestable = true
            else
                print("Errore: 'tocco' è nil in grabticket.")
            end
        end

        function disgrabticket(tocco)
            if tocco then
                tocco.isVisible = false
                tocco.isHitTestable = false
            else
                print("Errore: 'tocco' è nil in disgrabticket.")
            end
        end
        disgrabticket(popcorn_Button)

       
        function minigame(num)
            for i = 1, #sceneGroup do
                print("Oggetto nella scena:", sceneGroup[i])
            end
         --   removeCurrentScene()
            print("Funzione minigame chiamata! id_porta:", num) -- Aggiungi questa linea di debug
            local sceneName = "gioco_"..num..".mainmenu"
            sceneName=sceneName;
            print(sceneName)
           -- composer.recycleOnSceneChange = false
            if not isSceneTransitionInProgress then
                isSceneTransitionInProgress = true
                composer.removeScene("scene1")
                print("Cambiando scena a "..sceneName.."...") -- Lascia anche questa print per conferma
                composer.gotoScene(sceneName, { effect = "fade", time = 800, isOverlay = false})
                timer.performWithDelay(1000, function()
                    isSceneTransitionInProgress = false
                end)
                
            end
        end

       
        -- Funzione per muovere lo sfondo e gli oggetti
        local function moveBackground(pos, molt)
         -- print(physics.start)
            if currentDirection then

                if currentDirection == "up" and varDirecction ~= "up" then
                    background.y = background.y + moveSpeed / molt
                    object.fill = { type = "image", filename = "pg_statik.png" }
                    pos.y = pos.y + moveSpeed
                   -- print("t:", object, object.body)
                    if not canMove() then
                        background.y = background.y - moveSpeed / molt
                        pos.y = pos.y - moveSpeed
                    end
                elseif currentDirection == "down" and varDirecction ~= "down" then
                    object.fill = { type = "image", filename = "pg_statik_fron.png" }
                    pos.y = pos.y - moveSpeed
                    background.y = background.y - moveSpeed / molt
                    if not canMove() then
                        pos.y = pos.y + moveSpeed
                        background.y = background.y + moveSpeed / molt
                    end
                elseif currentDirection == "right" and varDirecction ~= "right" then
                    background.x = background.x - moveSpeed / molt
                    pos.x = pos.x - moveSpeed
                   -- print(background.x .. pos.x)
                    if not canMove() then
                        pos.x = pos.x + moveSpeed
                        background.x = background.x + moveSpeed / molt
                    end
                elseif currentDirection == "left" and varDirecction ~= "left" then
                    pos.x = pos.x + moveSpeed
                    background.x = background.x + moveSpeed / molt
                    if not canMove() then
                    --    print(background.x)
                        pos.x = pos.x - moveSpeed
                        background.x = background.x - moveSpeed / molt
                    end

                end
            end
        end
    
        -- Loop di gioco
        local function gameLoop(event)
            if isMoving then
                moveBackground(popcorn, count_obj + numeroPorte)
                moveBackground(ticketer, count_obj + numeroPorte)
                for i = 1, numeroPorte do
                    moveBackground(porte[i], count_obj + numeroPorte)

                end
            end
        end
        Runtime:addEventListener("enterFrame", gameLoop)

        -- Aggiungi pulsanti per il movimento
      


        -- Listener per i pulsanti
        local function buttonListener(event)
            mover=true;
            if event.phase == "began" then
                if event.target == upButton then
                    currentDirection = "up"
                elseif event.target == downButton then
                    currentDirection = "down"
                elseif event.target == leftButton then
                    currentDirection = "left"
                elseif event.target == rightButton then
                    currentDirection = "right"
                elseif event.target == ticket_Button and ticket_sensor then
                    print("Ticket selezionato")
                   -- updateTicketText()
                    if _G.sharedData.gettoni >= 1 then
                    _G.sharedData.ticketCount = _G.sharedData.ticketCount + 1
                   -- display.remove(topRightText) 
                    topRightText.text = "ticket:" .. _G.sharedData.ticketCount
                    _G.sharedData.gettoni= _G.sharedData.gettoni -1
                    topRightTextgettoni.text = "gettoni:" .. _G.sharedData.gettoni
            else
                native.showAlert("gettoni infucenti", "ti serve 1 gettoni", {"OK"})
            end 
                   --updateTicketText()
                  --  ticket_sensor = false
                    ticket_Button:setFillColor(0, 1, 1)
                elseif event.target == popcorn_Button then
                    if _G.sharedData.gettoni >= 3 then
                        _G.sharedData.pop = _G.sharedData.pop + 1
                       -- display.remove(topRightText) 
                       topRightpop.text = "popcorn:" .. _G.sharedData.pop
                        _G.sharedData.gettoni= _G.sharedData.gettoni -1
                        topRightTextgettoni.text = "gettoni:" .. _G.sharedData.gettoni
                    end
                elseif event.target == porta_Button then
                    if id_porta <= _G.sharedData.ticketCount then
                    minigame(id_porta);
                
                else 
                    native.showAlert("non hai tutti i tikcet", "ti servono "..id_porta.." gettoni", {"OK"})
                    print("bob")
                end
            end
                isMoving = true
            elseif event.phase == "ended" or event.phase == "cancelled" then
                currentDirection = nil
                isMoving = false
            end
            return true
        end
upButton:addEventListener("touch", buttonListener)
downButton:addEventListener("touch", buttonListener)
leftButton:addEventListener("touch", buttonListener)
rightButton:addEventListener("touch", buttonListener)
ticket_Button:addEventListener("touch", buttonListener)
popcorn_Button:addEventListener("touch", buttonListener)
porta_Button:addEventListener("touch", buttonListener)





end



scene1:addEventListener("create", scene1)
scene1:addEventListener("show", scene1)
scene1:addEventListener("hide", scene1)
scene1:addEventListener("destroy", scene1)
return scene1