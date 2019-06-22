--[[
	Name: car_dealer.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "car_dealer"
MapProp.m_tblSpawn = {}
MapProp.m_tblCars = {
	{ mdl = 'models/tdmcars/242turbo.mdl',pos = Vector('-3390.754883 3095.747559 92'), ang = Angle('0 0 0') },
	{ mdl = 'models/tdmcars/lam_gallardospyd.mdl',pos = Vector('-3174.830566 3095.571045 92'), ang = Angle('0 0 0') },
	{ mdl = 'models/tdmcars/hon_civic97.mdl',pos = Vector('-2845.163330 3095.912109 92'), ang = Angle('0 0 0') },
	{ mdl = 'models/tdmcars/jag_ftype.mdl',pos = Vector('-9921.064453 -9773.414063 92'), ang = Angle('0 0 0') },
	{ mdl = 'models/tdmcars/rx8.mdl',pos = Vector('-2573.026611 3095.949951 92'), ang = Angle('0 0 0') },
	{ mdl = 'models/tdmcars/por_carreragt.mdl',pos = Vector('-2617.664307 3783.639893 92'), ang = Angle('0 90 0') },
	{ mdl = 'models/tdmcars/aud_rs4avant.mdl',pos = Vector('-2948.171387 3784.743164 92'), ang = Angle('0 90 0') },
	{ mdl = 'models/tdmcars/mitsu_evox.mdl',pos = Vector('-3314.718750 3791.832031 92'), ang = Angle('0 90 0') },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblCars ) do
		local ent = ents.Create( "prop_physics" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetModel( propData.mdl )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		ent:SetSaveValue( "fademindist", GAMEMODE.Config.DetailPropFadeMin )
		ent:SetSaveValue( "fademaxdist", GAMEMODE.Config.DetailPropFadeMax )
		ent:SetPoseParameter( "vehicle_wheel_fl_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_fr_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_rl_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_rr_height", 0.5 )
		--ent:InvalidateBoneCache()

		local rand = math.random( 1, table.Count(GAMEMODE.Config.StockCarColors) )
		local idx = 0
		for k, v in pairs( GAMEMODE.Config.StockCarColors ) do
			idx = idx +1
			if idx == rand then
				ent:SetColor( v )
				break
			end
		end
		
		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end

	--Make the car preview area
	local ent = ents.Create( "prop_physics" )
	ent:SetModel( "models/hunter/tubes/circle4x4.mdl" )
	ent:SetPos( Vector(-9263.245117, -11054.450195, 297) )
	ent:SetAngles( Angle(0, 0, 0) )
	ent:SetMaterial( "phoenix_storms/dome" )
	ent.IsMapProp = true
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale( 1.5 )
	ent:PhysicsInit( SOLID_VPHYSICS )
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetSaveValue( "fademindist", GAMEMODE.Config.DetailPropFadeMin )
	ent:SetSaveValue( "fademaxdist", GAMEMODE.Config.DetailPropFadeMax )

	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )