--[[
	Name: sv_police_ranks.lua
]]--

GM.PoliceRanks = (GAMEMODE or GM).PoliceRanks or {}

function GM.PoliceRanks:SetRank(pPlayer, intRankID)
	if not pPlayer then return end
	if not intRankID then return end
	if intRankID > 9 or intRankID < 1 then return end
	GAMEMODE.Player.m_tblPlayerData[pPlayer:SteamID64()].Characters[pPlayer:GetCharacterID()].CopLevel = intRankID -- it's really stupid crutcher :C
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "cop_level", intRankID, false )
	self:Update(pPlayer)
end

function GM.PoliceRanks:GetPrettyRank(pPlayer)
	if not pPlayer then return end
	return GAMEMODE.Config.PoliceRanks[self:GetRank(pPlayer)]
end

function GM.PoliceRanks:GetRank(pPlayer)
	if not pPlayer then return end
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "cop_level" )
end

function GM.PoliceRanks:Promote(pPlayer, pTarget)
	if not pPlayer or not pTarget or not IsValid(pPlayer) or not IsValid(pTarget) then return end
	if self:GetRank(pTarget) +1 > 9 then return end
	if self:GetRank(pPlayer) -1 <= self:GetRank(pTarget) then return end
	self:SetRank(pTarget, self:GetRank(pTarget) +1)
	self:Update(pTarget)
end

function GM.PoliceRanks:Demote(pPlayer, pTarget)
	if not pPlayer or not pTarget or not IsValid(pPlayer) or not IsValid(pTarget) then return end
	if self:GetRank(pTarget) -1 < 1 then return end
	if self:GetRank(pPlayer) -1 < self:GetRank(pTarget) then return end
	self:SetRank(pTarget, self:GetRank(pTarget) -1)
	self:Update(pTarget)
end

function GM.PoliceRanks:Block(pPlayer)
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "cop_level", 0, false )
	self:Update(pPlayer)
end

function GM.PoliceRanks:IsBlocked(pPlayer)
	return self:GetRank(pPlayer) == 0 and true or false
end

function GM.PoliceRanks:Update(pPlayer)
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "cop_level" )
end

-- hook.Add( "GamemodePlayerSelectCharacter", "OnPlayerLoadPoliceRanks", function( pPlayer, intCharID )
-- 	GAMEMODE.SQL:QueryReadOnly( ([[SELECT coplevel FROM characters WHERE steamID = '%s' AND character_id = %i]]):format(pPlayer:SteamID64(), intCharID), function( tblData, q )
-- 		if not IsValid( pPlayer ) then return end
-- 		GAMEMODE.PoliceRanks:SetRank(pPlayer, tonumber(tblData[1].coplevel))
-- 	end )
-- end )

-- hook.Add( "GamemodeCanPlayerSetJob", "UpdateCopList", function( pPlayer, intJobID )
-- 	GAMEMODE.Net:UpdateCopList()
-- end)

-- hook.Add( "PlayerDisconnected", "UpdateCopList", function( pPlayer )
-- 	GAMEMODE.Net:UpdateCopList()
-- end)