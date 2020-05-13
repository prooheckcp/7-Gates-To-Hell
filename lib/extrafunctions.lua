function InteractableApplyDamage(params)
   if not GetPlayer().onCharge then
  if params == nil then return end
 ApplyPlayerDamage(params.Damage)
 PlayerOnFire(10)
 end
end

function SwordAttacked(params)
 -- print(params)
  if params ~= nil then
   -- print(params.Object.Index)
   if params.Data.Integrity > 0 then
    params.Data.Integrity = params.Data.Integrity - 1
  else
    --table.remove(params.Object.table,params.Object.Index)
  end
  
  end
  
end


function ApplyDamageOnInteractable(enemies,damage,SkillUsed,Params)
  if enemies.Intangibility == false then
    
    local HP = enemies.Health
    enemies.Health = enemies.Health - (damage + CalculatePlayerStrength(GetPlayerStats().Level,GetPlayerAtrib().Strength))
    enemies.Intangibility =true
    return enemies.Health,damage,HP
  else
    return enemies.Health,0,enemies.Health
  end
end