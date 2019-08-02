--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 31
Job.Enum = "JOB_MACONHA"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Maconheiro"
Job.Cat = "Criminosos"
Job.Pay = {
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
}
Job.Text = [[So faz merda e fuma sehloiro
    
[x] Nao pode assaltar
[x] Pode ter printer/bitminer
[x] Pode vender Sehloiro para os outros
[x] Pode ter bases
[x] Só pode fazer grupo com quimico e outros maconheiros

]];

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