--[[
	© 2018 Sinful Gaming, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
GM._Core = GM._Core or {}

include("sh_loader.lua")

if SERVER then
  AddCSLuaFile("sh_loader.lua")
  AddCSLuaFile "vrzn/gamemode/config/sh_config.lua"
  AddCSLuaFile "vrzn/gamemode/libraries/sh_util.lua"
  AddCSLuaFile "vrzn/gamemode/libraries/sh_pacmodels.lua"
  include "vrzn/gamemode/config/sh_config.lua"
  include "vrzn/gamemode/libraries/sh_util.lua"
  include "vrzn/gamemode/libraries/sh_pacmodels.lua"
  
  include "vrzn/gamemode/config/sv_config.lua"
  include "vrzn/gamemode/modules/sv_firesystem.lua"

  include "vrzn/gamemode/modules/sv_pvs_buffer.lua"

  
  --Load vgui
  local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "vgui/*.lua", "LUA" )
  for k, v in pairs( foundFiles ) do
    AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "vgui/".. v )
  end

  --Add resources
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

-- resource.AddWorkshop( "104502728" )
end



if CLIENT then
  include "vrzn/gamemode/config/sh_config.lua"
  include "vrzn/gamemode/libraries/sh_util.lua"
  include "vrzn/gamemode/libraries/sh_pacmodels.lua"

  local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "vgui/*.lua", "LUA" )
  for k, v in pairs( foundFiles ) do
    include( GM.Config.GAMEMODE_PATH.. "vgui/".. v )
  end

end

GM._Core.LoadCore()
hook.Run("GM._Core.PostCoreLoaded")

GM._Core.LoadModules()
hook.Run("GM._Core.PostModuleLoaded")

timer.Simple(0, function()
  hook.Run("GM._Core.PostLoaded")
end)


GM.Name 	= "VRZN"
GM.Author 	= "Nodge"
GM.Email 	= "wbm.nodge@gmail.com"
GM.Website 	= "http://mjsv.us"



function GM:PrintDebug( intLevel, ... )
	print( ... )
end


if not debug.getregistry().Player.CheckGroup then
	debug.getregistry().Player.CheckGroup = function()
		return true
	end
end

if game.SinglePlayer() then
	debug.getregistry().Player.SteamID64 = function()
		return "1234567890"
	end
end

hook.Remove( "PlayerTick", "TickWidgets" )

--Precache models
for k, v in pairs( GM.Config.PlayerModels.Male ) do
	util.PrecacheModel( k )
end

for k, v in pairs( GM.Config.PlayerModels.Female ) do
	util.PrecacheModel( k )
end

for k, v in pairs( GM.Config.PlayerModelOverloads.Male or {} ) do
	util.PrecacheModel( k )
end

for k, v in pairs( GM.Config.PlayerModelOverloads.Female or {} ) do
	util.PrecacheModel( k )
end