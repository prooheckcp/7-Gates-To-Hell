----Visual Stuff----
local forest --The first level of the game
local worlds = {}
local ScreenPhase = 0
function GetWorlds() return worlds, ScreenPhase end -- Returns the first level of the game UwU
function GetScreenPhase() return ScreenPhase end
function lastphase() ScreenPhase = ScreenPhase - 1 end
function nextphase() ScreenPhase = ScreenPhase + 1 end
function ChangePhase(number) ScreenPhase = number end
local paused = false
function GetPaused() return paused end 
function ChangePause() paused = not paused end

--Player
local playerImage = {size = nil, image = nil, idle = {}, walk ={}, jump = {}, slash = {}, tookdamage = {}}

--enemies images
--local EnemyQuad = love.graphics.newQuad(0,0,62,62)



-----Requires-----
require "Phases/menu"
local ButtonLib = require "lib/InterfaceLib"
require "lib/player"
require "lib/colision"
require "lib/world"
require "lib/vector"
require "lib/UI"
require "lib/BetterLua"
require "lib/enemies"
require "lib/audio"
require "lib/skills"
require "lib/debounces"
require "lib/interactables"
require "lib/extrafunctions"
require "Phases/tiledmap"
require "lib/animations"
require "lib/tutorial"
require "lib/Boss"
------------------

-----Variables-----
--Folders
Images = "Images/Menu/"
MapImages = "Images/Map/"
InterfaceImages = "Images/Interface/"
SpriteSheets = "Images/Spritesheets/"
Music = "Audio/Music/"
SFX = "Audio/SFX/"

--Others
local magma = {image = nil, quads = {}}
local sky, sky2, sky3, sky4
local cursor, cursor2
local gravity = vector2.new(0, 500)


-------------------
local enemies = {}


local EnemyImages = {}
EnemyImages.Slime = love.graphics.newImage(SpriteSheets.."Slime_animation_x64.png")
EnemyImages.BlueSlime = love.graphics.newImage(SpriteSheets.."Slime_animation_blue1.png")
EnemyImages.Rocky = love.graphics.newImage(SpriteSheets.."MagmaCubeSpriteSheet.png")
EnemyImages.BlueRocky = love.graphics.newImage(SpriteSheets.."MagmaCubeSpriteSheetBlueFire.png")
EnemyImages.Bird = love.graphics.newImage(SpriteSheets.."Bird.png")
EnemyImages.Guardian = love.graphics.newImage(SpriteSheets.."guardianSpriteSheet.png")


-------------------
love.window.setFullscreen(true)

  



function love.load()
  
   --Magma--
  magma.image = love.graphics.newImage(SpriteSheets.. "MagmaAnimation.png")
  for i = 0, 2 do --loop kek
    for j = 0, 3 do
    table.insert(magma.quads ,love.graphics.newQuad(i * 128, j * 128, 128, 128, magma.image:getDimensions()))
    end
  end
  

  CreateVariables()
  CreateImages()
  LoadAudio() -- Load sound effects and music
  LoadTutorial()
  --Load skys--
  sky, sky2, sky3, sky4 = love.graphics.newImage(MapImages.."ForestBackground.png"), love.graphics.newImage(MapImages.."OverWorld2.png"), love.graphics.newImage(MapImages.. "NetherBackground2.png"), love.graphics.newImage(MapImages.. "NetherBackground1.png")
  --Set cursors--
  cursor = love.mouse.newCursor(InterfaceImages.. "cursor.png")
  cursor2 = love.mouse.newCursor(InterfaceImages.. "cursor2.png")
  --
  --Quad System--
  local playerSpriteSheet = love.graphics.newImage(SpriteSheets.."/player.png")
  local playerQuadSize = 136
  --
  playerImage.size = playerQuadSize
  for i = 0, 2 do --idle
    playerImage.idle[i + 1] = love.graphics.newQuad(i * playerQuadSize, 0, playerQuadSize, playerQuadSize, playerSpriteSheet:getDimensions())
  end
  for i = 0, 5 do --walk
    playerImage.walk[i + 1] = love.graphics.newQuad(i * playerQuadSize, playerQuadSize + 1, playerQuadSize, playerQuadSize - 1, playerSpriteSheet:getDimensions())
  end
  for i = 0, 1 do --jump
    playerImage.jump[i + 1] = love.graphics.newQuad(i * playerQuadSize, playerQuadSize * 2 + 1, playerQuadSize, playerQuadSize - 1, playerSpriteSheet:getDimensions())
  end
  for i = 0, 4 do --slash
    playerImage.slash[i + 1] = love.graphics.newQuad(i * playerQuadSize, playerQuadSize * 3 + 1, playerQuadSize, playerQuadSize - 1, playerSpriteSheet:getDimensions())
  end
  
  playerImage.tookdamage[1] = love.graphics.newQuad(0, playerQuadSize * 4 + 1, playerQuadSize - 1, playerQuadSize, playerSpriteSheet:getDimensions()) --Took damage
  
  playerImage.image = playerSpriteSheet
  --
  ---------------
  


  
  worlds[1] = {map = loadTiledMap("Phases/Forest/mapConverter"), checkpoint = loadCheckPoint("Phases/Forest/mapConverter"), doorback = loadDoorBack("Phases/Forest/mapConverter"),enemies={},objects={}} --Put the file that you exported from Tiled
  worlds[2] = {map = loadTiledMap("Phases/DeepForest/mapConverter"), checkpoint = loadCheckPoint("Phases/DeepForest/mapConverter"), doorback = loadDoorBack("Phases/DeepForest/mapConverter"),enemies={},objects={}}
  worlds[3] = {map = loadTiledMap("Phases/Nether1/mapConverter"), checkpoint = loadCheckPoint("Phases/Nether1/mapConverter"), doorback = loadDoorBack("Phases/Nether1/mapConverter"),enemies={},objects={}}
  worlds[4] = {map = loadTiledMap("Phases/Nether2/mapConverter"), checkpoint = loadCheckPoint("Phases/Nether2/mapConverter"), doorback = loadDoorBack("Phases/Nether2/mapConverter"),enemies={},objects={}}
    worlds[5] = {map = loadTiledMap("Phases/BossRoom/mapConverter"), checkpoint = loadCheckPoint("Phases/BossRoom/mapConverter"), doorback = loadDoorBack("Phases/BossRoom/mapConverter"),enemies={},objects={}}
   local EnemyQuads ={walk={},stunned={},damage={}}
  local BirdQuad ={walk={},stunned={},damage={}}
   local magmaCubeQuad = {walk={},stunned={},damage={}}
   local guardianQuad = {walk={},stunned={},damage={}}
   for y = 0,1 do
     for x = 0,1 do
   table.insert(EnemyQuads.walk, love.graphics.newQuad(x * 64,y *64,64,64,EnemyImages.Slime:getDimensions()))
    end

   end
   table.insert(EnemyQuads.stunned,love.graphics.newQuad(0 * 64,2 *64,64,64,EnemyImages.Slime:getDimensions()))
    table.insert(EnemyQuads.damage,love.graphics.newQuad(0 * 64,2 *64,64,64,EnemyImages.Slime:getDimensions()))
   for x = 0,1 do
     for y = 0,1 do 
   table.insert(BirdQuad.walk, love.graphics.newQuad(x * 64,y *64,64,64,EnemyImages.Bird:getDimensions()))
   
      end
   end
    table.insert(BirdQuad.stunned,love.graphics.newQuad(0 * 64,2 *64,64,64,EnemyImages.Bird:getDimensions()))
    table.insert(BirdQuad.damage,love.graphics.newQuad(0 * 64,2 *64,64,64,EnemyImages.Bird:getDimensions()))
   
    for x = 0,3 do
        table.insert(magmaCubeQuad.walk, love.graphics.newQuad(x * 40,1 *40,40,40,EnemyImages.Rocky:getDimensions()))
         table.insert(magmaCubeQuad.stunned,love.graphics.newQuad(x * 40,0 *40,40,40,EnemyImages.Rocky:getDimensions()))
    end

    table.insert(magmaCubeQuad.damage,love.graphics.newQuad(0 * 64,2 *64,64,64,EnemyImages.Rocky:getDimensions()))
 for x = 0,1 do

        table.insert(guardianQuad.walk, love.graphics.newQuad(x * 100,0,100,100,EnemyImages.Guardian:getDimensions()))
      
   end
       table.insert(guardianQuad.stunned,love.graphics.newQuad(0 * 100,1 *100,100,100,EnemyImages.Guardian:getDimensions()))
    table.insert(guardianQuad.damage,love.graphics.newQuad(0 * 100,1 *100,100,100,EnemyImages.Guardian:getDimensions()))
    
    
 --First World   
 table.insert(worlds[1].enemies,CreateEnemy(1452, 664, 64, 64, 15, 5, "slime [1]", 1, 130, 400, RGB(18, 161, 37), 150, 7,EnemyImages.Slime,EnemyQuads))
 table.insert(worlds[1].enemies,CreateEnemy(4580, 681, 64, 64, 25, 7, "blue slime [2]", 1, 130, 400, RGB(255,255,255), 150, 15,EnemyImages.BlueSlime,EnemyQuads))
 table.insert(worlds[1].enemies,CreateEnemy(5971, 618, 64, 64, 35, 15, "slime [3]", 1, 130, 400, RGB(18, 161, 37), 150, 25,EnemyImages.Slime,EnemyQuads))
 table.insert(worlds[1].enemies,CreateEnemy(6714, 870, 64, 64, 45, 22, "slime [4]", 1, 130, 400, RGB(18, 161, 37), 150, 35,EnemyImages.Slime,EnemyQuads))
 
 --Second World
 table.insert(worlds[2].enemies,CreateEnemy(1149, 1194, 64, 64,50, 30, "blue slime [5]", 1, 130, 400, RGB(255,255,255), 150, 40,EnemyImages.BlueSlime,EnemyQuads))
 table.insert(worlds[2].enemies,CreateEnemy(2781, 1194, 64, 64, 55, 47, "Charger [6]", 2, 130, 400, RGB(255,255,255), 150, 45,EnemyImages.Bird,BirdQuad))
 table.insert(worlds[2].enemies,CreateEnemy(3481, 1194, 64, 64, 60, 58, "blue slime [7]", 1, 130, 400, RGB(255,255,255), 150, 50,EnemyImages.BlueSlime,EnemyQuads))
 table.insert(worlds[2].enemies,CreateEnemy(3385, 1194, 64, 64, 65, 73, "Charger [8]", 2, 130, 400, RGB(255,255,255), 150, 55,EnemyImages.Bird,BirdQuad))
    
    
 --Third World   
 
  table.insert(worlds[3].enemies,CreateEnemy(600, 800, 40, 40, 70, 100, "Rockys [9]", 3, 130, 400, RGB(255, 255, 255), 150,60,EnemyImages.Rocky,magmaCubeQuad))
  table.insert(worlds[3].enemies,CreateEnemy(600, 420, 40, 40, 75, 120, "blue Rockys [10]", 4, 130, 400, RGB(255, 255, 255), 150,65,EnemyImages.BlueRocky,magmaCubeQuad))
  table.insert(worlds[3].enemies,CreateEnemy(1890, 550, 40, 40, 85, 138, "Rockys [11]", 3, 130, 400, RGB(255, 255, 255), 150, 70,EnemyImages.Rocky,magmaCubeQuad))
  table.insert(worlds[3].enemies,CreateEnemy(2470, 800, 40, 40, 100, 175, "blue Rockys [12]", 4, 130, 400, RGB(255, 255, 255), 150, 75,EnemyImages.BlueRocky,magmaCubeQuad))
     
     
  --Fourth World
  
  
  table.insert(worlds[4].enemies,CreateEnemy(1250,800, 100, 100, 150, 250, "guardian [13]", 1, 130, 400, RGB(255, 255, 255), 250, 80,EnemyImages.Guardian,guardianQuad))
  table.insert(worlds[4].enemies,CreateEnemy(2550, 800, 100, 100, 200, 325, "guardian [14]", 1, 130, 400, RGB(255, 255, 255), 250, 85,EnemyImages.Guardian,guardianQuad))
    
    

  Skillstart()
   
  --table.insert(worlds[1].objects,CreateInteractable(1,vector2.new(1500,730),vector2.new(50,50),{1,1,1},true,0,InteractableApplyDamage,nil,{Damage=10,Integrity=100,MaxIntegrity=100},{Object={table=worlds[1].objects,obj=worlds[1].objects[#worlds[1].objects],Index=#worlds[1].objects+1},Data={Integrity=100,MaxIntegrity=100}},1,ApplyDamageOnInteractable,{Weakness="Charge"}))
  
  playerPortrait = love.graphics.newImage(MapImages.."Knight.png")
  FirstPlayerLoad(worlds[1])
end

function love.draw()

love.graphics.setColor(1, 1, 1)


  if ScreenPhase == 0 then
    
    menuDrawing(ButtonLib)
  
  else
  
  --Holds loading errors--
  if worlds[ScreenPhase] == nil then
    return
  end
  ------------------------
  --Draws the Map--
  love.graphics.setColor(1, 1, 1)
  if ScreenPhase == 1 then
    image.new(sky, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight()) --Background of the map
  elseif ScreenPhase == 2 then
     image.new(sky2, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  elseif ScreenPhase == 3  or ScreenPhase == 4 then
    image.new(sky3, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  elseif ScreenPhase == 5 then
    image.new(sky4, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  end
  worlds[ScreenPhase].map:camera() --Camera system
  if ScreenPhase == 5 then
    love.graphics.setColor(0.6, 0.6, 0.6)
  else
    love.graphics.setColor(0.8, 0.8, 0.8)
  end
  worlds[ScreenPhase].map:drawBackground()
  love.graphics.setColor(1, 1, 1)
  -----------------
  
  --Draws enteties--
  DrawPlayer(playerImage)
  DrawEnemies(worlds[ScreenPhase].enemies)
  DrawInteractables(worlds[ScreenPhase].objects)
  love.graphics.setColor(1, 1, 1)
  worlds[ScreenPhase].map:draw() --Draws the Map that you loaded
  if ScreenPhase == 5 then
    DrawBoss(magma)
  end
 
  ------------------
  
  --Draws the UI--
  love.graphics.setColor(1, 1, 1) --Normal colors
  love.graphics.origin() --Blocks the camera from the following block of code
  DrawInterface()
  ---------------
  
--BetterText(math.floor(GetPlayer().position.x).. ", "..math.floor(GetPlayer().position.y) .."  current tile: X:"..math.floor(GetPlayer().position.x/128).. ", Y:"..math.floor(GetPlayer().position.y/128) .. " FPS:" ..love.timer.getFPS() , 0, 0)--Check player position for debugging purposes
  
  DrawTutorial()
  end

 
  

end  

function love.update(dt)
  PlayMusic()
  
  
  --Set the cursor
  if love.mouse.isDown(1) then
    love.mouse.setCursor(cursor2)
  else
    love.mouse.setCursor(cursor)
  end  
  UpdateInterface(dt) --Update Interface
  if not GetPaused() and ScreenPhase ~= 0 then
  
   if worlds[ScreenPhase] == nil then
    return
  end
  worlds[ScreenPhase].map:interectables()
  
  UpdateTimers(dt)
  SkillUpdate(worlds[ScreenPhase].enemies,worlds[ScreenPhase].objects)
  UpdatePlayer(gravity, dt, worlds[ScreenPhase].enemies, playerImage) --Update the Player
  UpdateInteractables(worlds[ScreenPhase].objects)
  UpdateEnemies(worlds[ScreenPhase].enemies,gravity,dt, forest)
    if ScreenPhase == 5 then
    UpdateBoss(dt)
  end
  if ScreenPhase > 0 then
    UpdateTutorial(dt)
  end
  
end

end








function love.keypressed(key)
  
  KeyPressedMenu(key)
  KeyPressedPauseMenu(key)
  KeyPressedInGame(key)
  KeyPressedInAtrbPoints(key)
  KeyPressedInOptions(key)
  
  
  
end  


function love.keyreleased(key)
  
  if ScreenPhase == 0 then
    KeyWasPressedOnMenu(key)
  end
  
  if key == "escape" and ScreenPhase ~= 0 then
    paused = not GetPaused()
  end

end  

function SetScreenPhase(phase)
  ScreenPhase = phase
end  




function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
	-- Main loop time.
	while true do
		local start_time = love.timer.getTime()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
		
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
		local end_time = love.timer.getTime()
		local frame_time = end_time - start_time
		
		if love.timer then love.timer.sleep(1/60-frame_time) end
    

    
	end

end
