--[[
    Name: vapes.lua
    For: Cosmic Gaming
    By: Cheese
]]--


local Item = {}
Item.Name = "Vape Americano"
Item.Desc = "Um vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_american"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_american"


GM.Inv:RegisterItem( Item )



local Item = {}
Item.Name = "Vape Customizavel"
Item.Desc = "Um Vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_custom"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_custom"

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Vape Alucinógeno"
Item.Desc = "Um Vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_hallucinogenic"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_hallucinogenic"

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Vape de Fruta"
Item.Desc = "Um Vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_juicy"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_juicy"

GM.Inv:RegisterItem( Item )