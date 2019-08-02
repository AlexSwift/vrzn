--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 19
Job.Enum = "JOB_CIVILIAN"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Artista de Rua"
Job.Cat = "Civis"
Job.Pay = {
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
}
Job.Text = [[Sempre rebelde com a vida que teve então decides partir para as ruas para explicar sua indignação.

OBJETIVOS:
x Pixar muros/paredes/casas da cidade
x Ser reconhecido na cidade
x Tentar tirar um sustento disto

REGRAS:
x Pode ser preso por "mostrar sua arte"
x Não pode ter printer
x Pode ter armas apenas de pequeno porte
x Pode participar de grupos
x Não pode cometer crimes alem de pichação]];

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