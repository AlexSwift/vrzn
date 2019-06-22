--[[
	Name: clothing_store.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "clothing_store"
MapProp.m_tblSpawn = {}

MapProp.m_tblMenuTriggers = {
	{ pos = Vector(-7748.45, 4798.03, 1095.42), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-7750.52, 4979.77, 1095.42), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-7752.59, 5070.64, 1095.42), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-7754.66, 5161.51, 1095.42), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblMenuTriggers ) do
		local ent = ents.Create( "ent_menu_trigger" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetMenu( propData.menu )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()
		ent:SetText( propData.msg )
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )