--[[
	Name: map_config.lua
	For: Project UnrealRP
	By: AndrewTech
]]--

if SERVER then
	resource.AddWorkshop( "1601428630" ) --map
	resource.AddWorkshop( "1601425051" ) --map content p.1
	resource.AddWorkshop( "1601404123" ) --map content p.2
	
	
	GM.DayNight.m_tblTimeData.High = string.byte( "m" )
	
	--[[ Car Dealer Settings ]]--DONE
	GM.Config.CarSpawns = {
		{ Vector( 10868.316406, 2239.178955, -253.792068 ), Angle( 0, 90, 0 ) },
		{ Vector( 10851.620117, 2426.980225, -253.733673 ), Angle( 0, 90, 0 ) },
		{ Vector( 10803.526367, 2601.000244, -255.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10846.233398, 2809.448486, -253.761841 ), Angle( 0, 90, 0 ) },
	}
	GM.Config.CarGarageBBox = {
		Min = Vector(10640.03125, 1936.1348876953, -300.86804199219),
		Max = Vector(12159.96875, 2943.8376464844, 10),
	}

	--[[ Jail Settings ]]--DONE
	GM.Config.JailPositions = {
		Vector( 3753.272949, 2461.303467, 65.529922 ),
		Vector( 3750.927979, 2205.123291, 65.031395 ),
		Vector( 3753.728027, 1957.783325, 65.446129 ),
		Vector( 3748.000732, 1710.314697, 65.155022 ),
	}
	GM.Config.JailReleasePositions = {
		Vector( 2163.281494, 3440.173340, 72.131790 ),
		Vector( 2460.515137, 3473.732910, 72.031639 ),
			}
	GM.Config.JailBBox = {
		Min = Vector(-0.37589645385742, 1536.2054443359, 0),
		Max = Vector(3967.96875, 3849.2885742188, 383.59616088867),
	}

	--[[ NPC Drug Dealer Settings ]]--DONE
	GM.Config.DrugNPCPositions = {
		{ Vector( 15637.649414, -4591.186035, 65.031250 ), Angle( 0, -40, 0 ) },
		{ Vector( -12797.639648, -11131.670898, -150.938690 ), Angle( 0, 0, 0 ) },
		{ Vector( 3824.972656, 546.760559, 64.163322 ), Angle( 0, 90, 0 ) },
	}

	--[[ Map Settings ]]--DONE
	GM.Config.SpawnPoints = {
		Vector( 5064.340332, 3007.629395, 136.031250 ),
		Vector( 4998.760742, 3008.217773, 136.031250 ),
		Vector( 5128.075684, 3011.578369, 136.031250 ),
		Vector( 5254.874023, 3007.882324, 136.031250 ),
		Vector( 4845.270508, 3010.259521, 136.031250 ),
		Vector( 4690.244141, 3456.837402, 136.031250 ),
		Vector( 5431.120117, 3446.484131, 136.031250),
	}

	--[[ Register the car customs shop location ]]--DONE
	GM.CarShop.m_tblGarage["rp_truenorth_v1a"] = {
		NoDoors = true,
		CarPos = {
			Vector( -9980.112305, 12942.848633, 69.009956 ),
			Vector( 9981.258789, 13310.233398, 69.096527 ),
			Vector( 9980.325195, 14065.288086, 69.190651 ),
			Vector( 9989.632813, 14461.711914, 69.562714 ),
			},
		BBox = {
		Min = Vector(9352.2021484375, 12672.280273438, -10.03125),
		Max = Vector(10367.94921875, 14711.96875, 351.79800415039),
		},
		PlayerSetPos = Vector( -6097.172852, -1639.750732, 64.031250 ), --If a player gets inside the garage, set them to this location((((DONT KNOW))))
	}

	--[[ Fire Spawner Settings ]]--DONE
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 60 *10
	GM.Config.AutoFireSpawnMaxTime = 60 *30
	GM.Config.AutoFireSpawnPoints = {
		--Road side car dealer
		Vector( "6561.401367 13914.392578 70.774628" ),

		--Factory
		Vector( "13131.758789 -780.269104 71.515755" ),
		Vector( "-7863.180664 7258.520020 0.000061" ),


		--Gas stations
		Vector( "-8673.186523 -9456.937500 69.013657" ),
		Vector( "-8667.534180 -9298.668945 68.169464" ),


		--Gas stations inside
		Vector( "15108.996094 12683.488281 66.159637" ),
		Vector( "15116.558594 12360.693359 64.218895" ),
	}
end

--[[ Car Dealer Settings ]]--DONE
GM.Config.CarPreviewModelPos = Vector( 6869.563965, 12586.995117, 71.971916 )
GM.Config.CarPreviewCamPos = Vector( 6860.059082, 12315.700195, 125.365761 )
GM.Config.CarPreviewCamAng = Angle( 0, 90, 0 )
GM.Config.CarPreviewCamLen = 1.5

--[[ Chop Shop ]]--DONE
GM.Config.ChopShop_ChopLocation = Vector( 13196.025391, -4121.841797, 63.937027 )

--[[ Weather & Day Night ]]--DONE
GM.Config.Weather_SkyZPos = nil --Skybox is not even height!
GM.Config.FogLightingEnabled = false