BetterLua = {}
function BetterLua.Writeln(text)
  io.write(text)
  io.write("\n")
end
function BetterLua.IntRGB(red,green,blue)
  local R = red / 255
  local G = green / 255
  local B = blue / 255
  return R,G,B
end
function BetterLua.IntRGB(red,green,blue,alpha) --rgb 255 format
  local R = red / 255
  local G = green / 255
  local B = blue / 255
  local A = alpha
  return R,G,B,A
end 



function BetterLua.Wait(seconds) --waits a number of seconds
local startTime = os.time()
repeat until os.time() > seconds + startTime
end 
function BetterLua.Wait()
 local startTime = os.time()
repeat until os.time() > 0.001 + startTime
end
function BetterLua.TableRemoveByValue(Luatable,value) --removes a value from a table
  for i = 1, #Luatable do
    if (Luatable[i] == value) then
      table.remove(Luatable,i)
      break
    end
   end 
end 
return BetterLua