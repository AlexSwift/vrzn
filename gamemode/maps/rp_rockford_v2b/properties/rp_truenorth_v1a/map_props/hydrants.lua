local MapProp = {}
MapProp.ID = "job_hydrant_water"
MapProp.m_tblSpawn = {}
MapProp.m_tblSpawnPoints = {
	--not already in the map
	{ pos = Vector(6216.2495117188, 4270.150390625, 8.0312538146973), ang = Angle(0, 0, 0) },
	{ pos = Vector(7376.1352539063, 3673.7009277344, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(8314.224609375, 2799.1879882813, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(9759.349609375, 3594.4760742188, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(10997.478515625, 3055.5954589844, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(11551.467773438, 4686.4091796875, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(10473.0390625, 5313.1748046875, 8.03125), ang = Angle(0, 0, 0) },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblSpawnPoints ) do
		local ent = ents.Create( "ent_hydrant" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
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