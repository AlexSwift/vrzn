--[[
	Name: mail_spawn.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Mail Manager"
NPCMeta.UID = "mail_spawn"
NPCMeta.SubText = "Become a mail truck driver here"
NPCMeta.Model = "models/Humans/Group02/male_08.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/npc/male01/answer30.wav",
		"vo/npc/male01/gordead_ans01.wav",
		"vo/npc/male01/gordead_ques16.wav",
		"vo/npc/male01/hi01.wav",
		"vo/npc/male01/hi02.wav",
	},
	EndDialog = {
		"vo/npc/male01/finally.wav",
		"vo/npc/male01/pardonme01.wav",
		"vo/npc/male01/vanswer01.wav",
		"vo/npc/male01/vanswer13.wav",
	},
	JobQuit = {
		"vo/npc/male01/answer02.wav",
		"vo/npc/male01/answer03.wav",
		"vo/npc/male01/answer04.wav",
		"vo/npc/male01/answer24.wav",
		"vo/npc/male01/heretohelp01.wav",
		"vo/npc/male01/heretohelp02.wav",
		"vo/npc/male01/notthemanithought02.wav",
		"vo/npc/male01/notthemanithought01.wav",
	},
	JobJoin = {
		"vo/npc/male01/answer25.wav",
		"vo/npc/male01/answer24.wav",
		"vo/npc/male01/answer28.wav",
		"vo/npc/male01/answer35.wav",
	},
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAIL ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "mail_spawn" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "mail_spawn_notmail" )
	end

	if (entNPC.m_intLastSoundTime or 0) < CurTime() then
		local snd, _ = table.Random( self.Sounds.StartDialog )
		entNPC:EmitSound( snd, 60 )
		entNPC.m_intLastSoundTime = CurTime() +2
	end
end

function NPCMeta:OnPlayerEndDialog( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end

	if (pPlayer.m_entTalkingNPC.m_intLastSoundTime or 0) < CurTime() then
		local snd, _ = table.Random( self.Sounds.EndDialog )
		pPlayer.m_entTalkingNPC:EmitSound( snd, 60 )
		pPlayer.m_entTalkingNPC.m_intLastSoundTime = CurTime() +2
	end

	pPlayer.m_entTalkingNPC = nil
end

function NPCMeta:SpawnMailTruck( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAIL ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_MAIL ):PlayerSpawnMailTruck( pPlayer )
	self:OnPlayerEndDialog( pPlayer )
end

function NPCMeta:StowMailTruck( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAIL ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_MAIL ):PlayerStowMailTruck( pPlayer )
	self:OnPlayerEndDialog( pPlayer )
end

function NPCMeta:BecomeJob( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAIL ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_MAIL ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_MAIL ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "mail_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_MAIL )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:QuitJob( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAIL ) then return end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN )
	local snd, _ = table.Random( self.Sounds.JobQuit )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "mail_spawn_truck", self.SpawnMailTruck, self )
		GM.Dialog:RegisterDialogEvent( "mail_stow_truck", self.StowMailTruck, self )
		GM.Dialog:RegisterDialogEvent( "mail_become", self.BecomeJob, self )
		GM.Dialog:RegisterDialogEvent( "mail_quit", self.QuitJob, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "mail_spawn", self.StartDialog_Spawn, self )
		GM.Dialog:RegisterDialog( "mail_spawn_notmail", self.StartDialog_NotMail, self )
		GM.Dialog:RegisterDialog( "mail_atplayercap", self.StartDialog_AtJobCap, self )
	end
	
	function NPCMeta:StartDialog_Spawn()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to spawn my mail truck.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "mail_spawn_truck" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to store my mail truck.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "mail_stow_truck" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to quit my job", function()
			GAMEMODE.Net:SendNPCDialogEvent( "mail_quit" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_NotMail()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to become a mail truck driver.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "mail_become" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_AtJobCap()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Sorry, we are not currently hiring." )

		GAMEMODE.Dialog:AddOption( "Oh, alright then...", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )