local Enabled = false
local normalfont
function loadPauseMenuVars()
--normalfont = love.graphics.getFont(Images.."joystick monospace.ttf")
end
function leaveGame()
  love.event.quit()
end

function DrawPauseMenu()
  if Enabled then
    love.graphics.setColor(0.5,0.5,0.5,0.4)
    love.graphics.rectangle("fill",0,0,love.graphics:getWidth(),love.graphics:getHeight())
    love.graphics.setColor(0.5,0.5,0.5)
    BetterText("Paused",love.graphics:getWidth()/2-45,150)
    local leave = button.create("rec",love.graphics:getWidth()/2,love.graphics:getHeight()/2,200,100,"Leave the Game")
    button.event(leave,"leaveGame")
   -- love.graphics.setFont(normalfont)
  end
end


function UpdatePauseMenu()
  if Enabled then
    
  end
end

function EnablePauseMenu(state)
  Enabled = state
end

function GetPauseMenuEnabled()
  return Enabled
end