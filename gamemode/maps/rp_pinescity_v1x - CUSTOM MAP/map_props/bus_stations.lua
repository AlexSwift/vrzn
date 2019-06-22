--[[
	Name: bus_stations
	
	By: Rustic7
]]--

local MapProp = {}
MapProp.ID = "bus_stations"
MapProp.m_tblSpawn = {}
MapProp.m_tblProps = {}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblProps ) do
		local ent = ents.Create( "prop_physics" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetModel( propData.mdl )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		ent:SetSaveValue( "fademindist", 4096 )
		ent:SetSaveValue( "fademaxdist", 3072 )

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )