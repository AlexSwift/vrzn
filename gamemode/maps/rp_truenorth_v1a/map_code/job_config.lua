--[[
	Name: job_config.lua
	For: Project UnrealRP
	By: AndrewTech
		
]]--

--[[ EMS Config ]]--DONE
GM.Config.EMSHospitalZone = {
		Min = Vector(12032.31640625, 12415.8984375, -10.03125),
		Max = Vector(13719.986328125, 13320.018554688, 320.03280639648),
}

if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector(12672.45703125, 11127.96875, -10.33539199829102),
		Max = Vector(13519.96875, 12407.776367188, 263.68316650391),
	}

	GM.Config.EMSCarSpawns = {
		{ Vector( 13092.068359, 11421.661133, 2.192498 ), Angle( 0, -90, 0 ) },
		{ Vector( 13098.44, 11679.15, 66.19 ), Angle( 0, -90, 0 ) },
		{ Vector( 13087.42, 11936.49, 66.19 ), Angle( 0, -90, 0 ) },
		{ Vector( 13076.40, 12193.83, 66.19 ), Angle( 0, -90, 0 ) },


	}
end

--[[ Fire Config ]]--DONE
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector(12672.45703125, 11127.96875, -10.33539199829102),
		Max = Vector(13519.96875, 12407.776367188, 263.68316650391),
	}

	GM.Config.FireCarSpawns = {
		{ Vector( 13133.170898, 11687.291992, 10.218956), Angle( 0, -90, 0 ) },
		{ Vector( 13087.42, 11936.49, 66.19 ), Angle( 0, -90, 0 ) },
		{ Vector( 13098.44, 11679.15, 66.19 ), Angle( 0, -90, 0 ) },
		{ Vector( 13076.40, 12193.83, 66.19 ), Angle( 0, -90, 0 ) },
	}
end

--[[ Cop Config ]]--DONE
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector(-0.21689462661743, 1535.96875, -10.8154878616333),
		Max = Vector(3967.96875, 5503.8637695313, 383.92126464844),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( 3235.250000, 3888.625000, -0.562500 ), Angle( 0, 0, 0 ) },
		{ Vector( 2659.753418, 3910.075195, 2.208935 ), Angle( 0, 0, 0 ) },
		{ Vector( 2659.753418, 3910.075195, 2.208935 ), Angle( 0, 0, 0 ) },
		{ Vector( 3040.343750, 3895.245361, -0.562500 ), Angle( 0, 0, 0 ) },
		{ Vector( 2844.718750, 3902.035400, -0.593750 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Tow Config ]]--DONE
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector(5578.052734375, 11057.780273438, -10.03125),
		Max = Vector(8056.7485351563, 12287.96875, 204.81010437012),
	}

	GM.Config.TowParkingZone = {
		Min = Vector(7552.6240234375, 12799.96875, -21.993112564087),
		Max = Vector(8279.0634765625, 13879.96875, 513.44952392578),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( 7942.139648, 12984.382813, -14.385483 ), Angle( 0, 0, 0 ) },
		{ Vector( 7757.071289, 12996.401367, -14.418734 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Taxi Config ]]--DONE
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector(11251.908203125, 7234.810546875, -10.03125),
		Max = Vector(11517.995117188, 7901.453125, 252.24458312988),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( 11380.598633, 7573.872559, -1.728527 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Sales Config ]]--DONE
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector(10497.129882813, 6615.8393554688, -10.03125),
		Max = Vector(10750.713867188, 7162.224609375, 218.60984802246),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( 10614.305664, 6901.440918, -1.188471 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Mail Config ]]--DONE
if SERVER then
	GM.Config.MailParkingZone = GM.Config.SalesParkingZone
	GM.Config.MailCarSpawns = GM.Config.SalesCarSpawns
end

GM.Config.MailDepotPos = Vector( 10614.305664, 6901.440918, 1 )
GM.Config.MailPoints = {
	{ Pos = Vector( 9665.531250, 9531.031250, 13.687500 ), Name = "Casino", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 11729.781250, 7680.406250, 16.375000 ), Name = "Transit Authority", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2308.881836, 3660.961914, 18.043951 ), Name = "Police Department", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 13494.875000, 13380.625000, 72.375000 ), Name = "Hospital", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 11732.406250, 4736.031250, 16.343750 ), Name = "Furniture Gallery", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 9205.000000, 9516.250000, 13.1875000 ), Name = "Electronics Plus", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 8746.528320, 9516.887695, 18.124439 ), Name = "Kappel's Clothing", MinPrice = 50, MaxPrice = 200 },

	--Subs
	{ Pos = Vector( 290.559692, 8132.866699, 144.277420 ), Name = "House 50 Spruce Cres", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -4014.602295, 9637.833984, 141.716125 ), Name = "House 35 River Rd", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -4656.071777, 12390.243164, 145.990341 ), Name = "House 10 River Rd", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 297.282867, 13667.803711, 145.962891 ), Name = "House 2 Spruce Cres", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 169.338745, 11322.252930, 145.997467 ), Name = "House 16 Spruce Cres", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -3845.500244, 7741.598633, 141.674118 ), Name = "House 69 River Rd", MinPrice = 50, MaxPrice = 200 },
}

--[[ Bus Config ]]--DONE
if SERVER then
	GM.Config.BusParkingZone = GM.Config.TaxiParkingZone
	GM.Config.BusCarSpawns = GM.Config.TaxiCarSpawns
end

--[[ Garbage Config ]]--DONE
if SERVER then
	GM.Config.GarbageParkingZone = GM.Config.TowParkingZone
	GM.Config.GarbageCarSpawns = GM.Config.TowCarSpawns
end

--[[ Secret Service Config ]]--DONE
if SERVER then
	GM.Config.SSParkingZone = {
		Min = Vector(4097.1181640625, 4608.7651367188, -10.03125),
		Max = Vector(5989.0424804688, 5047.8217773438, 273.12307739258),
	}
  
	GM.Config.SSCarSpawns = {
		{ Vector( 4820.639648, 4799.150879, -0.245996 ), Angle( 0, 180, 0 ) },

	}
end

--[[ City Worker Service Config ]]--DONE
if SERVER then
	GM.Config.CityWorkerParkingZone = GM.Config.TowParkingZone
	GM.Config.CityWorkerCarSpawns = GM.Config.TowCarSpawns

	GM.Config.CityWorkerDebrisSpawns = {
		Vector(10740.896484375, 7275.6694335938, 0.03125),
		Vector(11260.87890625, 4699.232421875, 0.03125),
		Vector(14164.107421875, 2710.2807617188, 0),
		Vector(13705.8828125, 682.61901855469, 0.03125),
		Vector(11876.919921875, -4549.7236328125, 0.031234741210938),
		Vector(12143.936523438, -5813.7265625, 0.03125),
		Vector(13684.490234375, -10879.133789063, 0.03131103515625),
		Vector(9389.634765625, -11081.978515625, 6.103515625),
		Vector(7505.4409179688, -7349.4013671875, -6.103515625),
		Vector(5674.7163085938, -1651.5516357422, -3.0517578125),
		Vector(-142.36608886719, 4566.2109375, 0),
		Vector(1578.2583007813, 6051.9521484375, 0.03131103515625),
		Vector(3299.0974121094, 5563.0346679688, 0.031219482421875),
		Vector(6701.7524414063, 8590.3671875, 6.103515625),
		Vector(13894.896484375, 10029.571289063, 0),
		Vector(14220.151367188, 13463.96875, 0.03125),
		Vector(8467.162109375, 15289.900390625, 0.03118896484375),
		Vector(8277.2724609375, 13540.717773438, 0.03125),
		Vector(9598.689453125, 11701.872070313, 3.0517578125),
	}
end

--[[ Mafia Config ]]--DONE
if SERVER then
	GM.Config.MafiaParkingZone = {
		Min = Vector( 12863.940429688, 9470.08203125, -10.03125 ),
		Max = Vector( 13063.59375, 9737.244140625, 308.51428222656 ),
	}

	GM.Config.MafiaCarSpawns = {
		{ Vector( 12962.737305, 9602.936523, -3.140152 ), Angle( 0, -90, 0 ) },

	}
end