--[[
	Name: ladrao.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 14
Job.Enum = "JOB_ASSALTANTE"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Ladrão"
Job.Cat = "Criminosos"
Job.Text = [[Um criminoso comum ou um ladrão de sucesso, tudo depende de você.
    
[x] Nao pode assaltar a mesma pessoa em menos de 5m
[x] Pode ter casa
[x] Pode ter bitminer/printer]];
Job.PlayerCap = { Min = 5, MinStart = 5, Max = 5, MaxEnd = 5 }
Job.Pay = {
	{ PlayTime = 0, Pay = 0 },
	{ PlayTime = 0, Pay = 0 },
	{ PlayTime = 0, Pay = 0 },
	{ PlayTime = 0, Pay = 0 },
}

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
end

GM.Jobs:Register( Job )