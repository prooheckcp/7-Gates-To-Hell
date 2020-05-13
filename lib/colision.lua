function GetBoxCollisionDirection(x1, y1, w1, h1, x2, y2, w2, h2)
  
  local xdist = math.abs((x1 + (w1 / 2)) - (x2 + (w2 / 2)))
  local ydist = math.abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
  local combinedwidth = (w1 / 2) + (w2 / 2)
  local combinedheight = (h1 / 2) + (h2 / 2)
  if xdist > combinedwidth then
    local player = GetPlayer()
    return vector2.new(0, 0)
  end
  
  if ydist > combinedheight then
    return vector2.new(0, 0)
  end  
  local overlapx = math.abs(xdist - combinedwidth)
  local overlapy = math.abs(ydist - combinedheight)
  local direction = vector2.normalize(vector2.sub(vector2.new(x1, y1), vector2.new(x2, y2)))
  
  local collisiondirection
  
  if overlapx > overlapy then
   
   -- collisiondirection = vector2.normalize(vector2.new(0, direction.y * overlapy))
    collisiondirection = vector2.new(0, direction.y * overlapy)
  elseif overlapx < overlapy then
    collisiondirection = vector2.new(direction.x * overlapx, 0)
   else
    collisiondirection = vector2.new(direction.x * overlapx, direction.y * overlapy)
   
  end 
  return collisiondirection
end  

function CheckObjectCollisionForPlayer(player, world, acceleration, movementdirection, futureposition)
  

  -------------------------
  local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x, player.size.y, world.position.x, world.position.y, world.size.x, world.size.y)
  
   local collisiondir = vector2.normalize(collisiondirection)
  if (collisiondir.x ~= 0 or collisiondir.y ~= 0) then
    if collisiondir.y ~= 0 and movementdirection.y ~= collisiondir.y then
        player.velocity.y = 0
        acceleration.y = 0
        if collisiondir.y == -1 then
        player.onGround = true
      end
    end 
    if collisiondir.x ~= 0 and movementdirection.x ~= collisiondir.x then
     player.velocity.x = 0
     acceleration.x = 0
   end


  end
  return acceleration
end  

function CheckObjectCollisionForTiled(player, world, acceleration, movementdirection, futureposition) --only works on tiled

  -------------------------
  local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x, player.size.y, world.x, world.y, world.width, world.height)
  
   local collisiondir = vector2.normalize(collisiondirection)
  if (collisiondir.x ~= 0 or collisiondir.y ~= 0) then
    if collisiondir.y ~= 0 and movementdirection.y ~= collisiondir.y then
        player.velocity.y = 0
        acceleration.y = 0
        if collisiondir.y == -1 then
          player.onGround = true
        end
    end 
    if collisiondir.x ~= 0 and movementdirection.x ~= collisiondir.x then
     player.velocity.x = 0
     acceleration.x = 0
   end


  end
  
                if math.ceil(collisiondirection.x) ~= 0 and (player.position.x + player.size.x > world.x and player.position.x < world.x + world.width) then
                  player.position.x = player.position.x + collisiondirection.x + 1
                end
                if math.ceil(collisiondirection.y) ~= 0 and (player.position.y + player.size.y < world.y and player.position.y > world.y + world.height) then
                  player.position.y = player.position.y + collisiondirection.y + 1
                end

  return acceleration
end  

function CheckObjectCollisionForTiledEnemies(player, world, acceleration, movementdirection, futureposition) --only works on tiled
  

  -------------------------
  local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x, player.size.y, world.x, world.y, world.width, world.height)
  
  local collisiondir = vector2.normalize(collisiondirection)
  if not (collisiondir.x == 0 and collisiondir.y == 0) then
    if collisiondir.y == movementdirection.y then
      player.velocity.y = 0
      acceleration.y = 0
    
    elseif collisiondir.y == 1 then --up collision
      player.velocity.y = 0
      acceleration.y = 0
      
    elseif movementdirection.x ~= collisiondir.x then -- side collision
      player.velocity.x = 0
      acceleration.x = 0
      
    end  
  end  
  return acceleration
end  

function CheckObjectCollisionForEnemy(player, world, acceleration, movementdirection, futureposition)
  

  -------------------------
  local collisiondirection = GetBoxCollisionDirection(futureposition.x-3, futureposition.y, player.size.x+6, player.size.y, world.position.x, world.position.y, world.size.x, world.size.y)
  
  local collisiondir = vector2.normalize(collisiondirection)
  if not (collisiondir.x == 0 and collisiondir.y == 0) then
    if collisiondir.y == movementdirection.y then
      player.velocity.y = 0
      acceleration.y = 0
    
    elseif collisiondir.y == 1 then --up collision
      player.velocity.y = 0
      acceleration.y = 0
      
    elseif movementdirection.x ~= collisiondir.x then -- side collision
      player.velocity.x = 0
      acceleration.x = 0
      
    end  
  end  
  return acceleration
end  





