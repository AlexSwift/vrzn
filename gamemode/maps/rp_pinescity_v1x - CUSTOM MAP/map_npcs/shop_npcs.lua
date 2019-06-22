--[[
	Name: shop_npcs.lua
	
		
]]--

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( -2223.977051, 3867.359375, 160.031250 ) },
	angs = { Angle( 1, -89, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( -3124.031250, 11536.395508, -335.656250 ) },
	angs = { Angle( 0, 179, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( -9973.208984, 11194.004883, 111.031250 ) },
	angs = { Angle( 2, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -9075.205078, 11342.031250, 145.370163 ) },
	angs = { Angle( 1, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( 6225.968750, -7306.835449, 145.370163 ) },
	angs = { Angle( 1, -1, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( -5246.406250, 11306.812500, 111.031250 ) },
	angs = { Angle( 1, -179, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( -6205.937500, 11308.437500, 96.031250 ) },
	angs = { Angle( 1, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( -6780.698730, 11343.861328, 145.370163 ) },
	angs = { Angle( 2, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( -8091.875000, 12557.656250, 819.031250 ) },
	angs = { Angle( 1, -179, 0 ) },
}

local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( -5209.968750, 11306.781250, 96.031250 ) },
	angs = { Angle( 1, -179, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( 6661.968750, -7343.949707, 147 ) },
	angs = { Angle( 2, 178, 0 ) },
}