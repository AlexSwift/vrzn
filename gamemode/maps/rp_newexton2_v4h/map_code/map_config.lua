 --[[

	Name: map_config.lua
	
]]--


if SERVER then
	resource.AddWorkshop( "1318768443") --map
	GM.DayNight.m_tblTimeData.High = string.byte( "m" )


	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( -7684.47, 2301.15, 1088.03 ), Angle( 0, 180, 0 ) },
	}

	GM.Config.CarGarageBBox = {
			Min = Vector( -8188.28, 1950.95, 990.42 ), --Inside of the garage
			Max = Vector( -6329.59, 4174.81, 1265.86 ), --Inside of the garage
	}


	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( -6236.16, 8354.04, 885.74 ),
		Vector( -6245.09, 8005.67, 885.74 ),
	}

	GM.Config.JailReleasePositions = {
		Vector( -6589.90, 7890.69, 1152.03 ),
		Vector( -6588.94, 8038.37, 1152.03 ),
	}

	GM.Config.JailBBox = {
		{
			Min = Vector( -7162.24, 7757.23, 724.12 ),
			Max = Vector( -6272.36, 8621.38, 980.00 ),
		},
	}

	GM.Config.JailBBox = {
		{
			Min = Vector( -7614.85, -5339.12, -14068.31 ),
			Max = Vector( -7086.16, -4905.16, -13215.98 ),
		},
	}

	
	--[[ NPC Drug Dealer Settings ]]--

	GM.Config.DrugNPCPositions = {
		{ Vector( "-10191.97 1450.51 1088.03" ), Angle( 0, 0, 0 ) },
	}


	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( -6907.20, 6262.83, 1088.03 ),
		Vector( -6806.21, 6261.05, 1088.03 ),
	}


	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_newexton2_v4h"] = {
		NoDoors = true,
		CarPos = {
			Vector( -5115.15, -5509.55, 1080.03 ),
			Vector( -4672.76, -5504.63, 1080.03 ),
		},
		
		BBox = {
			Min = Vector( -5502.21, -5960.46, 1093.82 ), --Inside of the garage
			Max = Vector( -4402.06, -4915.89, 1126.95 ), --Inside of the garage
		},

		PlayerSetPos = Vector( -7782.479492, -2050.822998, 8.031250 ), --If a player gets inside the garage, set them to this location
	}


	--[[ Fire Spawner Settings ]]--
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 60 *10
	GM.Config.AutoFireSpawnMaxTime = 60 *30
	GM.Config.AutoFireSpawnPoints = {

		--Road side car dealer
		Vector( "-2204.491699 -753.151123 19.765747" ),

		--Road side city alley
		Vector( "-9854.040039 3485.471924 7.999939" ),

		--Factory
		Vector( "-8813.806641 7178.747070 0.000000" ),
		Vector( "-7863.180664 7258.520020 0.000061" ),
		Vector( "-7099.451172 7063.115234 0.000000" ),

		--Gas stations
		Vector( "150.768524 4202.308105 536.031250" ),
		Vector( "426.462280 3770.764404 536.031250" ),
		Vector( "-13753.673828 2417.652344 384.031250" ),
		Vector( "-14085.485352 2898.688965 384.031250" ),

		--Gas stations inside
		Vector( "845.067078 3938.952637 544.031250" ),
		Vector( "-14467.480469 2654.844238 392.031250" ),
	}
end


--[[ Car Dealer Settings ]]--
GM.Config.CarPreviewModelPos = Vector( -7046.13, -4974.89, 1034.14 )
GM.Config.CarPreviewCamPos = Vector( -6884.56, -5171.52, 1213.84 )
GM.Config.CarPreviewCamAng = Angle( 27.16, 130.47, 0 )
GM.Config.CarPreviewCamLen = 1.5


--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( -4182, -8230, 287 )


--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = nil --Skybox is not even height!
GM.Config.FogLightingEnabled = false