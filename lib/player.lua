require "lib/vector"
require "lib/debounces"

--Variables
local StartMaxHealth = 100
local StartMaxStamina = 100
local CooldownStartTime = 10
local KeyboardScheme = {}
KeyboardScheme[1] ={ up="up",left="left",right="right",down = "down",Slash=1,Charge=2,AdrenalineRush=4,HeavySlash=3,ExorcistSlash=5}
KeyboardScheme[2] = {up="up",left="left",right="right",down = "down",Slash=1,Charge=2,AdrenalineRush=4,HeavySlash=3,ExorcistSlash=5}
local Keys = KeyboardScheme
local Keys2 = {up="w",left="a",right="d",down = "s"}
local playerStartPos = vector2.new(1130,659.333)--vector2.new(love.graphics.getWidth()/2 + 700, 650) GetWorlds()[1].checkpoint
local Cooldown = CooldownStartTime
local Intangibility_Cooldown = 1
local StaminaRegenPerSec = 1
local DeathTimer = 2
local playerNormalColor = {1, 1, 1}
local playerDamagedColor = {1,0,0}
local playerColor = playerNormalColor
local LevelUpNotification = 0
local OnBattle = 0

function Fighting()
  OnBattle = 6
end  


--Declaration of settings 
local player = {
  position = vector2.new(playerStartPos.x, playerStartPos.y),
  velocity = vector2.new(0, 0),
  orientation = 1,
  size = vector2.new(76, 90),
  maxvelocity = 500,
  mass = 1,
  frictioncoefficient = 300,
  onGround = false,
  onCharge = false,
  checkPoint = vector2.new(playerStartPos.x, playerStartPos.y),
  Hide = false,
  Buffed = false,
  FireTime=0,
  ControlEnabled=true
}

--Player Stats
local playerStats = {
  MaxHealth = StartMaxHealth,
  Health = StartMaxHealth,
  MaxStamina = StartMaxStamina,
  Stamina = StartMaxStamina,
  Silenced = 0,
  Intangibility = false,
  onAttacking = false,
  XP = 0,
  Level = 1,
  ExperienceReq = {10, 20, 50, 80, 120, 185, 230, 290, 400, 480, 550, 700, 1000, 1300}
}
local playerAtrib = {
  Constitution = 0,
  Stamina = 0, --endurance
  Strength = 0
}
local playerCommands = {
  noClip = false,
}
-- functiond related with player settings


function BossDamagePlayer(damage, knock)

  if not playerStats.Intangibility and knock then
    
    PlayerKnockback(vector2.new(0.1, 1))
  end
  
  if not playerStats.Intangibility then
    playSfX("burn")
    ApplyPlayerDamage(damage)
  end
end  


function GetPlayerCommands()
  return playerCommands
end
function GetPlayerStats()
  return playerStats
end
function GetPlayerAtrib()
  return playerAtrib
end
function GetPlayer()
  return player
end
function GetSilence()
  if playerStats.Silenced > 0 then
  return true
else
   return false
 end
end
function GetPlayerStartPos()
  playerStartPos = vector2.new(love.graphics.getWidth()/2, 100)
  return playerStartPos
end

function ChangePlayerStat(stat,value)
  local HP = playerStats[stat]
  playerStats[stat] = playerStats[stat] + value
  return playerStats[stat], value, HP
end


function GetKey(key)
  if not player.ControlEnabled then return end
  return KeyboardScheme[1][key], KeyboardScheme[2][key]
end

function GetPlayerKeys()
  return KeyboardScheme
end  

function GetKeyboardScheme(value)
  return KeyboardScheme[value]
end
function ApplyPlayerDamage(damage)
  if GetPlayerStats().Health > 0 and not GetPlayerStats().Intangibility then
    playSfX("tookdamage")
    GetPlayerStats().Intangibility = true
    playerColor = playerDamagedColor
    OnBattle = 6
    if GetTimer("PlayerDamageDebounce") == nil then
      Timer.Add("PlayerDamageDebounce",Intangibility_Cooldown)
    end
    Timer.Play("PlayerDamageDebounce")
    return ChangePlayerStat("Health",-damage)
  end
end
function ConsumePlayerStamina(ammount)
  return ChangePlayerStat("Stamina",-ammount)
end
function GivePlayerXP(ammount)
  return ChangePlayerStat("XP",ammount)
end
function PlayerIsDead()
  if GetPlayerStats().Health <= 0 then
    return true
  else
    return false
  end
end



function DrawPlayer(spritesheet)
  

  
  if not GetPlayer().Hide then

  local idle = animation.create(spritesheet.idle)
  local walk = animation.create(spritesheet.walk)
  local jump = animation.create(spritesheet.jump)
  local slash = animation.create(spritesheet.slash)
  local tookDamage = animation.create(spritesheet.tookdamage)
  
  local quad = spritesheet.idle[1]
  
  --reset animations when not on use
  if not GetPlayerStats().onAttacking then
    slash.frame(1) 
    slash:reset()
  end
  if player.velocity.y < 2 and player.velocity.y ~= 0 and player.onGround == false then
  else
    jump.frame(1)
    jump:reset()
  end
  if player.velocity.x == 0 then 
    walk.frame(1)
    walk:reset()
  end  
  --
  
  if GetPlayerStats().onAttacking == true then --Slashing
    local Cattack = GetPlayerCurrentSkill()
    
    if Cattack == "Slash" then
      slash.gap(0.1)
      quad = slash:play()
    end
    
    if Cattack == "Heavy Slash" then
      slash.gap(0.1)
      quad = slash:play()
      if quad == spritesheet.slash[5] then
        slash.gap(999)
        quad = walk:play()
      end
    end  
    
    if Cattack == "Charge" then
      quad = spritesheet.slash[5]
    end  
  
    
  elseif playerColor ~= playerNormalColor then  
    quad = tookDamage:play()    
  elseif player.velocity.y < 2 and player.velocity.y ~= 0 and player.onGround == false then   --Jump
    jump.gap(0.2)   
    quad = jump:play()
    if quad == spritesheet.jump[2] then
      jump.gap(999)
    end
  elseif player.velocity.y > 0 and player.velocity.y ~= 0 and player.onGround == false then --Fall
    quad = spritesheet.jump[2]
  elseif player.velocity.x == 0 then --Idle
    idle.gap(0.4)
    quad = idle:play()
  elseif player.velocity.x ~= 0 then --Walking
    walk.gap(0.15)
    quad = walk:play()
    
  end
  
  
  


  --idle:play()

    --Player drawing--
    if LevelUpNotification > 0 then
      BetterText("Level Up!", player.position.x - player.size.x/2, player.position.y - 40)
    end
    love.graphics.setColor(playerColor)
    
    if player.orientation == 1 then
      love.graphics.draw(spritesheet.image, quad, player.position.x - 10, player.position.y + player.size.y, 0, 1, 1, 0, spritesheet.size)
    elseif player.orientation == -1 then
      love.graphics.draw(spritesheet.image, quad, player.position.x + player.size.x + 10, player.position.y + player.size.y, 0, -1, 1, 0, spritesheet.size)
    end
    ------------------
    
    --Player Hitbox--
    if love.keyboard.isDown("b") then
    love.graphics.setColor(0.2, 0.2, 0.8, 0.5)
    love.graphics.rectangle("fill", player.position.x, player.position.y, player.size.x, player.size.y)
    end
    -----------------
    love.graphics.setColor(1, 1, 1)

  
 if GetPlayerStats().onAttacking == true and GetPlayer().orientation ~= 0 then
   --love.graphics.setColor(0.5,0.5,0.5)
   --love.graphics.rectangle("fill", GetPlayer().position.x + (GetPlayer().size.x * GetPlayer().orientation), GetPlayer().position.y + (GetPlayer().size.x / 2),GetPlayer().size.x,10)
  end
end

love.graphics.setColor(1, 1, 1)

end

local function Died()
 GetPlayer().Hide = false
  GetPlayer().position = GetWorlds()[GetScreenPhase()].checkpoint
  GetPlayerStats().Health = GetPlayerStats().MaxHealth 
  GetPlayerStats().Stamina = GetPlayerStats().MaxStamina
  playerColor = playerNormalColor
  DeathTimer = 2
  ResetBoss()
  
  
 -- Timer.Erase("AwaitingRespawn")

end
function UpdatePlayer(gravity, dt,enemies)
  
  if OnBattle > 0 then
    OnBattle = OnBattle - dt
  end  
  
  if LevelUpNotification > 0 then
    LevelUpNotification = LevelUpNotification - dt
  end
  
  
  if GetPlayerStats().Health <= 0 then
    GetPlayerStats().Health = 0
    GetPlayer().Hide = true
    if DeathTimer <= 0 then
      Died()
    else
      DeathTimer = DeathTimer - dt
    end
  end    
  
  if dt > 0.06 or dt < 0.01 then
    return 
  end
  
  
  if GetPlayer().position.y > (love.graphics.getHeight() * 2) then
    Died()
  end
  GetPlayerStats().MaxHealth = CalculatePlayerMaxHealth(GetPlayerStats().Level,GetPlayerAtrib().Constitution)
  GetPlayerStats().MaxStamina = CalculateMaxStamina(GetPlayerStats().Level,GetPlayerAtrib().Stamina)
  
  if GetPlayerStats().Health > GetPlayerStats().MaxHealth then
    GetPlayerStats().Health = GetPlayerStats().MaxHealth 
  end
  
  if GetPlayerStats().Stamina > GetPlayerStats().MaxStamina then
    GetPlayerStats().Stamina = GetPlayerStats().MaxStamina
  elseif GetPlayerStats().Stamina < 0 then
    GetPlayerStats().Stamina = 0
  end
  
 if playerStats.ExperienceReq[playerStats.Level] ~= nil and GetPlayerStats().XP >= GetPlayerStats().ExperienceReq[GetPlayerStats().Level] then --Check if player is max level or not
    GetPlayerStats().Level = GetPlayerStats().Level + 1
    
    playSfX("level")
    LevelUpNotification = 2
    
    GetPlayerStats().XP = GetPlayerStats().XP - GetPlayerStats().ExperienceReq[GetPlayerStats().Level-1]
  end
  if GetTimer("Regens") == nil then --Check if the timer exist
    Timer.Add("Regens", 2,true,true) --create a timer with 1.5 seconds, activate loop mode and start it
  end
  if GetTimer("SPRegen") == nil then --Check if the timer exist
    Timer.Add("SPRegen",1.5,true,true) --create a timer with 1.5 seconds, activate loop mode and start it
  end
  if Timer.GetValue("SPRegen") <= 0 and Timer.IsPlaying("SPRegen") then
    if GetPlayerStats().Stamina < GetPlayerStats().MaxStamina then
      GetPlayerStats().Stamina = GetPlayerStats().Stamina + CalculateStaminaRegeneration(GetPlayerStats().Level,GetPlayerAtrib().Stamina)
    end
  end  
  if Timer.GetValue("Regens") <= 0 and Timer.IsPlaying("Regens") then
    if GetPlayerStats().Health < GetPlayerStats().MaxHealth and GetPlayerStats().Health > 0  and OnBattle <= 0 then
      GetPlayerStats().Health = GetPlayerStats().Health + CalculateHealthRegeneration(GetPlayerStats().Level,GetPlayerAtrib().Stamina)
     -- print(CalculateHealthRegeneration(GetPlayerStats().Level,GetPlayerAtrib().Stamina))
    end
  end
  if GetPlayerStats().Intangibility then
   if Timer.GetValue("PlayerDamageDebounce") ~= nil and Timer.GetValue("PlayerDamageDebounce") <= 0.02 then
      playerColor = playerNormalColor
     end
     if Timer.GetValue("PlayerDamageDebounce") == 0 then
  GetPlayerStats().Intangibility = false
  Timer.Reset("PlayerDamageDebounce")
    end
  end

    
  --Gravity
  if not PlayerIsDead() then
  local acceleration = vector2.new(0, 0)
  if not playerCommands.noClip and player.velocity.y <= 0 then
    acceleration = vector2.applyForce(gravity, player.mass, acceleration)
  elseif player.velocity.y >= 0 then
    acceleration = vector2.applyForce(vector2.mult(gravity, 1.5), player.mass, acceleration)
  else
  acceleration =vector2.applyForce(vector2.new(0,0), player.mass, acceleration)
end

  
  --Friction
  if vector2.magnitude(player.velocity) > 5 then --Avoid lag glitches
    local friction = vector2.mult(vector2.normalize(vector2.mult(player.velocity, -1)), player.frictioncoefficient)
    acceleration = vector2.applyForce(friction, player.mass, acceleration)
  else
    player.velocity = vector2.new(0,0)
  end
  
  
  local movementdirection = vector2.new(0, -1)
  
  --Controls
  if not player.onCharge then
    if love.keyboard.isDown(GetKey("right")) then
      player.orientation = 1
      movementdirection.x = 1 
      if (player.onGround or player.velocity.x >= -20) then
        if player.velocity.x < -20 then
          local move = vector2.new(1000, 0)
          acceleration = vector2.applyForce(move, player.mass, acceleration) 
        else
          local move = vector2.new(500, 0)
          acceleration = vector2.applyForce(move, player.mass, acceleration) 
        end  
      end
     
    end  
  
    if love.keyboard.isDown(GetKey("left")) then
      
      player.orientation = -1
      movementdirection.x = -1
      if (player.onGround or player.velocity.x <= 20) then
        
        if player.velocity.x > 20 then
          local move = vector2.new(-1000, 0)
          acceleration = vector2.applyForce(move, player.mass, acceleration) 
        else
          local move = vector2.new(-500, 0)
          acceleration = vector2.applyForce(move, player.mass, acceleration) 
        end  
        

      end

    
    end
  
    if (love.keyboard.isDown(GetKey("up"))) and player.onGround and player.velocity.y == 0 and not playerCommands.noClip then
      --local move = vector2.new(0, -50000)
      -- acceleration = vector2.applyForce(move, player["mass"], acceleration)
      playSfX("jump")
      player.velocity.y = -400
      movementdirection.y = 1
      player.onGround = false
  
  end
    if playerCommands.noClip then
      if love.keyboard.isDown(GetKey("down")) then
        local move = vector2.new(0, 500)
        acceleration = vector2.applyForce(move, player.mass, acceleration)
        movementdirection.y = -1
      end
      if love.keyboard.isDown(GetKey("up")) and player.velocity.y == 0 then
        local move = vector2.new(0, -500)
        acceleration = vector2.applyForce(move, player.mass, acceleration)
        movementdirection.y = 1
      end
    end
else


      local move = vector2.new(500 * player.orientation, 0)
      acceleration = vector2.applyForce(move, player.mass, acceleration)
  end
  
  movementdirection = vector2.normalize(player.velocity)

   --calculate the future velocity
   local futurevelocity = vector2.add(player.velocity, vector2.mult(acceleration,dt))
   futurevelocity = vector2.limit (futurevelocity, player.maxvelocity)
   
  local futureposition = vector2.add(player.position, vector2.mult(futurevelocity, dt))
  
  local worlds, screenphase = GetWorlds() 
  worlds[screenphase].map:Hitbox(player, acceleration, movementdirection, futureposition) --Create collisions with the world UwU

for index2, key2 in pairs(enemies) do
    if not key2.IsDead then
   if key2.position.x < (GetPlayer().position.x + love.graphics.getWidth()/2) and key2.position.x > (GetPlayer().position.x - love.graphics.getWidth()/2) then
      local futureposition = vector2.add(player.position, vector2.mult(futurevelocity, dt))
      acceleration = CheckObjectCollisionForPlayer(player, key2, acceleration, movementdirection, futureposition)
    end
  end
end
---Update Player---

if GetCurrentBossStats() ~= nil then
  acceleration = CheckObjectCollisionForPlayer(player, {position = vector2.new(128 * 13, 128 * 7), size = vector2.new(128, 128 * 2)}, acceleration, movementdirection, futureposition) --Boss
end

  if player.FireTime > 0 and player.onGround then
    player.onGround = false
    local dire = love.math.random(-1,1)
  acceleration = vector2.new(9500 * dire, -9500)
      local move = vector2.new(9500 * dire, -9000)
    acceleration = vector2.applyForce(move, player.mass, acceleration) 
    player.FireTime = player.FireTime - 1
    if player.FireTime - 1 <= 0 then
      playerStats.Intangibility = true
      Timer.Reset("PlayerDamageDebounce")
      Timer.Play("PlayerDamageDebounce")
    end
          
end

  player.velocity = vector2.add(player.velocity, vector2.mult(acceleration, dt))
  player.velocity = vector2.limit(player.velocity, player.maxvelocity)
  player.position = vector2.add(player.position, vector2.mult(player.velocity, dt))
  return acceleration, movementdirection
  
  end
  end
  --[[
  equations!!!!!!!!!!!!!!!!!!!!!!!!!
  ]]
  function CalculatePlayerMaxHealth(level,constitution)
    return ((100 + (level * 20)) + (constitution * 10))
  end
  function CalculateHealthRegeneration(level,stamina_atrib)
    return ((10 + (level * 2)) + (stamina_atrib * 1))
  end
  function CalculatePlayerMaxStamina(level,stamina_atrib)
    return ((90 + (level * 10)) + (stamina_atrib * 5))
  end
  function CalculateStaminaRegeneration(level,stamina_atrib)
    return ((9 + (level * 1)) + (stamina_atrib * 2))
  end
    function CalculateMaxStamina(level,stamina_atrib)
    return ((90 + (level * 10)) + (stamina_atrib * 5))
  end
  function CalculatePlayerStrength(level,strength)
    return ((2 * level) + (1 * strength))
  end
  
  function PlayerOnFire(value)
    if player.FireTime <= 0 and not playerStats.Intangibility then
      player.FireTime = value
    end
   --   local player = GetPlayer()
  --  local acceleration = vector2.new(-9500 * -firedirection.x,-9500)
  --     local move = vector2.new(-9500 * -firedirection.x, -9000)
   --       acceleration = vector2.applyForce(move, player.mass, acceleration) 
   --       player.velocity = vector2.add(player.velocity, vector2.mult(acceleration, love.timer.getDelta()))
    --      player.velocity = vector2.limit(player.velocity, player.maxvelocity)
   --       player.position = vector2.add(player.position, vector2.mult(player.velocity, love.timer.getDelta()))
  
  end
  function PlayerKnockback(dir, enemy)
    if not player.onCharge then 
      local player = GetPlayer()
  
      if dir.y ~= 0 and dir.x == 0 then
        if player.position.x + player.size.x/2 < enemy.position.x + enemy.size.x/2 then
          dir.x = -1
        else
          dir.x = 1
        end
      
          
    end
    
    --[[
    local acceleration = vector2.new(9500 * dir.x,-3500)
       local move = vector2.new(1500 * dir.x, -1000)
    ]]
    local acceleration = vector2.new(12500 * dir.x,-19500)
       local move = vector2.new(12500 * dir.x, -15500)--vector2.new(9500 * dir.x, -1000)
          acceleration = vector2.applyForce(move, player.mass, acceleration) 
          player.velocity = vector2.add(player.velocity, vector2.mult(acceleration, love.timer.getDelta()))
      player.velocity = vector2.limit(player.velocity, player.maxvelocity)
  player.position = vector2.add(player.position, vector2.mult(player.velocity, love.timer.getDelta()))
end
end
  function FirstPlayerLoad(world)
    --playerStartPos = vector2.new(world.checkpoint.x,world.checkpoint.y)
    player.position = world.checkpoint
    player.checkpoint = world.checkpoint
  end