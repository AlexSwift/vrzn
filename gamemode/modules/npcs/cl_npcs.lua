--[[
	Name: cl_npcs.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


GM.NPC = (GAMEMODE or GM).NPC or {}
GM.NPC.m_tblNPCRegister = (GAMEMODE or GM).NPC.m_tblNPCRegister or {}

function GM.NPC:LoadNPCs()
	GM:PrintDebug( 0, "->LOADING NPCs" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "core/npcs/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "core/npcs/".. v )
	end

	GM:PrintDebug( 0, "->NPCs LOADED" )
end

function GM.NPC:Register( tblNPC )
	self.m_tblNPCRegister[tblNPC.UID] = tblNPC

	if tblNPC.RegisterDialogEvents then
		tblNPC:RegisterDialogEvents()
	end
end

function GM.NPC:GetNPCMeta( strNPCUID )
	return self.m_tblNPCRegister[strNPCUID]
end

function GM.NPC:Initialize()
	for k, v in pairs( self.m_tblNPCRegister ) do
		if v.Initialize then v:Initialize() end
	end
end