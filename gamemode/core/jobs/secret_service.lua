--[[
	Name: secret_service.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 13
Job.Enum = "JOB_SSERVICE"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Serviço Secreto"
Job.Cat = "Agentes da lei"
Job.Cat = [[Formado em artilharia pesada, decidiu 
se juntar a policia para defender as pessoas .
Pode algemar as pessoas e chamar a policia.

	[x] DEVE ficar ao lado do prefeito
[x] Só pode utilizar a job se houver um prefeito
	[x] Nao pode ser corrupto
	[x] DEVE fazer de tudo para proteger o prefeito
	[x] Nao pode cometer nenhum tipo de crime
	[x] Nao pode ajudar a policia se nao for relacionado com o prefeito]];
Job.Pay = {
	{ PlayTime = 0, Pay = 180 },
	{ PlayTime = 4 *(60 *60), Pay = 225 },
	{ PlayTime = 12 *(60 *60), Pay = 285 },
	{ PlayTime = 24 *(60 *60), Pay = 350 },
	{ PlayTime = 24 *(60 *60), Pay = 400 },
}
Job.PlayerCap = GM.Config.Job_SService_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = false
Job.DefaultChatRadioChannel = 10
Job.ChannelKeys = {
	[10] = false,
}
Job.PendingPlayerApps = {}
Job.SSGaragePos = GM.Config.SSParkingZone
Job.CarSpawns = GM.Config.SSCarSpawns

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_SSERVICE then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
		--pPlayer:Give( "weapon_ziptie" )
		pPlayer:Give( "policebadgewallet" )
		pPlayer:Give( "radio_ss" )
		pPlayer:Give( "radio_cop" )
	end

	function Job:PlayerApply( pPlayer )
		if pPlayer.m_intLastSSApply then
			if pPlayer.m_intLastSSApply > CurTime() then
				pPlayer:AddNote( ("Você deve aguardar %d segundos para talvez submeter sua aplicação."):format(pPlayer.m_intLastSSApply -CurTime()) )
				return false
			end
		end

		self.PendingPlayerApps[pPlayer] = true
		pPlayer.m_intLastSSApply = GAMEMODE.Config.SSApplyInterval

		for k, v in pairs( player.GetAll() ) do
			if GAMEMODE.Jobs:GetPlayerJobID( v ) == JOB_MAYOR then
				GAMEMODE.Net:SendMayorSSApps( v )
				break
			end
		end

		pPlayer:AddNote( "Você submeteu sua aplicação!" )
		return true
	end
	
	function Job:PlayerPullApp( pPlayer )
		self.PendingPlayerApps[pPlayer] = nil

		for k, v in pairs( player.GetAll() ) do
			if GAMEMODE.Jobs:GetPlayerJobID( v ) == JOB_MAYOR then
				GAMEMODE.Net:SendMayorSSApps( v )
				break
			end
		end

		pPlayer:AddNote( "Você requisitou sua sbumição ao Serviço Secreto!" )
	end

	function Job:PlayerHasApp( pPlayer )
		return self.PendingPlayerApps[pPlayer]
	end
	
	function Job:ApprovePlayerApp( pPlayer )
		self.PendingPlayerApps[pPlayer] = nil
		GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_SSERVICE )
		pPlayer:AddNote( "O Prefeito aprovou sua aplicação para o Serviço Secreto!" )
	end
	
	function Job:DenyPlayerApp( pPlayer )
		self.PendingPlayerApps[pPlayer] = nil
		pPlayer:AddNote( "O Prefeito reprovou sua aplicação para o Serviço Secreto!" )
	end

	function Job:MayorFirePlayer( pPlayer )
		pPlayer:AddNote( "Você foi demitido do Serviço Secreto!" )
		GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN )
	end

	function Job:OnPlayerSpawnSSCar( pPlayer, entCar )
		local color, skin, groups = net.ReadColor(), net.ReadUInt( 8 ), net.ReadTable()
		entCar:SetColor( color )
		entCar:SetSkin( skin )

		for k, v in pairs( groups ) do
			entCar:SetBodygroup( k, v )
		end

		entCar.IsCopCar = true
		pPlayer:AddNote( "Você spawnou um veículo do governo!" )
	end

	--Player wants to spawn a gov car
	GM.Net:RegisterEventHandle( "mayor", "ss_sp_c", function( intMsgLen, pPlayer )
		if not pPlayer:WithinTalkingRange() then return end
		if pPlayer:GetTalkingNPC().UID ~= "ss_spawn_car" then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_SSERVICE and GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_JUDGE then return end

		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, net.ReadString(), Job.CarSpawns, Job.SSGaragePos )
		if IsValid( car ) then
			Job:OnPlayerSpawnSSCar( pPlayer, car )
		end
	end )

	--Player wants to stow their gov car
	GM.Net:RegisterEventHandle( "mayor", "ss_st", function( intMsgLen, pPlayer )
		if not pPlayer:WithinTalkingRange() then return end
		if pPlayer:GetTalkingNPC().UID ~= "ss_spawn_car" then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_SSERVICE and GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_JUDGE then return end

		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, Job.SSGaragePos )
	end )

	function GM.Net:SendMayorSSApps( pMayor )
		if GAMEMODE.Jobs:GetPlayerJobID( pMayor ) ~= JOB_MAYOR then return end
		
		for k, v in pairs( Job.PendingPlayerApps ) do
			if not IsValid( k ) then Job.PendingPlayerApps[k] = nil end
		end

		self:NewEvent( "mayor", "upd_ss_app" )
			net.WriteUInt( table.Count(Job.PendingPlayerApps), 8 )

			for k, v in pairs( Job.PendingPlayerApps ) do
				net.WriteEntity( k )
			end
		self:FireEvent( pMayor )
	end

	GM.Net:RegisterEventHandle( "mayor", "ss_apr", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["nsa.exe"] then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end

		local target = net.ReadEntity()
		if not IsValid( target ) or not target:IsPlayer() or target == pPlayer then return end
		if GAMEMODE.Jobs:GetPlayerJobID( target ) == JOB_SSERVICE then return end
		if not Job.PendingPlayerApps[target] then return end
		Job:ApprovePlayerApp( target )

		GAMEMODE.Net:SendMayorSSApps( pPlayer )
	end )

	GM.Net:RegisterEventHandle( "mayor", "ss_dny", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["nsa.exe"] then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end

		local target = net.ReadEntity()
		if not IsValid( target ) or not target:IsPlayer() or target == pPlayer then return end
		if GAMEMODE.Jobs:GetPlayerJobID( target ) == JOB_SSERVICE then return end
		if not Job.PendingPlayerApps[target] then return end
		Job:DenyPlayerApp( target )

		GAMEMODE.Net:SendMayorSSApps( pPlayer )
	end )

	GM.Net:RegisterEventHandle( "mayor", "ss_fire", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["nsa.exe"] then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end

		local target = net.ReadEntity()
		if not IsValid( target ) or not target:IsPlayer() or target == pPlayer then return end
		if GAMEMODE.Jobs:GetPlayerJobID( target ) ~= JOB_SSERVICE then return end
		if not Job.PendingPlayerApps[target] then return end
		Job:MayorFirePlayer( target )

		GAMEMODE.Net:SendMayorSSApps( pPlayer )
	end )

	hook.Add( "GamemodePlayerSetJob", "UpdateMayorApps", function( pPlayer, intJobID )
		if intJobID ~= JOB_MAYOR then return end
		GAMEMODE.Net:SendMayorSSApps( pPlayer )
	end )
else
	--client
	GM.Net:RegisterEventHandle( "mayor", "upd_ss_app", function( intMsgLen, pPlayer )
		local num = net.ReadUInt( 8 )
		local apps = {}

		if num > 0 then
			for i = 1, num do
				apps[net.ReadEntity()] = true
			end
		end

		GAMEMODE.m_tblSSApps = apps
		hook.Call( "GamemodeOnGetSSApps", GAMEMODE, apps )
	end )

	function GM.Net:RequestApproveSSApp( pPlayer )
		self:NewEvent( "mayor", "ss_apr" )
			net.WriteEntity( pPlayer )
		self:FireEvent()
	end
	
	function GM.Net:RequestDenySSApp( pPlayer )
		self:NewEvent( "mayor", "ss_dny" )
			net.WriteEntity( pPlayer )
		self:FireEvent()
	end
	
	function GM.Net:RequestFireSS( pPlayer )
		self:NewEvent( "mayor", "ss_fire" )
			net.WriteEntity( pPlayer )
		self:FireEvent()
	end

	function GM.Net:RequestSpawnSSCar( strJobCarID, colColor, intSkin, tblBodygroups )
		self:NewEvent( "mayor", "ss_sp_c" )
			net.WriteString( strJobCarID )
			net.WriteColor( colColor or Color(255, 255, 255, 255) )
			net.WriteUInt( intSkin or 0, 8 )
			net.WriteTable( tblBodygroups or {} )
		self:FireEvent()
	end

	function GM.Net:RequestStowSSCar()
		self:NewEvent( "mayor", "ss_st" )
		self:FireEvent()
	end
end

GM.Jobs:Register( Job )