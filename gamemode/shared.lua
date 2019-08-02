--[[
	Name: sh_init.lua
		by: Asriel + CodeRed

]]--
GM.Name 	= "VrZn"
GM.Author 	= "Nodge"
GM.Email 	= "wbm.nodge@gmail.com"
GM.Website 	= "vrzn.mjsv.us"


GM.BaseDirectory = GM.FolderName .. "/gamemode/"

AddCSLuaFile("cl_init.lua")
AddCSLuaFile()

--CreateConVar("serverid",1,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_NEVER_AS_STRING}, "Console Varible to set the server's ID.")

function GM:PrintDebug( intLevel, ... )
	-- MsgC(Color(150, 150, 150), "[SantosRP]: ", Color(120, 255, 120), ..., "\n")
end

function GM:PrintCore(... )
	local name = SERVER and "[VRZN]: " or "[VRZN CLIENT]: "
	 MsgC(Color(255, 150, 150), name, Color(0, 255, 78), ..., "\n")
end

include("core/boot/sh_boot.lua")
AddCSLuaFile("core/boot/sh_boot.lua")

if game.SinglePlayer() then
	debug.getregistry().Player.SteamID64 = function()
		return "1234567890"
	end
end

function GM:OnReloaded()
	if SERVER then
		AddNoteAll("O servidor está passando por uma atualização rápida.", 2, 5)
		AddNoteAll("Você vai sentir um pouco de lag.", 2, 10)
		self.NPC:Initialize()
	else
		GAMEMODE.HUD:AddNote("Estamos atualizando o servidor.", 2, 5)
		GAMEMODE.HUD:AddNote("Lag durante o processo é normal :) .", 2, 5)
	end
end

hook.Remove( "PlayerTick", "TickWidgets" )

local foundFiles, foundFolders = file.Find( GM.BaseDirectory.. "santos/vgui/*.lua", "LUA" )

for k, v in pairs( foundFiles ) do
	if CLIENT then
		include(GM.BaseDirectory.. "santos/vgui/".. v)
	end

	AddCSLuaFile(GM.BaseDirectory.. "santos/vgui/".. v)
end

if SERVER then
	local function FilesInDir( strDir, b )
		local files, folders = file.Find( strDir.. "/*", "GAME" )
		local ret = {}

		for k, file in pairs( files ) do
			ret[k] = strDir.. "/".. file
		end

		for k, folder in pairs( folders ) do
			for k2, v2 in pairs( FilesInDir(strDir.. "/".. folder, true) ) do
				table.insert( ret, v2 )
			end
		end

		return ret
	end

	hook.Add( "Initialize", "CompareAddons:BuildList", function( )
		for k, v in pairs( engine.GetAddons( ) ) do
			local _file = v.wsid and v.wsid or string.gsub( tostring( v.file ), "%D", "" )
			resource.AddWorkshop( _file )
		end
	end )
end
