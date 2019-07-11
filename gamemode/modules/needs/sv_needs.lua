--[[
	Name: sv_needs.lua
	For: TalosLife
	By: TalosLife 
]]--

GM.Needs = (GAMEMODE or GM).Needs or {}
GM.Needs.m_tblNeeds = (GAMEMODE or GM).Needs.m_tblNeeds or {}

function GM.Needs:Initialize()
	self:RegisterNeed( "Hunger", "You died of hunger!", "You are dying of hunger!", 500, 2, 1, 50 )
end

function GM.Needs:RegisterNeed( strNeedID, strDeathMessage, strNeedMessage, intMaxAmount, intDecayScale, intDamageAmount, vaDecayInterval )
	self.m_tblNeeds[strNeedID] = {
		Max = intMaxAmount,
		Decay = intDecayScale,
		Damage = intDamageAmount,
		DeathMsg = strDeathMessage,
		NeedMsg = strNeedMessage,
		DecayScale = intDecayScale,
		DecayInterval = vaDecayInterval,
	}
end

function GM.Needs:GetNeedData( strNeedID )
	return self.m_tblNeeds[strNeedID]
end

function GM.Needs:SetPlayerNeed( pPlayer, strNeedID, intAmount, bNoSend )
	GAMEMODE.Player:SetGameVar( pPlayer, "need_".. strNeedID, intAmount, bNoSend )

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.Needs = saveTable.Needs or {}
	saveTable.Needs[strNeedID] = intAmount
	
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Needs" )

	-- if strNeedID == "Stamina" then
	-- 	self:UpdatePlayerStamina( pPlayer, intAmount )
	-- end
	hook.Call( "GamemodeOnSetPlayerNeed", GAMEMODE, pPlayer, strNeedID, intAmount, newAmount )
end

function GM.Needs:GetPlayerNeed( pPlayer, strNeedID )
	return GAMEMODE.Player:GetGameVar( pPlayer, "need_".. strNeedID, 0 )
end

function GM.Needs:AddPlayerNeed( pPlayer, strNeedID, intAmount )
	self:SetPlayerNeed( pPlayer, strNeedID, math.min(self:GetPlayerNeed(pPlayer, strNeedID) +intAmount, self.m_tblNeeds[strNeedID].Max) )
	self:OnAddPlayerNeed( pPlayer, strNeedID, intAmount )
end

function GM.Needs:TakePlayerNeed( pPlayer, strNeedID, intAmount )
	self:SetPlayerNeed( pPlayer, strNeedID, math.max(self:GetPlayerNeed(pPlayer, strNeedID) -intAmount, 0) )
	self:OnTakePlayerNeed( pPlayer, strNeedID, intAmount )
end

function GM.Needs:OnAddPlayerNeed( pPlayer, strNeedID, intAmount )
	local newAmount = self:GetPlayerNeed( pPlayer, strNeedID )
	hook.Call( "GamemodeOnAddPlayerNeed", GAMEMODE, pPlayer, strNeedID, intAmount, newAmount )
end

function GM.Needs:OnTakePlayerNeed( pPlayer, strNeedID, intAmount )
	local newAmount = self:GetPlayerNeed( pPlayer, strNeedID )
	hook.Call( "GamemodeOnTakePlayerNeed", GAMEMODE, pPlayer, strNeedID, intAmount, newAmount )
end


function GM.Needs:ProcessPlayerNeeds( pPlayer )
	pPlayer.m_tblNeedTimes = pPlayer.m_tblNeedTimes or {}

	local time = CurTime()
	for k, v in pairs( self.m_tblNeeds ) do
		if not pPlayer.m_tblNeedTimes[k] then
			pPlayer.m_tblNeedTimes[k] = time
		end
		
		if type( v.DecayInterval ) == "function" then
			if time < pPlayer.m_tblNeedTimes[k] +v.DecayInterval( pPlayer )	then continue end
		else
			if time < pPlayer.m_tblNeedTimes[k] +v.DecayInterval then continue end
		end
		pPlayer.m_tblNeedTimes[k] = time

		if v.Decay <= 0 then --This need regenerates
			self:AddPlayerNeed( pPlayer, k, math.abs(v.Decay) )
		else --This need decays
			if not GAMEMODE.Jail:IsPlayerInJail( pPlayer ) then
				self:TakePlayerNeed( pPlayer, k, v.Decay )
			end
		end
		
		--If this need is at 0 and does damage
		if not GAMEMODE.Jail:IsPlayerInJail( pPlayer ) then
			if self:GetPlayerNeed( pPlayer, k ) <= 0 and v.Damage > 0 then
				pPlayer:SetHealth( pPlayer:Health() -v.Damage )
				if pPlayer:Health() <= 0 then
					pPlayer:AddNote( v.DeathMsg )
					pPlayer:Kill()
					break
				else
					pPlayer:AddNote( v.NeedMsg )
				end
			end
		end
	end
end

function GM.Needs:Tick()
	-- self:TickPlayerStamina()

	if CurTime() < (self.m_intLastThink or 0) then return end
	self.m_intLastThink = CurTime() +1

	for k, v in pairs( player.GetAll() ) do
		if not v:Alive() then continue end
		local saveTable = GAMEMODE.Char:GetCurrentSaveTable( v )
		if not saveTable then return end

		self:ProcessPlayerNeeds( v )
		-- self:UpdatePlayerStaminaDecay( v )
		
		saveTable.Needs = saveTable.Needs or {}
		for needID, data in pairs( self.m_tblNeeds ) do
			saveTable.Needs[needID] = self:GetPlayerNeed( v, needID )
		end

		GAMEMODE.SQL:MarkDiffDirty( v, "data_store", "Needs" )
	end
end

function GM.Needs:PlayerDeath( pPlayer )
	for k, v in pairs( self.m_tblNeeds ) do
		self:SetPlayerNeed( pPlayer, k, v.Max )
	end

	pPlayer.m_intCurSprintVelL = nil
end

function GM.Needs:PlayerSpawn( pPlayer )
	-- self:UpdatePlayerStamina( pPlayer, self:GetPlayerNeed(pPlayer, "Stamina") )
end

hook.Add( "GamemodeDefineGameVars", "DefineNeedVars", function( pPlayer )
	for k, v in pairs( GAMEMODE.Needs.m_tblNeeds ) do
		GAMEMODE.Player:DefineGameVar( pPlayer, "need_".. k, v.Max, "UInt16", true )
	end
end )

hook.Add( "GamemodePlayerSelectCharacter", "ApplyNeedVars", function( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Needs then return end

	for k, v in pairs( saveTable.Needs ) do
		GAMEMODE.Needs:SetPlayerNeed( pPlayer, k, v, true )
	end
end )

hook.Add( "GamemodePlayerLevelUpSkill", "UpdatePlayerMaxSpeed", function( pPlayer, strSkill, intOldLevel, intNewLevel )
	-- if strSkill ~= "Stamina" then return end
	-- GAMEMODE.Needs:UpdatePlayerStamina( pPlayer, GAMEMODE.Needs:GetPlayerNeed(pPlayer, "Stamina") )
end )