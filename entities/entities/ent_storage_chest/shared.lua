--[[
	Name: shared.lua
	For: SantosRP
	By: TalosLife
]]--

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Purpose			= ""


function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "MaxVolume" )
end