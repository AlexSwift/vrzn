--[[
	Name: peugeot.lua
	For: UnrealRP
	By: Harry
]]--

local Car = {}
Car.VIP = false
Car.Make = "Peugeot"
Car.Name = "Peugeot 508 GT 2019"
Car.UID = "peugeot508gt"
Car.Desc = "The Peugeot, gmod-able by TDM"
Car.Model = "models/azok30/peugeot_508_gt_2019.mdl"
Car.Script = "scripts/vehicles/azok30/peugeot_508_gt_2019.txt"
Car.Price = 45000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )