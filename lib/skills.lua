
local playerCurrentSkill = nil

function GetPlayerCurrentSkill() return playerCurrentSkill end

  function WriteRules(_canBeDamaged,_canBeStunned,_spendStamina)
    return {
        CanBeDamaged=_canBeDamaged,
        CanBeStunned =_canBeStunned,
        CanSpendStamina= _spendStamina,
     }
  end
local Skills = {
  Slash = {
      Damage= 3,
      Cooldown=0.6,
      CurrentCooldown=0,
      StaminaCost=10,
      RequiredLevel=1,
      SpecialEffectDuration=nil,
      Silence=0.6,
      Rules=WriteRules(true,false,true),
      Description=nil,
      Level = 1
    },
    Charge = {
      Damage=1,
      Cooldown=5,
      CurrentCooldown=0,
      StaminaCost=25,
      RequiredLevel=4,
      SpecialEffectDuration=nil,
      Silence=2,
      Rules=WriteRules(true,false,false),
      Description=nil,
      Level = 4
    },
    ["Adrenaline Rush"] = {
      Damage=0,
      Cooldown=15,
      CurrentCooldown=0,
      StaminaCost=100,
      RequiredLevel=12,
      SpecialEffectDuration= 4,
      Silence=0,
      Rules=WriteRules(false,false,true),
      Description=nil,
      Level = 12
    },
    ["Heavy Slash"] = {
      Damage=3,
      Cooldown=6,
      CurrentCooldown=0,
      StaminaCost=35,
      RequiredLevel=1,
      SpecialEffectDuration= 10,
      Silence=2,
      Rules=WriteRules(true,true,true),
      Description=nil,
      Level = 8

    },--[[
    ["Exorcist Slash"] = {
      Damage=15,
      Cooldown=10,
      CurrentCooldown=0,
      StaminaCost=10,
      RequiredLevel=1,
      SpecialEffectDuration=nil,
      Silence=1,
      Rules=WriteRules(true,false,true),
      Description=nil
    },]]
  }
  

function GetSkills()
  return Skills
end
function ExecuteSkill()
  Slash()
end


function Skillstart()
   --SetKeys(GetKeyboardScheme(1))
end
function SkillUpdate(enemies,objects)
  
  for i ,v in pairs(Skills) do
    --print(i)
    if GetTimer(i.."_Cooldown") and Timer.IsPlaying(i.."_Cooldown") then
      if Timer.GetValue(i.."_Cooldown") > 0 then
      v.CurrentCooldown = Timer.GetValue(i.."_Cooldown")
    else
      v.CurrentCooldown = 0
      end
    end
  end
  
  if GetTimer("DisableAttackingAnimation") ~= nil and Timer.GetValue("DisableAttackingAnimation") <= 0 then
    GetPlayerStats().Silenced = 0
  end

  if love.keyboard.isDown(GetKey("Slash")) and GetPlayerStats().Stamina >= Skills["Slash"].StaminaCost and Skills.Slash.CurrentCooldown <= 0 and GetPlayerStats().Level >= Skills["Slash"].Level then
   playSfX("slash") --SOUND EFFECT 
   playerCurrentSkill = "Slash"
    Attack("Slash",enemies,objects)
    
   
    
    --Timer.Play("SkillCooldown")
   
  end
  if GetPlayerStats().Silenced == 0 and  love.keyboard.isDown(GetKey("Charge")) and GetPlayerStats().Stamina > 1 and GetPlayer().onCharge == false and GetPlayerStats().Stamina >= Skills.Charge.StaminaCost and GetPlayerStats().Level >= Skills["Charge"].Level then
      if not GetTimer("Charge_Cooldown") or (GetTimer("Charge_Cooldown")and Timer.GetValue("Charge_Cooldown") == 0) then
    playSfX("woosh") --SOUND EFFECT 
    playerCurrentSkill = "Charge"
    GetPlayer().onCharge = true
    GetPlayerStats().Intangibility = true
    ConsumePlayerStamina(GetSkills()["Charge"].StaminaCost)

    Attack("Charge",enemies)
   
    Timer.Add("OnChargeTimer",GetSkills()["Charge"].Silence,false,true)
    end
  end
   if love.keyboard.isDown(GetKey("HeavySlash")) and GetPlayerStats().Stamina > 1 and Skills["Heavy Slash"].CurrentCooldown <= 0 and GetPlayerStats().Level >= Skills["Heavy Slash"].Level then
     playSfX("slash2")
     playerCurrentSkill = "Heavy Slash"
    Attack("Heavy Slash",enemies)
  end
  
  --[[
  if love.keyboard.isDown(GetKey("ExorcistSlash")) and GetPlayerStats().Stamina > 1 then
    playerCurrentSkill = "Exorcist Slash"
    Attack("Exorcist Slash",enemies)
  end]]
  if love.keyboard.isDown(GetKey("AdrenalineRush")) and GetPlayerStats().Stamina > 1 and not GetPlayer().Buffed and GetPlayerStats().Level >= Skills["Adrenaline Rush"].Level then
    if not GetTimer("Adrenaline Rush_Cooldown") or (GetTimer("Adrenaline Rush_Cooldown") and Timer.GetValue("Adrenaline Rush_Cooldown") == 0) then
    playSfX("powerup")
    playerCurrentSkill = "Adrenaline Rush"
    GetPlayer().maxvelocity = 400 + 10
    GetPlayerAtrib().Strength = GetPlayerAtrib().Strength + 10
    GetPlayer().Buffed = true
    ConsumePlayerStamina(GetSkills()[playerCurrentSkill].StaminaCost)
    playerCurrentSkill = nil
    Timer.Add("Adrenaline Rush_Cooldown",GetSkills()["Adrenaline Rush"].Cooldown,false,true)
    Timer.Add("AdrenalineTimer",GetSkills()["Adrenaline Rush"].SpecialEffectDuration,false,true)
    end
  
end
  if Timer.GetValue("DisableAttackingAnimation") == 0 then
      GetPlayerStats().onAttacking = false
      playerCurrentSkill = nil

      
    end
  if  GetTimer("AdrenalineTimer") ~= nil and Timer.GetValue("AdrenalineTimer") <= 0 and Timer.IsPlaying("AdrenalineTimer") then

    GetPlayer().Buffed = false
    GetPlayer().maxvelocity = 400 
    GetPlayerAtrib().Strength = GetPlayerAtrib().Strength - 10
  end
  if Timer.GetValue("OnChargeTimer") ~= nil then
    if Timer.GetValue("OnChargeTimer") <= 0 then
      if GetPlayer().onCharge == true then
        GetPlayer().onCharge = false
        Timer.Add("TimeUntilResetIntangibility",0.8,false,true)
      end
      if (Timer.GetValue("TimeUntilResetIntangibility") <= 0 and Timer.IsPlaying("TimeUntilResetIntangibility")) then
        GetPlayerStats().Intangibility = false
      end    
    elseif Timer.GetValue("OnChargeTimer") > 0 then
        for i = 1,#enemies do   
      local dir = GetBoxCollisionDirection(GetPlayer().position.x + ((GetPlayer().size.x) * GetPlayer().orientation),GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,enemies[i].position.x,enemies[i].position.y,enemies[i].size.x,enemies[i].size.y)
        if dir.x ~= 0 or dir.y ~= 0 then
          if Dattack.Rules.CanBeDamaged then
            ApplyDamageOnEnemy(enemies[i],GetSkills()["Charge"].Damage)
        
        end
    end
    
  end
   local world, screenphase = GetWorlds()
    if screenphase == 5 then
  local dirBoss = GetBoxCollisionDirection(GetPlayer().position.x + ((GetPlayer().size.x) * GetPlayer().orientation),GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,GetBoss().position.x,GetBoss().position.y,GetBoss().size.x,GetBoss().size.y)
        if dirBoss.x ~= 0 or dirBoss.y ~= 0 then
          if Dattack.Rules.CanBeDamaged then
            DamageBoss(GetSkills()["Charge"].Damage)
        
      end
      end
end
end
  
  end

 -- print(Timer.GetValue("SkillCooldown"))
end
function Attack(spellName,enemies,interactibles)
 if not GetSilence() then
    if (GetTimer(spellName.."_Cooldown") == nil or Timer.GetValue(spellName.."_Cooldown") == 0) then
  Dattack = GetSkills()[spellName]
    Timer.Add(spellName.."_Cooldown",Dattack.Cooldown)
    Timer.Play(spellName.."_Cooldown")
    GetPlayerStats().onAttacking = true
    if Dattack.Rules.CanSpendStamina then
      ConsumePlayerStamina(Dattack.StaminaCost)
    end
    if Dattack.Silence > 0 then
        GetPlayerStats().Silenced = Dattack.Silence
    end

    for i = 1,#enemies do   
      --print(i,enemies[i].Health)
      --GetPlayer().size.x--
      local dir = GetBoxCollisionDirection(GetPlayer().position.x + ((GetPlayer().size.x) * GetPlayer().orientation),GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,enemies[i].position.x,enemies[i].position.y,enemies[i].size.x,enemies[i].size.y)
      local normaldir = vector2.normalize(dir)
        if dir.x ~= 0 or dir.y ~= 0 then
          if Dattack.Rules.CanBeDamaged then
            ApplyDamageOnEnemy(enemies[i],Dattack.Damage)
            EnemyKnockback(enemies[i],normaldir)
          end
          if Dattack.Rules.CanBeStunned then
              ApplyStunOnEnemy(enemies[i],Dattack.SpecialEffectDuration)
          end
        end
      end
      
      if interactibles ~= nil then
        for i = 1,#interactibles do   
      --print(i,enemies[i].Health)
      --GetPlayer().size.x--
      local dir = GetBoxCollisionDirection(GetPlayer().position.x + ((GetPlayer().size.x) * GetPlayer().orientation),GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,interactibles[i].position.x,interactibles[i].position.y,interactibles[i].size.x,interactibles[i].size.y)
        if dir.x ~= 0 or dir.y ~= 0 then
          if Dattack.Rules.CanBeDamaged then
            ApplyAttackOnObject(interactibles[i],Dattack.Damage,spellName)
          end
          if Dattack.Rules.CanBeStunned then
            --  ApplyAttackOnObject(interactibles[i],Dattack.SpecialEffectDuration)
          end
        end
      end
    end
     local world, screenphase = GetWorlds()
    if screenphase == 5 then
     local dir = GetBoxCollisionDirection(GetPlayer().position.x + ((GetPlayer().size.x) * GetPlayer().orientation),GetPlayer().position.y,GetPlayer().size.x,GetPlayer().size.y,GetBoss().position.x,GetBoss().position.y,GetBoss().size.x,GetBoss().size.y)
        if dir.x ~= 0 or dir.y ~= 0 then
          if Dattack.Rules.CanBeDamaged then
            DamageBoss(Dattack.Damage)
          end
          if Dattack.Rules.CanBeStunned then
            --  ApplyAttackOnObject(interactibles[i],Dattack.SpecialEffectDuration)
          end
        end
        end
end
   Timer.Add("DisableAttackingAnimation",Dattack.Silence)
   Timer.Play("DisableAttackingAnimation")
end
end

function DrawSkills()
  if playerCurrentSkill == "Exorcist Slash" then
    love.graphics.setColor(0,0,1)
    local offset = 0
    if GetPlayer().orientation == -1 then
     offset = GetPlayer().size.x + 10
    end
    love.graphics.rectangle("fill",GetPlayer().position.x + (GetPlayer().size.x + 10 * GetPlayer().orientation-offset),GetPlayer().position.y,10,GetPlayer().size.y)
  end
end