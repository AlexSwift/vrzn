--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 23
Job.Enum = "JOB_SEGURANCA"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Segurança"
Job.Cat = "Serviços"
Job.Pay = {
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
}
Job.Text = [[Formado em varias artes marciais, decidiu 
abandonar a policia para defender as pessoas que lhe pagam.
Pode algemar as pessoas e acionar a policia.

    [x] Nao pode assaltar , apenas defender base/loja
    [x] Nao pode assaltar , somente defender seu Patrão
    [x] Pode trabalhar de seguranca de loja
    [x] Nao pode ajudar a policia se nao for relacionado com sua propriedade]];

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