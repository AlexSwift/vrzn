--[[
	Name: civilian.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 16
Job.Enum = "JOB_PSICOPATA"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Psicopata"
Job.PlayerCap = { Min = 1, MinStart = 1, Max = 1, MaxEnd = 1 }
Job.Cat = "Criminosos"
Job.Text = [[Sofreu muito abuso durante a infância e desenvolveu vários traumas psicológicos,
agora chegou a vez de dar o troco
	
	[x] Nao pode matar em publico
	[x] Pode matar livremente no esgoto
	[x] So pode utilizar armas da job
	[x] Pode invadir casas para matar pessoas
	[x] Pode sequestrar somente para matar
	[x] Nao pode fazer grupos
	[x] Nao pode invadir a delegacia]];
Job.Vip = true
Job.Pay = {
	{ PlayTime = 0, Pay = 5 },
	{ PlayTime = 12*( 60*60 ), Pay = 15},
	{ PlayTime = 24*( 60*60 ), Pay = 25},
	{ PlayTime = 24*( 60*60 ), Pay = 35},
}
Job.PlayerModel = {
	Male_Fallback = "models/players/mj_dbd_guam.mdl",
	Female_Fallback = "models/players/mj_dbd_guam.mdl",

	Male = {
		["male_01"] = "models/players/mj_dbd_guam.mdl",
	},
	Female = {
		["female_01"] = "models/players/mj_dbd_guam.mdl",
	},
}
Job.VIP = true


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