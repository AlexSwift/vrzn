--[[
	Name: weapons_police.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


local Item = {}
Item.Name = "Police Issue M4A1"
Item.Desc = "An M4A1 rifle."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_rif_m4a1.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "police issue M4A1"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_m4a1"
Item.DropClass = "fas2_m4a1"
Item.PacOutfit = "m4_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue P226"
Item.Desc = "A P226 pistol."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pist_p228.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "police issue P226"
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "fas2_p226"
Item.DropClass = "fas2_p226"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue Glock-20"
Item.Desc = "A Glock-20 pistol."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pist_glock18.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "police issue Glock-20"
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "fas2_glock20"
Item.DropClass = "fas2_glock20"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )




local Item = {}
Item.Name = "Police Issue M3 Super 90"
Item.Desc = "An M3 Super 90 shotgun."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_shot_m3super90.mdl"
Item.Weight = 14
Item.Volume = 11
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "police issue M3 Super 90"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_m3s90"
Item.DropClass = "fas2_m3s90"
Item.PacOutfit = "m3_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


