--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 17
Job.Enum = "JOB_MINER"
Job.TeamColor = Color( 110, 48, 0 )
Job.Name = "Minerador"
Job.Cat = "Civis"
Job.Text = [[TEste de 1 linha
	teste de 2 linhas
	teste de 3 linhas
	TEste de 1 linha
	teste de 2 linhas
	teste de 3 linhas
	TEste de 1 linha
	teste de 2 linhas
	teste de 3 linhas

	textotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotextotexto]];
Job.Pay = {
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 20 },
	{ PlayTime = 0, Pay = 25 },
	{ PlayTime = 0, Pay = 30 },
}
Job.PlayerCap = { Min = 4, MinStart = 4, Max = 4, MaxEnd = 4 }

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
end

function Job:GetPlayerModel( pPlayer )
	local base, overload

	if SERVER then
		base = GAMEMODE.Player:GetGameVar( pPlayer, "char_model_base", nil )
		overload = GAMEMODE.Player:GetGameVar( pPlayer, "char_model_overload", nil )
	else
		base = GAMEMODE.Player:GetGameVar( "char_model_base", nil )
		overload = GAMEMODE.Player:GetGameVar( "char_model_overload", nil )
	end
	
	if util.IsValidModel( overload or "" ) then
		return overload
	else
		return base
	end
end

function Job:PlayerSetModel( pPlayer )
	local mdl = self:GetPlayerModel(pPlayer)

	if mdl then
		pPlayer:SetModel( mdl )
		pPlayer:SetSkin( GAMEMODE.Player:GetGameVar(pPlayer, "char_skin", 0) )
	end
end

function Job:PlayerLoadout( pPlayer )
	pPlayer:Give( "zrms_pickaxe" )
end

GM.Jobs:Register( Job )