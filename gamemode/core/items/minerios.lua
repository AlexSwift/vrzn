local Item = {}
Item.Name = "Barra de Ouro"
Item.Skin = 3
Item.Rarity = "Épico"
Item.Desc = "Produto de mineração, vale mais que dinheiro (maoeeee)."
Item.Model = "models/Zerochain/props_mining/zrms_bar.mdl"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "zrms_bar_gold"
Item.Illegal = false

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Barra de Ferro"
Item.Desc = "Produto de mineração."
Item.Model = "models/Zerochain/props_mining/zrms_bar.mdl"
Item.Rarity = "Normal"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "zrms_bar_iron"
Item.Illegal = false

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Barra de Bronze"
Item.Rarity = "Raro"
Item.Skin = 1
Item.Desc = "Produto de mineração."
Item.Model = "models/Zerochain/props_mining/zrms_bar.mdl"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "zrms_bar_bronze"
Item.Illegal = false

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Barra de Prata"
Item.Rarity = "Raro"
Item.Skin = 2
Item.Desc = "Produto de mineração."
Item.Model = "models/Zerochain/props_mining/zrms_bar.mdl"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "zrms_bar_silver"
Item.Illegal = false

GM.Inv:RegisterItem( Item )