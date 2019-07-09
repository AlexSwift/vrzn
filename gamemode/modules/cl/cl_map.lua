--[[
	Name: cl_map.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


GM.Map = {}

function GM.Map:Load()
	self:LoadMapCode()
end

function GM.Map:Initialize()
end

--[[ Map Code ]]--
function GM.Map:LoadMapCode()
	GM:PrintDebug( 0, "->LOADING MAP CODE" )

	local map = game.GetMap():gsub(".bsp", "")
	local path = GM.Config.GAMEMODE_PATH.. "core/maps/".. map.. "/map_code/"

	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
	end

	GM:PrintDebug( 0, "->MAP CODE LOADED" )
end