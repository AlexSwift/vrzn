--[[
	Name: jaguar.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.VIP = true
Car.Make = "Jaguar"
Car.Name = "Jaguar F-Type"
Car.UID = "jaguar_f_type"
Car.Desc = "The Jaguar F-Type V12, gmod-able by TDM"
Car.Model = "models/tdmcars/jag_ftype.mdl"
Car.Script = "scripts/vehicles/TDMCars/jag_ftype.txt"
Car.Price = 142000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = false
Car.Make = "Jaguar"
Car.Name = "Jaguar F-Pace"
Car.UID = "jaguar_f5_pace"
Car.Desc = "The Jaguar F-Type, gmod-able by TDM"
Car.Model = "models/crsk_autos/jaguar/fpace_2016.mdl"
Car.Script = "scripts/vehicles/crsk_autos/crsk_jaguar_fpace_2016.txt"
Car.Price = 38500
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = false
Car.Make = "Jaguar"
Car.Name = "Jaguar XE-Pace"
Car.UID = "jaguar_XE"
Car.Desc = "The Jaguar F-Type, gmod-able by TDM"
Car.Model = "models/dk_cars/jaguar/xe/jag_xe.mdl"
Car.Script = "scripts/vehicles/dkcars/dk_jxe.txt"
Car.Price = 67500
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = false
Car.Make = "Jaguar"
Car.Name = "Jaguar XKR-S"
Car.UID = "JaguarXKR"
Car.Desc = "The Jaguar F-Type, gmod-able by TDM"
Car.Model = "models/spedcars/xkr.mdl"
Car.Script = "scripts/vehicles/spedcars/xkr.txt"
Car.Price = 113000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )