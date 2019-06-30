--[[
	Name: map_config.lua
	
		
]]--

if SERVER then
	resource.AddWorkshop( "579409868") --map
	resource.AddWorkshop( "579407884") --map content p.1
	resource.AddWorkshop( "579409188") --map content p.2
	
	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( -1774., -5505, -195 ), Angle( 0, 0, 0 ) },
		{ Vector( -1792, -5290, -195 ), Angle( 0, 0, 0 ) },
		{ Vector( -1765, -5060, -195 ), Angle( 0, 0, 0 ) },
		{ Vector(  -1768, -4830, -195 ), Angle( 0, 0, 0 ) },
		{ Vector( -2208, -4831, -195 ), Angle( 0, -150, 0 ) },
		{ Vector( -2198, -5060, -195 ), Angle( 0, -150, 0 ) },
		{ Vector( -2207, -5284, -195 ), Angle( 0, -150, 0 ) },
		{ Vector( -2188, -5504, -195 ), Angle( 0, -150, 0 ) },


	}
	GM.Config.CarGarageBBox = {
		Min = Vector( -2346.386719, -5840.432617, -208 ),
		Max = Vector( -1620.068481, -4608.962891, 307 ),
	}

	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( -2182, 488, -120),
		Vector( -2347, 510, -120 ),
		Vector( -2428, 1010, -120 ),
		Vector( -2268, 1001, -120 ),
		Vector( -2088, 991, -120 ),
	}
	GM.Config.JailReleasePositions = {
		Vector( -1592, -52, -149 ),
		Vector( -1579, 116, -149 ),
		Vector( -1368, 226, -145 ),
	}
	GM.Config.JailBBox = {
		Min = Vector(-1417.968750, -165.461472, -205), 
		Max = Vector(-2507, 1006, 370 )
	}

	--[[ NPC Drug Dealer Settings ]]-- Faltando
	GM.Config.DrugNPCPositions = {
		{ Vector( -9380.265625, 8607.599609, 8 ), Angle(0, 0, 0) },
		{ Vector( 1797.927124, 9606.061523, 78 ), Angle(0, 50, 0) },
		{ Vector( 8474.322266, -7223.315918, 90 ), Angle(0, -140, 0) },
		{ Vector( 11273.801758, -244.420776, 450 ), Angle(0, 100, 0) },
	}

	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( 3334.430176, 1229.166992 -200 ),
		Vector( 3144.420166, 958.786621, -200 ),
		Vector( 3132.640869, 891.414673, -200 ),
		Vector( 3340.830078, 649.361145, -200 ),
	}

	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_downtown_v2_insonic"] = {
		Doors = {
			["Repair_garagedoor 2"] = { CarPos = Vector(-1952, -6492, -138) }, --Doors for the garage
			["Repair_garagedoor 1"] = { CarPos = Vector(-1952, -5836, -138) }, --Doors for the garage
		},
		BBox = {
			Min = Vector( -934.224792, -5697.066895, -250.179871 ), --Inside of the garage
			Max = Vector( -2344.711914, -6754.595703, 355.342529 ), --Inside of the garage
		},
		PlayerSetPos = Vector( -2282.217285, -5969.218750, -195.968750 ), --If a player gets inside the garage, set them to this location
	}

	--[[ Fire Spawner Settings ]]--
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 1 * 1
	GM.Config.AutoFireSpawnMaxTime = 1 * 5
	GM.Config.AutoFireSpawnPoints = {
		--Gas stations
		Vector( "-8942.533203 -7861.419922 288.031250" ),
		Vector( "-8715.147461 -8090.916504 288.031250" ),
		Vector( "-6547.855469 1689.688477 288.031250" ),
		Vector( "-6564.518066 1903.038940 288.031250" ),
		Vector( "-11943.944336 10784.564453 60.031250" ),
		Vector( "-12175.997070 10799.713867 60.031250" ),

		--Gas stations inside
		Vector( "-6895.257324 1255.600098 292.031250" ),
		Vector( "-11610.813477 10396.053711 64.031250" ),
		Vector( "-8439.782227 -7404.658203 292.031250" ),

		--Junkyard
		Vector( "-3962.382568 -9468.200195 286.502014" ),
		Vector( "-5659.629395 -9288.423828 280.031250" ),
		Vector( "-3365.916992 -8674.002930 280.031250" ),

		--Grocery store
		Vector( "-11883.190430 -11767.650391 292.031250" ),
		Vector( "-11879.181641 -10883.125977 292.031250" ),

		--Electronics store alley
		Vector( "-11857.025391 -12460.521484 292.031219" ),

		--Bank
		Vector( "-4931.397949 4436.788086 288.031250" ),

		--Underpass
		Vector( "-12887.172852 5914.155273 8.031250" ),
	}
end

--[[ Car Dealer Settings ]]--
GM.Config.CarPreviewModelPos = Vector( 7974.013184, 7984.390625, 12192.031250 )
GM.Config.CarPreviewCamPos = Vector( 7717.645508, 7679.407227, 12286.620117 )
GM.Config.CarPreviewCamAng = Angle( 20, 51, 0 )
GM.Config.CarPreviewCamLen = 1.5

--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( -5658.086914, -9473.299805, 348.023529 )

--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = 380
GM.Config.FogLightingEnabled = true