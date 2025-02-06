-- Inizializza Solar2D
local composer = require("composer")
local scene1 = composer.newScene()
--return scene1
_G.sharedData = {
    ticketCount =2,
    gettoni=1,
    point=0,
    pop=1,
    playerName = "Giocatore1"
    
}

composer.gotoScene("scene1")
--return scene1