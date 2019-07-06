
local Item = {}
Item.Name = " Weldrod Mk.IIA. "
Item.Desc = " Revólver silenciado de ação unica, .32 ACP. "
Item.Type = "type_weapon" 
Item.Model = "models/khrcw2/doipack/w_welrod.mdl"
Item.Weight = 1 
Item.Volume = 0 
Item.CanDrop = true 
Item.DropClass = "doi_atow_welrod" 
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "doi_atow_welrod"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " K98K. "
Item.Desc = " Fuzil de ação de ferrolho, 7.92.57MM. "
Item.Type = "type_weapon" 
Item.Model = "models/khrcw2/doipack/w_kar98k.mdl"
Item.Weight = 7
Item.Volume = 0 
Item.CanDrop = true 
Item.DropClass = "doi_atow_k98k"
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "doi_atow_k98k"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " M1917. "
Item.Desc = " Revólver de 6 tiros, .45 ACP. "
Item.Type = "type_weapon"
Item.Model = "models/khrcw2/doipack/w_sw1917.mdl"
Item.Weight = 2
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "doi_atow_sw1917"
Item.CanEquip = true 
Item.Illegal = true
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "doi_atow_sw1917"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " HK P30L. "
Item.Desc = " Revólver semiautomático, 9x19mm. "
Item.Type = "type_weapon"
Item.Model = "models/cw2/weapons/w_p30.mdl" 
Item.Weight = 2
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "p30"
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "p30"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Webley Mk.IV. "
Item.Desc = " Revólver de 6 tiros, .380mm  "
Item.Type = "type_weapon"
Item.Model = "models/khrcw2/doipack/w_webley.mdl" 
Item.Weight = 2
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "doi_atow_webley"
Item.CanEquip = true
Item.Illegal = true 
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "doi_atow_webley"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " SPAS-12. "
Item.Desc = " espingarda de combate com 8 tiros, .12 "
Item.Type = "type_weapon"
Item.Model = "models/cw2/weapons/w_franchi_spas12.mdl"
Item.Weight = 8
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "cwc_spas12"
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cwc_spas12"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " L115. "
Item.Desc = " Rifle sniper de ação de ferolho com 5 tiros, .338"
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_cstm_l96.mdl"
Item.Weight = 9
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "cw_l115"
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cw_l115"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " IM1 Desert Eagle. "
Item.Desc = " Pistola semi-automática, de ação simples, .50AE "
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pist_deagle.mdl"
Item.Weight = 3
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "cw_deagle" 
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "cw_deagle"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " G3A3. "
Item.Desc = " Fuzil de assalto automatico, 7.62x51mm "
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_snip_g3sg1.mdl"
Item.Weight = 8
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "cw_g3a3"
Item.CanEquip = true
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cw_g3a3"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " AR-15 "
Item.Desc = " Rifle semiautomático leve, 5.56×45mm "
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_rif_m4a1.mdl"
Item.Weight = 5
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "cw_ar15" 
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cw_ar15"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Stevens M620 "
Item.Desc = " Espingarda de ação semi-automática, .12  "
Item.Type = "type_weapon"
Item.Model = "models/khrcw2/w_khri_stevenm62.mdl"
Item.Weight = 5
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "khr_m620"
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "khr_m620"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " M1928A1 "
Item.Desc = " SMG automática dos mafioso loko, .45 ACP "
Item.Type = "type_weapon"
Item.Model = "models/khrcw2/doipack/w_thompson1928.mdl"
Item.Weight = 4
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "doi_atow_m1928a1"
Item.CanEquip = true
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "doi_atow_m1928a1"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " MG42 "
Item.Desc = " Metraladora leve com 250 tiros, 7.92x57mm "
Item.Type = "type_weapon" 
Item.Model = "models/khrcw2/doipack/w_mg42.mdl" 
Item.Weight = 13
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "doi_atow_mg42"
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "doi_atow_mg42"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " ACR "
Item.Desc = "  Rifle de Combate Adaptável, 5.56x45mm "
Item.Type = "type_weapon" 
Item.Model = "models/cw2/rifles/w_acr.mdl"
Item.Weight = 5
Item.Volume = 0
Item.CanDrop = true 
Item.DropClass = "cw_acr"
Item.CanEquip = true
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cw_acr"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " H&K G36C "
Item.Desc = " Fuzil NATO alemão, 5.56x45mm "
Item.Type = "type_weapon"
Item.Model = "models/weapons/cw20_g36c.mdl" 
Item.Weight = 5
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "cw_g36c" 
Item.CanEquip = true
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon" 
Item.EquipGiveClass = "cw_g36c"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " M249 "
Item.Desc = " Metraladora leve com 100 tiros, 5.56x45mm "
Item.Type = "type_weapon"
Item.Model = "models/weapons/cw2_0_mach_para.mdl"
Item.Weight = 14
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "cw_m249_official"
Item.CanEquip = true 
Item.Illegal = true 
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cw_m249_official"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " H&K UMP "
Item.Desc = " SMG automática com 25 tiros, .45 ACP "
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_smg_ump45.mdl"
Item.Weight = 4
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "cw_ump45"
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "cw_ump45"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = " Browning Hi-Power "
Item.Desc = " Pistola semiautomática de ação simples, 9x19mm "
Item.Type = "type_weapon"
Item.Model = "models/khrcw2/doipack/w_browninghp.mdl"
Item.Weight = 4
Item.Volume = 0
Item.CanDrop = true
Item.DropClass = "doi_atow_browninghp"
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "doi_atow_browninghp"
Item.PacOutfit = "ak47_back"
GM.Inv:RegisterItem( Item )