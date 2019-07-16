--[[
	Name: cl_police_ranks.lua
]]--

GM.PoliceRanks = (GAMEMODE or GM).PoliceRanks or {}

function GM.PoliceRanks:GetPrettyRank(pPlayer)
	if not pPlayer then return end
	return GAMEMODE.Config.PoliceRanks[self:GetRank(pPlayer)]
end

function GM.PoliceRanks:GetRank(pPlayer)
	if not pPlayer then return end
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "cop_level" )
end

function GM.PoliceRanks:IsBlocked(pPlayer)
	return self:GetRank(pPlayer) == 0 and true or false
end