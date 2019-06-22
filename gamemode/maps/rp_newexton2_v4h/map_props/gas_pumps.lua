--[[

	Name: gas_pumps.lua

	For: santosrp

	By: santosrp

]]--



local MapProp = {}

MapProp.ID = "gas_pumps"

MapProp.m_tblSpawn = {}

MapProp.m_tblPumps = {

	{ pos = Vector(3443.39, 5179.93, 1030.42), angs = Angle(0, 0, 0) },

	{ pos = Vector(3443.39, 5077.22, 1030.42), angs = Angle(0,-180, 0) },

	{ pos = Vector(3851.49, 5061.68, 1030.42), angs = Angle(0, 0, 0) },

	{ pos = Vector(3851.49, 5182.00, 1030.42), angs = Angle(0, -180, 0) },

	{ pos = Vector(-5759.48, -8190.95, -516.46), angs = Angle(0, 0, 0) },

}



function MapProp:CustomSpawn()

	for k, v in pairs( self.m_tblPumps ) do

		local ent = ents.Create( "ent_fuelpump" )

		ent:SetPos( v.pos )

		ent:SetAngles( v.angs )

		ent.IsMapProp = true

		ent:Spawn()

		ent:Activate()



		local phys = ent:GetPhysicsObject()

		if IsValid( phys ) then

			phys:EnableMotion( false )

		end

	end

end



GAMEMODE.Map:RegisterMapProp( MapProp )