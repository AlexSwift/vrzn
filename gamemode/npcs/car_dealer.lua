--[[
	Name: car_dealer.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


local NPCMeta = {}
NPCMeta.Name = "Car Dealer"
NPCMeta.UID = "car_dealer"
NPCMeta.SubText = "Purchase a vehicle here"
NPCMeta.Model = "models/alyx.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/eli_lab/al_thyristor02.wav",
		"vo/novaprospekt/al_gladtoseeyoureok.wav",
	},
	EndDialog = {
		"vo/eli_lab/al_allright01.wav",
		"vo/novaprospekt/al_careofyourself.wav",
	}
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "car_dealer" )

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

function NPCMeta:ShowBuyCarMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "car_buy" )
end

function NPCMeta:ShowSellCarMenu( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "car_sell" )
end

function NPCMeta:ShowSpawnMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "car_spawn" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "car_dealer_buy", self.ShowBuyCarMenu, self )
		GM.Dialog:RegisterDialogEvent( "car_dealer_sell", self.ShowSellCarMenu, self )
		GM.Dialog:RegisterDialogEvent( "car_spawn_menu", self.ShowSpawnMenu, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "car_dealer", self.StartDialog, self )
		GM.Dialog:RegisterDialog( "car_spawn", self.StartDialog, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Como posso ajudar?" )

		GAMEMODE.Dialog:AddOption( "Quero comprar um carro.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "car_dealer_buy" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Quero vender meu carro.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "car_dealer_sell" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Quero spawnar meu carro.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "car_spawn_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Quero sair.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )