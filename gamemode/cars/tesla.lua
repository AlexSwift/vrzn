--[[
	Name: tesla.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Tesla"
Car.Name = "Tesla Model S P90D"
Car.UID = "tesla_model"
Car.Desc = "A drivable Tesla Model S by TheDanishMaster"
Car.Model = "models/tdmcars/tesla_models.mdl"
Car.Script = "scripts/vehicles/sentry/models.txt"
Car.Price = 71000
Car.FuellTank = 80000
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )


local Car = {}
Car.VIP = true
Car.Make = "Tesla"
Car.Name = "Tesla Model X P100D"
Car.UID = "tesla_modelx"
Car.Desc = "A drivable Tesla Model S by TheDanishMaster"
Car.Model = "models/crsk_autos/tesla/model_x_2015.mdl"
Car.Script = "scripts/vehicles/crsk_autos/crsk_tesla_model_x_2015.txt"
Car.Price = 142500
Car.FuellTank = 80000
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Tesla"
Car.Name = "Tesla Roadster"
Car.UID = "tesla_roadster"
Car.Desc = "A drivable Tesla Model S by TheDanishMaster"
Car.Model = "models/sentry/roadsters.mdl"
Car.Script = "scripts/vehicles/TDMCars/teslamodels.txt"
Car.Price = 60000
Car.FuellTank = 80000
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )