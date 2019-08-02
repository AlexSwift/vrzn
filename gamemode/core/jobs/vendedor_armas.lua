--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 30
Job.Enum = "JOB_VENDEDORARMAS"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Vendedor de Armas"
Job.Cat = "Vendedores"
Job.Pay = {
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
}
Job.Text = [[Consiga armas de todos os tipos, de todos os lugares,
sempre que a população precisar.

[x] Nao pode assaltar
[x] So pode fazer grupo com Segurança, Mercado Negro e outros vendedores.
[x] Pode ter bitminer/printer
[x] Deve ter uma loja sinalizando com placa
[x] Pode visitar bases para vender armas]];

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