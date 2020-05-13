local brick -- To block the player from running away

local tile = 128
local dangerare = 0.2
local dangerareaD = 1
local BossComplete = false
local defaultProximityTimer = 10
local ProximityTimer = defaultProximityTimer

local BossDefaultStats = {
  health = 500,
  active = false,
  lava_floor = 100,
  lava_pillars = 50,
  timeBeetweenEachMove = 8,
  breaktime = 3,
  cooldown = 5,
  breaktimeCooldown = 0,
  currentattack = nil
}


local Boss = {
    size=vector2.new(100,200),
    position=vector2.new(2852,1062)
      }
local attacks = {

  LavaFloor = {
    Name = "LavaFloor",
    Draw = nil,
    behavior = nil,
    timer = 0
    },
  

  SpawnPillar = {
    Name = "SpawnPillar",
    Draw = nil,
    behavior = nil,
    timer = 0
  },
  SpawnPillar2 = {
    Name = "SpawnPillar2",
    Draw = nil,
    behavior = nil,
    timer = 0
  },
  
    BigPillar = {
    Name = "BigPillar",
    Draw = nil,
    behavior = nil,
    timer = 0
  },

  
  }

local CurrentBossStats = nil

function GetCurrentBossStats() return CurrentBossStats end
function GetDefaultBossStats() return BossDefaultStats end
function BossCompletion() return BossComplete end
function ResetBossCompletion() BossComplete = false end

--Pillar Attack
  function attacks.SpawnPillar.behavior(dt)
    attacks.SpawnPillar.timer = attacks.SpawnPillar.timer + dt
    
    if attacks.SpawnPillar.timer > 4 then
     for i= 14, 28 , 2 do
       
       if GetPlayer().position.x + GetPlayer().size.x > i * tile and GetPlayer().position.x < i * tile + tile then
         BossDamagePlayer(CurrentBossStats.lava_pillars, false)
       end
       
     end  
    end
    
  end  

function attacks.SpawnPillar.Draw(magma)   
  
  local magmaflow = animation.create(magma.quads)
  local quad = magmaflow:play()
  magmaflow.gap(0.15)
  
  
  for i= 14, 28 , 2 do
    for j = 0, 15 do
        if attacks.SpawnPillar.timer > 4 then
          love.graphics.draw(magma.image, quad, tile * i, tile * 2 + (tile * j) - 50, 0, 1, 1)
        else
          love.graphics.setColor(0.8, 0.1, 0.1, dangerare)
          love.graphics.rectangle("fill", tile * i, tile  + (tile * j), tile, tile)
          love.graphics.setColor(1, 1, 1)
        end
      end
    end  
end

--Pillar Attack2
  function attacks.SpawnPillar2.behavior(dt)
    attacks.SpawnPillar2.timer = attacks.SpawnPillar2.timer + dt
    
    if attacks.SpawnPillar2.timer > 4 then
     for i= 15, 28 , 2 do
       
       if GetPlayer().position.x + GetPlayer().size.x > i * tile and GetPlayer().position.x < i * tile + tile then
         BossDamagePlayer(CurrentBossStats.lava_pillars, false)
       end
       
     end  
    end
    
  end  

function attacks.SpawnPillar2.Draw(magma)   
  
  local magmaflow = animation.create(magma.quads)
  local quad = magmaflow:play()
  magmaflow.gap(0.15)
  
  
  for i= 15, 28 , 2 do
    for j = 0, 15 do
        if attacks.SpawnPillar2.timer > 4 then
          love.graphics.draw(magma.image, quad, tile * i, tile * 2 + (tile * j) - 50, 0, 1, 1)
        else
          love.graphics.setColor(0.8, 0.1, 0.1, dangerare)
          love.graphics.rectangle("fill", tile * i, tile  + (tile * j), tile, tile)
          love.graphics.setColor(1, 1, 1)
        end
      end
    end  
end

--BigPillar Attack
  function attacks.BigPillar.behavior(dt)
    attacks.BigPillar.timer = attacks.BigPillar.timer + dt
    
    if attacks.BigPillar.timer > 4 then
     for i= 18, 26  do
       
       if GetPlayer().position.x + GetPlayer().size.x > i * tile and GetPlayer().position.x < i * tile + tile then
         BossDamagePlayer(CurrentBossStats.lava_pillars, false)
       end
       
     end  
    end
    
  end  

function attacks.BigPillar.Draw(magma)   
  
  local magmaflow = animation.create(magma.quads)
  local quad = magmaflow:play()
  magmaflow.gap(0.15)
  
  
  for i= 18, 26  do
    for j = 0, 15 do
        if attacks.BigPillar.timer > 4 then
          love.graphics.draw(magma.image, quad, tile * i, tile * 2 + (tile * j) - 50, 0, 1, 1)
        else
          love.graphics.setColor(0.8, 0.1, 0.1, dangerare)
          love.graphics.rectangle("fill", tile * i, tile  + (tile * j), tile, tile)
          love.graphics.setColor(1, 1, 1)
        end
      end
    end  
end

--Lava floor
function attacks.LavaFloor.Draw(magma)
  
  local magmaflow = animation.create(magma.quads)
  local quad = magmaflow:play()
  magmaflow.gap(0.15)
  
  
  
  

  
    for i= 14, 28 do
      for j = 0, 3 do
        if attacks.LavaFloor.timer > 4 then
          love.graphics.draw(magma.image, quad, tile * i, tile * 9 + (tile * j) - 50, 0, 1, 1)
        else
          love.graphics.setColor(0.8, 0.1, 0.1, dangerare)
          love.graphics.rectangle("fill", tile * i, tile * 9 + (tile * j) - 50, tile, tile)
          love.graphics.setColor(1, 1, 1)
        end
      end
    end  
  
  end
  
  function attacks.LavaFloor.behavior(dt)
    attacks.LavaFloor.timer = attacks.LavaFloor.timer + dt --Warning time!
    
    if GetPlayer().position.y + GetPlayer().size.y > tile * 9 - 50 and attacks.LavaFloor.timer > 4 then
      print("OOF!")
      BossDamagePlayer(CurrentBossStats.lava_floor, true)
    end
    
  end  
  
    

  
 














function ResetBoss()
  
  --Reset the boss 
  CurrentBossStats = nil
  
  for _, i in pairs(attacks) do
    i.timer = 0
  end  
  
end  
  
function StartBossFight()
  
  brick = love.graphics.newImage(MapImages.."Bricked_Wall.png")
  
  --If it is the first time starting the boss
  if CurrentBossStats == nil then
    CurrentBossStats = deepcopy(BossDefaultStats)
    print("started!")
  end  
  
end  

function DrawBoss(magma)
  
  if CurrentBossStats ~= nil then
    
    --Wall to block the player off
    love.graphics.draw(brick, tile * 13, tile * 7, 0,  1, 1)
    love.graphics.draw(brick, tile * 13, tile * 8, 0,  1, 1)
    love.graphics.rectangle("fill",Boss.position.x,Boss.position.y,Boss.size.x,Boss.size.y)
    if CurrentBossStats.currentattack ~= nil then
    
    CurrentBossStats.currentattack.Draw(magma)
    
    end
  end
end  



function UpdateBoss(dt)
  dangerare = dangerare + dt * dangerareaD
  if dangerare > 0.6 then
    dangerareaD = dangerareaD * -1
    dangerare = 0.6
  elseif dangerare < 0.2 then
    dangerare = 0.2
    dangerareaD = dangerareaD * -1
  end
  --Start the fight if you get into the pit
  if GetPlayer().position.x > tile * 14 then
    StartBossFight()
  end
  --
  if math.abs(vector2.magnitude(GetPlayer().position) - vector2.magnitude(GetBoss().position)) < 100 then
    
     if ProximityTimer <= 0 then
        PlayerKnockback(vector2.new(-GetPlayer().orientation, 0),GetBoss())
        ProximityTimer = defaultProximityTimer
      else
        ProximityTimer = ProximityTimer - dt
      end
  end  
  

  
  if CurrentBossStats ~= nil then
    
    if BossDefaultStats.timeBeetweenEachMove > CurrentBossStats.cooldown then--Time beetween each moveset
      CurrentBossStats.cooldown = CurrentBossStats.cooldown + dt
    elseif CurrentBossStats.breaktimeCooldown > CurrentBossStats.breaktime then
      ChooseAttack()
    else
      CurrentBossStats.currentattack = nil
      CurrentBossStats.breaktimeCooldown = CurrentBossStats.breaktimeCooldown + dt
    end
    
    if CurrentBossStats.currentattack ~= nil then
      CurrentBossStats.currentattack.behavior(dt)
    end  
    
    

    --When the boss dies--
    if CurrentBossStats.health == 0 then
      GetPlayer().position.x, GetPlayer().position.y = 800, 1060
      GetPlayer().ControlEnabled = false
      CurrentBossStats = nil
      BossComplete = true
    end
    ----------------------
    
  end  
end   




function ChooseAttack()
   local j = 0
    for _,index in pairs(attacks) do
    j = j + 1
    end
  
    math.randomseed(os.time())
    local randomNumber = math.random(1, j)
    
    local i = 0
    
    for _,index in pairs(attacks) do
      i = i + 1
      
      if i == randomNumber then
        CurrentBossStats.currentattack = index
      end  
      
    end  
    
    print(CurrentBossStats.currentattack.Name)
    CurrentBossStats.cooldown = 0
    CurrentBossStats.breaktimeCooldown = 0
    CurrentBossStats.currentattack.timer = 0
    playSfX("warning")
end  



function DamageBoss(damage)
  
 if CurrentBossStats == nil then
  return
 end
 
  if CurrentBossStats.health - damage > 0 then 
    CurrentBossStats.health = CurrentBossStats.health - damage
  else  
    CurrentBossStats.health = 0
  end
 
end
 
 

--Seperate tables
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GetBoss()
  return Boss
end