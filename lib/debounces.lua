local Timers = {}
Timer = {}
function Timer.Add(name,_value,_loop,_play,_once)

    Timers[name] = {maxvalue = _value,value = _value,play=false,loop= false,once=false} 
    if _loop == nil then
    _loop = false
  end
  if _play == nil then
    _play = false
  end
  if _once == nil then
    _once = false
  end
    Timer.Loop(name,_loop)
    Timer.Play(name,_play)
    Timer.Once(name,_once)

 --table.insert(Timers[timername],{maxvalue = _value,value = _value})
end

function Timer.Play(name,isPlaying)
  if Timers[name] ~= nil then 
    if isPlaying == nil then
      isPlaying = true
    end
    Timers[name].play = isPlaying
  end
end
function Timer.Once(name,isOnce)
  if Timers[name] ~= nil then 
    if isOnce == nil then
      isOnce = true
    end
    Timers[name].once = isOnce
  end
end
function Timer.Loop(name,isLooping)
  if Timers[name] ~= nil then 
    if isLooping == nil then
      isLooping = true
    end
    Timers[name].loop = isLooping
  end
end
function Timer.Reset(name)
  if Timers[name] ~= nil then 
    Timers[name].value = Timers[name].maxvalue
  end
end
function Timer.Erase(name)
  Timer[name] = nil
end
function Timer.IsPlaying(name)
 if Timers[name] ~= nil then 
    return Timers[name].play
  else
  return nil
  end
end

function UpdateTimers(dt)
  local index = 0
  for i,debounceName in pairs(Timers) do
    index = index + 1
    if debounceName.value ~= 0 and debounceName.play == true then
      if debounceName.value > 0 then
        debounceName.value = debounceName.value - dt
      else --if the timer is 0 or less
        if debounceName.loop == false then--if the loop in the timer is disable then the value is set to 0 and stop playing
          debounceName.value = 0
          debounceName.play = false
          if debounceName.once == true then
            table.remove(Timers,index)
          end
        else
          debounceName.value = debounceName.maxvalue
        end
      end
    elseif debounceName.loop == true and debounceName.play == true and debounceName.value <= 0 then
      debounceName.value = debounceName.maxvalue
    end
  end
end

function GetTimer(name)
  return Timers[name]
end
function GetTimerTable(name)
  return Timers
end
function Timer.GetValue(name)
  if Timers[name] ~= nil then
    return Timers[name].value
  else
    return nil
  end
end
function CreateTimer(variable)
   if variable > 0 then
  variable = variable - love.timer.getDelta()

 return variable 
else
 return 0
 end
end
return Timer