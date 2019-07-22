--[[
	Name: electronics.lua
	For: TalosLife
	By: TalosLife
]]--

if DEV_SERVER then
	local Item = {}
	Item.Name = "Computador de desenvolvedor"
	Item.Desc = "Item de teste do desenvolvedor."
	Item.Model = "models/testmodels/macbook_pro.mdl"
	Item.Type = "type_electronics"
	Item.Weight = 12
	Item.Volume = 14
	Item.HealthOverride = 3000
	Item.CanDrop = true
	Item.LimitID = "computer"
	Item.DropClass = "ent_computer_base"
	Item.SetupEntity = function( _, entItem )
		--stuff
	end
	GM.Inv:RegisterItem( Item )
	GM.Inv:RegisterItemLimit( Item.LimitID, 1 )
end

--[[
	Name: electronics.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "VRZN Printer"
Item.Desc = "Cuidado, essa coisa explode"
Item.Type = "type_electronics"
Item.Model = "models/eliteroleplay/moneyprinter/moneyprinter.mdl"
Item.Weight = 1
Item.Volume = 2
Item.HealthOverride = 3000
Item.CanDrop = true
Item.LimitID = "adv_moneyprinter"
Item.DropClass = "adv_moneyprinter"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Radio civ"
Item.Desc = "Radio civ"
Item.Type = "type_weapon"
Item.Model = "models/gspeak/funktronics.mdl"
Item.Weight = 1
Item.Volume = 1
Item.HealthOverride = 3000
Item.CanDrop = true
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_gspeak_radio_civ"
Item.DropClass = "weapon_gspeak_radio_civ"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Caixa registradora"
Item.Desc = "Uma caixa registradora que permite que uma pessoa gerencia sua loja com segurança."
Item.Model = "models/props_c17/cashregister01a.mdl"
Item.Type = "type_electronics"
Item.Weight = 15
Item.Volume = 20
Item.HealthOverride = 3000
Item.CanDrop = true
Item.LimitID = "cash register"
Item.DropClass = "ent_cashregister"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )


local Item = {}
Item.Name = "Radio"
Item.Desc = "Um radio portavel."
Item.Type = "type_electronics"
Item.Model = "models/props/cs_office/radio.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = true
Item.LimitID = "radio"
Item.DropClass = "whk_musicplayer"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Televisao"
Item.Desc = "Uma TV plana. Toca videos do youtube e lives do twitch.tv."
Item.Type = "type_electronics"
Item.Model = "models/props/cs_office/TV_plasma.mdl"
Item.Weight = 10
Item.Volume = 15
Item.CanDrop = true
Item.LimitID = "television"
Item.DropClass = "whk_tv"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Sinal grande"
Item.Desc = "Um grande sinal digital. Mostra o texto que um usuario programou no sinal."
Item.Type = "type_electronics"
Item.Model = "models/props/cs_office/offpaintinga.mdl"
Item.Weight = 5
Item.Volume = 12
Item.CanDrop = true
Item.LimitID = "sign"
Item.DropClass = "ent_sign_large"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 2 } )

local Item = {}
Item.Name = "Cooler"
Item.Desc = "Um cooler."
Item.Model = "models/freeman/ventfan.mdl"
Item.Type = "type_electronics"
Item.Weight = 6
Item.Volume = 14
Item.HealthOverride = 500
Item.CanDrop = true
Item.LimitID = "fan"
Item.DropClass = "ent_box_fan"

Item.CraftingEntClass = "ent_assembly_table"
Item.CraftingTab = "Machines"
Item.CraftSkill = "Nível do Personagem"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Plate"] = 1,
	["Car Battery"] = 1,
	["Wrench"] = 1,
	
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 2 } )

local Item = {}
Item.Name = "Lampada grande"
Item.Desc = "Uma lampada feita para iluminar grandes  espaços."
Item.Type = "type_electronics"
Item.Model = "models/props_c17/light_decklight01_off.mdl"
Item.Weight = 20
Item.Volume = 30
Item.HealthOverride = 500
Item.CanDrop = true
Item.LimitID = "lamp"
Item.DropClass = "ent_hid_lamp"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 2 } )

local Item = {}

Item.Name = "Computador da companhia"
Item.Desc = "Servidor de computador avançado"
Item.Model = "models/alarm_system/computer.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_computer_white"
Item.LimitID = "alarm_computer_white"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 4)

local Item = {}

Item.Name = "Alarme"
Item.Desc = "Sistema de alarme avançado"
Item.Model = "models/alarm_system/siren.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_siren"
Item.LimitID = "alarm_siren"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 8)

local Item = {}

Item.Name = "Recebedor de sensor da porta"
Item.Desc = "Sensor recebedor de porta avançado"
Item.Model = "models/alarm_system/door_sensor_2.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_door_sensor_2"
Item.LimitID = "alarm_door_sensor_2"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 8)

local Item = {}

Item.Name = "Alarme de porta"
Item.Desc = "Sensor de porta avançado"
Item.Model = "models/alarm_system/door_sensor_1.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_door_sensor"
Item.LimitID = "alarm_door_sensor"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 8)

local Item = {}

Item.Name = "Detector de Incendio"
Item.Desc = "Sistema de alarme de incendio avançado"
Item.Model = "models/alarm_system/fire_detector.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_fire_sensor"
Item.LimitID = "alarm_fire_sensor"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 4)

local Item = {}

Item.Name = "Recebedor de laser"
Item.Desc = "Sistema recebedor de laser avançado"
Item.Model = "models/alarm_system/laser_alarm.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_laser_rec"
Item.LimitID = "alarm_laser_rec"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 4)

local Item = {}

Item.Name = "Sensor de Movimento"
Item.Desc = "Ponta de tecnologia de sensores de movimento"
Item.Model = "models/alarm_system/bewegungsmelder.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_motion_sensor"
Item.LimitID = "alarm_motion_sensor"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 4)

local Item = {}

Item.Name = "Laser"
Item.Desc = "Recebedor de Laser Avançado."
Item.Model = "models/alarm_system/laser_alarm.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_laser_2"
Item.LimitID = "alarm_laser_2"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 4)

local Item = {}

Item.Name = "Painel de Controle"
Item.Desc = "Controle todos sistemas aqui."
Item.Model = "models/alarm_system/terminal.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "alarm_terminal"
Item.LimitID = "alarm_terminal"

GM.Inv:RegisterItem(Item)
GM.Inv:RegisterItemLimit(Item.LimitID, 2)