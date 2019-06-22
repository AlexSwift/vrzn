--[[
	Name: job_clothing_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_clothing_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblLockers = {
	--not already in the map
	{ pos = Vector(-2432.031250, 149.813843, 149.878708), ang = Angle(0, -90, 0), id = "JOB_FIREFIGHTER" }, --Fire
	{ pos = Vector(-5300.001465, 12060.351563, 464.031250), ang = Angle(2.870010, -179.126678, 0.000000), id = "JOB_POLICE" }, --Police
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblLockers ) do
		local ent = ents.Create( "ent_job_clothing_locker" )
		ent:SetJobID( _G[propData.id] )
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