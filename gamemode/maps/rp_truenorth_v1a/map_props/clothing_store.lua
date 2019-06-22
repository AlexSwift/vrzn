--[[
	Name: clothing_store.lua
	For: Project UnrealRP
	By: AndrewTech
]]--

local MapProp = {}
MapProp.ID = "clothing_store"
MapProp.m_tblSpawn = {}

MapProp.m_tblMenuTriggers = {
	--shop 1
	{ pos = Vector(8965.9384765625, 10136.407226563, 69), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(8965.9384765625, 10270.067382813, 69), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(8965.9384765625, 10412.220703125, 69), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(8530.0009765625, 10091.534179688, 66), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(8530.0009765625, 10358.63671875, 66), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(8530.0009765625, 10451.296875, 66), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	
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