--//to end by prooheckcp

animation = {}
local animations = {}
local animationsInfo = {}
function animation.create(array)
  
  local DefaultInfo = {timeBeetweenFrames = 1, clock = 0, frame = 1}
  local CurrentInfo = nil
  local previusData = false
  local events = {}
  
  for i, k in pairs(animations) do
    if k == array then --Found previous data
      previusData = true
      CurrentInfo = animationsInfo[i]
      --print("already existed!")
    else --Create new data
      
    end
  end 
  if previusData ~= true then
    animations[#animations + 1] = array
    animationsInfo[#animationsInfo + 1] = DefaultInfo
  end

  if CurrentInfo ~= nil then
    if CurrentInfo.clock < CurrentInfo.timeBeetweenFrames then--reset timer
      CurrentInfo.clock = CurrentInfo.clock + love.timer.getDelta()
      
    else
      
      CurrentInfo.clock = 0
      if CurrentInfo.frame < #array then
        CurrentInfo.frame = CurrentInfo.frame + 1
      else
        CurrentInfo.frame = 1
      end
    end
  end  
  
  
  --if CurrentInfo ~= nil then
  
  function events:play()
    
    if CurrentInfo ~= nil then
      return array[CurrentInfo.frame]
    else
      return array[1]
    end
  end
  
  function events:reset(number)
    
    if CurrentInfo ~= nil then
      CurrentInfo.clock = 0 
    end
    
  end  

  function events.gap(seconds)
    if CurrentInfo ~= nil then
       CurrentInfo.timeBeetweenFrames = seconds
    end
  end  
    
  function events.frame(number)
    if CurrentInfo ~= nil then
      CurrentInfo.frame = number
    end
  end
  --end
  return events

end