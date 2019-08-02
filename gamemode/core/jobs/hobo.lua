--[[
	Name: ladrao.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 18
Job.Enum = "JOB_HOBO"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Mendigo"
Job.Cat = "Mendigos"
Job.Text = [[Reprimido pela sociedade desde seu nascimento e desprezado pela família.
OBJETIVOS: 
x Construa seu abrigo
x Tente ganhar esmola

REGRAS:
x Pode fazer grupo somente com outros mendigos
x Não pode cometer atos ilícitos
x Não pode ter armas
x Não pode dar dano em nínguem por recusarem dar esmola]];
Job.PlayerCap = { Min = 4, MinStart = 4, Max = 4, MaxEnd = 4 }
Job.PlayerModel = {
    Male_Fallback = "models/player/corpse1.mdl",
    Female_Fallback = "models/player/skeleton.mdl",

    Male = {
        ["male_01"] = "models/player/corpse1.mdl",
    },
    Female = {
        ["female_01"] = "models/player/skeleton.mdl",
    },
}
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

function Job:GetPlayerModel( pPlayer, bUnModified )
	if pPlayer.m_bJobCivModelOverload and not bUnModified then
		return GAMEMODE.Jobs:GetJobByID( JOB_CIVILIAN ):GetPlayerModel( pPlayer )
	end

	local valid, mdl
	if SERVER then
		valid, mdl = GAMEMODE.Util:FaceMatchPlayerModel(
			GAMEMODE.Player:GetGameVar( pPlayer, "char_model_base", "" ),
			GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE,
			self.PlayerModel
		)
	else
		valid, mdl = GAMEMODE.Util:FaceMatchPlayerModel(
			GAMEMODE.Player:GetGameVar( "char_model_base", "" ),
			GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE,
			self.PlayerModel
		)
	end

	if valid then
		return mdl
	else
		if GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE then
			return self.PlayerModel.Male_Fallback
		else
			return self.PlayerModel.Female_Fallback
		end
	end
end

if SERVER then
	function Job:PlayerSetModel( pPlayer )
		pPlayer:SetModel( self:GetPlayerModel(pPlayer) )
		pPlayer:SetSkin( not pPlayer.m_bJobCivModelOverload and
			(pPlayer.m_intSelectedJobModelSkin or 0) or
			GAMEMODE.Player:GetGameVar( pPlayer, "char_skin", 0 )
		)

		if pPlayer.m_tblSelectedJobModelBGroups then
			for k, v in pairs( pPlayer:GetBodyGroups() ) do
				if pPlayer.m_tblSelectedJobModelBGroups[v.id] then
					if pPlayer.m_tblSelectedJobModelBGroups[v.id] > pPlayer:GetBodygroupCount( v.id ) -1 then continue end
					pPlayer:SetBodygroup( v.id, pPlayer.m_tblSelectedJobModelBGroups[v.id] )
				end
			end
		end
	end
end

function Job:PlayerLoadout( pPlayer )
end

GM.Jobs:Register( Job )