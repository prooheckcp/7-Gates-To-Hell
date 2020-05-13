function DrawInteractables(objects)
  if objects then
  for i =1,#objects do
    love.graphics.setColor(objects[i].color)
    love.graphics.rectangle("fill",objects[i].position.x,objects[i].position.y,objects[i].size.x,objects[i].size.y)
  end
  end
end

function UpdateInteractables(objects)
  if objects then
  for i = 1,#objects do --+ ((GetPlayer().size.x) * GetPlayer().orientation)
    local sword = 0
    --if objects[i].IncludeSwordCollision then
      sword = (GetPlayer().size.x) * GetPlayer().orientation
    --end
     local dir = GetBoxCollisionDirection(GetPlayer().position.x,GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,objects[i].position.x,objects[i].position.y,objects[i].size.x,objects[i].size.y)
        if dir.x ~= 0 or dir.y ~= 0 then
              objects[i].triggering(objects[i].parameters)
        end
             local swordCollision = GetBoxCollisionDirection(GetPlayer().position.x + sword,GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,objects[i].position.x,objects[i].position.y,objects[i].size.x,objects[i].size.y)
        if swordCollision.x ~= 0 or swordCollision.y ~= 0 then
              objects[i].TriggerOnSword(objects[i].SwordParameters)
        end
    
     if objects[i].Health <= 0 and objects[i].CanDie then
    table.remove(objects,i)
  end
  end
  
 
  end
end

function CreateInteractable(_type,_position,_size,_color,_cancollide,_range,trigger,OnSword,_parameters,_swordParameters,_health,_onAttacked,_vars)
  return {
      itype=_type,
      MaxIntegrity= _integrity,
      position=_position,
      size=_size,
      color=_color,
      image=nil,
      MaxHealth=_health,
      Health=_health,
      CanDie=true,
      Intangibility=false,  
      cancollide=_cancollide,
      range=_range,
      triggering=trigger,
      TriggerOnSword=SwordAttacked,
      parameters=_parameters,
      SwordParameters=_swordParameters,
      OnAttacked=_onAttacked,
      Vars=_vars
    }
end

function ApplyAttackOnObject(object,damage,skill)
  if object.OnAttacked then
    object.OnAttacked(object,damage,skill,object.Vars)
  end
end