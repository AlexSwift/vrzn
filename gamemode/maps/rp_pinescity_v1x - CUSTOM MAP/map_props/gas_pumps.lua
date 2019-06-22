--[[
	Name: gas_pumps.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "gas_pumps"
MapProp.m_tblSpawn = {}
MapProp.m_tblPumps = {
	--Gas station 1
	{ pos = Vector( -8399.000000, 11032.000000, 97.000000 ), angs = Angle(0, 0, 0) },
	{ pos = Vector( -8649.000000, 11032.000000, 97.000000 ), angs = Angle(0, 0, 0) },
--------------gas 2
	{ pos = Vector(6043.000000, -6414.000000, 97.000000), angs = Angle(0, 0, 0) },
	{ pos = Vector(6315.000000, -6414.000000, 97.000000), angs = Angle(0, 0, 0) },
	{ pos = Vector(5793.000000, -6414.000000, 97.000000), angs = Angle(0, 0, 0) },
	{ pos = Vector(5543.000000, -6414.000000, 97.000000), angs = Angle(0, 0, 0) },
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