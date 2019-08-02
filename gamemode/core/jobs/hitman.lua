--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 32
Job.Enum = "JOB_HITMAN"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Hitman"
Job.Cat = "Serviços"
Job.Pay = {
	{ PlayTime = 0, Pay = 0 },
	{ PlayTime = 0, Pay = 0 },
	{ PlayTime = 0, Pay = 0 },
	{ PlayTime = 0, Pay = 0 },
}
Job.Text = [[Você é um assassino de aluguel,
trabalhe para quem pagar mais e faça seu nome ser temido.

	[x] Nao pode roubar
	[x] Nao pode fazer parte de grupos
	[x] Regra 4.3 do MOTD
	[x] Pode ter casa
	[x] Pode ter bitminer]];

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