HitmanPlus={}
HitmanPlus.Config={}
HitmanPlus.Config.HitTime = 360

local meta = FindMetaTable( "Player" )

function meta:isHitman()
	if GAMEMODE.Jobs:GetPlayerJob( self ).Name == "Hitman" then
		return true
	else
		return false
	end
end

function meta:getHitEventId()
	return self:GetNWInt("Hitman.curEventId",-10 )
end

function meta:IsHitBusy()
	return self:GetNWBool("Hitman.BusyState",false )
end

function meta:isHitmanBusy()
	if self:isHitman() and self:IsHitBusy() then
		return true
	else
		return false
	end
end