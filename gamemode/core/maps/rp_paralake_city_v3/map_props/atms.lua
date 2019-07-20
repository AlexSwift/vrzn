--[[
	Name: atms.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "atms"
MapProp.m_tblSpawn = {}
MapProp.m_tblAtms = {
	--not already in the map
	{ pos = Vector(-3085.9670410156, -2169.42578125, -158.76905822754), ang = Angle(0, 90, 0) }, --banco 1
	{ pos = Vector(-3083.4348144531, -1168.6611328125, -158.74320983887), ang = Angle(0, -90, 0) }, --banco 2
	
	{ pos = Vector(1926.8018798828, 958.48559570313, -158.72264099121), ang = Angle(0, 90, 0) }, -- spawn

	{ pos = Vector(-2029.4252929688, -658.63043212891, -159.76434326172), ang = Angle(0, 0, 0) }, -- McDonalds

	{ pos = Vector(-4625.5180664063, -7231.14453125, -159.72248840332), ang = Angle(0, -180, 0) }, --cassino

}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblAtms ) do
		local ent = ents.Create( "ent_atm" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )
