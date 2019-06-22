--[[

	Name: gas_pumps.lua

	For: Project UnrealRP
	By: AndrewTech

]]--



local MapProp = {}

MapProp.ID = "gas_pumps"

MapProp.m_tblSpawn = {}

MapProp.m_tblPumps = {
	{ pos = Vector(-8763.5966796875, -9235.859375, 12.03125), angs = Angle(0, 0, 0) },
	{ pos = Vector(-8765.6298828125, -9476.197265625, 12.03125), angs = Angle(0, 0, 0) },

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


	for a, b in pairs( ents.GetAll() ) do
		if b:GetModel() == "models/props_equipment/gas_pump.mdl" then
			local ent = ents.Create( "ent_fuelpump" )
			ent:SetPos( b:GetPos() )
			ent:SetAngles( b:GetAngles() )
			ent.IsMapProp = true
			ent:Spawn()
			ent:Activate()
			b:Remove()
			local phys = ent:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableMotion( false )
			end
		end
	end
end



GAMEMODE.Map:RegisterMapProp( MapProp )