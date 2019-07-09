-- local Item = {}
-- Item.Name = " nome da munição "
-- Item.F4 = true
-- Item.Cat = "ammo"
-- Item.Desc = "Munição para armas calibre xx" -- xx = calibre da munição.
-- Item.Type = "type_ammo"
-- Item.Model = "models/props_c17/FurnitureCouch001a.mdl" -- Modelo da munição, você pode usar um modelo só pra todas se quiser.
-- Item.Weight = 0.5 -- Peso da muniçao, não sei se devia passar de meio kg não, só se for uma bala da grossura de uma pica
-- Item.Volume = 0
-- Item.HealthOverride = 3000
-- Item.CanDrop = true
-- Item.DropClass = "classe da munição " -- Cola aqui a classe da munição (pega no ctrl+c) 
-- GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição de calibre.32 S&W"
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .32 ACP"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxSRounds.mdl"
Item.Weight = 0.3
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "doi_atow_ammo_32acp"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição de calibre .12 "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .12"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxBuckshot.mdl"
Item.Weight = 0.4
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_12gauge"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição calibre .556x45mm "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .556x45mm"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 0.4
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_556x45"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição de calibre .45 ACP "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .45 ACP"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxSRounds.mdl"
Item.Weight = 0.4
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_45acp"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = " Munição de calibre .338 lapua "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .338"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdll"
Item.Weight = 0.5
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_338lapua"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição calibre .50 AE "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .50"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxSRounds.mdl"
Item.Weight = 0.4
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_50ae"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição calibre .380 "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre .380"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxSRounds.mdl"
Item.Weight = 0.3
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "doi_atow_ammo_380mkiiz" 
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição calibre 7.92x57 "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre 7.92x57"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 0.5
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "doi_atow_ammo_792x57"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição calibre 9x19mm"
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre 9x19mm"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxSRounds.mdl"
Item.Weight = 0.2
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_9x19"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Munição de calibre 7.62x51mm "
Item.F4 = true
Item.Cat = "ammo"
Item.Value = 666
Item.Desc = "Munição para armas calibre 7.62x51mm"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 0.4 
Item.Volume = 0
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "cw_ammo_762x51"
GM.Inv:RegisterItem( Item )
