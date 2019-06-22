--[[
	Name: atms.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "atms"
MapProp.m_tblSpawn = {}
MapProp.m_tblAtms = {
	{ pos = Vector(-8720.00, -1525.40, 1543.038), ang = Angle(0, 180, 0) },
	{ pos = Vector(-6405.03, 5723.04, 1024.27), ang = Angle(0, 180, 0) },
	{ pos = Vector(-6403.60, 5859.39, 1024.27), ang = Angle(0, 180, 0) },
	{ pos = Vector(-7398.95, 5730.02, 1024.27), ang = Angle(0, 0, 0) },
	{ pos = Vector(-7386.43, 5839.99, 1024.27), ang = Angle(0, 0, 0) },
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

	for k, v in pairs( ents.GetAll() ) do
		if v:GetModel() == "models/props_unique/atm01.mdl" then
			local ent = ents.Create( "ent_atm" )
			ent:SetPos( v:GetPos() )
			ent:SetAngles( v:GetAngles() )
			ent.IsMapProp = true
			ent:Spawn()
			ent:Activate()
			v:Remove()

			local phys = ent:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableMotion( false )
			end
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )