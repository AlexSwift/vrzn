--[[
	Name: mayor.lua
		by: Asriel + CodeRed 
	By: Ultra
]]--

GM.Net:AddProtocol( "mayor", 54 )

local Job = {}
Job.ID = 12
Job.Enum = "JOB_MAYOR"
Job.TeamColor = Color( 255, 255, 255, 255 )
Job.Name = "Prefeito"
Job.Cat = "Agentes da lei"
Job.Text = [[Sempre suprindo sua vontade insasciável de podre, o que melhor que ter o poder sobre toda a população?
OBJETIVOS:
x Governar para o Povo
x Cuidar da proteção de todos
x Mobilizar as tropas terrestres
Digite /lockdown para iniciar um estado de toque de recolher.
Todos devem estar dentro de casa durante o toque de recolher.
Os policias vão patrulhar a area
/unlockdown para acabar o toque de recolher

[x] So pode portar pistola como arma de fogo
[x] Proibido cometer qualquer tipo de crime
[x] Pode fazer ditadura
[x] Nao pode criar leis que permitam RDM ou quebra de regras


]];
Job.DefaultChatRadioChannel = 1
Job.ChannelKeys = {
    [2] = true, -- Dá Acesso ao canal 2
    [4] = true, -- Dá Acesso ao canal 4
    [6] = true, --  Dá Acesso ao canal 6
    [10] = false,
}
Job.Pay = {
	{ PlayTime = 0, Pay = 220 },
	{ PlayTime = 4 *(60 *60), Pay = 280 },
	{ PlayTime = 12 *(60 *60), Pay = 350 },
	{ PlayTime = 24 *(60 *60), Pay = 450 },
}
Job.PlayerCap = { Min = 1, MinStart = 1, Max = 1, MaxEnd = 1 }

function Job:OnPlayerJoinJob( pPlayer )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "curr_radio_channel", tonumber(GAMEMODE.Radio:FindChannels( pPlayer )[1]), false )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "curr_radio_channel_name", GAMEMODE.Radio.m_tblChannels[GAMEMODE.Player:GetSharedGameVar( pPlayer, "curr_radio_channel" )]["channelName"], false)
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_MAYOR then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
		pPlayer:Give( "radio_ss" )
		pPlayer:Give( "radio_cop" )
	end

	hook.Add( "GamemodeBuildPlayerComputerApps", "AutoInstallMayorApps", function( pPlayer, entComputer, tblApps )
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end
		tblApps["turbotax97.exe"] = GAMEMODE.Apps:GetComputerApp( "turbotax97.exe" )
		tblApps["nsa.exe"] = GAMEMODE.Apps:GetComputerApp( "nsa.exe" )
	end )

	GM.Net:RegisterEventHandle( "mayor", "updt", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["turbotax97.exe"] then return end
		--if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end
		if pPlayer.m_intLastTaxUpdated or 0 > CurTime() then return end
		pPlayer.m_intLastTaxUpdated = CurTime() +2

		local id, val = net.ReadString(), math.Round( net.ReadFloat(), 2 )
		if GAMEMODE.Econ:SetTaxRate( id, val ) then
			GAMEMODE.Econ:CommitTaxData()
		end
	end )

	GM.Net:RegisterEventHandle( "mayor", "updtb", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["turbotax97.exe"] then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end
		pPlayer.m_intLastTaxUpdated = CurTime() +2

		local num = net.ReadUInt( 8 )
		if num <= 0 then return end
		local ids = {}

		for i = 1, num do
			local id, val = net.ReadString(), math.Round( net.ReadFloat(), 2 )

			if GAMEMODE.Econ:SetTaxRate( id, val, true ) then
				ids[id] = true
			end
		end

		GAMEMODE.Net:SendTaxUpdateBatch( nil, ids )
		GAMEMODE.Econ:CommitTaxData()
	end )

    hook.Add("PlayerDeath", "MayorPlayerDeath", function( pVictim, dmginfoInflictor, pAttacker )
		if GAMEMODE.Jobs:PlayerIsJob( pVictim, JOB_MAYOR ) then
			GAMEMODE.Jobs:SetPlayerJob( pVictim, JOB_CIVILIAN, false )
			AddNoteAll("Our mayor has passed away, you can register to be the next mayor via the mayor assistant.")
			for k,v in pairs(player.GetAll()) do
				if GAMEMODE.Jobs:PlayerIsJob( v, JOB_SSERVICE ) then
					GAMEMODE.Jobs:SetPlayerJob( v, JOB_CIVILIAN, false )
				end
			end
			GAMEMODE.Econ:SetTaxRate( 'car_insurance', 0 )
			GAMEMODE.Econ:SetTaxRate( 'fuel', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_1', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_2', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_3', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_4', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_5', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_6', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_7', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_8', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_9', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_10', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_11', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_12', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_13', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_15', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_88', 0 )
			GAMEMODE.Econ:SetTaxRate( 'income_99', 0 )
			GAMEMODE.Econ:SetTaxRate( 'prop_Apartments', 0 )
			GAMEMODE.Econ:SetTaxRate( 'prop_House', 0 )
			GAMEMODE.Econ:SetTaxRate( 'prop_Stores', 0 )
			GAMEMODE.Econ:SetTaxRate( 'prop_Warehouse', 0 )
			GAMEMODE.Econ:SetTaxRate( 'sales', 0 )
		end
	end)
else
	--client
	function GM.Net:RequestUpdateTaxRate( strTaxID, intNewValue )
		self:NewEvent( "mayor", "updt" )
			net.WriteString( strTaxID )
			net.WriteFloat( intNewValue )
		self:FireEvent()
	end

	function GM.Net:RequestUpdateBatchedTaxRate( tblTaxes )
		self:NewEvent( "mayor", "updtb" )
			net.WriteUInt( table.Count(tblTaxes), 8 )

			for k, v in pairs( tblTaxes ) do
				net.WriteString( k )
				net.WriteFloat( v )
			end
		self:FireEvent()
	end
end

GM.Jobs:Register( Job )