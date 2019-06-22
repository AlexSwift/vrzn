--[[
	Name: sv_player_damage.lua
	For: TalosLife
	By: TalosLife
]]--

GM.PlayerDamage = {}

PrecacheParticleSystem( "blood_advisor_pierce_spray_b" )

function GM.PlayerDamage:PlayerLimbTakeDamage( pPlayer, intDmg, intDmgType, bNoTakeDamage )
	local DmgScale =  0.325
	local scale = DmgScale
	if not bNoTakeDamage then
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage( intDmg )
		dmgInfo:SetAttacker( Entity(0) )
		dmgInfo:SetInflictor( Entity(0) )
		dmgInfo:SetDamageType( DMG_GENERIC )

		dmgInfo:ScaleDamage( scale )
		pPlayer:TakeDamageInfo( dmgInfo )
	end

	return scale
end

--Passes damage to limbs for some kinds of damage, ie vehicle collisions
function GM.PlayerDamage:EntityTakeDamage( eEnt, pDamageInfo )
	if not IsValid( eEnt ) or not eEnt:IsPlayer() then return end
	local attacker = pDamageInfo:GetAttacker()
	
	if IsValid( attacker ) and attacker:IsVehicle() then
		pDamageInfo:ScaleDamage( 1 *(pDamageInfo:GetDamageForce():Length() /64000) )
		local dmg = pDamageInfo:GetDamage()
		local scale, num = 0, math.min( math.ceil(dmg /8), 7 )
		
		if dmg >= 5 and eEnt:Health() -pDamageInfo:GetDamage() > 0 then --If the vehicle damage is high enough, ragdoll them!
			-- if not eEnt:IsUncon() and not eEnt:IsRagdolled() then
				eEnt.m_intLastHealth = eEnt:Health() -pDamageInfo:GetDamage()
				eEnt:SetHealth( eEnt.m_intLastHealth )
				for i = 0, ragEnt:GetPhysicsObjectCount() -1 do
					local phys = ragEnt:GetPhysicsObjectNum( i )
					phys:ApplyForceCenter( (attacker:GetVelocity():GetNormalized() *-768) +Vector(0, 0, 1500) )
				end

				GAMEMODE.Util:PlayerEmitSound( eEnt, "Pain" )

				return true --Go ahead and block stuff in this case
			-- end
		elseif eEnt:Health() -pDamageInfo:GetDamage() <= 0 then
			eEnt:SetHealth( 0 ) --sh_uncon will run next and handle this
			return
		end

		return
	else
		
		local scale = self:PlayerLimbTakeDamage( eEnt, pDamageInfo:GetDamage(), pDamageInfo:GetDamageType(), true )
		
		if pDamageInfo:GetDamageType() == DMG_FALL then
			if scale then pDamageInfo:ScaleDamage( scale ) end
			eEnt:SetHealth( math.max(0, eEnt:Health() -pDamageInfo:GetDamage()) )
		else
			pDamageInfo:ScaleDamage( 0 )
		end
		
		return true
	end
end

--Called to handle most kinds of damage for limbs
function GM.PlayerDamage:ScalePlayerDamage( pPlayer, pDamageInfo )
	
	
	local scale = self:PlayerLimbTakeDamage( pPlayer, pDamageInfo:GetDamage() *0.33, pDamageInfo:GetDamageType(), true )
	if scale then pDamageInfo:ScaleDamage( scale ) end
	-- if pPlayer:IsRagdolled() then pDamageInfo:ScaleDamage( 0 ) end
end

--Called to handle fall damage for limbs
function GM.PlayerDamage:GetFallDamage( pPlayer, intVel )
	local dmg = intVel /8
	if dmg < 2 then return 0 end

	local scale = 2.25
	local num = 3
	scale = scale +self:PlayerLimbTakeDamage( pPlayer, dmg /2, DMG_FALL, true )
	scale = scale +self:PlayerLimbTakeDamage( pPlayer, dmg /2, DMG_FALL, true )

	if dmg > 15 then --Damage other limbs too
		local numDamage = math.random( 1, 3 )
		local done = {}

		for i = 1, numDamage do
			scale = scale +self:PlayerLimbTakeDamage( pPlayer, dmg /3, DMG_FALL, true )
			num = num +1
		end
	end

	scale = scale /num
	dmg = dmg *scale
	-- if not pPlayer:IsUncon() and not pPlayer:IsRagdolled() then
		if pPlayer:Health() -dmg > 0 and dmg > 30 then
			GAMEMODE.Util:PlayerEmitSound( pPlayer, "Pain" )
			-- pPlayer:BecomeRagdoll( 10, true )
		elseif pPlayer:Health() -dmg <= 0 then
			GAMEMODE.Util:PlayerEmitSound( pPlayer, "Death" )
		end
	-- end

	if pPlayer.m_intLastHealth then
		pPlayer.m_intLastHealth = pPlayer.m_intLastHealth -dmg
	end

	return dmg
end



concommand.Add( "srp_dev_heal_me", function( pPlayer, strCmd, tblArgs )
	if not DEV_SERVER then
	if not pPlayer:IsSuperAdmin() then return end
	end

	pPlayer:SetHealth( pPlayer:GetMaxHealth() )
end )