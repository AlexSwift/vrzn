--[[
	Name: armouredcars.lua
	For: UnrealRP
	By: Harry
]]--

local Car = {}
Car.Make = "Armoured Cars"
Car.Name = "armoured insurgent"
Car.UID = "insurgent"
Car.Desc = "A drivable armoured insurgent"
Car.Model = "models/tokicars/insurgent_toki.mdl"
Car.Script = "scripts/vehicles/TDMCars/rs4avant.txt"
Car.Price = 2400000
Car.FuellTank = 80
Car.FuelConsumption = 220
GM.Cars:Register( Car )