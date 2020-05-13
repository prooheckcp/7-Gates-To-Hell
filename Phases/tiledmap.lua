function loadCheckPoint(path)
  
  local map = require(path)
  
  local result = 0
  
  for _,i in ipairs(map.layers) do
    if i.type == "objectgroup" and i.name == "interectables" then
      for _, j in ipairs(i.objects) do
        if j.name == "checkpoint" then
          result = vector2.new(j.x + j.width/2, j.y + j.height - GetPlayer().size.y)
        end  
      end  
    end  
  end  
  
  return result
  
end  

function loadDoorBack(path)
  
  if path == nil then
    return
  end
  
  local map = require(path)
  local result = 0
  
  for _,i in ipairs(map.layers) do
    if i.type == "objectgroup" and i.name == "interectables" then
      for _,j in ipairs(i.objects) do
        if j.name == "doorback" then
          result = vector2.new(j.x + j.width/2, j.y + j.height - GetPlayer().size.y)
        end
      end
    end
  end  
  
  return result
  
end  


function loadTiledMap(path)
  local map = require(path) --Gets the table from tiled with the map

  local forestfolder = path:sub(1, -13) --Deletes the map convertor directory in order to find the correct path

    map.quads = {} --All the sprites after getting devided
    
    local tileset = map.tilesets[1] --Gets the tileset, not sure why does tiled create one even thoe there is only 1 in the entire files

    map.tileset = tileset
    map.image = love.graphics.newImage(forestfolder..tileset.image) --Gets the sprite sheet

    map.animatedTiles = {} --In case we want to animate in the future (prob only if we keep working on it after the 3rd delivery idk)
    for i, tile in ipairs(tileset.tiles) do
        map.animatedTiles[tile.id] = tile
    end

    map.frame = 0
    map.timer = 0.0
    map.maxTimer = 0.1

    for y = 0, (tileset.imageheight / tileset.tileheight) - 1 do --Cuts the quads nice and good 
        for x = 0, (tileset.imagewidth / tileset.tilewidth) - 1 do
            local quad = love.graphics.newQuad(
                x * tileset.tilewidth,
                y * tileset.tileheight,
                tileset.tilewidth,
                tileset.tileheight,
                tileset.imagewidth,
                tileset.imageheight
            )
            table.insert(map.quads, quad)
        end
    end

    function map:update(dt)
        if self.timer > self.maxTimer then 
            self.frame = self.frame + 1
            self.timer = 0
        end
        
        self.timer = self.timer + dt
    end

    function map:Hitbox(player, acceleration, movementdirection, futureposition) --Make the player collide with the tiled world
      for i, hitbox in ipairs(self.layers) do
        if hitbox.type == "objectgroup" and hitbox.name ~= "camera" and hitbox.name ~= "interectables" then
          for i = 1, #hitbox.objects do
            CheckObjectCollisionForTiled(player, hitbox.objects[i], acceleration, movementdirection, futureposition)
          end  
        end  
      end
    end  

    function map:HitboxForEnemies(player, acceleration, movementdirection, futureposition) --Make a non player entetie collide with the tiled world
      for i, hitbox in ipairs(self.layers) do
        if hitbox.type == "objectgroup" and hitbox.name ~= "camera" and hitbox.name ~= "interectables" then
          for i = 1, #hitbox.objects do
            CheckObjectCollisionForTiledEnemies(player, hitbox.objects[i], acceleration, movementdirection, futureposition)
          end  
        end  
      end
    end  
    
    local offset = 0
    function map:camera()
      
      
      local cameraY = 0
      
      if GetPlayer().position.y > love.graphics.getHeight() - love.graphics.getHeight()/4 - offset then
        
        offset = offset - math.floor((200 * love.timer.getDelta()))
        
      elseif offset < 0 and GetPlayer().position.y + offset < love.graphics.getHeight()/1.5  then
        

        offset = offset + math.floor((200 * love.timer.getDelta()))
        
      end  
      
      cameraY = cameraY + offset
      
      for i, objects in ipairs(self.layers) do
        if objects.name == "camera" and objects.type == "objectgroup" then
          local field = objects.objects[1]
          
          if GetPlayer().position.x - love.graphics.getWidth()/2 < field.x then
            love.graphics.translate(math.floor(-(field.x)),  cameraY)
          elseif GetPlayer().position.x + love.graphics.getWidth()/2 > field.x + field.width then
            love.graphics.translate(math.floor(-(field.x + field.width) + love.graphics.getWidth()),  cameraY)
          else
            love.graphics.translate(math.floor(-GetPlayer().position.x + GetPlayerStartPos().x) , cameraY)
          end
        end  
      end
    end

  function map:interectables()
    for i, inter in ipairs(self.layers) do
      if inter.name == "interectables" then
        for i, objects in ipairs(inter.objects) do
          
          
          
          if objects.name == "nextphase" then
            if GetPlayer().position.x + GetPlayer().size.x > objects.x and GetPlayer().position.x < objects.x + objects.width and GetPlayer().position.y + GetPlayer().size.y > objects.y and GetPlayer().position.y < objects.y + objects.height then
              --To change for future tests
              --And add polish UwU
              
              local function transport()
              GetPlayer().position = GetWorlds()[GetScreenPhase() + 1].checkpoint
              nextphase()
              end
              UpdateDarkScreen(transport)
              
              
            end
          end
          
          if objects.name == "lastphase" then
            if GetPlayer().position.x + GetPlayer().size.x > objects.x and GetPlayer().position.x < objects.x + objects.width and GetPlayer().position.y + GetPlayer().size.y > objects.y and GetPlayer().position.y < objects.y + objects.height then
              --To change for future tests
              --And add polish UwU
              --add doorback
              local function transport()
              GetPlayer().position = GetWorlds()[GetScreenPhase() - 1].doorback
              lastphase()
              end
              UpdateDarkScreen(transport)
              
            end
          end
          
          
          --Add killing interectable? xD
          
        end
      end 
    end  
      
  end  
  
  


    function map:drawBackground()
        for i, layer in ipairs(self.layers) do
          if layer.type == "tilelayer" and layer.name == "background" then --Makes sure that it is a tile in order to not call hitboxes
              for y = 0, layer.height - 1 do
                  for x = 0, layer.width - 1 do
                      local index = (x + y * layer.width) + 1
                      local tid = layer.data[index]

                      if tid ~= 0 then

                          if self.animatedTiles[tid - 1] ~= nil then
                            
                              local anim = self.animatedTiles[tid - 1].animation
                              local numFrames = #anim
                              local index = self.frame % numFrames

                              tid = anim[index + 1].tileid + 1
                          end

                          local quad = self.quads[tid]
                          local xx = x * self.tileset.tilewidth + layer.offsetx
                          local yy = y * self.tileset.tileheight + layer.offsety
                        --Draws the quad
                          love.graphics.draw(
                              self.image,
                              quad,
                              xx,
                              yy
                          )
                      end
                  end
              end
            end
        end
    end  


    function map:draw() --Grabs on the quads folder and builds the map with the help of the "mapConverter" exported file
        for i, layer in ipairs(self.layers) do
          if layer.type == "tilelayer" and layer.name ~= "background" then --Makes sure that it is a tile in order to not call hitboxes
              for y = 0, layer.height - 1 do
                  for x = 0, layer.width - 1 do
                      local index = (x + y * layer.width) + 1
                      local tid = layer.data[index]

                      if tid ~= 0 then

                          if self.animatedTiles[tid - 1] ~= nil then
                            
                              local anim = self.animatedTiles[tid - 1].animation
                              local numFrames = #anim
                              local index = self.frame % numFrames

                              tid = anim[index + 1].tileid + 1
                          end

                          local quad = self.quads[tid]
                          local xx = x * self.tileset.tilewidth + layer.offsetx
                          local yy = y * self.tileset.tileheight + layer.offsety
                        --Draws the quad
                          love.graphics.draw(
                              self.image,
                              quad,
                              xx,
                              yy
                          )
                      end
                  end
              end
            end
        end
    end

    return map --To avoid the usage of global variables it returns the map so that I can set it in the main file UwU
end