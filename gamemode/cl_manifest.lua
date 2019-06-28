--[[
	Name: cl_manifest.lua
	For: vrzn
	By: vrzn
]]--

include "vrzn/gamemode/sh_config.lua"
include "vrzn/gamemode/sh_propprotect.lua"
include "vrzn/gamemode/sh_economy.lua"
include "vrzn/gamemode/sh_gmodhands.lua"
include "vrzn/gamemode/sh_npcdialog.lua"
--include "vrzn/gamemode/sh_chatbox.lua"
include "vrzn/gamemode/sh_util.lua"
include "vrzn/gamemode/sh_car_radios.lua"
include "vrzn/gamemode/sh_item_radios.lua"
include "vrzn/gamemode/sh_unconscious.lua"
include "vrzn/gamemode/sh_santos_customs.lua"
include "vrzn/gamemode/sh_cars_misc.lua"
include "vrzn/gamemode/sh_pacmodels.lua"
include "vrzn/gamemode/sh_chat.lua"
include "vrzn/gamemode/sh_player_anims.lua"
include "vrzn/gamemode/cl_networking.lua"
include "vrzn/gamemode/cl_player.lua"
include "vrzn/gamemode/cl_characters.lua"
include "vrzn/gamemode/cl_inventory.lua"
include "vrzn/gamemode/cl_gui.lua"
include "vrzn/gamemode/cl_npcs.lua"
include "vrzn/gamemode/cl_properties.lua"
include "vrzn/gamemode/cl_calcview.lua"
include "vrzn/gamemode/cl_cinicam.lua"
include "vrzn/gamemode/cl_cars.lua"
include "vrzn/gamemode/cl_chatradios.lua"
include "vrzn/gamemode/cl_jobs.lua"
include "vrzn/gamemode/cl_jail.lua"
include "vrzn/gamemode/cl_map.lua"
include "vrzn/gamemode/cl_hud.lua"
include "vrzn/gamemode/cl_hud_car.lua"
include "vrzn/gamemode/cl_license.lua"
include "vrzn/gamemode/cl_3d2dvgui.lua"
include "vrzn/gamemode/cl_skills.lua"
include "vrzn/gamemode/cl_drugs.lua"
include "vrzn/gamemode/cl_needs.lua"
include "vrzn/gamemode/cl_buddies.lua"
include "vrzn/gamemode/cl_weather.lua"
include "vrzn/gamemode/cl_daynight.lua"
include "vrzn/gamemode/cl_apps.lua"
include "vrzn/gamemode/sh_store_robbery.lua"
include "vrzn/gamemode/modules/libs/shadow.lua"
include "vrzn/gamemode/modules/libs/circle.lua"
include "vrzn/gamemode/modules/libs/awesome_utils.lua"

--Load vgui
local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "vgui/*.lua", "LUA" )
for k, v in pairs( foundFiles ) do
	include( GM.Config.GAMEMODE_PATH.. "vgui/".. v )
end