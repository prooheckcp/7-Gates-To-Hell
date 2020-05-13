------Variables------
local Images2, AbilitySquare, AbilitySquareCD,  BarBackground, HealthBar, EnergyBar, ExperienceBar, level, font,buffsquare, skill1, skill2, skill3, skill4, skill5, statisticsButton, backgroundwindow, plusButton, DefaultBar, recFrame, optionsFrame, plusSign, crossSign, soundPoint, minusSign, CheatsFrame, configbutton
local CurrentSquare
local playerStats = GetPlayerStats()
local atributesWindow = false
local cheatswindow = false
local optionsMenu = false
local hackedAtribbutePoints = 0
local ScreenTransition = {x = -5000, func = nil}
local deathScreen = false
---------------------

------Arrays: Dictionary Style------
local InterfaceObjects = {
  HealthBar = {
      BackgroundPosition = vector2.new(20, 20),
      BackgroundSize = vector2.new(300, 50),
      BarSize = 300
                },
                
  EnergyBar = {
      BackgroundPosition = vector2.new(20, 70),
      BackgroundSize = vector2.new(300, 50),
      BarSize = 300
                },
            
  ExperienceBar = {
      BackgroundPosition = vector2.new(20, 120),
      BackgroundSize = vector2.new(300, 25),
      BarSize = 300
                  }                   
  }
-------------------
 
function getatrbpts() return atributesWindow end

  local function OpenPauseMenu()
    ChangePause()
  end  


local function OpenAtribbutesWindow()
  playSfX("click") --click! 
  atributesWindow = not atributesWindow
end

    --Functions--
    local function closewindow()
      playSfX("click") --click! 
      optionsMenu = false 
      ChangeOptionsMenuStatus()
    end  
    
    local function RaiseMusicVolume()
      playSfX("click") --click! 
      ChangeMusicVolume(0.1)
    end  

    local function LowerMusicVolume()
      playSfX("click") --click! 
      ChangeMusicVolume(-0.1)
    end  
    
    local function RaiseSFXVolume()
      playSfX("click") --click! 
      ChangeSoundEffectsVolume(0.1)
    end  

    local function LowerSFXVolume()
      playSfX("click") --click! 
      ChangeSoundEffectsVolume(-0.1)
    end  

function DrawVictoryScreen()
  
  local function QuitTheGame()
    love.event.quit()
  end
  
  local function ContinuePlaying()
    ResetBossCompletion()
    GetPlayer().ControlEnabled = true
  end
  
  if BossCompletion() then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    local test = love.graphics.newFont(Images.."joystix monospace.ttf", 60)
    love.graphics.setFont(test)
    local font = love.graphics.getFont()
    local Text = "Thank you for completing\nour game, feel free\nto join our discord \nin order to keep up with our\ndevelopment\nDiscord: discord.gg/2ddmryH\n-Proohekcp, Martimking"
    local TextX = font:getWidth(Text)
    local TextY = font:getHeight(Text) * 7
    
    BetterText(Text, love.graphics.getWidth()/2 - TextX/2, love.graphics.getHeight()/2 - TextY/2)
    local quit = button.create(RGB(0, 143, 38) ,love.graphics.getWidth()/2 + 50, love.graphics.getHeight() - 125, 220, 75, "Quit")
    local back = button.create(RGB(0, 143, 38) ,love.graphics.getWidth()/2 - 270, love.graphics.getHeight() - 125, 220, 75, "Go back")
    quit:click1(QuitTheGame)
    back:click1(ContinuePlaying)
    
  end
end  

function BossBattleInterface()
  
  if GetCurrentBossStats() ~= nil then
    
    local barSize = (GetCurrentBossStats().health) / GetDefaultBossStats().health
    barSize = barSize * 600
    
    --local temporary = love.graphics.newFont(Images.."joystix monospace.ttf", 25) --Change the UI font into "Joystix monospace"
    --love.graphics.setFont(font)
    
    
    local BossName = "Sett, the boss"
    local BossHP = GetCurrentBossStats().health.. "/" ..GetDefaultBossStats().health
    
    local test = love.graphics.newFont(Images.."joystix monospace.ttf", 40)
    love.graphics.setFont(test)
    local font = love.graphics.getFont()
    local NameX = font:getWidth(BossName) 
    local NameY = font:getHeight(BossName) 
    local BossHPX = font:getWidth(BossHP)
    local BossHPY = font:getHeight(BossHP)
    
    
    love.graphics.setColor(0, 0, 0)
    image.new(DefaultBar, love.graphics.getWidth()/2 - 600/2 , 100, 0, 600, 75)
    love.graphics.setColor(0.2, 0.7, 0.2)
    image.new(DefaultBar, love.graphics.getWidth()/2 - 600/2 , 100, 0, barSize, 75)
    love.graphics.setColor(1, 1, 1)
    BetterText(BossName , love.graphics.getWidth()/2 - 600/2 - NameX/2 + 300,100 - NameY)
    
    BetterText(BossHP , love.graphics.getWidth()/2 - 600/2 - BossHPX/2 + 300,100 + 37.5 -BossHPY/2)

    local test2 = love.graphics.newFont(Images.."joystix monospace.ttf", 25)
    love.graphics.setFont(test2)
    
  end
  
end  

function DeathScreen()
  if deathScreen then
    love.graphics.setColor(0, 0, 0, 0.8)
    local BlackBarSize = 200
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2 - BlackBarSize/2, love.graphics.getWidth(), BlackBarSize)
    local font = love.graphics.getFont()
    local String = "You died"
    local PosX, PosY = love.graphics.getWidth()/2 - (font:getWidth(String)/2) * 3, love.graphics.getHeight()/2 - (font:getHeight(String)/2)*3
    local SizeX, SizeY = 3, 3
    
    love.graphics.setColor(1, 1, 1, 1)
    --Text Stroke
    --I printed it 8 times because its the only possible way of creating a stroke effect on love2d
    love.graphics.print(String, PosX + 3, PosY, 0, SizeX, SizeY)
    love.graphics.print(String, PosX + 3, PosY + 3, 0, SizeX, SizeY)
    love.graphics.print(String, PosX + 3, PosY - 3, 0, SizeX, SizeY)
    love.graphics.print(String, PosX - 3, PosY, 0, SizeX, SizeY)
    love.graphics.print(String, PosX - 3, PosY + 3, 0, SizeX, SizeY)
    love.graphics.print(String, PosX - 3, PosY - 3, 0, SizeX, SizeY)
    love.graphics.print(String, PosX , PosY + 3, 0, SizeX, SizeY)
    love.graphics.print(String, PosX, PosY - 3, 0, SizeX, SizeY)

  --Front text
  love.graphics.setColor(0.85, 0, 0)
  love.graphics.print(String, PosX , PosY, 0, SizeX, SizeY)
    
  end  
end  

function UpdateDarkScreen(ff)

  if ScreenTransition.func == nil then
    
    GetPlayer().ControlEnabled = false
    ScreenTransition.x = love.graphics.getWidth()
    ScreenTransition.func = ff
  end
end  

function DrawCheatsWindow()
  if cheatswindow then
    
    --Functions--
    local function closewindow()
      playSfX("click") --click!
      cheatswindow = not cheatswindow
    end  
    
    local function AddAtrbPoints()
      playSfX("click") --click!
      hackedAtribbutePoints = hackedAtribbutePoints + 1
    end  
    
    local function RaiseLevel()
      playSfX("click") --click!
      ChangePlayerStat("Level", 1)
      
    end  
    
    local function RaiseXP()
      playSfX("click") --click!
      ChangePlayerStat("XP", GetPlayerStats().ExperienceReq[GetPlayerStats().Level]/2)
    end  
    
    local function GoToPhase1()
      playSfX("click") --click!
      ChangePhase(1)
      GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
    end  
    
    local function GoToPhase2()
      playSfX("click") --click!
      ChangePhase(2)
      GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
    end  
    local function GoToPhase3()
      playSfX("click") --click!
      ChangePhase(3)
      GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
    end  
    local function GoToPhase4()
      playSfX("click") --click!
      ChangePhase(4)
      GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
    end  
    local function GoToPhase5()
      playSfX("click") --click!
      ChangePhase(5)
      GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
    end  
    
    local function godMod()
      GetPlayerStats().Intangibility = not GetPlayerStats().Intangibility
    end  
    
    -------------
    
    
    local offsetX = 0
    local offsetY = 0
    if offset ~= nil then
      offsetX = offset.x
      offsetY = offset.y
    end
    
    local BackgroundSizeX = 600
    local BackgorundSizeY = 400
    local BackgroundFrameX = love.graphics.getWidth()/2 - BackgroundSizeX/2 + offsetX
    local BackgroundFrameY = 0 + love.graphics.getHeight()/2 - BackgorundSizeY/2 + offsetY
    
    
    local Tittle = "Cheats"
    local font = love.graphics.getFont()
    local TittleX = font:getWidth(Tittle)
    image.new(CheatsFrame, BackgroundFrameX, BackgroundFrameY, 0, BackgroundSizeX, BackgorundSizeY)  
    BetterText(Tittle, BackgroundFrameX + BackgroundSizeX/2 - (TittleX/2 * 1.5), BackgroundFrameY + 20, 1.5, 1.5)    
    
    local Xbutton = button.create(RGB(220, 0, 0) ,BackgroundFrameX + BackgroundSizeX - 200, BackgroundFrameY + 325, 175, 50, "Close") --Change position
    
    
    local LevelUp = button.create(RGB(132, 0, 189) ,BackgroundFrameX + 20, BackgroundFrameY + 100, 200, 50, "Lvl up")
    local GainXP = button.create(RGB(132, 0, 189) ,BackgroundFrameX + 20, BackgroundFrameY + 175, 200, 50, "Lvl/2")
    local GainAtributtePoints = button.create(RGB(255, 0, 0) ,BackgroundFrameX + 20, BackgroundFrameY + 250, 200, 50, "ATB +1")
    local GodMode = button.create(RGB(255, 0, 0) ,BackgroundFrameX + 20, BackgroundFrameY + 325, 200, 50, "God")
    
    --Phases system
    BetterText("Phases:", BackgroundFrameX + BackgroundSizeX - 365, BackgroundFrameY + 85, 1, 1) 
    local Phase1 = button.create(RGB(0, 143, 38) ,BackgroundFrameX + 250, BackgroundFrameY + 125, 50, 50, "1")
    local Phase2 = button.create(RGB(0, 143, 38) ,BackgroundFrameX + 310, BackgroundFrameY + 125, 50, 50, "2")
    local Phase3 = button.create(RGB(0, 143, 38) ,BackgroundFrameX + 370, BackgroundFrameY + 125, 50, 50, "3")
    local Phase4 = button.create(RGB(0, 143, 38) ,BackgroundFrameX + 430, BackgroundFrameY + 125, 50, 50, "4")
    local Phase5 = button.create(RGB(0, 143, 38) ,BackgroundFrameX + 490, BackgroundFrameY + 125, 50, 50, "5")
    --
    
    --Events--
    Xbutton:click1(closewindow)
    GainAtributtePoints:click1(AddAtrbPoints)
    LevelUp:click1(RaiseLevel)
    GainXP:click1(RaiseXP)
    GodMode:click1(godMod)
    
    Phase1:click1(GoToPhase1)
    Phase2:click1(GoToPhase2)
    Phase3:click1(GoToPhase3)
    Phase4:click1(GoToPhase4)
    Phase5:click1(GoToPhase5)
    
    
    ----------
    
  end  
end  


function DrawOptionsMenu(offset)

    

    -------------
    
    
    local offsetX = 0
    local offsetY = 0
    if offset ~= nil then
      offsetX = offset.x
      offsetY = offset.y
    end
    
    local BackgroundSizeX = 600
    local BackgorundSizeY = 400
    local BackgroundFrameX = love.graphics.getWidth()/2 - BackgroundSizeX/2 + offsetX
    local BackgroundFrameY = 0 + love.graphics.getHeight()/2 - BackgorundSizeY/2 + offsetY
    
    
    local Tittle = "Options"
    local font = love.graphics.getFont()
    local TittleX = font:getWidth(Tittle)
    image.new(optionsFrame, BackgroundFrameX, BackgroundFrameY, 0, BackgroundSizeX, BackgorundSizeY)  
    BetterText(Tittle, BackgroundFrameX + BackgroundSizeX/2 - (TittleX/2 * 1.5), BackgroundFrameY + 20, 1.5, 1.5)    
    
    local Xbutton = button.create(RGB(220, 0, 0) ,BackgroundFrameX + BackgroundSizeX - 200, BackgroundFrameY + 325, 175, 50, "Close") --Change position
    Xbutton:click1(closewindow)
    --Music
    local PlusBackgroundMusic = button.create2(plusSign, BackgroundFrameX + BackgroundSizeX - 52, BackgroundFrameY + 100, 40)
    local MinusBackgroundMusic = button.create2(minusSign, BackgroundFrameX + BackgroundSizeX - 460, BackgroundFrameY + 100, 40)
    --SFX
    local PlusSFX = button.create2(plusSign, BackgroundFrameX + BackgroundSizeX - 52, BackgroundFrameY + 200, 40)
    local MinusSFX = button.create2(minusSign, BackgroundFrameX + BackgroundSizeX - 460, BackgroundFrameY + 200, 40)    
    
    
    local AmountOfBarsMusic = math.floor(((GetMusicVolume() * 10)) - 0.9)
    local AmountOfBarsSFX = math.floor(((GetSoundEffectsVolume() * 10)) - 0.9 )
    
    for i = 0, AmountOfBarsMusic do
      --print("Number of frames:".. ((GetMusicVolume() * 10)))
      image.new(soundPoint, BackgroundFrameX + BackgroundSizeX - 416  + (i * 36)  ,BackgroundFrameY + 100, 0, 36, 40)
    end

    for i = 0, AmountOfBarsSFX do
      --print("Number of frames:".. ((GetMusicVolume() * 10)))
      image.new(soundPoint, BackgroundFrameX + BackgroundSizeX - 416  + (i * 36)  ,BackgroundFrameY + 200, 0, 36, 40)
    end
      
    PlusBackgroundMusic:click1(RaiseMusicVolume)
    MinusBackgroundMusic:click1(LowerMusicVolume)
    PlusSFX:click1(RaiseSFXVolume)
    MinusSFX:click1(LowerSFXVolume)
      
    if GetMousePlace()  == 0 then
      MinusBackgroundMusic:mousehover(false)
      PlusBackgroundMusic:mousehover(false)
      MinusSFX:mousehover(false)
      PlusSFX:mousehover(false)
    end
    
  
    if GetMousePlace() == 1 then
      MinusBackgroundMusic:mousehover(true)
    else  
      MinusBackgroundMusic:mousehover(false)
    end
    if GetMousePlace()  == 2 then
      PlusBackgroundMusic:mousehover(true)
    else  
      PlusBackgroundMusic:mousehover(false)
    end
    if GetMousePlace()  == 3 then
      MinusSFX:mousehover(true)
    else  
      MinusSFX:mousehover(false)
    end
    if GetMousePlace()  == 4 then
      PlusSFX:mousehover(true)
    else  
      PlusSFX:mousehover(false)
    end   
    if GetMousePlace() == 5 then
      Xbutton:mousehover(true)
    else
      Xbutton:mousehover(false)
    end  
    
end  



function KeyPressedInOptions(key)
  
  if optionsMenu or GetOptionsMenu() then
    
  
  if key == "return" then
    
    if GetMousePlace() == 1 then
        
        LowerMusicVolume()
    elseif GetMousePlace() == 2 then
        RaiseMusicVolume()
    elseif GetMousePlace() == 3 then
      LowerSFXVolume()
    elseif GetMousePlace() == 4 then
      RaiseSFXVolume()
    elseif GetMousePlace() == 5 then  
      closewindow()
      GetMousePlace(0)
    end
          
    
    elseif key == "w" and GetMousePlace() > 1 then
      GetMousePlace(GetMousePlace() - 1)
    elseif key == "w" and GetMousePlace() <= 1 then
      GetMousePlace(5)
    elseif key == "s" and GetMousePlace() < 5 then
      GetMousePlace(GetMousePlace() + 1)
    elseif key == "s" and GetMousePlace() > 4 then
      GetMousePlace(1)
    
      
    end  
  end
end  






  local function CloseTheGame()
    playSfX("click") --click! 
    love.event.quit()
  end
  
  local function BackToMenu()
    playSfX("click") --click! 
    ChangeLastPhase(GetScreenPhase())
    ChangePhase(0)
    ChangePause()
  end  
  
  local function OpenCheats()
    playSfX("click") --click! 
    cheatswindow = true
  end
  
  local function OpenOptions()
    playSfX("click") --click! 
    optionsMenu = not optionsMenu
  end  
  
  
  
function KeyPressedInGame(key)
  
  
    if GetPaused() or GetScreenPhase() == 0 or atributesWindow then
      return
    end
    
    if key == "return" then
    
      if GetMousePlace() == 1 then
        
        OpenAtribbutesWindow()
      elseif GetMousePlace() == 2 then
        ChangePause()
          

      end
          GetMousePlace(0)
    
    elseif key == "a" and GetMousePlace() > 1 then
      GetMousePlace(GetMousePlace() - 1)
    elseif key == "a" and GetMousePlace() <= 1 then
      GetMousePlace(2)
    elseif key == "d" and GetMousePlace() < 2 then
      GetMousePlace(GetMousePlace() + 1)
    elseif key == "d" and GetMousePlace() > 1 then
      GetMousePlace(1)
    
      
    end  
    
end
  
  
function KeyPressedPauseMenu(key)
    if optionsMenu or cheatswindow or GetScreenPhase() == 0 or not GetPaused() then
      return
    end
   
    if key == "return" then
    
      if GetMousePlace() == 1 then
        BackToMenu()
        elseif GetMousePlace() == 2 then
          OpenOptions()
        elseif GetMousePlace() == 3 then
          print("clicked enter")
          OpenPauseMenu()
        elseif GetMousePlace() == 4 then
          CloseTheGame()
      end
          GetMousePlace(0)
    
    elseif key == "w" and GetMousePlace() > 1 then
      GetMousePlace(GetMousePlace() - 1)
    elseif key == "w" and GetMousePlace() <= 1 then
      GetMousePlace(4)
    elseif key == "s" and GetMousePlace() < 4 then
      GetMousePlace(GetMousePlace() + 1)
    elseif key == "s" and GetMousePlace() > 3 then
      GetMousePlace(1)
    
      
    end  
    
    
end    
  
function DrawPauseMenu()


  
  --Set Background--
  love.graphics.setColor(0, 0, 0, 0.2)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(1, 1, 1)
  ------------------
  
  local offset = 0
  
  local BackgroundSizeX = 400
  local BackgorundSizeY = 700
  local BackgroundFrameX = love.graphics.getWidth()/2 - BackgroundSizeX/2 + offset
  local BackgroundFrameY = 0 + love.graphics.getHeight()/2 - BackgorundSizeY/2 + offset
  
  local Tittle = "Paused"
  local font = love.graphics.getFont()
  local TittleX = font:getWidth(Tittle)
  
  image.new(recFrame, BackgroundFrameX, BackgroundFrameY, 0, BackgroundSizeX, BackgorundSizeY, 0) --Background Frame
  BetterText("Paused", BackgroundFrameX + BackgroundSizeX/2 - (TittleX/2 * 1.5), BackgroundFrameY + 35, 1.5, 1.5)
  
  local menu = button.create(RGB(220, 0, 0), BackgroundFrameX + BackgroundSizeX/2 - 150, BackgroundFrameY + 125, 300, 60, "Menu")
  local options = button.create(RGB(220, 0, 0), BackgroundFrameX + BackgroundSizeX/2 - 150, BackgroundFrameY + 200, 300, 60, "Options")
  local cheats = button.create(RGB(220, 0, 0), BackgroundFrameX + BackgroundSizeX/2 - 150, BackgroundFrameY + 275, 300, 60, "Close")
  local quit = button.create(RGB(220, 0, 0), BackgroundFrameX + BackgroundSizeX/2 - 150, BackgroundFrameY + 350, 300, 60, "Quit")
  
  local mousePlace = GetMousePlace()
  
      if mousePlace == 0 and not optionsMenu then
      menu:mousehover(false)
      options:mousehover(false)
      cheats:mousehover(false)
      quit:mousehover(false)
    end
    
  
    if mousePlace == 1 and not optionsMenu then
      menu:mousehover(true)
    else  
      menu:mousehover(false)
    end
    if mousePlace == 2 and not optionsMenu then
      options:mousehover(true)
    else  
      options:mousehover(false)
    end
    if mousePlace == 3 and not optionsMenu then
      cheats:mousehover(true)
    else  
      cheats:mousehover(false)
    end
    if mousePlace == 4 and not optionsMenu then
      quit:mousehover(true)
    else  
      quit:mousehover(false)
    end 
  
  
  
  --Events 
  if not optionsMenu and not cheatswindow then
    quit:click1(CloseTheGame)
    menu:click1(BackToMenu)
    options:click1(OpenOptions)
    cheats:click1(OpenPauseMenu)
  end
  
  
  if optionsMenu then
    --Set Background--
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    ------------------
    DrawOptionsMenu() -- Draw the options window
    
  elseif cheatswindow then  
    DrawCheatsWindow() -- Draw the Cheats window
  end
  
  
  
end  

function DrawAtributesWindow()
  
  if atributesWindow then
    
    local font = love.graphics.getFont()
    local word = "Stats"
    local textX = font:getWidth(word)
    local textY = font:getHeight(word)
    
    --ChangeVariables--
    local startingPoints = 5 --Starting atribute points
    local MaxPointsAtr = 10 --max points you can have in a single atribute
    --Get Stuff--
    local atri = GetPlayerAtrib()
    local TotalPointsUsed = atri.Constitution + atri.Stamina + atri.Strength
    local CurrentPoints = (startingPoints + GetPlayerStats().Level) - TotalPointsUsed + hackedAtribbutePoints
    --
    
    --Equations--
    function BarSize(maxSize, points)
      return (points/MaxPointsAtr * maxSize)
    end  
    -------------
    
    --Interface Elements--
    image.new(backgroundwindow, love.graphics.getWidth()/2 - 400, love.graphics.getHeight()/2 - 300, 0, 800, 600)
    BetterText(word, love.graphics.getWidth()/2 - textX/2, love.graphics.getHeight()/2 - 210)
    BetterText("Current attribute points: " ..CurrentPoints, love.graphics.getWidth()/2 - 375, love.graphics.getHeight()/2 + 250)    
    image.new(BarBackground, love.graphics.getWidth()/2 - 350, love.graphics.getHeight()/2 - 100, 0, 550, 75) --Con bar
    love.graphics.setColor(0, 224/255, 42/255)
    image.new(DefaultBar, love.graphics.getWidth()/2 - 350, love.graphics.getHeight()/2 - 100, 0, BarSize(550, atri.Constitution), 75) --Con bar
    love.graphics.setColor(1, 1, 1)
    image.new(BarBackground, love.graphics.getWidth()/2 - 350, love.graphics.getHeight()/2, 0, 550, 75) --Stam bar
    love.graphics.setColor(0, 126/255, 1)
    image.new(DefaultBar, love.graphics.getWidth()/2 - 350, love.graphics.getHeight()/2, 0, BarSize(550, atri.Stamina), 75) --Stam bar
    love.graphics.setColor(1, 1, 1)
    image.new(BarBackground, love.graphics.getWidth()/2 - 350, love.graphics.getHeight()/2 + 100, 0, 550, 75) --Strenght bar
    love.graphics.setColor(1, 132/255, 0)
    image.new(DefaultBar, love.graphics.getWidth()/2 - 350, love.graphics.getHeight()/2 + 100, 0, BarSize(550, atri.Strength), 75) --Strenght bar
    love.graphics.setColor(1, 1, 1)
    BetterText("Constitution Points: "..atri.Constitution, love.graphics.getWidth()/2 - 330, love.graphics.getHeight()/2 - 100 + 37.5 - textY/2)
    BetterText("Stamina Points: "..atri.Stamina, love.graphics.getWidth()/2 - 330, love.graphics.getHeight()/2 + 37.5 - textY/2)
    BetterText("Strength Points: "..atri.Strength, love.graphics.getWidth()/2 - 330, love.graphics.getHeight()/2 + 100 + 37.5 - textY/2)
   -- image.new(GreenBar, love.graphics.getWidth()/2, textX/2, love.graphics.getHeight()/2, 0, 400, 200)
    ----------------------
    
    --Buttons--
    local consButton = button.create2(plusButton, love.graphics.getWidth()/2 + 250, love.graphics.getHeight()/2 - 100, 75)
    local stamButton = button.create2(plusButton, love.graphics.getWidth()/2 + 250, love.graphics.getHeight()/2, 75)
    local strButton = button.create2(plusButton, love.graphics.getWidth()/2 + 250, love.graphics.getHeight()/2 + 100, 75)
    local clsButton = button.create(RGB(220, 0, 0) ,love.graphics.getWidth()/2 + 200, love.graphics.getHeight()/2 + 225, 175, 50, "Close") --Change position
    -----------
    
    --Buttons Functions--
    function RaiseCons()
      if CurrentPoints > 0 and MaxPointsAtr > atri.Constitution then
        playSfX("click2")
        atri.Constitution = atri.Constitution + 1
      else
        playSfX("error")
      end
    end    
    
    function RaiseStam()
      if CurrentPoints > 0 and MaxPointsAtr > atri.Stamina then
        playSfX("click2")
        atri.Stamina = atri.Stamina + 1
      else
        playSfX("error")
      end
    end    
    
    function RaiseStr()
      if CurrentPoints > 0 and MaxPointsAtr > atri.Strength then
        playSfX("click2")
        atri.Strength = atri.Strength + 1
      else
        playSfX("error")
      end
    end    
    ---------------------
    if GetMousePlace() == 0 then
      consButton:mousehover(false)
      stamButton:mousehover(false)
      strButton:mousehover(false)
      clsButton:mousehover(false)
    end
    
  
    if GetMousePlace() == 1 then
      consButton:mousehover(true)
    else  
      consButton:mousehover(false)
    end
    if GetMousePlace() == 2 then
      stamButton:mousehover(true)
    else  
      stamButton:mousehover(false)
    end
    if GetMousePlace() == 3 then
      strButton:mousehover(true)
    else  
      strButton:mousehover(false)
    end
    if GetMousePlace() == 4 then
      clsButton:mousehover(true)
    else  
      clsButton:mousehover(false)
    end 
    
    --Buttons Events--
    consButton:click1(RaiseCons)
    stamButton:click1(RaiseStam)
    strButton:click1(RaiseStr)
    clsButton:click1(OpenAtribbutesWindow)
    ------------------
    

    
    
  end  
  
end  

function KeyPressedInAtrbPoints(key) --keyboards keys for atrbt points
    if GetPaused() or GetScreenPhase() == 0 or not atributesWindow then
      return
    end
  
      if key == "return" then
    
      if GetMousePlace() == 1 then
        
        RaiseCons()
      elseif GetMousePlace() == 2 then
        RaiseStam()
      elseif GetMousePlace() == 3 then
          RaiseStr()
      elseif GetMousePlace() == 4 then
        OpenAtribbutesWindow()
        GetMousePlace(0)
      end
          
    
    elseif key == "w" and GetMousePlace() > 1 then
      GetMousePlace(GetMousePlace() - 1)
    elseif key == "w" and GetMousePlace() <= 1 then
      GetMousePlace(4)
    elseif key == "s" and GetMousePlace() < 4 then
      GetMousePlace(GetMousePlace() + 1)
    elseif key == "s" and GetMousePlace() > 3 then
      GetMousePlace(1)
    
      
    end  
  
  
end  

function DrawInterface()
  
    love.graphics.print("Current Mouse Place: " ..GetMousePlace())
  DrawAtributesWindow()
  DeathScreen()
  BossBattleInterface()
  
  if GetPaused() then
    DrawPauseMenu()
  end 
  
  

  

  
  local button1 = button.create2(statisticsButton, love.graphics.getWidth() - 90, love.graphics.getHeight() - 90, 75)
  local button2 = button.create2(configbutton, love.graphics.getWidth() - 180, love.graphics.getHeight() - 90, 75) 
  

  
  button1:click1(OpenAtribbutesWindow) --not working D:
  button2:click1(OpenPauseMenu)   --not working

    if GetMousePlace() == 0 and not GetPaused() and not atributesWindow then
      button1:mousehover(false)
      button2:mousehover(false)
    end
  
    if GetMousePlace() == 1 and not GetPaused() and not atributesWindow then
      button1:mousehover(true)
    else  
      button1:mousehover(false)
    end  
    if GetMousePlace() == 2 and not GetPaused() and not atributesWindow then
      button2:mousehover(true)
    else
      button2:mousehover(false)
    end
  

  
  
  font = love.graphics.newFont(Images.."joystix monospace.ttf", 25) --Change the UI font into "Joystix monospace"
  love.graphics.setFont(font)
  
  --Abilities squares
  local Square1X, Square1Y = pixelToScale(0.5, 0.9)
  local skills = GetSkills()
  local keys = GetPlayerKeys()
  local i = 0
  local attack, attack2
  
  --Check the keybinds for each specific key and create the abilities squares with its respective keys
    for index1, key1 in pairs(skills) do
      if index1 == "Slash" then
        i = 4
        attack, attack2 = keys[1].Slash, keys[2].Slash
        CurrentSquare = skill1
      end
      
      if index1 == "Charge" then
        i = 3
        attack, attack2 = keys[1].Charge, keys[2].Charge
        CurrentSquare = skill2
      end      
      
      if index1 == "Adrenaline Rush" then
        i = 1
        attack, attack2 = keys[1].AdrenalineRush, keys[2].AdrenalineRush
        CurrentSquare = skill3
      end

      if index1 == "Heavy Slash" then
        i = 2
        attack, attack2 = keys[1].HeavySlash, keys[2].HeavySlash
        CurrentSquare = skill4
      end

      if index1 == "Exorcist Slash" then
        i = 0
        attack, attack2 = keys[1].ExorcistSlash, keys[2].ExorcistSlash
        CurrentSquare = skill5
      end
      
      love.graphics.setColor(1, 1, 1)
      
      image.new(CurrentSquare, (Square1X - (i * 64) + i * -30)  + 64 * 2.5, Square1Y, 0, 64, 64) --Draw squares
      
      --Makes a square when the player level is too low
      if key1.Level > GetPlayerStats().Level then
        local text = love.graphics.getFont()
        local LevelString = "Lvl:"..key1.Level
       
        local levelstringX = text:getWidth(LevelString)
        local levelstringY = text:getHeight(LevelString)
        local textscaleX = 50/ levelstringX
        
        image.new(AbilitySquareCD, 6 + (Square1X - (i * 64) + i * -30)  + 64 * 2.5, Square1Y + 6, 0, 52,  52, 0, 0)
        BetterText( LevelString, (Square1X - (i * 64) + i * -30) + 64 * 2.5 + 32 - (textscaleX * (levelstringX/2)), Square1Y + levelstringY/2, textscaleX)
        
        
        
      end  
      
      --Makes a square above the other square with a number describing the amount of time until the cooldown is over
      if key1.CurrentCooldown ~= 0 then
        local text = love.graphics.getFont()
        local string = tostring(math.floor(key1.CurrentCooldown).."."..math.floor(key1.CurrentCooldown * 10))
        local stringX = text:getWidth(string)
        local stringY = text:getHeight(string)
        local scalex = 64/ stringX
        local percentage = math.floor((key1.CurrentCooldown*64) / key1.Cooldown)
        if percentage ~= 0 then --Avoids love2D out of position visual error
          image.new(AbilitySquareCD, 6 + (Square1X - (i * 64) + i * -30)  + 64 * 2.5, Square1Y + 6, 0, 52, percentage - 6, 0, 0)
          BetterText( string,(Square1X - (i * 64) + i * -30)  + 64 * 2.5 + 32 - stringX/2, Square1Y + stringY/2, scalex - 0.1)
        end
      end
      BetterText(tostring(attack.."/"..attack2), (Square1X - (i * 64) + i * -30)  + 64 * 2.5 - 20, Square1Y - 10, 0.7, 0.7) --Key to press information
      
      --Indicates wheater the player has the buff on or off
      if GetPlayer().Buffed then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(buffsquare,335,50)
        love.graphics.setColor(1,1,0)
        if GetTimer("AdrenalineTimer") then
          love.graphics.rectangle("fill",335,50+buffsquare:getHeight(),(Timer.GetValue("AdrenalineTimer")*buffsquare:getWidth())/GetTimer("AdrenalineTimer").maxvalue,10)
        end
        love.graphics.setColor(1, 1, 1)
      end
--detect if the player is buffed and turn visible the information



    end


  
  --Health Bar BackGround------------------------------------------------------------------------------------------------------------------
  image.new(BarBackground, InterfaceObjects.HealthBar.BackgroundPosition.x, InterfaceObjects.HealthBar.BackgroundPosition.y, 0, InterfaceObjects.HealthBar.BackgroundSize.x, InterfaceObjects.HealthBar.BackgroundSize.y)
    
  --Health Bar  
  image.new(HealthBar, InterfaceObjects.HealthBar.BackgroundPosition.x, InterfaceObjects.HealthBar.BackgroundPosition.y, 0, InterfaceObjects.HealthBar.BarSize, InterfaceObjects.HealthBar.BackgroundSize.y) 
  
  --Health Bar Text
  local HealthString = "Hp: " ..playerStats.Health.. "/" ..playerStats.MaxHealth
  
  BetterText(HealthString, InterfaceObjects.HealthBar.BackgroundPosition.x + 10, InterfaceObjects.HealthBar.BackgroundPosition.y + InterfaceObjects.HealthBar.BackgroundSize.y/6) --Create text with stroke
  
  --Energy Bar BackGround------------------------------------------------------------------------------------------------------------------
  image.new(BarBackground, InterfaceObjects.EnergyBar.BackgroundPosition.x, InterfaceObjects.EnergyBar.BackgroundPosition.y, 0, InterfaceObjects.EnergyBar.BackgroundSize.x, InterfaceObjects.EnergyBar.BackgroundSize.y)
    
  --Energy Bar
  image.new(EnergyBar, InterfaceObjects.EnergyBar.BackgroundPosition.x, InterfaceObjects.EnergyBar.BackgroundPosition.y, 0, InterfaceObjects.EnergyBar.BarSize, InterfaceObjects.EnergyBar.BackgroundSize.y) 
  
  --Energy Bar Text
    local EnergyString = "SP: " ..playerStats.Stamina.. "/" ..playerStats.MaxStamina
  
  BetterText(EnergyString, InterfaceObjects.EnergyBar.BackgroundPosition.x + 10, InterfaceObjects.EnergyBar.BackgroundPosition.y + InterfaceObjects.EnergyBar.BackgroundSize.y/6) --Create text with stroke
  
  --Experience Bar BackGround------------------------------------------------------------------------------------------------------------------
  image.new(BarBackground, InterfaceObjects.ExperienceBar.BackgroundPosition.x, InterfaceObjects.ExperienceBar.BackgroundPosition.y, 0, InterfaceObjects.ExperienceBar.BackgroundSize.x, InterfaceObjects.ExperienceBar.BackgroundSize.y)
    
  --Experience Bar  
  image.new(ExperienceBar, InterfaceObjects.ExperienceBar.BackgroundPosition.x, InterfaceObjects.ExperienceBar.BackgroundPosition.y, 0, InterfaceObjects.ExperienceBar.BarSize, InterfaceObjects.ExperienceBar.BackgroundSize.y) 
  
  --Experience Bar Text
  if playerStats.ExperienceReq[level] ~= nil then --check if player is max level or not
    local ExperienceString = "Exp: " ..playerStats.XP.. "/" ..playerStats.ExperienceReq[level]
  
  BetterText(ExperienceString, InterfaceObjects.ExperienceBar.BackgroundPosition.x + 10, InterfaceObjects.ExperienceBar.BackgroundPosition.y + InterfaceObjects.ExperienceBar.BackgroundSize.y/6, 0.7, 0.7) --Create text with stroke
  else
    BetterText("Max level", InterfaceObjects.ExperienceBar.BackgroundPosition.x + 10, InterfaceObjects.ExperienceBar.BackgroundPosition.y + InterfaceObjects.ExperienceBar.BackgroundSize.y/6, 0.7, 0.7)
  end
  --Level Number------------------------------------------------------------------------------------------------------------------
  local LevelString
  if level ~= nil then
    LevelString = "Lvl " ..level
else
    LevelString = "LEVEL NOT FOUND"
  end
  BetterText(LevelString, InterfaceObjects.ExperienceBar.BackgroundPosition.x, InterfaceObjects.ExperienceBar.BackgroundPosition.y + InterfaceObjects.ExperienceBar.BackgroundSize.y) --Create text with stroke


  --Transition Effect
  if ScreenTransition.x > -love.graphics.getWidth() * 2 then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", ScreenTransition.x, 0, love.graphics.getWidth() * 2, love.graphics.getHeight())
  end

  DrawVictoryScreen()-- end of the game

end

function UpdateInterface(dt)
  
  if GetPlayerStats().Health <= 0 then
    deathScreen = true
  else
    deathScreen = false
  end

  
  if ScreenTransition.x > -love.graphics.getWidth() * 2 then
    
    ScreenTransition.x = ScreenTransition.x - (5000 * dt)
    
  end
   if ScreenTransition.x < 0 and ScreenTransition.func ~= nil then
    ScreenTransition.func()
    ScreenTransition.func = nil
    GetPlayer().ControlEnabled = true
  end   
  
  
  
  --Update the font being used--
  font = love.graphics.getFont()
  --Update player level--
  level = playerStats.Level
  --Health--
  InterfaceObjects.HealthBar.BarSize = (playerStats.Health * InterfaceObjects.HealthBar.BackgroundSize.x)/playerStats.MaxHealth
  --Energy--
  InterfaceObjects.EnergyBar.BarSize = (playerStats.Stamina * InterfaceObjects.EnergyBar.BackgroundSize.x)/playerStats.MaxStamina
  --Experiencee--
  if playerStats.ExperienceReq[level] ~= nil then --check if player is max level or not
    InterfaceObjects.ExperienceBar.BarSize = (playerStats.XP * InterfaceObjects.ExperienceBar.BackgroundSize.x)/playerStats.ExperienceReq[level]
  else
    InterfaceObjects.ExperienceBar.BarSize = InterfaceObjects.ExperienceBar.BackgroundSize.x
  end
end  

function CreateImages()
  
    EnergyBar = love.graphics.newImage(InterfaceImages.."EnergyBar.png")
    HealthBar = love.graphics.newImage(InterfaceImages.."HealthBar.png")
    ExperienceBar = love.graphics.newImage(InterfaceImages.."ExperienceBar.png")
    BarBackground = love.graphics.newImage(InterfaceImages.."BarBackground.png")
    AbilitySquare = love.graphics.newImage(InterfaceImages.. "PixelArtSquare.png")
    AbilitySquareCD = love.graphics.newImage(InterfaceImages.."PixelArtSquareOnCooldown.png")
    buffsquare = love.graphics.newImage(InterfaceImages.."Adrenaline.png")
    statisticsButton = love.graphics.newImage(InterfaceImages.. "SquaredButtonStatistics.png")
    backgroundwindow = love.graphics.newImage(InterfaceImages.. "portraitAtributes.png")
    DefaultBar = love.graphics.newImage(InterfaceImages.. "Bar.png")    
    plusButton = love.graphics.newImage(InterfaceImages.. "SquaredButtonPlus.png")
    skill1 =love.graphics.newImage(InterfaceImages.. "SkillSlashSquare.png") --Slash
    skill2 =love.graphics.newImage(InterfaceImages.. "SkillChargeSquare.png") --Slash
    skill3 =love.graphics.newImage(InterfaceImages.. "SkillBuffSquare.png") --Slash
    skill4 =love.graphics.newImage(InterfaceImages.. "SkillHeavySlash.png") --Slash
    skill5 =love.graphics.newImage(InterfaceImages.. "SkillExSlashSquare.png") --Slash
    recFrame = love.graphics.newImage(InterfaceImages.. "Frame.png")
    optionsFrame = love.graphics.newImage(InterfaceImages.. "OptionsPanel.png")
    plusSign = love.graphics.newImage(InterfaceImages.."SquaredButtonPlus.png")
    crossSign = love.graphics.newImage(InterfaceImages.."SquaredButtonX.png")
    soundPoint = love.graphics.newImage(InterfaceImages.. "SoundPoint.png")
    minusSign = love.graphics.newImage(InterfaceImages.. "SquaredButtonMinus.png")
    CheatsFrame = love.graphics.newImage(InterfaceImages.. "CheatsWindow.png")
    configbutton = love.graphics.newImage(InterfaceImages.. "ConfigButton.png")
    
end  

function GetRectangle() return DefaultBar end

