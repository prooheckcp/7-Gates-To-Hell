local grass, logo, background, grasstop, dirt, window, plusSign, iadelogo, prooheckcp, martim

--Credits--
local optionsMenu = false
local creditsWindow = false
local CwindowOffsetX = 0
local CwindowOffsetY = 0
local OwindowOffsetX, OwindowOffsetY = 0, 0
local LastPhase = 1

local mousePlace = 0 --For the menu
-----------

function GetOptionsMenu()
  return optionsMenu
end  

function GetMousePlace(new) if new ~= nil then
  mousePlace = new 
else 
  return mousePlace
  end end 
  



function ChangeLastPhase(phase)
  LastPhase = phase
end  

function ChangeOptionsMenuStatus()
  
  optionsMenu = false
  
end  



function CreateVariables()
  
  grass = love.graphics.newImage(MapImages.."GrassTexture.png")
  logo = love.graphics.newImage(MapImages.. "logo.png")
  background = love.graphics.newImage(MapImages.. "ForestBackground.png")
  grasstop = love.graphics.newImage(MapImages.. "GrassTop.png")
  dirt = love.graphics.newImage(MapImages.."DirtTexture.png")
  window = love.graphics.newImage(InterfaceImages.. "portraitAtributes.png")
  plusSign = love.graphics.newImage(InterfaceImages.. "SquaredButtonX.png")
  iadelogo = love.graphics.newImage(Images.. "iadeLogo.png")
  prooheckcp = love.graphics.newImage(Images.. "prooheckcp.png")
  martim = love.graphics.newImage(Images.. "martim.png")
  
end  

local function CloseGame()
  love.event.quit()
end  

local function OpenOptions()
  playSfX("click") --click! 
  optionsMenu = not optionsMenu
  OwindowOffsetY = -1000
end  



local function StartTheGame()
  playSfX("click") --click!   
  SetScreenPhase(LastPhase)
  --GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
    
end  

local function CloseCredits()
  print("closed credits")
  creditsWindow = false
end


local function OpenCredits()
  print("opened credits")
  playSfX("click") --click! 
  creditsWindow = true
  CwindowOffsetY = -800
end  

  


function KeyWasPressedOnMenu(key)
  
  if not creditsWindow and not optionsMenu then
    if key == "p" then --Start the game
      StartTheGame()
    end  
  
    if key == "o" then
      OpenOptions()
    end
  
    if key == "c" then
      OpenCredits()
    end  
    
    if key == "q" then
      CloseGame()
    end  
    
  end
end  


function KeyPressedMenu(key)
  
    if creditsWindow or optionsMenu or GetScreenPhase() ~= 0 then
      return
    end
  
  if key == "return" then
      if mousePlace == 1 then
        StartTheGame()
        elseif mousePlace == 2 then
          OpenOptions()
        elseif mousePlace == 3 then
          print("clicked enter")
          OpenCredits()
        elseif mousePlace == 4 then
          CloseGame()
      end
          mousePlace = 0
  elseif key == "w" and mousePlace > 1 then
    
    mousePlace = mousePlace - 1
    
  elseif key == "w" and mousePlace <= 1 then
    
    mousePlace = 4
    
  elseif key == "s" and mousePlace < 4 then
    
      mousePlace = mousePlace + 1
      
  elseif key == "s" and mousePlace >= 4 then
    
    mousePlace = 1
      
  end    
    
  
end  


function DrawCreditsWindows()
  
  --------Update--------
  CwindowOffsetX, CwindowOffsetY = frame.slide(CwindowOffsetX, CwindowOffsetY, 0, 0, 900)
  ----------------------
  
  --Variables--
    local font = love.graphics.getFont()
    local word = "Credits"
    local textX = font:getWidth(word)
    local textY = font:getHeight(word)
  -------------
  
  --Window background
  image.new(window, love.graphics.getWidth()/2 - 400 + CwindowOffsetX, love.graphics.getHeight()/2 - 300 + CwindowOffsetY, 0, 800, 600)
  --Closing Button
  local Xbutton = button.create2(plusSign, 
    love.graphics.getWidth()/2 + 310 + CwindowOffsetX, 
    love.graphics.getHeight()/2 - 170 + CwindowOffsetY, 50)
  --Name of the window
  BetterText(word, love.graphics.getWidth()/2 - textX/2 + CwindowOffsetX, love.graphics.getHeight()/2 - 210 + CwindowOffsetY)
  --Logo
  image.new(iadelogo,
    love.graphics.getWidth()/2 + CwindowOffsetX - 400,
    love.graphics.getHeight()/2 + CwindowOffsetY + 180,
    0,
    501 * 1,
    118.5 * 1)
  
  --vasco soares--
  image.new(prooheckcp,
    love.graphics.getWidth()/2 + CwindowOffsetX - 380,
    love.graphics.getHeight()/2 + CwindowOffsetY - 150,
    0,
    250,
    250)
  --name text
  local name1 = "Vasco Soares"
  BetterText(name1, 
    love.graphics.getWidth()/2 - 380 + CwindowOffsetX, 
    love.graphics.getHeight()/2 + 100 + CwindowOffsetY)

  --Daniel Martins--
  image.new(martim,
    love.graphics.getWidth()/2 + CwindowOffsetX + 130,
    love.graphics.getHeight()/2 + CwindowOffsetY - 150,
    0,
    250,
    250)
  --name text
  local name2 = "Daniel Martins"
  local name2x = font:getWidth(name2)
  BetterText(name2, 
    love.graphics.getWidth()/2 + 380 - name2x + CwindowOffsetX, 
    love.graphics.getHeight()/2 + 100 + CwindowOffsetY)
  ----------------
  
  
  --Events--
  if CwindowOffsetX == 0 and CwindowOffsetY == 0 then
    Xbutton:click1(CloseCredits)
  end  
  ----------
  
end  

function menuDrawing(button)
  
  
  
  image.new(background, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight()) --Background
  
  love.graphics.print("Current Mouse Place: " ..mousePlace)
  
  
  for i = 0, love.graphics.getWidth()/grass:getWidth() do
  
  image.new(grass, i * grass:getWidth(), love.graphics.getHeight() - grass:getHeight() * 2 , 0, nil, nil)
  image.new(dirt, i * grass:getWidth(), love.graphics.getHeight() - grass:getHeight()  , 0, nil, nil)
  
  end  
  
  

  local play = button.create(RGB(220, 0, 0), love.graphics.getWidth()/2 - 250, 275, 500, 100, "Play (P)")
  
  local options = button.create(RGB(220, 0, 0), love.graphics.getWidth()/2 - 250, 400, 500, 100, "Options (O)") 
  
  local credits = button.create(RGB(220, 0, 0), love.graphics.getWidth()/2 - 250, 525, 500, 100, "Credits (C)") 
  
  local quit = button.create(RGB(220, 0, 0), love.graphics.getWidth()/2 - 250, 650, 500, 100, "Quit (Q)")
  
    
    if mousePlace == 0 then
      play:mousehover(false)
      options:mousehover(false)
      credits:mousehover(false)
      quit:mousehover(false)
    end
    
  
    if mousePlace == 1 then
      play:mousehover(true)
    else  
      play:mousehover(false)
    end
    if mousePlace == 2 then
      options:mousehover(true)
    else  
      options:mousehover(false)
    end
    if mousePlace == 3 then
      credits:mousehover(true)
    else  
      credits:mousehover(false)
    end
    if mousePlace == 4 then
      quit:mousehover(true)
    else  
      quit:mousehover(false)
    end 
  
  
  
  --Events--
  if not creditsWindow and not optionsMenu then
    

    
    credits:click1(OpenCredits)
    play:click1(StartTheGame)
    options:click1(OpenOptions)
    quit:click1(CloseGame)
  end
  ----------
  image.new(logo, love.graphics.getWidth()/2 - 225, 25, 0, 450, 300) --Logo
  


  if creditsWindow then
    DrawCreditsWindows()
  end
  
  if optionsMenu then
    OwindowOffsetX, OwindowOffsetY = frame.slide(OwindowOffsetX, OwindowOffsetY, 0, 0, 900)
    DrawOptionsMenu(vector2.new(OwindowOffsetX, OwindowOffsetY))
  end
  
end  

return menu