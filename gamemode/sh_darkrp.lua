-------------------------------------------------------------
  -- Setup
-------------------------------------------------------------
local p = getmetatable("FindMetaTable")

-------------------------------------------------------------
  -- Money Functions
-------------------------------------------------------------
function p:addMoney(number)
  self:AddMoney(number or 0)
end

function p:getMoney()
  return self:GetMoney()
 end

function p:canAfford(number)
  return self:GetMoney() <= number
end

function p:getDarkRPVar(type)
  if type == "money" then return self:GetMoney() or 0 end
  if type == "job" then return self:Team() or 0 end
  if type == "Arrested" then return self:IsPlayerInJail() or false end
  if type == "rpname" then return self:Nick() or "nil" end

  -- Ones that SantosRP doesn't have.

  if table.HasValue({"AFK", "AFKDemoted", "salary", "HasGunlicense", "wanted", "wantedReason", "agenda", "zombieToggle", "zPoints", "hasHit", "hitTarget", "hitPrice", "lastHitTime", "Energy"}, type) then return false end

  return nil
end

-------------------------------------------------------------
  -- Other Functions
-------------------------------------------------------------
function p:arrest(time)
  time = time or 10

  GAMEMODE.Jail:SendPlayerToJail(self)

  timer.Simple(time, function()
    if not self then return end
    if not self:IsPlayerInJail() then return end

    GAMEMODE.Jail:ReleasePlayerFromJail(self)
  end)
end

function p:unArrest()
  if not self then return end

  GAMEMODE.Jail:ReleasePlayerFromJail(self)
end

function p:isArrested()
  return self:IsPlayerInJail()
end