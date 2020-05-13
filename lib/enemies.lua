local Intangibility_Cooldown = 0.1
local Enemies = {}
local timer = 10
local HealthBarVar ={Color={0,1,0}, Y_offset=20,Y_size=50}
local StunBarVar ={Color={0.5,0.5,0.5}, Y_offset=35,Y_size=10}
local exclemationPoint, healthbar
local exclemantionOffSetY = 0
local exclemationDirection = true --true = up, false = down
local ghosts = {}
local fallVelocity = 150

function CreateEnemy(x, y, sizeX, sizeY, health, xp, name, etype, range, detectionRange, RGB, speed, damage,_image,_quads)

  exclemationPoint = love.graphics.newImage(MapImages.."ExclemationMark.png")
  healthbar =  love.graphics.newImage(InterfaceImages.."HealthBar.png")

  return {
    MaxHealth = health, --Enemy Max Health
  Health = health, --Enemy Current Health
  position = vector2.new(x,y), --Enemy Location Center
  size = vector2.new(sizeY, sizeY), -- Enemy Character Size
  Intangibility = false,
  IntangibilityTimer = Intangibility_Cooldown,
  Color = RGB,
  DefaultColor = RGB,-- The color of the enemy
  Damage = damage, -- Damage per hit
  XPAmmount = xp, -- The XP the enemy will drop
  IsStunned = false,
  StunTimer = 0,
  MaxStunTimer = 0,
  bilboard={Text= tostring(name),Color={1,1,1}},
  etype = etype, --type of behavior
  range = range, --Patrol range
  StartPos = vector2.new(x, y),
  velocity = vector2.new(0, 0),
  acceleration = vector2.new(0, 0),
  state = "PATROL",
  frictioncoefficient = 300,
  Drange = detectionRange,
  RespawnTimer=10,
  CurrentRespawnTimer=10,
  invulnerable = 0,
  maxvelocity = speed,
  searching=true,
  Exaustion=2,
  MaxExaustion=2,
  hunting={distance,direction,forceTowards},
  mass=1,
  knockbacked=0,
  spawnPosition = vector2.new(x,y),
  IsDead=false,
  respawnTimer=15,
  currentRespawnTimer=15,
  explosionTimer=2,
  explosionTriggered=false,
  currentExplosionTimer=2,
  art={
    image=_image,
    quads=_quads.walk,
    Walk_animation= animation.create(_quads.walk),
    StunQuads=_quads.stunned,
    Stun_animation=animation.create(_quads.stunned),
    DamageQuads=_quads.damage,
    Damage_animation=animation.create(_quads.damage),
    

    
    }
}

end

function EnemyPositionYByTile(tile,enemyHeight)
  return (tile * 128 - enemyHeight)
end
function EnemyPositionXByTile(tile,enemyHeight)
  return (tile * 128 - enemyHeight)
end

--Update the enemie health after taking damage
function ApplyDamageOnEnemy(enemies,damage)
  if enemies.Intangibility == false then
    enemies.Color = {1,0,0}
    playSfX("hitted")
    Fighting()
    local HP = enemies.Health
    enemies.Health = enemies.Health - (damage + CalculatePlayerStrength(GetPlayerStats().Level,GetPlayerAtrib().Strength))
    enemies.Intangibility =true
    return enemies.Health,damage,HP
  else
    return enemies.Health,0,enemies.Health
  end
end

--Control the enemie stun timer
function ApplyStunOnEnemy(enemies,timer)
 if enemies ~= nil then
    if type(timer) == "number" then
      enemies.IsStunned = true
      enemies.StunTimer = timer
      enemies.MaxStunTimer = timer
    end
  end
end


--Updates all enemies variables
function UpdateEnemies(enemies,gravity,dt)
  
if dt > 0.06 or dt < 0.01 then
  return 
end  
  
  local ExclamationPointSpeed = 15
  if exclemationDirection then
    
    exclemantionOffSetY = exclemantionOffSetY + ExclamationPointSpeed * dt
    
    if exclemantionOffSetY >= 10 then
        exclemationDirection = false
    end
    
  elseif not exclemationDirection then
  
    exclemantionOffSetY = exclemantionOffSetY - ExclamationPointSpeed * dt
    
    if exclemantionOffSetY <= 0 then
      exclemationDirection = true
    end
  
  end  
  for i = 1,#ghosts do
    if ghosts[i] then
      if ghosts[i].CurrentRespawnTimer > 0 then
      --  ghosts[i].CurrentRespawnTimer = ghosts[i].CurrentRespawnTimer - dt
      else
        ghosts[i].CurrentRespawnTimer = ghosts[i].RespawnTimer
        ghosts[i].Health = ghosts[i].MaxHealth
        ghosts[i].position = ghosts[i].StartPos
        ghosts[i].IsStunned = false
        ghosts[i].StunTimer = 0
        ghosts[i].MaxStunTimer = 0
       
        
    --    table.insert(enemies,ghosts[i])
        table.remove(ghosts,i)
      end
    end
  end
  
  local player = GetPlayer()
  for i = 1,#enemies do
  if  enemies[i] ~= nil then
   if enemies[i].IsDead == true then
    if enemies[i].currentRespawnTimer <= 0 then
      enemies[i].IsDead = false
      enemies[i].Health = enemies[i].MaxHealth          
      enemies[i].position = enemies[i].spawnPosition
      enemies[i].IsStunned = false
      enemies[i].StunTimer = 0
      enemies[i].MaxStunTimer = 0
      enemies[i].currentRespawnTimer=enemies[i].RespawnTimer
      enemies[i].currentExplosionTimer = enemies[i].explosionTimer
      enemies[i].explosionTriggered = false
    else
      enemies[i].currentRespawnTimer = enemies[i].currentRespawnTimer - dt
    end

   end 
  if enemies[i].IsDead == false then
    if enemies[i].explosionTriggered then
      if enemies[i].currentExplosionTimer <= 0 then
        Explosion(enemies[i],50)
        else
        enemies[i].currentExplosionTimer = enemies[i].currentExplosionTimer - dt
      end
    end
  
  if enemies[i].position.x < (GetPlayer().position.x + love.graphics.getWidth()/2 + enemies[i].size.x * 2) and enemies[i].position.x > (GetPlayer().position.x - love.graphics.getWidth()/2 - enemies[i].size.x * 2) then
    if enemies[i].StunTimer > 0 then
      enemies[i].StunTimer = enemies[i].StunTimer - dt
    elseif enemies[i].StunTimer < 0 then
      enemies[i].StunTimer = 0
    end
    if enemies[i].knockbacked > 0 then
      enemies[i].knockbacked = enemies[i].knockbacked - dt
    end
    if (enemies[i].knockbacked > 0 and enemies[i].etype ~= 2) or (enemies[i].etype == 2 and enemies[i].IsStunned) then
      KnockbackBehavior(enemies[i])
    else
      if Behavior ~= nil then
        Behavior(enemies[i]) -- Controls enemy position and AI
      end
    end
    if enemies[i].IsStunned == true then
      if enemies[i].StunTimer == 0 then
        enemies[i].IsStunned = false
      end
    end
    if enemies[i].Intangibility then
      if enemies[i].IntangibilityTimer > 0 then
        enemies[i].IntangibilityTimer = enemies[i].IntangibilityTimer - dt
        if enemies[i].IntangibilityTimer <  Intangibility_Cooldown - 0.1 then
          enemies[i].Color = enemies[i].DefaultColor --Back to default color
        end
     else
        
       enemies[i].Intangibility = false
       enemies[i].IntangibilityTimer = Intangibility_Cooldown
       
      end
     
    
  end
  end
  --collision
  if enemies[i].IsDead == false then
 -- if enemies[i].IsStunned == false then
   if enemies[i].etype ~= 4 then
   if enemies[i].IsStunned == false then
    local dir = GetBoxCollisionDirection(GetPlayer().position.x - 4,GetPlayer().position.y - 2,GetPlayer().size.x + 7,GetPlayer().size.y + 4,enemies[i].position.x,enemies[i].position.y,enemies[i].size.x,enemies[i].size.y)
  
    if dir.x ~= 0 or dir.y ~= 0 then
      if enemies[i].etype == 3 and not GetPlayer().onCharge then
        local BurnChance = love.math.random(1,4)
        if BurnChance > 2 then
          PlayerOnFire(5)
          ApplyPlayerDamage(enemies[i].Damage + BurnChance)
        end
      end
      
      ApplyPlayerDamage(enemies[i].Damage)
      PlayerKnockback(dir, enemies[i])
     -- Explosion(enemies[i],20)
      if enemies[i].etype == 2 then
 
    enemies[i].invulnerable = 2


end
end
end
else
  if math.abs(vector2.magnitude(enemies[i].position)-vector2.magnitude(GetPlayer().position)) <= 50 then
    if not enemies[i].explosionTriggered then
    enemies[i].explosionTriggered = true
    end
  end
  
  end
--end of collision

    if enemies[i].Health <= 0 and enemies[i].IsDead == false then 
      if enemies[i].currentExplosionTimer > 0.1 then
      GivePlayerXP(enemies[i].XPAmmount)
      end
      table.insert(ghosts,enemies[i])
      enemies[i].IsDead = true
     
      
      
    end
    end
  end
end
--end
end


--Draw the enemie healh bar on the top of his head
local function HealthBar(enemies)
  --healthbar
  love.graphics.setColor(0,0,0)
  image.new(healthbar, enemies.position.x, enemies.position.y - (HealthBarVar.Y_offset), 0, enemies.size.x,StunBarVar.Y_size, 0.5, 0.5)
  love.graphics.setColor(0, 1, 1)
  local percent = ((enemies.Health)/enemies.MaxHealth) * (enemies.size.x)
  image.new(healthbar, enemies.position.x , enemies.position.y - (HealthBarVar.Y_offset), 0, percent ,StunBarVar.Y_size, 1, 1)


end


--Draw a stun bar showing the duration left for the stun to end
local function StunBar(enemies)
  if enemies then
    if enemies.StunTimer > 0 then
      love.graphics.setColor(0,0,0)
      love.graphics.rectangle("fill",enemies.position.x,enemies.position.y - (StunBarVar.Y_offset),enemies.size.x,StunBarVar.Y_size)
    
      local percent = (enemies.StunTimer * enemies.size.x)/enemies.MaxStunTimer
      BetterText("Stunned",enemies.position.x - 50,enemies.position.y - (StunBarVar.Y_offset + 25))
      love.graphics.setColor(StunBarVar.Color)
      love.graphics.rectangle("fill",enemies.position.x,enemies.position.y - (StunBarVar.Y_offset),percent,StunBarVar.Y_size)
    end
  end
end
local font

--Draws the enemies in the player screen
function DrawEnemies(enemies)
   --Change the UI font into "Joystix monospace"
  if not font then
  font = love.graphics.newFont(Images.."joystix monospace.ttf", 25)
  end
  love.graphics.setFont(font)
  for i = 1,#enemies do
    if not enemies[i].IsDead then
      --Name of the enemy at the top of him
    local Text = love.graphics.getFont()
    local NameSizeX = Text:getWidth(enemies[i].bilboard.Text) --Check the name of the enemy on X
    local NameSizeY = Text:getHeight(enemies[i].bilboard.Text) --Check the name of the enemy on Y
    
  --Enemy Exclemation Point for when following the target
    love.graphics.setColor(1, 1, 1)
    if enemies[i].state == "ATTACK" and not enemies[i].IsStunned then
      image.new(exclemationPoint, enemies[i].position.x + enemies[i].size.x/4, enemies[i].position.y - (exclemationPoint:getHeight()/2) - NameSizeY  -(exclemantionOffSetY), 0, 16, 60.8, 0.5, 0)
    end

    if not enemies[i].IsStunned then
      love.graphics.setColor(enemies[i].bilboard.Color)
      BetterText(enemies[i].bilboard.Text, enemies[i].position.x - NameSizeX/6, enemies[i].position.y - NameSizeY - StunBarVar.Y_size , 0.75, 0.75)
    end
    HealthBar(enemies[i]) --Call Health Bar
    StunBar(enemies[i]) -- Call Stun Bar
    love.graphics.setColor(enemies[i].Color)


  if enemies[i].art.image then
      local finalQuad
      if not enemies[i].IsStunned then
        enemies[i].art.Walk_animation = animation.create(enemies[i].art.quads)
        enemies[i].art.Walk_animation.gap(1 * #enemies)
        finalQuad = enemies[i].art.Walk_animation:play()
      else
        if #enemies[i].art.StunQuads > 1 then
          enemies[i].art.Stun_animation = animation.create(enemies[i].art.StunQuads)
          enemies[i].art.Stun_animation.gap(1 * #enemies)
          finalQuad = enemies[i].art.Stun_animation:play()
        else
          finalQuad = enemies[i].art.StunQuads[1]
        end
      end
    if enemies[i].Intangibility then
      if #enemies[i].art.DamageQuads > 1 then
        enemies[i].art.Damage_animation = animation.create(enemies[i].art.DamageQuads)
        enemies[i].art.Damage_animation.gap(1 * #enemies)
        finalQuad = enemies[i].art.Damage_animation:play()
      else
        finalQuad = enemies[i].art.DamageQuads[1]
      end
  end
  if finalQuad ~= nil then
    if not enemies[i].IsStunned then
     if enemies[i].acceleration.x < 0 then
      love.graphics.draw(enemies[i].art.image,finalQuad,enemies[i].position.x ,enemies[i].position.y,0,1,1)
    else
       love.graphics.draw(enemies[i].art.image,finalQuad,enemies[i].position.x+enemies[i].size.x ,enemies[i].position.y,0,-1,1)
    end
  else
       love.graphics.draw(enemies[i].art.image,finalQuad,enemies[i].position.x ,enemies[i].position.y,0,1,1)
    end
  end
    
    else
       love.graphics.setColor(enemies[i].Color)
      love.graphics.rectangle("fill",enemies[i].position.x,enemies[i].position.y,enemies[i].size.x,enemies[i].size.y)
    end
  end
end
end


function EnemyKnockback(enemy,direction)
  if direction.x == 0 then
   
      direction.x = -GetPlayer().orientation
    end
    enemy.knockbacked = 0.6
  enemy.acceleration = vector2.new(9000 * -direction.x,-9500)---direction.x
       local move = vector2.new(9000 * -direction.x, -5500)--vector2.new(9500 * dir.x, -1000)
      enemy.acceleration = vector2.applyForce(move, enemy.mass,  enemy.acceleration) 

      enemy.velocity = vector2.add(enemy.velocity, vector2.mult(enemy.acceleration, love.timer.getDelta()))
      enemy.velocity = vector2.limit(enemy.velocity, enemy.maxvelocity*2)
    
     
  enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, love.timer.getDelta()))

  end

   function KnockbackBehavior(enemy)

     local dt = love.timer.getDelta()
      local movementdirection = vector2.new(0,-1)
     local acceleration = vector2.new(0,0)
     enemy.acceleration = acceleration
     local gravity = vector2.new(0,500)
     enemy.acceleration = vector2.applyForce(gravity, enemy.mass, enemy.acceleration)
     
   if vector2.magnitude(enemy.velocity) > 1 then --Avoid lag glitches
    --  if enemy.etype == 2 then 
   -- local friction = vector2.mult(vector2.normalize(vector2.mult(enemy.velocity, -1)),300)
   -- enemy.acceleration = vector2.applyForce(friction, player.mass, enemy.acceleration)
--  else
    local friction = vector2.mult(vector2.normalize(vector2.mult(enemy.velocity, -1)), 300)
    enemy.acceleration = vector2.applyForce(friction, player.mass, enemy.acceleration)
   -- end
 end
  
  
  local futurevelocity = vector2.add(enemy.velocity,vector2.mult(enemy.acceleration, dt))  
  futurevelocity = vector2.limit(futurevelocity, enemy.maxvelocity * 2)
  
  --calculating future position
  local futureposition = vector2.add(enemy.position,vector2.mult(futurevelocity, dt)) 
  --calculating collision
  local worlds, screenphase = GetWorlds() 
  if enemy.acceleration.x < 0 then
    movementdirection.x = 1

  elseif enemy.acceleration.x > 0 then
    movementdirection.x = -1
  end 
  
  if enemy.acceleration.y > 0 then
    movementdirection.y = -1

  elseif enemy.acceleration.y < 0 then
    movementdirection.y = 1
  end

  -- movementdirection = vector2.normalize(enemy.velocity)
  worlds[screenphase].map:HitboxForEnemies(enemy, enemy.acceleration, movementdirection, futureposition)
  
  --calculating the movement
  enemy.velocity = vector2.add(enemy.velocity, vector2.mult(enemy.acceleration, dt))
  enemy.velocity = vector2.limit(enemy.velocity, enemy.maxvelocity * 2) 
  enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, dt)) 
     
   enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, love.timer.getDelta()))
   
   
  end


function Behavior(enemy)
  if enemy.invulnerable > 0 then
    enemy.invulnerable = enemy.invulnerable - love.timer.getDelta()
  end  

  
  local StartingPoint = enemy.StartPos
  local Range =  enemy.range
  
  if enemy.acceleration.x == 0 then
    enemy.acceleration = vector2.new(500, 0) --Set default speed
  end   
  
-------------------Detection Radius-------------------  

  if StartingPoint.x + Range > enemy.position.x and StartingPoint.x - Range < enemy.position.x then
    enemy.invulnerable = 0
  end  


  if (GetPlayer().position.x > (enemy.position.x - enemy.Drange) and GetPlayer().position.x < (enemy.position.x + enemy.Drange)) and StartingPoint.x + Range * 8 > enemy.position.x and StartingPoint.x - Range * 8 < enemy.position.x then
    if enemy.invulnerable <= 0 then
      enemy.state = "ATTACK"
    else
      enemy.state = "PATROL"
    end  
  elseif enemy.invulnerable <= 0 and (enemy.etype ~= 2 or (enemy.etype == 2 and enemy.searching)) then
    enemy.state = "PATROL"
    enemy.invulnerable = 1
    if enemy.Health < enemy.MaxHealth then
      enemy.Health = enemy.Health + (enemy.MaxHealth/10 * love.timer.getDelta()) --Reset enemy HP in case off combat glitched
    elseif enemy.Health > enemy.MaxHealth then
      enemy.Health = enemy.MaxHealth
    end
    
    
  elseif enemy.invulnerable > 0 and (enemy.etype ~= 2 or (enemy.etype == 2 and enemy.searching)) then
    enemy.state = "PATROL"
    if enemy.Health < enemy.MaxHealth then
      enemy.Health = enemy.Health + (enemy.MaxHealth/10 * love.timer.getDelta()) --Reset enemy HP in case off combat glitched
    elseif enemy.Health > enemy.MaxHealth then
      enemy.Health = enemy.MaxHealth
    end

  end
  


-------------------PATROL MODE-------------------
  if enemy.state == "PATROL" then
    if StartingPoint.x + Range < enemy.position.x then
      
      if enemy.acceleration.x > 0 then
        enemy.acceleration = vector2.mult(enemy.acceleration, -1)
      end

    elseif StartingPoint.x - Range > enemy.position.x then

      if enemy.acceleration.x < 0 then
        enemy.acceleration = vector2.mult(enemy.acceleration, -1)
      end
    end
  end
  

-------------------ATTACK MODE-------------------
  if enemy.state == "ATTACK" then
    love.graphics.rectangle("fill", enemy.position.x, enemy.position.y - 150, 10, 10)
    enemy.acceleration = vector2.new(0, 0)
      
     if enemy.etype ~= 2 then
      -- if enemy.knockbacked > 0 then return end  --impedir de andar
      local distance =  vector2.sub(GetPlayer().position, enemy.position)
      local direction = vector2.normalize(distance)
      local forceToward = vector2.mult(direction, enemy.maxvelocity) --550
      forceToward.y = 0
      if enemy.knockbacked > 0 then
      forceToward.x = 0
      end
      enemy.acceleration.x = forceToward.x
      
  else
     if enemy.searching then
        enemy.searching = false
        enemy.hunting.distance =  vector2.sub(GetPlayer().position, enemy.position)
      
        enemy.hunting.direction = vector2.normalize(enemy.hunting.distance)
    end
      enemy.hunting.forceToward = vector2.mult(enemy.hunting.direction, enemy.maxvelocity * 2)
    
      enemy.hunting.forceToward.y = 0
      enemy.acceleration.x = enemy.hunting.forceToward.x
  if not enemy.searching then
    enemy.Exaustion= enemy.Exaustion - love.timer.getDelta()
    if enemy.Exaustion <= 0 then
      enemy.Exaustion=enemy.MaxExaustion
      enemy.searching=true
    
    end
  end
      
  end
  end  
 
-------------------Collisions-------------------
  local futurevelocity = vector2.add(enemy.velocity, vector2.mult(enemy.acceleration, love.timer.getDelta()))
   local ChargeSpeedMultiplier = 1
   if enemy.state == "ATTACK" and enemy.etype == 2 then
    ChargeSpeedMultiplier = 2
  end
  futurevelocity = vector2.limit(futurevelocity, enemy.maxvelocity * ChargeSpeedMultiplier)
  local movementdirection = vector2.new(0, -1)
  local futureposition
  futureposition = vector2.add(enemy.position, vector2.mult(futurevelocity, love.timer.getDelta()))

--Check the enemy movement direction
  if enemy.acceleration.x < 0 then
    movementdirection.x = -1
  elseif enemy.acceleration.x > 0 then
    movementdirection.x = 1
  end 
  
  if enemy.acceleration.y > 0 then
    movementdirection.y = -1
  elseif enemy.acceleration.y < 0 then
    movementdirection.y = 1
  end  
  
  
------------------------------------
  enemy.acceleration = vector2.applyForce(vector2.new(0, 500), 1, enemy.acceleration) --Gravity


local worlds, screenphase = GetWorlds() 
  worlds[screenphase].map:HitboxForEnemies(enemy, enemy.acceleration, movementdirection, futureposition)


    if enemy.acceleration.x == 0 then
      if enemy.etype ~= 2 then
      if enemy.knockbacked <= 0 then
      enemy.acceleration = vector2.applyForce(vector2.new(0, -500), 1, enemy.acceleration)
      end
    else
       if not enemy.IsStunned then
      ApplyStunOnEnemy(enemy,10)
      enemy.searching = true
      enemy.Exaustion=enemy.MaxExaustion
      end
      end
    end  
  
 
---Check the player
  enemy.acceleration = CheckObjectCollisionForEnemy(enemy, GetPlayer(), enemy.acceleration, movementdirection, futureposition)

-------------------APPLY THE VECTORS-------------------  
 -- if not enemy.IsStunned then
 
    enemy.velocity = vector2.add(enemy.velocity , vector2.mult(vector2.mult(enemy.acceleration, 50), love.timer.getDelta()))
    local velocityY = enemy.velocity.y
    enemy.velocity = vector2.limit(enemy.velocity, enemy.maxvelocity * ChargeSpeedMultiplier)
    enemy.velocity.y = velocityY
    if enemy.velocity.y > fallVelocity then
      enemy.velocity.y = fallVelocity
    end
    if enemy.IsStunned then
      enemy.velocity.x = 0
    end
    enemy.position = vector2.add(enemy.position , vector2.mult(enemy.velocity, love.timer.getDelta()))
 -- end

  end

 function Explosion(origin,range)
    if math.abs(vector2.magnitude(origin.position) - vector2.magnitude(GetPlayer().position)) < range then
   --if GetPlayer().position.x > (origin.position.x - range) and GetPlayer().position.x < (origin.position.x + range) then

     ApplyPlayerDamage(origin.Damage)
    end
    local world,screenphase = GetWorlds()
    for i = 1,#world[screenphase].enemies do
    if world[screenphase].enemies[i] ~= origin then
      if math.abs(vector2.magnitude(origin.position) - vector2.magnitude(world[screenphase].enemies[i].position)) < range then
        ApplyDamageOnEnemy(world[screenphase].enemies[i],origin.Damage)
      end
    else
      world[screenphase].enemies[i].Health = 0
    end
  end
 end
 end
  
return Enemies