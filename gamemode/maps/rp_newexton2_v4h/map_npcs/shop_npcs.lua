--[[
	Name: shop_npcs.lua
	For: SantosRP
	By: DFG SantosRP
]]--
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( -6595, -5422.80, 1080.03 ) },
	angs = { Angle( 0, -89, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( -6911.16, 2099.90, 1088.03 ) },
	angs = { Angle( 0, 90, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( -9870.25, 3984.48, 1025.23 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( 4081.90, 6077.73, 1088.03 ) },
	angs = { Angle( 0, 145, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -6498.17, -8684.37, -447.97 ) },
	angs = { Angle( 0, -179, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -14646.812500, 2689.875000, -13551.968750 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( -7919.97, 3513.03, 1360.03 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( -6913.10, 3776.25, 1360.03 ) },
	angs = { Angle( 0, 90, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( -7679.91, 4667.54, 1088.03 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( -6025.70, 2867.18, 1360.03	) },
	angs = { Angle( 0, -180, 0 ) },
}
local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( -6938.48, 2544.00, 1360.03 ) },
	angs = { Angle( 0, 90, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( -6285.58, 4804.52, 1088.03 ) },
	angs = { Angle( 0, 90, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( -5810.42, -9467.27, -447.97 ) },
	angs = { Angle( 0, -90, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "vape_clerk",
	pos = { Vector( 1612.375000, 6191.781250, -13377.968750 ) },
	angs = { Angle( 0, -90, 0 ) },
}