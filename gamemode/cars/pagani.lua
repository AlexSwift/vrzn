--[[
	Name: jaguar.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


local Car = {}
Car.VIP = true
Car.Make = "Pagani"
Car.Name = "Pagani Zonda C12"
Car.UID = "pagani_zonda"
Car.Desc = "The Pagani Zonda C12, gmod-able by TDM"
Car.Model = "models/tdmcars/zondac12.mdl"
Car.Script = "scripts/vehicles/TDMCars/c12.txt"
Car.Price = 990000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )