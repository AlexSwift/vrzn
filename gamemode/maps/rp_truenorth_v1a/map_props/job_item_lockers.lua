--[[
	Name: job_item_lockers.lua
	For: Project UnrealRP
	By: AndrewTech
]]--

local MapProp = {}
MapProp.ID = "job_item_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblEnts = {
	{ pos = Vector(13222.646484375, 11146.1484375, 43.8568), ang = Angle(0, 90, 0), model = "models/props_c17/Lockers001a.mdl", job = "JOB_EMS" },
	{ pos = Vector(13320.646484375, 11146.1484375, 43.8568), ang = Angle(0, 90, 0), model = "models/props_c17/Lockers001a.mdl", job = "JOB_FIREFIGHTER" },
	{ pos = Vector(1434.82, 3210.81, 42.27), ang = Angle(0, 90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_POLICE" },
	{ pos = Vector(1350, 3210.81, 42.27), ang = Angle(0, 90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SWAT" },
	{ pos = Vector(-8038.968750 -5388.593262 -13876.319336), ang = Angle(14, -89, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SSERVICE" },
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