
local ScreenWidth = love.graphics.getWidth()
local ScreenHeigth = love.graphics.getHeight()



--This needs to be global because there are no classes in Lua
image = {}
frame = {}
button  = {}


local buttoncreate = {}
local buttoncreate2 = {}
function button.create2(imagefile, PosX, PosY, Size)
 
  local index = tostring(PosX.. PosY.. Size)
  local MouseHover = true
  local info = {}
  info.mouseHover = false
  

  
  if buttoncreate[index] == nil then
    buttoncreate[index] = {mousehover =  false, lastMousePosition = {x = love.mouse.getX(), y = love.mouse.getY()}, clicking = false}
    print("xD rawr")
  else
    info.mouseHover = buttoncreate[index].mousehover
  end  



  function info:mousehover(bool)
    buttoncreate[index].mousehover = bool
    return index
  end  
  
  
  --Set the hovering animation--
  if love.mouse.getX() > PosX and love.mouse.getX() < PosX + Size and love.mouse.getY() > PosY and love.mouse.getY() < PosY + Size then
    buttoncreate[index].mousehover = true
  elseif love.mouse.getX() ~= buttoncreate[index].lastMousePosition.x and love.mouse.getY() ~= buttoncreate[index].lastMousePosition.y then
    buttoncreate[index].mousehover = false
    GetMousePlace(0)
  end
  
  
  buttoncreate[index].lastMousePosition.x = love.mouse.getX()
  buttoncreate[index].lastMousePosition.y = love.mouse.getY()
  
  Size = Size/ imagefile:getWidth()
  
  
  if buttoncreate[index].mousehover then
    love.graphics.setColor(1, 1, 0.3, 0.8)
    love.graphics.rectangle("fill", PosX - 5, PosY -5, Size * imagefile:getWidth() + 10, Size * imagefile:getWidth() + 10)
  end
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(imagefile, PosX, PosY, 0, Size, Size)
  --
    if buttoncreate[index].mousehover then
      love.graphics.setColor(1, 1, 0.3, 0.2)
      love.graphics.rectangle("fill", PosX, PosY, Size * imagefile:getWidth(), Size * imagefile:getWidth())
    end  
    love.graphics.setColor(1, 1, 1)
  
  
  function info:click1(func)
      if love.mouse.isDown(1) and (buttoncreate[index].clicking == false) then

      
      buttoncreate[index].clicking = true
      if info.mouseHover then
        func()
      end
      
      return true
    elseif love.mouse.isDown(1) and (buttoncreate[index].clicking == true and buttoncreate[index] ~= nil) then
      return false
    elseif not love.mouse.isDown(1) then 

        buttoncreate[index].clicking = false
      return false
    end  
  end 

  return info
  
end  

function button.create(formate, PosX, PosY, SizeX, SizeY, String)
  
  --Variables--
  local index = tostring(PosX.. PosY.. SizeX .. SizeY)
  
  local mouseHover2 = false
  local info = {}
  info.mouseHover = false
  -------------
  
  if buttoncreate2[index] == nil then
    buttoncreate2[index] = {mousehover =  false, lastMousePosition = {x = love.mouse.getX(), y = love.mouse.getY()}, clicking = false}
    print("xD rawr")
  else
    info.mouseHover = buttoncreate2[index].mousehover
  end  

  function info:mousehover(bool)
    buttoncreate2[index].mousehover = bool
    return index
  end



  --Set the hovering animation--
  if love.mouse.getX() > PosX and love.mouse.getX() < PosX + SizeX and love.mouse.getY() > PosY and love.mouse.getY() < PosY + SizeY then
    info.mouseHover = true
  elseif love.mouse.getX() ~= buttoncreate2[index].lastMousePosition.x and love.mouse.getY() ~= buttoncreate2[index].lastMousePosition.y then
    info.mouseHover = false
    GetMousePlace(0)
  end
  
  
  
  buttoncreate2[index].lastMousePosition.x = love.mouse.getX()
  buttoncreate2[index].lastMousePosition.y = love.mouse.getY()
  

  
  
  if info.mouseHover then
    love.graphics.setColor(1, 1, 0.3, 0.8)
    love.graphics.rectangle("fill", PosX - 5, PosY -5, SizeX + 10, SizeY + 10)
  end  
  

  
  love.graphics.setColor(1, 1, 1)
  ------------------------------
  
  --Set the rectangle up--
  love.graphics.setColor(formate)
  love.graphics.draw(GetRectangle(), PosX, PosY, 0, SizeX/GetRectangle():getWidth(), SizeY/GetRectangle():getHeight())
  love.graphics.setColor(1, 1, 1)
  ------------------------
  
  --Set the text details--
  local font = love.graphics.newFont(Images.."joystix monospace.ttf", 25) --Change the UI font into "Joystix monospace"
  love.graphics.setFont(font)
  local font2 = love.graphics.getFont()
  
  local stringlenght = font:getWidth(String)
  local stringHeight = font:getHeight(String)
  
  local textX = 1.5
  local textY = 1.5 
  local textPosX = PosX + SizeX/2 - (stringlenght* textX)/2
  local textPosY = PosY + SizeY/2 - (stringHeight * textY)/2
  ------------------------
  
  --Set the text itself--
    love.graphics.setColor(0, 0, 0)
    --Text Stroke
    love.graphics.print(String, textPosX + 1, textPosY, 0, textX, textY)
    love.graphics.print(String, textPosX + 1, textPosY + 1, 0, textX, textY)
    love.graphics.print(String, textPosX + 1, textPosY - 1, 0, textX, textY)
    love.graphics.print(String, textPosX - 1, textPosY, 0, textX, textY)
    love.graphics.print(String, textPosX - 1, textPosY + 1, 0, textX, textY)
    love.graphics.print(String, textPosX - 1, textPosY - 1, 0, textX, textY)
    love.graphics.print(String, textPosX , textPosY + 1, 0, textX, textY)
    love.graphics.print(String, textPosX, textPosY - 1, 0, textX, textY)

   --Front text
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(String, textPosX , textPosY, 0, textX, textY)
  -----------------------
  
  if info.mouseHover then
    love.graphics.setColor(1, 1, 0.3, 0.2)
    love.graphics.rectangle("fill", PosX, PosY, SizeX, SizeY)
  end  
  love.graphics.setColor(1, 1, 1)
  
  function info:click1(func)
      if love.mouse.isDown(1) and (buttoncreate2[index].clicking == false) then

      
      buttoncreate2[index].clicking = true
      if info.mouseHover then
        func()
      end
      
      return true
    elseif love.mouse.isDown(1) and (buttoncreate2[index].clicking == true and buttoncreate[index] ~= nil) then
      return false
    elseif not love.mouse.isDown(1) then 

        buttoncreate2[index].clicking = false
      return false
    end  
  end  
  
  return info
  
end  

function image.pixelsX(image, x)
  
  return (x/image:getWidth())
  
  
end  

function image.pixelsY(image, y)
  
  return (y/image:getHeight())
  
end  

function frame.slide(Ix, Iy, Fx, Fy, velocity)
  
  local x, y = Ix, Iy
  local speed = (velocity * love.timer.getDelta())
  

  
  if Ix > Fx then
   x = x - speed 
  elseif Ix < Fx then 
   x = x + speed
  end
   if Iy > Fy then
   y = y - speed 
  elseif Iy < Fy then 
   y = y + speed
  end

  if (Ix > Fx and Ix - speed < Fx) or (Ix < Fx and Ix + speed > Fx) then
    x = Fx
  end 
  
  if (Iy > Fy and Iy - speed < Fy) or (Iy < Fy and Iy + speed > Fy) then
    y = Fy
  end 



  return x, y
  
end  

function pixelSlide(I, F, DT)

  
end  

function image.new(ilabel, PosX, PosY, rotation, sizeX, sizeY, offsetX, offsetY)
  
  if sizeX ~= nil then
  sizeX = image.pixelsX(ilabel, sizeX)
end

  if sizeY ~= nil then
    sizeY = image.pixelsY(ilabel, sizeY)
  end  

  if offsetX == nil then
    offsetX = 0
  end  
  
  if offsetY == nil then
    offsetY = 0
  end  

  rotation = (rotation * (math.pi*2))/360
  love.graphics.draw(ilabel, PosX, PosY, rotation, sizeX, sizeY, offsetX, offsetY)
  
end  

function pixelToScale(xValue, yValue)
  
  return (xValue * love.graphics.getWidth()), (yValue * love.graphics.getHeight())
  
end  

function ScaleToPixels(xValue, yValue)
  
  return (xValue / love.graphics.getWidth()), (yValue / love.graphics.getHeight())
  
end  

function BetterText(String, PosX, PosY, SizeX, SizeY)
  
  if SizeX == nil then
    SizeX = 1
  end
  
  if SizeY == nil then
    SizeY = 1
  end  
  
    love.graphics.setColor(0, 0, 0)
    --Text Stroke
    --I printed it 8 times because its the only possible way of creating a stroke effect on love2d
    love.graphics.print(String, PosX + 1, PosY, 0, SizeX, SizeY)
    love.graphics.print(String, PosX + 1, PosY + 1, 0, SizeX, SizeY)
    love.graphics.print(String, PosX + 1, PosY - 1, 0, SizeX, SizeY)
    love.graphics.print(String, PosX - 1, PosY, 0, SizeX, SizeY)
    love.graphics.print(String, PosX - 1, PosY + 1, 0, SizeX, SizeY)
    love.graphics.print(String, PosX - 1, PosY - 1, 0, SizeX, SizeY)
    love.graphics.print(String, PosX , PosY + 1, 0, SizeX, SizeY)
    love.graphics.print(String, PosX, PosY - 1, 0, SizeX, SizeY)

  --Front text
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(String, PosX , PosY, 0, SizeX, SizeY)
  
  
end  

function RGB(r, g, b)
  return {r/255, g/255, b/255}
end  

return button

