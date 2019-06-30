--[[
	Name: sh_config.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


    DEV_SERVER= false

    GM.Config = {}
    GM.Config.GAMEMODE_PATH  = "vrzn/gamemode/"
    GM.Config.DeathWaitTime  = 1 *10 --Time to wait for insta-death countdown

--[[ ConVars ]]--
if CLIENT then
    GM.Config.HasDataCap     = CreateClientConVar( "srp_datacap_mode", "0", true, false )
    GM.Config.LightSensitiveMode            = CreateClientConVar( "srp_lightsensitive_mode", "0", true, false )
end
--[[ User Group Settings ]]--
local function GlowColour() return HSVToColor( CurTime() % 6 * 60, 1, 1 ) end
local function epip() return HSVToColor( CurTime() % 6 * 80, 0, 1 )  end
    GM.Config.tblZones2 = {
    -- { Name           = "", Min = Vector(), Max = Vector(), Safe = false },
	{ 
    Name = "Estacionamento Público",
    Min  = Vector( -2348.701416, -4603.702637, -205 ),
    Max  = Vector(-1630.166382, -5834.920898, 370 ),
    Safe = false
	},
    { 
    Name = "Cassino",
    Min  = Vector( -3642.798584, -7167.158203, -205 ),
    Max  = Vector( -5704.512207, -8380.028320, 370 ),
    Safe = true
		},
    { 
    Name = "Zona Sul",
    Min  = Vector( 1094.265503, -7379.178223, -205),
    Max  = Vector(3783.506836, -4330.623047 ,370),
    Safe = false
	},
    { 
    Name = "Banco do Brasil",
    Min  = Vector( -2943.794678, -2435.335205, -205 ),
    Max  = Vector( -4522.928711, -818.316345, 370 ),
    Safe = false
		},
	{ 
    Name = "Praia",
    Min  = Vector( 2037.370605, -402.734314, -400 ),
    Max  = Vector(  8055.685059, -4139.222168, 370 ),
    Safe = false
	},
	{ 
    Name = "Spawn",
    Min  = Vector( 2895, 180, -205 ),
    Max  = Vector( 3658, 1391, 370 ),
    Safe = true
	},
	{ 
    Name = "Rua do Spawn",
    Min  = Vector( 3660.870117, 1977.190674, -205 ),
    Max  = Vector( 1966.033936, 1385.873413, 370),
    Safe = false
		},
	{ 
    Name = "Rua do Spawn",
    Min  = Vector( 2895, 180, -205 ),
    Max  = Vector( 1966.033936, 1385.873413, 370),
    Safe = false
		},
	{ 
    Name = "Rua do vazio",
    Min  = Vector( 6242.884766, 4671.600098, -205 ),
    Max  = Vector(1756.762085, 2502.399658, 370),
    Safe = false
		},
	{ 
    Name = "Rua do vazio",
    Min  = Vector( 3223.665283, 1983.911377, -209.235535 ),
    Max  = Vector( 4084.629883, 2502.272949, 370),
    Safe = false
		}, --p2
	{ 
    Name = "Rua do vazio",
    Min  = Vector( 3223.665283, 1983.911377, -209.235535 ),
    Max  = Vector( 1756.762085, 2502.399658, 370),
    Safe = false
		}, --p3
	{ 
    Name = "Bairro Capitalista",
    Min  = Vector( -5746.612793, -7170.313477, -205 ),
    Max  = Vector( -2350.304443, -3622.072510, 370 ),
    Safe = false
	},
    { 
    Name = "Bairro Capitalista",
    Min  = Vector( -3643.174805, -8381.653320, -205 ),
    Max  = Vector( -1579.879517, -7171.869141, 370 ),
    Safe = false
		}, -- p2
    { 
    Name = "Bairro Capitalista",
    Min  = Vector( -2353.048340, -7170.374023, -205 ),
    Max  = Vector(  1094.302734, -5820.246582, 370 ),
    Safe = false
		}, -- p3
    { 
    Name = "Bairro Capitalista",
    Min  = Vector(-709.961670, -7170.530762, -205 ),
    Max  = Vector( 1094.783386, -8387.021484, 370 ),
    Safe = false
		}, --p4
    { 
    Name = "Bairro Capitalista",
    Min  = Vector(-1628.458496, -5833.840332, -205 ),
    Max  = Vector( 1015.451294, -3176.507080, 370 ),
    Safe = false
		}, --p5
    { 
    Name = "Bairro Capitalista",
    Min  = Vector(-2348.701416, -4603.702637, -205),
    Max  = Vector(-1627, -3622.072510, 370),
    Safe = false
		}, -- p6
    { 
    Name = "Posto de Gasolina",
    Min  = Vector( -1579.919678, -8387.961914, -205 ),
    Max  = Vector( -709.135193, -7170.523926, 370),
    Safe = false
		},
    { 
    Name = "Zona Industrial",
    Min  = Vector(-5589.061035, 1057.255249, -205),
    Max  = Vector( -2182.334473, 5318.679688, 370),
    Safe = false
		},
    { 
    Name = "Vero Sítio do Aposentado Nese",
    Min  = Vector( 4090.013672, 2499.208496, -205),
    Max  = Vector( 7107.777832, 483.341003, 370 ),
    Safe = false
			},
    { 
    Name = "Centro da Cidade",
    Min  = Vector(-2945, -2810, -205),
    Max  = Vector(-1035.808716, -169.362793, 370 ),
    Safe = false
		},
    { 
    Name = "Centro da Cidade",
    Min  = Vector(-1441.762695, 971.363831, -205),
    Max  = Vector(-1035.808716, -169.362793, 370 ),
    Safe = false
		},
    { 
    Name = "Delegacia / Prefeitura",
    Min  = Vector(-1417.968750, -165.461472, -205),
    Max  = Vector(-2507, 1006, 370 ), Safe = false
		},
    { 
    Name = "Rua do Desencontro",
    Min  = Vector(1756.978149, 2502.833740, -205 ),
    Max  = Vector( -2182.334473, 5318.679688, 370 ),
    Safe = false
			},
    { 
    Name = "Rua Gole de Skol",
    Min  = Vector(-1013.800293, 2252.774902, -205 ),
    Max  = Vector( 1964.741699, 180.094254, 370 ),
    Safe = false
		},
    { 
    Name = "Rua do Trabalhador",
    Min  = Vector(2037.370605, -402.734314, -400 ),
    Max  = Vector( -1034.700317, -2811.300781, 370 ),
    Safe = false
			},
    { 
    Name = "Culto do Lobo",
    Min  = Vector(2143.866455, -1919.952881, -727.949585 ),
    Max  = Vector(  41.741394, -3208.399902, -624.643799 ),
    Safe = false
			},
    { 
    Name = "Área de Eventos",
    Min  = Vector(8202.799805, 8197.596680,	 12185.641602 ),
    Max  = Vector( -8191.802246, -8193.515625, 14427.484375 ),
    Safe = false
		},
    { 
    Name = "Subterrâneo",
    Min  = Vector( 6252, 4651, -303 ),
    Max  = Vector( -627,-1912, -751 ),
    Safe = false },

}

    GM.Config.tblItemRarity  = {
    ["Normal"]= Color( 66, 66, 66 ),
    ["Raro"]  = Color( 69, 204, 249 ),
    ["Épico"] = Color( 183, 96, 226 ),
    ["Lendário"]             = Color( 238, 176, 0 ),
    ["Limitado"]             = Color( 202, 50, 57 ),
}

    GM.Config.UserGroupConfig= {
    ["founder"] = {
    Name          = "Founder",
    Color         = GlowColour,
    Rainbow       = true
    },
    ["owner"] = { 
    Name          = "Owner",
    Color         = GlowColour,
    Rainbow       = true
    },
    ["developer"] = {
    Name          = "Developer",
    Color         = GlowColour,
    Rainbow       = true
    },
}

    GM.Config.VIPGroups      = {

}

GM.Config.VIP2Groups      = {

}

GM.Config.VIP3Groups      = {
    ["founder"]              = true,
    ["developer"]            = true,
    ["superadmin"]           = false,
}

--[[ Item Limits ]]--
    GM.Config.MaxItemLimit   = 64
    GM.Config.GroupExtraMaxItems            = {
    ["founder"]              = 640,
    ["superadmin"]           = 640,
    ["headofstaff"]          = 640,
    ["developer"]            = 640,
    ["communitymanager"]     = 640,
    ["servermanager"]        = 640,
    ["headadmin"]            = 44,
    ["seinoradmin"]          = 44,
    ["admin"] = 44,
    ["moderator"]            = 34,
    ["trialmod"]             = 34,
    ["support"]              = 34,
    ["vip"]   = 24,
}

--[[ Character Settings ]]--
    GM.Config.MaxCharacters  = DEV_SERVER and 3 or 3
    GM.Config.NameLength     = { First = 15, Last = 15 }
    GM.Config.StartingMoney  = { Wallet = 25000, Bank = 35000 }
    GM.Config.MaxCarryWeight = 600
    GM.Config.MaxCarryVolume = 1000

--Player models allowed in character creation
    GM.Config.PlayerModels   = {
    Female    = {
    ["models/humans/modern/female_01.mdl"]  = true,
    ["models/humans/modern/female_02.mdl"]  = true,
    ["models/humans/modern/female_03.mdl"]  = true,
    ["models/humans/modern/female_04.mdl"]  = true,
    ["models/humans/modern/female_06.mdl"]  = true,
    ["models/humans/modern/female_07.mdl"]  = true,
	},
    Male      = {
    ["models/humans/modern/male_01_01.mdl"] = true,
    ["models/humans/modern/male_01_02.mdl"] = true,
    ["models/humans/modern/male_01_03.mdl"] = true,
    ["models/humans/modern/male_02_01.mdl"] = true,
    ["models/humans/modern/male_02_02.mdl"] = true,
    ["models/humans/modern/male_02_03.mdl"] = true,
    ["models/humans/modern/male_03_01.mdl"] = true,
    ["models/humans/modern/male_03_02.mdl"] = true,
    ["models/humans/modern/male_03_03.mdl"] = true,
    ["models/humans/modern/male_03_04.mdl"] = true,
    ["models/humans/modern/male_03_05.mdl"] = true,
    ["models/humans/modern/male_03_06.mdl"] = true,
    ["models/humans/modern/male_03_07.mdl"] = true,
    ["models/humans/modern/male_04_01.mdl"] = true,
    ["models/humans/modern/male_04_02.mdl"] = true,
    ["models/humans/modern/male_04_03.mdl"] = true,
    ["models/humans/modern/male_04_04.mdl"] = true,
    ["models/humans/modern/male_05_01.mdl"] = true,
    ["models/humans/modern/male_05_02.mdl"] = true,
    ["models/humans/modern/male_05_03.mdl"] = true,
    ["models/humans/modern/male_05_04.mdl"] = true,
    ["models/humans/modern/male_05_05.mdl"] = true,
    ["models/humans/modern/male_06_01.mdl"] = true,
    ["models/humans/modern/male_06_02.mdl"] = true,
    ["models/humans/modern/male_06_03.mdl"] = true,
    ["models/humans/modern/male_06_04.mdl"] = true,
    ["models/humans/modern/male_06_05.mdl"] = true,
    ["models/humans/modern/male_07_01.mdl"] = true,
    ["models/humans/modern/male_07_02.mdl"] = true,
    ["models/humans/modern/male_07_03.mdl"] = true,
    ["models/humans/modern/male_07_04.mdl"] = true,
    ["models/humans/modern/male_07_05.mdl"] = true,
    ["models/humans/modern/male_07_06.mdl"] = true,
    ["models/humans/modern/male_08_01.mdl"] = true,
    ["models/humans/modern/male_08_02.mdl"] = true,
    ["models/humans/modern/male_08_03.mdl"] = true,
    ["models/humans/modern/male_08_04.mdl"] = true,
    ["models/humans/modern/male_09_01.mdl"] = true,
    ["models/humans/modern/male_09_02.mdl"] = true,
    ["models/humans/modern/male_09_03.mdl"] = true,
    ["models/humans/modern/male_09_04.mdl"] = true,
	},
}
--List of player models a player can switch to, if the face type matches
--Used in the clothing shop
    GM.Config.PlayerModelOverloads          = {
    Male      = {
    ["male_01"]              = {
			"models/player/suits/male_01_closed_coat_tie.mdl",
			"models/player/suits/male_01_closed_tie.mdl",
			"models/player/suits/male_01_open.mdl",
			"models/player/suits/male_01_open_tie.mdl",
			"models/player/suits/male_01_open_waistcoat.mdl",
			"models/player/suits/male_01_shirt.mdl",
			"models/player/suits/male_01_shirt_tie.mdl",
		},
    ["male_02"]              = {
			"models/player/suits/male_02_closed_coat_tie.mdl",
			"models/player/suits/male_02_closed_tie.mdl",
			"models/player/suits/male_02_open.mdl",
			"models/player/suits/male_02_open_tie.mdl",
			"models/player/suits/male_02_open_waistcoat.mdl",
			"models/player/suits/male_02_shirt.mdl",
			"models/player/suits/male_02_shirt_tie.mdl",
		},
    ["male_03"]              = {
			"models/player/suits/male_03_closed_coat_tie.mdl",
			"models/player/suits/male_03_closed_tie.mdl",
			"models/player/suits/male_03_open.mdl",
			"models/player/suits/male_03_open_tie.mdl",
			"models/player/suits/male_03_open_waistcoat.mdl",
			"models/player/suits/male_03_shirt.mdl",
			"models/player/suits/male_03_shirt_tie.mdl",
		},
    ["male_04"]              = {
			"models/player/suits/male_04_closed_coat_tie.mdl",
			"models/player/suits/male_04_closed_tie.mdl",
			"models/player/suits/male_04_open.mdl",
			"models/player/suits/male_04_open_tie.mdl",
			"models/player/suits/male_04_open_waistcoat.mdl",
			"models/player/suits/male_04_shirt.mdl",
			"models/player/suits/male_04_shirt_tie.mdl",
		},
    ["male_05"]              = {
			"models/player/suits/male_05_closed_coat_tie.mdl",
			"models/player/suits/male_05_closed_tie.mdl",
			"models/player/suits/male_05_open.mdl",
			"models/player/suits/male_05_open_tie.mdl",
			"models/player/suits/male_05_open_waistcoat.mdl",
			"models/player/suits/male_05_shirt.mdl",
			"models/player/suits/male_05_shirt_tie.mdl",
		},
    ["male_06"]              = {
			"models/player/suits/male_06_closed_coat_tie.mdl",
			"models/player/suits/male_06_closed_tie.mdl",
			"models/player/suits/male_06_open.mdl",
			"models/player/suits/male_06_open_tie.mdl",
			"models/player/suits/male_06_open_waistcoat.mdl",
			"models/player/suits/male_06_shirt.mdl",
			"models/player/suits/male_06_shirt_tie.mdl",
		},
    ["male_07"]              = {
			"models/player/suits/male_07_closed_coat_tie.mdl",
			"models/player/suits/male_07_closed_tie.mdl",
			"models/player/suits/male_07_open.mdl",
			"models/player/suits/male_07_open_tie.mdl",
			"models/player/suits/male_07_open_waistcoat.mdl",
			"models/player/suits/male_07_shirt.mdl",
			"models/player/suits/male_07_shirt_tie.mdl",
		},
    ["male_08"]              = {
			"models/player/suits/male_08_closed_coat_tie.mdl",
			"models/player/suits/male_08_closed_tie.mdl",
			"models/player/suits/male_08_open.mdl",
			"models/player/suits/male_08_open_tie.mdl",
			"models/player/suits/male_08_open_waistcoat.mdl",
			"models/player/suits/male_08_shirt.mdl",
			"models/player/suits/male_08_shirt_tie.mdl",
		},
    ["male_09"]              = {
			"models/player/suits/male_09_closed_coat_tie.mdl",
			"models/player/suits/male_09_closed_tie.mdl",
			"models/player/suits/male_09_open.mdl",
			"models/player/suits/male_09_open_tie.mdl",
			"models/player/suits/male_09_open_waistcoat.mdl",
			"models/player/suits/male_09_shirt.mdl",
			"models/player/suits/male_09_shirt_tie.mdl",
		},
	},
    Female    = {},
}

--Skin indexes to block in character creation / clothing store
    GM.Config.BlockedModelSkins             = {
    ["models/humans/modern/female_01.mdl"]  = { 6, 21 },
    ["models/humans/modern/female_02.mdl"]  = { 6, 21 },
    ["models/humans/modern/female_03.mdl"]  = { 6, 21 },
    ["models/humans/modern/female_04.mdl"]  = { 6, 21 },
    ["models/humans/modern/female_06.mdl"]  = { 6, 21 },
    ["models/humans/modern/female_07.mdl"]  = { 6, 21 },

    ["models/humans/modern/male_01_01.mdl"] = { 1 },
    ["models/humans/modern/male_01_02.mdl"] = { 1 },
    ["models/humans/modern/male_01_03.mdl"] = { 1 },
    ["models/humans/modern/male_02_01.mdl"] = { 1 },
    ["models/humans/modern/male_02_02.mdl"] = { 1 },
    ["models/humans/modern/male_02_03.mdl"] = { 1 },
    ["models/humans/modern/male_03_01.mdl"] = { 1 },
    ["models/humans/modern/male_03_02.mdl"] = { 1 },
    ["models/humans/modern/male_03_03.mdl"] = { 1 },
    ["models/humans/modern/male_03_04.mdl"] = { 1 },
    ["models/humans/modern/male_03_05.mdl"] = { 1 },
    ["models/humans/modern/male_03_06.mdl"] = { 1 },
    ["models/humans/modern/male_03_07.mdl"] = { 1 },
    ["models/humans/modern/male_04_01.mdl"] = { 1 },
    ["models/humans/modern/male_04_02.mdl"] = { 1 },
    ["models/humans/modern/male_04_03.mdl"] = { 1 },
    ["models/humans/modern/male_04_04.mdl"] = { 1 },
    ["models/humans/modern/male_05_01.mdl"] = { 1 },
    ["models/humans/modern/male_05_02.mdl"] = { 1 },
    ["models/humans/modern/male_06_01.mdl"] = { 1 },
    ["models/humans/modern/male_06_02.mdl"] = { 1 },
    ["models/humans/modern/male_06_03.mdl"] = { 1 },
    ["models/humans/modern/male_06_04.mdl"] = { 1 },
    ["models/humans/modern/male_06_05.mdl"] = { 1 },
    ["models/humans/modern/male_07_01.mdl"] = { 1 },
    ["models/humans/modern/male_07_02.mdl"] = { 1 },
    ["models/humans/modern/male_07_03.mdl"] = { 1 },
    ["models/humans/modern/male_07_04.mdl"] = { 1 },
    ["models/humans/modern/male_07_05.mdl"] = { 1 },
    ["models/humans/modern/male_07_06.mdl"] = { 1 },
    ["models/humans/modern/male_08_01.mdl"] = { 1 },
    ["models/humans/modern/male_08_02.mdl"] = { 1 },
    ["models/humans/modern/male_08_03.mdl"] = { 1 },
    ["models/humans/modern/male_08_04.mdl"] = { 1 },
    ["models/humans/modern/male_09_01.mdl"] = { 1 },
    ["models/humans/modern/male_09_02.mdl"] = { 1 },
    ["models/humans/modern/male_09_03.mdl"] = { 1 },
    ["models/humans/modern/male_09_04.mdl"] = { 1 },
}

--[[ Car Settings ]]--
--Stock colors a player may pick from when buying a new car
    GM.Config.StockCarColors = {
    ["White"] = Color( 255, 255, 255, 255 ),
    ["Silver"]= Color( 182, 182, 182, 255 ),
    ["Black"] = Color( 36, 36, 36, 255 ),
    ["Red"]   = Color( 255, 0, 0, 255 ),
    ["Blue"]  = Color( 0, 63, 255, 255 ),
    ["Green"] = Color( 0, 127, 31, 255 ),
    ["Yellow"]= Color( 255, 250, 0, 255 ),
}
    GM.Config.LPlateCost     = 2000 --Cost to buy custom license plates
    GM.Config.BaseFuelCost   = 3 --Cost per unit of fuel for the gas pumps
    GM.Config.MaxCarHealth   = 100
    GM.Config.CarInsuranceTaxInterval       = 60 *60 *12 --Time in seconds of continuous play time to wait before billing a player for the cars they own
    GM.Config.CarInsuranceBillTime          = 86400 *7 --Time in seconds a car insurance bill should last for before default
    GM.Config.CarInsuranceBillScale         = 0.100 --How much to scale the full repair cost +tax of a vehicle by for setting the price of a car insurance bill

--NOTES FOR JAIL/LICENSE/TICKET SETTINGS
--Keep string lengths and history counts small, or it could end up saving a large amount of data
--IF the data exceeds ~63kb the net messages for the police computer will start to FAIL!
--Saving a large amount of data may also cause a small amount of lag during the save

--[[ Jail Settings ]]--
    GM.Config.MinJailTime    = 300 --Min time a player can be jailed for in seconds
    GM.Config.MaxJailTime    = 3600 --Max time a player can be jailed for in seconds
    GM.Config.MaxJailReasonLen              = 64 --Max string length for jail reason
    GM.Config.MaxJailFreeReasonLen          = 64 --Max string length for early release reason
    GM.Config.MaxArrestHistory              = 10 --Max number of past arrests to keep track of
    GM.Config.MaxWarrantReasonLength        = 64 --Max string length for warrant reason

--[[ License/Ticket Settings ]]--
    GM.Config.MaxTicketReasonLength         = 64 --Max string length for a ticket reason
    GM.Config.MinTicketPrice = 10 --Min price a player may set for a ticket
    GM.Config.MaxTicketPrice = 2500 --Max price a player may set for a ticket
    GM.Config.MaxOutstandingTickets         = 10 --Max number of unpaid tickets a player can have, if at max a cop may not write any more tickets for that player
    GM.Config.MaxTicketHistory              = 10 --Max number of paid tickets to keep track of
    GM.Config.MaxLicenseDotHistory          = 10 --Max number of past license dots to keep track of
    GM.Config.MaxLicenseDotReasonLength     = 64 --Max string length for a license dot reason
    GM.Config.MinLicenseRevokeTime          = 1 *60 --Min time a player may revoke another player's license for in seconds
    GM.Config.MaxLicenseRevokeTime          = 48 *60 *60 --Max time a player may revoke another player's license for in seconds

--[[ Dispatch Settings ]]--
    GM.Config.Text911CoolDown= 30

--[[ Job Lockers ]]--
    GM.Config.JobLockerItems = {
    [2]       = { --Police locker
    ["Night Stick"]          = 1,
    ["Radar Gun"]            = 1,
    ["Spike Strip"]          = 1,
    ["Battering Ram"]        = 1,
    ["Taser"] = 1,
    ["Police Shield"]        = 1,
    ["Police Badge"]         = 1,
    ["Police Issue Glock-20 Undercover"]    = 1,
    ["Police Radio"]         = 1,

    ["Police Issue M4A1"]    = 1,
    ["Police Issue MP5A5"]   = 1,
    ["Police Issue M24"]     = 1,
    ["Police Issue M3 Super 90"]            = 1,
    ["Police Issue Glock-20"]= 1,
    ["Police Issue P226"]    = 1,
    ["Police Issue Flash Grenade"]          = 2,

    ["Police Issue 5.56x45MM 60 Rounds"]    = 2,
    ["Police Issue .357 SIG 30 Rounds"]     = 2,
    ["Police Issue 10x25MM 60 Rounds"]      = 2,
    ["Police Issue 12 Gauge 16 Rounds"]     = 2,
    ["Police Issue 7.62x51MM 40 Rounds"]    = 2,
    ["Police Issue 9x19MM 60 Rounds"]       = 2,


    ["Police Issued EoTech 553"]            = 1,
    ["Police Issued CompM4"] = 1,
    ["Police Issued Foregrip"]              = 1,
    ["Police Issued ELCAN C79"]             = 1,


    ["Police Issue Traffic Cone"]           = 10,
    ["Police Issue Traffic Board"]          = 1,
    ["Police Issue Spare Tire Kit"]         = 2,
    ["Police Issue Traffic Barrel"]         = 10,
    ["Police Issue Checkpoint"]             = 1,
    ["Police Issue Concrete Barrier"]       = 10,
    ["Police Issue Roadside Quick-Fix Kit"] = 2,
    ["Police Issue Engine Overhaul"]        = 2,
    ["Police Issue Vehicle Repair Kit"]     = 3,

	},
    [3]       = { --EMS locker
    ["Government Issue First Aid Kit"]      = 1,
    ["Government Issue Medical Supplies"]   = 32,
    ["Morphine Applicator"]  = 1,
    ["Blood Draw Syringe"]   = 1,
    ["Patient Clipboard"]    = 1,
	},
    [28]      = { -- Road Worker locker
    --["Lawn Mower"]         = 1,
	},

    [4]       = { --Fire locker

    ["FD Issue 10ft. Ladder"]= 4,
    ["FD Issue 50ft. Ladder"]= 1,
    ["FD Issue Traffic Barrel"]             = 10,
    ["FD Issue Traffic Cone"]= 10,
    ["FD Issue Concrete Barrier"]           = 10,
    ["Fire Extinguisher"]    = 1,
    ["FD Issue Medical Supplies"]           = 18,
    ["FD Issue First Aid Kit"]              = 1,
    ["Fire Axe"]             = 1,
	},


    [13]      = { --Secret service locker

    ["Goverment Issue SR-25"]= 1,
    ["Goverment Issue 7.62x51MM 40 Rounds"] = 2,
    ["Goverment Issue G36C"] = 1,
    ["Goverment Issue 5.56x45MM 60 Rounds"] = 2,
    ["Goverment Issue MP5A5"]= 1,
    ["Goverment Issue 9x19MM 60 Rounds"]    = 2,
    ["Goverment Issue Glock-20"]            = 1,
    ["Goverment Issue 10x25MM 60 Rounds"]   = 2,
    ["Government Issue Zip Tie"]            = 1,
    ["Secret Service Badge"] = 1,
    ["Government Issue Barrier"]            = 6,
    ["Government Issue Traffic Barrel"]     = 10,
    ["Goverment Issued Taser"]              = 1,
    ["Goverment Issued Earpiece"]           = 1,
    ["Goverment Issue Engine Overhaul"]     = 2,
    ["Goverment Issue Vehicle Repair Kit"]  = 3,
    ["Goverment Issue Spare Tire Kit"]      = 2,
	},

    [21]      = { --SWAT Locker
    ["Night Stick"]          = 1,
    ["Radar Gun"]            = 1,
    ["SWAT Shield"]          = 1,
    ["Spike Strip"]          = 1,
    ["Battering Ram"]        = 1,
    ["Taser"] = 1,
    ["Police Badge"]         = 1,
    ["Police Issue Glock-20 Undercover"]    = 1,

    ["Police Issue M4A1"]    = 1,
    ["Police Issue MP5A5"]   = 1,
    ["Police Issue M24"]     = 1,
    ["Police Issue M3 Super 90"]            = 1,
    ["Police Issue Glock-20"]= 1,
    ["Police Issue P226"]    = 1,
    ["SWAT Issue SR-25"]     = 1,
    ["SWAT Issue G36C"]      = 1,
    ["Police Issue Flash Grenade"]          = 2,

    ["Police Issue 5.56x45MM 60 Rounds"]    = 2,
    ["Police Issue .357 SIG 30 Rounds"]     = 2,
    ["Police Issue 10x25MM 60 Rounds"]      = 2,
    ["Police Issue 12 Gauge 16 Rounds"]     = 2,
    ["Police Issue 7.62x51MM 40 Rounds"]    = 2,
    ["Police Issue 9x19MM 60 Rounds"]       = 2,

--[[
    ["Police Issued Suppressor"]            = 1,
    ["Police Issued EoTech 553"]            = 1,
    ["Police Issued CompM4"] = 1,
    ["Police Issued Foregrip"]              = 1,
    ["Police Issued ELCAN C79"]             = 1,
--]]

    ["Police Issue Traffic Cone"]           = 10,
    ["Police Issue Traffic Board"]          = 1,
    ["Police Issue Spare Tire Kit"]         = 2,
    ["Police Issue Traffic Barrel"]         = 10,
    ["Police Issue Checkpoint"]             = 1,
    ["Police Issue Concrete Barrier"]       = 10,

    ["Police Issue Roadside Quick-Fix Kit"] = 2,
    ["Police Issue Engine Overhaul"]        = 2,
    ["Police Issue Vehicle Repair Kit"]     = 3,
	},
}

--[[ Job Player Caps ]]--
    GM.Config.Job_Taxi_PlayerCap            = {
    Min       = 2, --The smallest number of players that may become this job
    Max       = 4, --The largest number of players that may become this job
    MinStart  = 4, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_Tow_PlayerCap             = {
    Min       = 2, --The smallest number of players that may become this job
    Max       = 3, --The largest number of players that may become this job
    MinStart  = 4, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_BusDriver_PlayerCap       = {
    Min       = 1, --The smallest number of players that may become this job
    Max       = 2, --The largest number of players that may become this job
    MinStart  = 4, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_SalesTruck_PlayerCap      = {
    Min       = 1, --The smallest number of players that may become this job
    Max       = 3, --The largest number of players that may become this job
    MinStart  = 1, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 50 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_MailTruck_PlayerCap       = {
    Min       = 2, --The smallest number of players that may become this job
    Max       = 4, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_Police_PlayerCap          = {
    Min       = 6, --The smallest number of players that may become this job
    Max       = 16, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_EMS_PlayerCap             = {
    Min       = 4, --The smallest number of players that may become this job
    Max       = 7, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_Fire_PlayerCap            = {
    Min       = 4, --The smallest number of players that may become this job
    Max       = 5, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_Lawyer_PlayerCap          = {
    Min       = 4, --The smallest number of players that may become this job
    Max       = 8, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_Prosecutor_PlayerCap      = {
    Min       = 4, --The smallest number of players that may become this job
    Max       = 8, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.Job_SService_PlayerCap        = {
    Min       = 4, --The smallest number of players that may become this job
    Max       = 12, --The largest number of players that may become this job
    MinStart  = 8, --At or below this number of total players, only Min amount of players may become this job
    MaxEnd    = 60 --At or above this number of total players, the job cap will be at the Max set value
}
    GM.Config.SSApplyInterval= 2 *60

--[[ Property Settings ]]--
    GM.Config.PropertyEvictTime             = 60 *60 --Time in seconds after being billed for a property to evict the owner
    GM.Config.PropertyTaxInterval           = 60 *60 *3 --How often (in seconds) should we bill players for a property they own?
    GM.Config.PropertyTaxScale              = 0.015 --How much to scale the cost of a property + tax for setting the price of a property tax bill
    GM.Config.PropertyCats   = {
	"Stores",
	"Apartments",
	"Warehouse",
	"House",
}

--[[ Performance Settings ]]--
    GM.Config.RenderDist_Level0             = 300 --Most expensive render operations
    GM.Config.RenderDist_Level1             = 768
    GM.Config.RenderDist_Level2             = 1500

--[[ Driving Test Questions ]]--
    GM.Config.DrivingTestQuestions    = {
{ Question         	 = "What do you do when its a green light?",
    Options            = {
    ["You begin to move"]             = true,
    ["You stop"]       = true,
    ["You turn off your engine"]      = true }
													},
{ Question         	 = "What do you do if you see someone thats just crashed.",
    Options            = {
    ["Continue driving"]              = true,
    ["Call your friends"]             = true,
    ["Investigate the scene"]         = true }
},
{ Question         	 = "Someone has just crashed into you and damaged your car.",
    Options            = {
    ["Pull a weapon on him"]          = true,
    ["Exchange insurance information"]= true,
    ["Talk shit to him while ramming his car"]       = true }
},
{ Question         	 = "Your car seems to be not functioning properly, what do you do?",
    Options            = {
    ["Call the cops"]  = true,
    ["Stand on the road to get someones attention"]  = true,
    ["Phone up mechanical services"]  = true }
},
{ Question         	 = "You encounter a police road block and the officer tells you to turn around, do you",
    Options            = {
    ["Ignore the officer and continue driving"]      = true,
    ["Sit in your car and do nothing"]= true,
    ["Carefully turn around and drive"]              = true }
},
{ Question        	 = "You see a another driver driving recklessly, what do you do?",
    Options            = {
    ["Inform the police"]             = true,
    ["Drive recklessly yourself"]     = true,
    ["Message your friend"]           = true }
},
{ Question         	 = "You have just accidentally crashed into a pole and you have injured yourself, what do you do?",
    Options            = {
    ["Lie on the road and wait for someone to help"] = true,
    ["Follow someone until they help you"]           = true,
    ["Call EMS"]       = true }
},
}

--[[ NPC Healer Settings ]]--
    GM.Config.NPCHealerCost  = 250 --Cost a player must pay to be healed
    GM.Config.MinEMSToDisable= 10 --Minimum number of players with ems jobs to disable the healer npc

--[[ NPC Clothing Shop Settings ]]--
    GM.Config.ClothingPrice  = 200

--[[ Phone Settings ]]--
    GM.Config.MaxTextMsgLen  = 256

--[[ Skills ]]--
    GM.Config.Skills         = {
    ["1 Nível do Personagem"]= { MaxLevel = 100, Const = 0.25, ReductionRatio = 0.75 /25 }, --Used for crafting table
    ["Criminalidade"]        = { MaxLevel = 25, Const = 0.25 }, --Used for making meth
    ["Fabricação"]           = { MaxLevel = 5, Const = 0.25, ReductionRatio = 0.75 /25 }, --Used for assembly table
    -- ["Respeito"]          = { MaxLevel = 25, Const = 0.25 }, --Used for growing weed/coco

}

--[[ Crafting ]]--
    GM.Config.CraftingSounds = {
	Sound( "taloslife/ui_repairweapon_01.mp3" ),
	Sound( "taloslife/ui_repairweapon_02.mp3" ),
	Sound( "taloslife/ui_repairweapon_03.mp3" ),
	Sound( "taloslife/ui_repairweapon_04.mp3" ),
	Sound( "taloslife/ui_repairweapon_05.mp3" ),
	Sound( "taloslife/ui_repairweapon_06.mp3" ),
	Sound( "taloslife/ui_repairweapon_07.mp3" ),
}

--[[ Chop Shop ]]--
    GM.Config.ChopShop_CarStealDuration     = 60 *5 --Time before a player can spawn a stolen car again
    GM.Config.ChopShop_CarStealCooldown     = 60 *20 --Time before a player can chop another car
    GM.Config.ChopShop_CarChopDuration      = 60 *1 --Time to chop a car


--[[ Store Robbery ]]
    GM.Config.StoreRobbery_RobberyCooldown  = 60 * 15
    GM.Config.StoreRobbery_RobberyDuration  = 60 * 5
    GM.Config.StoreRobbery_PoliceNeeded     = 3