--[[
	Name: job_item_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_item_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblEnts = {
	{ pos = Vector(-6259.682617, 6919.135742, 336.131866), ang = Angle(0, -90, 0), model = "models/props_wasteland/controlroom_storagecloset001a.mdl", job = "JOB_EMS" },
	{ pos = Vector(-5518.917480, 3180.968750, 142.431992), ang = Angle(0, -90, 0), model = "models/props_wasteland/controlroom_storagecloset001a", job = "JOB_EMS" },
	{ pos = Vector(-5300.031250, 12134.295898, 464.031250), ang = Angle(0, -180, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_POLICE" },
	{ pos = Vector(-5324.126465, 11914.811523, 464.860504), ang = Angle(0, -90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SWAT" }
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblEnts ) do
		local ent = ents.Create( "ent_job_item_locker" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent.MapPropID = id
		ent:Spawn()
		ent:Activate()
		ent:SetModel( propData.model )
		ent:SetJobID( _G[propData.job] )

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )