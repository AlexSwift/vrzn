--[[
	Name: shop_npcs.lua
	For: Project UnrealRP
	By: AndrewTech
]]--

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( 6087.968750, 13164.911133, 72.031250 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( 11350.117188, 1952.033936, -191.968750 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( 9801.306640625, 4537.0815429688, 8.03125 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( 15686.42, 13740.03, 80.03 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -8348.89, -9556.03, 76.03 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( 9068.85, 10128.01, 72.03 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( 12080.76, 9864.03, 72.03 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( 8709.75, 9945.00, 72.00 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( 12235.313476563, 4809.32421875, 8.03125	) },
	angs = { Angle( 0, -90, 0 ) },
}

local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
randPos[1].z = randPos[1].z + -13952
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( 12157.779296875, 4807.3115234375, 8.03125 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( 15088.513672, 9865.111328, 72.031250 ) },
	angs = { Angle( 0, 90, 0 ) },
}
