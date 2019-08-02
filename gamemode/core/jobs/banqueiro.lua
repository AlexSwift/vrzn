--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 22
Job.Enum = "JOB_BANKER"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Banqueiro"
Job.Cat = "Civis"
Job.Pay = {
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
	{ PlayTime = 0, Pay = 15 },
}
Job.Text = [[Sempre muito bom com números faz o que há de melhor para si mesmo.
OBJETIVOS: 
x Criar o Banco Central
x Gerar uma economia grande com seu trabalho
x Ser conhecido pela cidade inteira

REGRAS:
x So pode fazer grupo com seguranças do banco
x Não pode cometer atos ilícitos
x Pode ter apenas armas de pequeno porte

[x] OBRIGATORIO dar dinheiro dos clientes
[x] OBRIGATORIO cobrar para guardar bitminers/printers
[x] Nao pode passar longos periodos fora do banco.]];

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