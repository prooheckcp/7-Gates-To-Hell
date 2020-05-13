--Music--
local Forest, Forest2, menu, nether, nether2, boss
---------

local Screen
local CurrentMusic = Forest

--Sound effects--
local slash -- For slashing attack
local click -- For buttons
local click2 -- For differnt type of button
local errorsfx -- When there is an error doing the action
local slash1 -- For the slash attack
local slash2 -- For the heavy slash
local woosh -- For the charged attack
local levelup -- For when the player levels up
local swordhit --when the attack hits a target
local powerup -- For adrenaline rush
local tookdamage -- Getting hit
local jump --Jump sound effect
local warning -- Warning for boss attacks
local burning --For the boss lava
-----------------

local MusicVolume = 0.1 --Set Default Music Volume
local SoundEffectsVolume = 0.1 --Set Default Sound Effects Volume

function ChangeMusicVolume(number) 
  if MusicVolume <= 1 and MusicVolume >= 0 then 
    local result = MusicVolume + number 
    
    if result <= 1 and result >= 0 then
      MusicVolume = result
    end
    
  end 
end


function ChangeSoundEffectsVolume(number)
  if SoundEffectsVolume <= 1 and SoundEffectsVolume >= 0 then
    local result = SoundEffectsVolume + number
    
    if result <= 1 and result >= 0 then
      SoundEffectsVolume = result
    end  
  end
end  

function GetSoundEffectsVolume() return SoundEffectsVolume end --Set sound effect volume
function GetMusicVolume() return MusicVolume end



--Load the musics into the script--

function LoadAudio()
  --Music 
  Forest = love.audio.newSource(Music.."forest.mp3", "stream")
  CurrentMusic = Forest
  Forest2 = love.audio.newSource(Music.. "forest2.mp3", "stream")
  menu = love.audio.newSource(Music.. "menu.mp3" , "stream")
  nether = love.audio.newSource(Music.. "Nether.mp3", "stream")
  nether2 = love.audio.newSource(Music.. "Nether2.mp3", "stream")
  boss = love.audio.newSource(Music.. "Boss.mp3", "stream")
  --Sound Effects
  click = love.audio.newSource(SFX.. "click2.wav", "static")
  click2 = love.audio.newSource(SFX.. "click3.wav", "static")
  errorsfx = love.audio.newSource(SFX.. "error.mp3", "static")
  slash = love.audio.newSource(SFX.. "swing.mp3", "static")
  woosh = love.audio.newSource(SFX.. "swoosh.mp3", "static")
  levelup = love.audio.newSource(SFX.."levelup.wav", "static")
  swordhit = love.audio.newSource(SFX.. "sword_hit.wav", "static")
  powerup = love.audio.newSource(SFX.. "powerup.mp3", "static")
  slash2 = love.audio.newSource(SFX.. "slash2.wav", "static")
  tookdamage = love.audio.newSource(SFX.. "tookdamage.wav", "static")
  jump = love.audio.newSource(SFX.. "jump.mp3", "static")
  warning = love.audio.newSource(SFX.. "warning.wav", "static")
  burning = love.audio.newSource(SFX.. "burn.wav", "static")
end
-----------------------------------

--Chose the musics used within each phase--

function ChangeMusic()
  
  if Screen == 1 then
    CurrentMusic = Forest
  end    
    
  if Screen == 0 then
    CurrentMusic = menu
  end  
  
  if Screen == 2 then
    CurrentMusic = Forest2
  end
  
  if Screen == 3 then
    CurrentMusic = nether
  end  
  
  if Screen == 4 then
    CurrentMusic = nether2
  end
  
  if Screen == 5 then
    CurrentMusic = boss
  end
  
  
end  
-------------------------------------------



function UpdateAudio()
  
  love.audio.setVolume(MusicVolume)

end  


function PlayMusic()

  if CurrentMusic ~= nil then
    CurrentMusic:setLooping(true)
  end
  
  if GetScreenPhase() ~= Screen then
    Screen = GetScreenPhase()
    
    
    if CurrentMusic ~= nil then
      CurrentMusic:stop()
    end
    
    ChangeMusic()    
    
    if CurrentMusic ~= nil then
      CurrentMusic:play() 
      
    end

    
  end
  --Change audios
    CurrentMusic:setVolume(MusicVolume)
  --  
  
end  
function playSfX(SFX2)
  
  local CurrentSFX
  
  if SFX2 == "slash" then
    CurrentSFX = slash
  end  
  
  if SFX2 == "click" then
    CurrentSFX = click
  end
  
  if SFX2 == "click2" then
    CurrentSFX = click2
  end  
  
  if SFX2 == "error" then
    CurrentSFX = errorsfx
  end  
  
  if SFX2 == "woosh" then
    CurrentSFX = woosh
  end
  
  if SFX2 == "level" then
    CurrentSFX = levelup
  end
  
  if SFX2 == "hitted" then
    CurrentSFX = swordhit
  end
  
  if SFX2 == "powerup" then
    CurrentSFX = powerup
  end  
  
  if SFX2 == "slash2" then
    CurrentSFX = slash2
  end
  
  if SFX2 == "tookdamage" then
    CurrentSFX = tookdamage
  end  
  
  if SFX2 == "jump" then
    CurrentSFX = jump
  end  
  
  if SFX2 == "warning" then
    CurrentSFX = warning
  end  
  
  if SFX2 == "burn" then
    CurrentSFX = burning
  end  
  --if SFX2 == "slash2" then
    --CurrentSFX = slash1
  --end
  
    if CurrentSFX ~= nil then
      CurrentSFX:setVolume(SoundEffectsVolume)
      CurrentSFX:stop(CurrentSFX)
      CurrentSFX:play(CurrentSFX)
    end
    
end  

















