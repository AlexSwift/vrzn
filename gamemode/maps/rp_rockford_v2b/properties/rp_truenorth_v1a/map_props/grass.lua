local MapProp = {}
MapProp.ID = "job_mowabel_grass"
MapProp.m_tblSpawn = {}
MapProp.m_tblSpawnPoints = {
	--not already in the map
	{ pos = Vector(8541.142578125, 5085.4423828125, 5.994140625), ang = Angle(0, 0, 0) },
	{ pos = Vector(7184.9350585938, 5749.3369140625, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(7030.1630859375, 5112.7036132813, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(8794.8759765625, 7277.98828125, 6.0464782714844), ang = Angle(0, 0, 0) },
	{ pos = Vector(8793.2705078125, 8221.73828125, 3.895263671875), ang = Angle(0, 0, 0) },
	{ pos = Vector(7277.19140625, 7770.0776367188, 8.03125), ang = Angle(0, 0, 0) },
	{ pos = Vector(8311.8134765625, 9901.3251953125, 8.0313110351563), ang = Angle(0, 0, 0) },
	{ pos = Vector(13230.590820313, 2708.5349121094, 17.796157836914), ang = Angle(0, 0, 0) },
	{ pos = Vector(13207.092773438, -283.55493164063, 29.521575927734), ang = Angle(0, 0, 0) },
	{ pos = Vector(12246.056640625, 707.66217041016, 31.533508300781), ang = Angle(0, 0, 0) },
	{ pos = Vector(10970.787109375, 506.97302246094, 0), ang = Angle(0, 0, 0) },
	{ pos = Vector(10311.485351563, -575.3193359375, 0), ang = Angle(0, 0, 0) },
}

function MapProp:CustomSpawn()
	print("Work")
	for _, propData in pairs( self.m_tblSpawnPoints ) do
		local ent = ents.Create( "ent_mow_grass" )
		print(ent)
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