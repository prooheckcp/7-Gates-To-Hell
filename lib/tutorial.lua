
--The phase
local tutorialPhase = 0
local DefaultTimeBeetweenWindows = 1 -- set to 2
local timer = 0

--Images
local frame, keybutton, arrowup, arrowdown, arrowright, arrowleft

--Tutorial window info
local ShowingWindow = false
local TutorialFrameOffsetX, TutorialFrameOffsetY = 550, 0
local FrameX, FrameY = 450, 300
local PosX, PosY = love.graphics.getWidth() - 550 + TutorialFrameOffsetX, love.graphics.getHeight() - 400 + TutorialFrameOffsetY

local arrowAttbOffset = 0
local arrowAttbOffsetVelocity = 25
local waitPhase3 = 0
local waitPhase5 = 0
local playercurrentXP = 0
--

local InfoLogs = {
  "Lets start by moving \nPress the keys below",
  "Great Job! \nNow lets try to\nattack by using one\nof the keys bellow:",
  "Nice! now lets learn\nabout attribute\npoints!\nClick the red square\nat the bottom right.",
  "Here you can upgrade\nyour statistics\nConstitution:More HP\nStamina:More energy\nStrengh:More Damage\nReclick the button\nto close",
  "Try killing a mob\nnow!",
  "Very well! Good\nluck with your\nadventure!"
  
  }


local PressedKeys = {
  w = false,
  a = false,
  d = false,
  g = false
  
  }


function NextPhase()
  tutorialPhase = tutorialPhase + 1
end

function KeyColor(boolVariable)
    if not boolVariable then
      love.graphics.setColor(0.3, 0.3, 0.3)
    else
      love.graphics.setColor(1, 1, 1)
    end
end  

function CreateKey(key, positionX, positionY)
  local font = love.graphics.getFont()
  local keyWidth = font:getWidth(key)
  local keyHeight = font:getHeight(key)
  local keyPositionX, keyPositionY = PosX - keyWidth/2 + positionX, PosY - keyHeight/2 + positionY
  
  
  image.new(keybutton, PosX + positionX, PosY + positionY, 0, 64, 64)
  BetterText(key, keyPositionX + 32, keyPositionY + 32)
end  

function LoadTutorial()
  
  --Set Images
  frame = love.graphics.newImage(InterfaceImages.."CheatsWindow.png")
  keybutton = love.graphics.newImage(InterfaceImages.."KeyButton.png")
  arrowup = love.graphics.newImage(InterfaceImages.. "arrowup.png")
  arrowdown = love.graphics.newImage(InterfaceImages.. "arrowdown.png")
  arrowleft = love.graphics.newImage(InterfaceImages.. "arrowleft.png")
  arrowright = love.graphics.newImage(InterfaceImages.. "arrowright.png")
end  


function DrawTutorial()
  
  local tutorialString = "Tutorial"
  local font = love.graphics.getFont()
  local stringx = font:getWidth(tutorialString)
  local stringy = font:getHeight(tutorialString)
  FrameX, FrameY = 450, 300
  PosX, PosY = love.graphics.getWidth() - 550 + TutorialFrameOffsetX, love.graphics.getHeight() - 400 + TutorialFrameOffsetY 
  
  --Keys to be pressed on the first phase
 
  
  if tutorialPhase < 6 then
    image.new(frame, PosX , PosY, 0, FrameX, FrameY)
    BetterText(tutorialString, PosX + 450/2 - stringx/2, PosY + stringy/2, 1, 1)
    BetterText(InfoLogs[tutorialPhase + 1], PosX + 10, PosY + 70)
  end  
    
    
  --Movement Part!  
  if tutorialPhase == 0 then
    
    KeyColor(PressedKeys.w)
    CreateKey("W", 80, 145)
    KeyColor(PressedKeys.w) 
    CreateKey("Î", 306, 145)
    
    KeyColor(PressedKeys.a)
    CreateKey("A", 10, 145)
    KeyColor(PressedKeys.a)
    CreateKey("<-", 236, 145)
    KeyColor(PressedKeys.d)
    CreateKey("D", 150, 145)
    KeyColor(PressedKeys.d)
    CreateKey("->", 376, 145)
    
  end     
  --Attack
  if tutorialPhase == 1 then
    KeyColor(PressedKeys.g)
    CreateKey("1", 80, 200)
    KeyColor(PressedKeys.g)
    CreateKey("G", 300, 200)
    
  end  
  
  --Atribute window
  if tutorialPhase == 2 or (tutorialPhase == 3  and waitPhase3 > 2) then
    image.new(arrowdown, love.graphics.getWidth() - 85, love.graphics.getHeight() - 175 + arrowAttbOffset, 0, 64, 64)
  end  
  
  
end  

function UpdateTutorial(dt)
  
  if TutorialFrameOffsetX > 0 then
    TutorialFrameOffsetX = TutorialFrameOffsetX -  350 * dt
  end  
  
  if tutorialPhase == 3 then
    waitPhase3 = waitPhase3 + dt
  elseif tutorialPhase == 5 then  
    waitPhase5 = waitPhase5 + dt
  end  
  --Arrow polish  
  if tutorialPhase == 2 or (tutorialPhase == 3  and waitPhase3 > 2) then
    
    if arrowAttbOffset > 20 and arrowAttbOffsetVelocity > 0 then
      arrowAttbOffsetVelocity = arrowAttbOffsetVelocity * -1
    
    elseif arrowAttbOffset < 0 and arrowAttbOffsetVelocity < 0 then
      arrowAttbOffsetVelocity = arrowAttbOffsetVelocity * -1
    end
    
      arrowAttbOffset = arrowAttbOffset + arrowAttbOffsetVelocity * dt
  end  
    
    
  --First Phase  
  if PressedKeys.w and PressedKeys.a  and PressedKeys.d and tutorialPhase == 0 then
    
    if timer == 0 then
      playSfX("click2")
    end
    if timer < DefaultTimeBeetweenWindows then
      timer = timer + dt
    else  
      NextPhase()
      timer = 0
    end  
  end

  --Second Phase 
  if PressedKeys.g and tutorialPhase == 1 then
    
    if timer == 0 then
      playSfX("click2")
    end
    if timer < DefaultTimeBeetweenWindows then
      timer = timer + dt
    else  
      NextPhase()
      timer = 0
    end  
    
  end  

  --Third Phase 
  if getatrbpts() and tutorialPhase == 2 then
    
      playSfX("click2")
      NextPhase() 
    
  end 
  
  --Fourth Phase 
  if not getatrbpts() and tutorialPhase == 3 then
      playSfX("click2")
      playercurrentXP = GetPlayerStats().XP
      NextPhase()
  end   
  
  --Fifth Phase 
  if GetPlayerStats().XP > playercurrentXP and tutorialPhase == 4 then
      playSfX("click2")
      NextPhase()
  end  
  
  --Sixth Phase 
  if waitPhase5 > 4 and tutorialPhase == 5 then
      playSfX("click2")
      NextPhase()
  end    
  
  KeyReleasedTutorial()

  
  
  
end  

function KeyReleasedTutorial()
  
  if tutorialPhase == 0 and TutorialFrameOffsetX <= 0 then
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      PressedKeys.w = true
    end  
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      PressedKeys.a = true
    end  
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      PressedKeys.d = true
    end  
  end
  
  if tutorialPhase == 1 then
    if love.keyboard.isDown("g") or love.keyboard.isDown("1") then
      PressedKeys.g = true
    end  
  end  

end  


