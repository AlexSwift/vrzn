--[[
	Name: sh_loader.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--
local file = file

local FILE_CLIENT = 0x0
local FILE_SHARED = 0x1
local FILE_SERVER = 0x2

local function AddCSInclude(sDirectory, sFilePattern, sFileType)
  files = file.Find(sDirectory.. "/".. sFilePattern, "LUA")

  for _, file in pairs(files) do
    local fileDir = sDirectory.. "/".. file

    if sFileType == FILE_SHARED then include(fileDir) end
    if sFileType == FILE_CLIENT and CLIENT then include(fileDir) end
    if sFileType == FILE_SERVER and SERVER then include(fileDir) end

    if sFileType == FILE_CLIENT and SERVER or sFileType == FILE_SHARED and SERVER then AddCSLuaFile(fileDir) end
  end
end

local function LoadAllTypes(sDirectory)
  AddCSInclude(sDirectory, "cl_*.lua", FILE_CLIENT)
  AddCSInclude(sDirectory, "sh_*.lua", FILE_SHARED)
  AddCSInclude(sDirectory, "sv_*.lua", FILE_SERVER)
end

local function LoadFolder(sFolder, tExcludeDir)
  tExcludeDir = tExcludeDir or {}

  LoadAllTypes(sFolder)

  local _, dirs = file.Find(sFolder.. "/*", "LUA")

  for _, dir in pairs(dirs) do
    if tExcludeDir[dir] then continue end

    LoadAllTypes(sFolder.. "/".. dir)
  end
end

function GM._Core.LoadLibs()
  GM:PrintCore("[X] CARREGANDO BIBLIOTECAS")
  LoadFolder(GM.BaseDirectory.. "libs")
  GM:PrintCore("[v] DONE")
end

function GM._Core.LoadConfig()
  GM:PrintCore("[X] CARREGANDO ARQUIVOS DE CONFIGURAÇÃO")
  LoadFolder(GM.BaseDirectory.. "config")
  GM:PrintCore("[v] DONE")
end

function GM._Core.LoadCore()
  GM:PrintCore("[X] CARREGANDO ARQUIVOS DE BOOT")
  LoadFolder(GM.BaseDirectory.. "core", {boot = true})
  GM:PrintCore("[v] DONE")
end

function GM._Core.LoadModules()
  GM:PrintCore("[X] INSERINDO MÓDULOS")
  LoadFolder(GM.BaseDirectory.. "modules", {
    day_night = true
  })
  GM:PrintCore("[v] DONE")
end
