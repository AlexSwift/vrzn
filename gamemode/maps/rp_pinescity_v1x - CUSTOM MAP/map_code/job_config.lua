--[[
	Name: job_config.lua
	
		
]]--

--[[ EMS Config ]]--
GM.Config.EMSHospitalZone = {
	Min = Vector( -5774.72265625, 1682.96875, 86.105407714844 ),
	Max = Vector( -4602.3911132813, 3568.5668945313, 1100.96875 ),

       }

if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector( -5774.72265625, 1682.96875, 86.105407714844 ),
		Max = Vector( -4602.3911132813, 3568.5668945313, 1100.96875 ),
	}

	GM.Config.EMSCarSpawns = {
		{ Vector( -5496.843750, 3478.781250, 90.187500 ), Angle( 1, -90, 0.000000 ) },
		{ Vector( -5505.468750, 3273.406250, 90.187500 ), Angle( 1.417558, -90, 0.000000 ) },
	}
end

--[[ Fire Config ]]--
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector( -3890.5390625, -87.26237487793, 86.03125 ),
		Max = Vector( -2975.03125, 591.78979492188, 375.74685668945 ),

	}

	GM.Config.FireCarSpawns = {
		{ Vector( -3164.187988, 194.891769, 160.031250 ), Angle( 0.757559, 0.692673, 0.000000 ) },
		{ Vector( -3345.231201, 202.185608, 160.031250 ), Angle( 0.757559, 0.692673, 0.000000 ) },
		{ Vector( -3540.724609, 210.061691, 160.031250 ), Angle( 0.757559, 0.692673, 0.000000 ) },
		{ Vector( -3736.709473, 217.957443, 160.031250 ), Angle( 0.757559, 0.692673, 0.000000 ) },
	}
end

--[[ Cop Config ]]--
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector( -7183.3276367188, 11694.020507813, 86.03125 ),
		Max = Vector( -5785.3251953125, 12713.03125, 395.89007568359 ),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( -7026.749512, 11920.310547, 160.031250 ), Angle( 1, -56, 0 ) },
		{ Vector( -6993.887207, 12123.918945, 160.031250 ), Angle( 1, -56, 0 ) },
	}
end

--[[ Tow Config ]]--
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector( -11993.91796875, -3113.7600097656, 86.000007629395 ),
		Max = Vector( -9658.88671875, -1811.7850341797, 1100.96875 ),
	}
	
	GM.Config.TowParkingZone = {
		Min = Vector( -12122.524414063, -1846.91796875, 88.03125 ),
		Max = Vector( -11357.984375, -887.03125, 395.43322753906 ),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( -11850.442383, -1187.704956, 160.031250 ), Angle( 1.153646, -91.221207, 0.000000) },
	}
end

--[[ Taxi Config ]]--
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector( -5667.7060546875, 8671.376953125, -77.96875 ),
		Max = Vector( -4932.3178710938, 9190.4970703125, 77.96875 ),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( -5101.031250, 8985.437500, -71.656250 ), Angle( 0, 175, 0 ) },
	}
end

--[[ Sales Config ]]--
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector( -7774.3012695313, 7415.1899414063, 78.03125 ),
		Max = Vector( -7318.2646484375, 8528.208984375, 1295.96875 ),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( -7694.156250, 7993.531250, 92.625000 ), Angle( 0, -180.221207, 0.000000 ) },
	}
end

--[[ Mail Config ]]--
if SERVER then
	GM.Config.MailParkingZone = {
		Min = Vector( -12122.524414063, -1846.91796875, 88.03125 ),
		Max = Vector( -11357.984375, -887.03125, 395.43322753906 ),
	}

	GM.Config.MailCarSpawns = {
		{ Vector( -11531.224609, -1264.819092, 160.031250 ), Angle( 2.143646, -87.525063, 0.000000 ) },
		
	}
end

GM.Config.MailDepotPos = Vector( -11531.224609, -1264.819092, 160.031250 )
GM.Config.MailPoints = {
	--Subs
	{ Pos = Vector( 9863, 10080, 80 ), Name = "Subs Large 1", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 9863, 11261, 80 ), Name = "Subs Large 2", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 9863, 12536, 80 ), Name = "Subs Large 3", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 8773, 10886, 80 ), Name = "Subs 4", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( 8029, 11542, 80 ), Name = "Subs 3", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( 6723, 10880, 80 ), Name = "Subs 2", MinPrice = 40, MaxPrice = 150 },
	{ Pos = Vector( 5997, 11538, 80 ), Name = "Subs 1", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( 4139, 9404, 80 ), Name = "Freddy's Bakery Subs", MinPrice = 50, MaxPrice = 250 },
	{ Pos = Vector( 4480, 12724, 80 ), Name = "Clothing Store Subs", MinPrice = 50, MaxPrice = 250 },

	{ Pos = Vector( 516, 9456, 126 ), Name = "Church", MinPrice = 100, MaxPrice = 150 },
	{ Pos = Vector( -8595, 10900, 292 ), Name = "Police Station", MinPrice = 100, MaxPrice = 200 },
	{ Pos = Vector( -11365, 5960, 192 ), Name = "Hungriges Srhmein Restaurant", MinPrice = 100, MaxPrice = 10 },
	{ Pos = Vector( -7473, 5068, 288 ), Name = "Mad Joe's Coffee", MinPrice = 10, MaxPrice = 50 },
	{ Pos = Vector( -5415, 5238, 292 ), Name = "Bank", MinPrice = 200, MaxPrice = 300 },
	{ Pos = Vector( -6315, 5165, 288 ), Name = "Fish Store", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( -6160, 3985, 292 ), Name = "Safety First", MinPrice = 50, MaxPrice = 150 },
	{ Pos = Vector( -9468, 3298, 296 ), Name = "Sky Scraper", MinPrice = 50, MaxPrice = 150 },
	{ Pos = Vector( -8848, -10716, 292 ), Name = "Car Dealer", MinPrice = 100, MaxPrice = 250 },
       }

--[[ Bus Config ]]--
if SERVER then
	GM.Config.BusParkingZone = GM.Config.MailParkingZone
	GM.Config.BusCarSpawns = GM.Config.MailCarSpawns
end