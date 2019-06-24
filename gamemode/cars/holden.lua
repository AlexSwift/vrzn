--[[
	Name: holden.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


local Car = {}
Car.VIP = true
Car.Make = "Holden"
Car.Name = "Holden GTS"
Car.UID = "holden_gts"
Car.Desc = "The Holden, gmod-able by TDM"
Car.Model = "models/tdmcars/hsvgts.mdl"
Car.Script = "scripts/vehicles/TDMCars/hsvgts.txt"
Car.Price = 45000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Holden"
Car.Name = "Holden HSV W427"
Car.UID = "holden_hsv"
Car.Desc = "The Holden, gmod-able by TDM"
Car.Model = "models/tdmcars/hsvw427.mdl"
Car.Script = "scripts/vehicles/TDMCars/hsvw427.txt"
Car.Price = 93000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )