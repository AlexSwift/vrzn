--[[
	Name: remove_props.lua
	For: Project UnrealRP
	By: AndrewTech
]]--

local MapProp = {}
MapProp.ID = "remove_props"

MapProp.m_tblSpawn = {}

MapProp.m_tblRemove = {
	-- prop_physics

}

function MapProp:CustomSpawn()
	for k, v in pairs( self.m_tblRemove ) do
		for _, ent in pairs( ents.FindInSphere(v.pos, 5) ) do
			if v.mdl then
				if ent:GetModel() == v.mdl then ent:Remove() end
			elseif v.class then
				if ent:GetClass() == v.class then ent:Remove() end
			end
		end
	end

	for k, v in pairs( ents.GetAll() ) do
		if v:GetModel() == "models/props_urban/gas_pump001.mdl" then
			v:Remove()
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )