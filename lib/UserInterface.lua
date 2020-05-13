require "lib/player"
require "lib/vector"
require "lib/BetterLua"
local frameDraw = love.graphics.newImage("/Images/paperScrollBackground.jpg")
local BaseFramePosition = vector2.new(50,10)
local FrameVisible = false
local _blockWindowFromUpdate = false
function openStatsWindow()
  
  if _blockWindowFromUpdate == false then
    FrameVisible = not FrameVisible
    _blockWindowFromUpdate = true
  end
  
end
function love.mousereleased(x,y,key)
  if key == 1 and _blockWindowFromUpdate == true then
    _blockWindowFromUpdate = false
  end
end

function DrawUserInterface()
  love.graphics.setFont(love.graphics.newFont(20))
  love.graphics.print("Health: "..GetPlayerStats().Health.."/"..GetPlayerStats().MaxHealth ,0,0)
  love.graphics.print("Stamina: "..GetPlayerStats().Stamina.."/"..GetPlayerStats().MaxStamina ,0,50)
  love.graphics.print("Level: ".. GetPlayerStats().Level,0,100)
  love.graphics.print("XP: ".. GetPlayerStats().XP.."/100",0,150)
  local openStats = button.create("rec",50,800,80,80,"Stats")
  button.event(openStats,"openStatsWindow")
  if (FrameVisible == true) then
    drawStatsWindow()
  end
end

function drawStatsWindow()
   image.new(frameDraw,BaseFramePosition.x,BaseFramePosition.y,0,400,400)
  love.graphics.print("Constitution: ",BaseFramePosition.x+50,BaseFramePosition.y+20)
  love.graphics.print("Stamina: ",BaseFramePosition.x+50,BaseFramePosition.y+80)
end