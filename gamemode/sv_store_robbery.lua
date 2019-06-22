--[[
	Name: sv_shop_robbery.lua
]]--

GM.StoreRobbery = (GM or GAMEMODE).StoreRobbery or {}
GM.StoreRobbery.m_tblPlayers = (GM or GAMEMODE).StoreRobbery.m_tblPlayers or {}
GM.StoreRobbery.m_tblRobbing = (GM or GAMEMODE).StoreRobbery.m_tblRobbing or {}

local hands_up = {
	["ValveBiped.Bip01_R_UpperArm"] = Angle(75,-100,0),
	["ValveBiped.Bip01_L_UpperArm"] = Angle(-75,-100,0),
	["ValveBiped.Bip01_R_Forearm"] = Angle(0,-50,0),
	["ValveBiped.Bip01_L_Forearm"] = Angle(0,-50,0),
}

function GM.StoreRobbery:FindShopToRob( pPlayer )
	local v = pPlayer:GetTalkingNPC()
	if not IsValid( v ) or v:IsPlayer() then return end
	if v.m_intRobStart then return end
	return v
end

function GM.StoreRobbery:PlayerRobShop( pPlayer )
	local entNPC = self:FindShopToRob( pPlayer )
	if not IsValid( entNPC ) then return 0 end
	if not self:PlayerCanRobShop( pPlayer, entNPC ) then return 1 end
	
	entNPC.m_intRobStart = CurTime()
	entNPC.m_pRobbedBy = pPlayer
	entNPC.m_strRobbedBy = pPlayer:SteamID64()

	self.m_tblRobbing[entNPC] = true
	self.m_tblPlayers[pPlayer:SteamID64()] = CurTime()
	
	for k,v in pairs(hands_up) do
		local bone = entNPC:LookupBone(k)
		if bone then
			entNPC:ManipulateBoneAngles(bone, v)
		end
	end
	
	entNPC:EmitSound( "robbing_alert" )

	pPlayer:AddNote( "Stay close to store clerk to complete the robbery!" )
	pPlayer:SetNWFloat( "robbery_timer", CurTime() )
	pPlayer:SetNWFloat( "robbery_duration", GAMEMODE.Config.StoreRobbery_RobberyDuration )
	
	if entNPC.Address then
		strText = "Unit be advised, there is a robbery in progress at "..entNPC.Address..", code 3."
	else
		strText = "Unit be advised, there is a robbery in progress, code 3."
	end
	
	for k, v in pairs( player.GetAll() ) do
		if not GAMEMODE.Jobs:GetPlayerJob( v ) then continue end
		if GAMEMODE.Jobs:GetPlayerJob( v ).Receives911Messages then
			GAMEMODE.Net:SendTextMessage( v, "Dispatch", strText )
			v:AddNote( "Robbery call just came in, details on phone." )
			v:EmitSound( "santosrp/sms.mp3" )
		end
	end

	return 2
end

--Checks if a player can rob a shop
function GM.StoreRobbery:PlayerCanRobShop( pPlayer, entNPC )
	local intPoliceOnline = 0
	local tblFoundWeps = {}
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) != JOB_CIVILIAN then pPlayer:AddNote( "Only citizens can start a robbery!" ) return false end

	for k, v in pairs( pPlayer:GetEquipment() ) do
		item = GAMEMODE.Inv:GetItem( v )
		if item and item.Type == "type_weapon" and item.Illegal then
			table.insert( tblFoundWeps, item.Name )
		end
	end

	if #tblFoundWeps <= 0 then
		 pPlayer:AddNote( "You don't have any gun, to rob the store." )
		 return
	end

	for k,v in ipairs(player.GetAll()) do
		if GAMEMODE.Jobs:GetPlayerJobID( v ) == JOB_POLICE then
			intPoliceOnline = intPoliceOnline + 1	
		end
	end
	
	if intPoliceOnline < GAMEMODE.Config.StoreRobbery_PoliceNeeded then pPlayer:AddNote( "Not enough police online to start a robbery." ) return end -- Check how many cops online are required to start a robbery
	
	if entNPC.m_intRobStart then return false end --Already being robbed
	
	if self.m_tblPlayers[pPlayer:SteamID64()] then --Robbed a shop before
		if CurTime() > self.m_tblPlayers[pPlayer:SteamID64()] + GAMEMODE.Config.StoreRobbery_RobberyCooldown then --Cooldown ran out
			self.m_tblPlayers[pPlayer:SteamID64()] = nil
			return true
		else
			local timeLeft = ((self.m_tblPlayers[pPlayer:SteamID64()] + GAMEMODE.Config.StoreRobbery_RobberyCooldown) -CurTime()) /60
			pPlayer:AddNote( ("You must wait %s minutes before robbing another shop."):format(math.Round(timeLeft, 0)) )
		end
	end
	
	return not self.m_tblPlayers[pPlayer:SteamID64()]
end

function GM.StoreRobbery:Tick()
	if not self.m_intLastThink then self.m_intLastThink = 0 end
	if self.m_intLastThink > CurTime() then return end
	self.m_intLastThink = CurTime() +1

	for k, v in pairs( self.m_tblRobbing ) do
		if not IsValid( k ) or not k.m_strRobbedBy or not IsValid( k.m_pRobbedBy ) or k.m_pRobbedBy:GetPos():Distance( k:GetPos() ) > 500 or not k.m_pRobbedBy:Alive() then --[BROKEN] or k.m_pRobbedBy:isHandcuffed() then --failed to rob it, reset it so they can try again
			if k and k.m_strRobbedBy then
				self.m_tblPlayers[k.m_strRobbedBy] = nil
			end

			if IsValid( k.m_pRobbedBy ) then
				k.m_pRobbedBy:AddNote( "You are no longer robbing the shop." )
				k.m_pRobbedBy:SetNWFloat( "robbery_timer", -1 )
			end
			

			self.m_tblRobbing[k] = nil --unref from robbery table
			k.m_intRobStart = nil --remove data
			k.m_pRobbedBy = nil --remove data
			k.m_strRobbedBy = nil --remove data
			
			for i,v in pairs(hands_up) do
				local bone = k:LookupBone(i)
				if bone then
					k:ManipulateBoneAngles(bone, Angle(0,0,0))
				end
			end
			
			k:StopSound( "robbing_alert" )

			continue
		end

		if CurTime() > k.m_intRobStart + GAMEMODE.Config.StoreRobbery_RobberyDuration then
		    
			local money = math.random(2000, 10000)
			k.m_pRobbedBy:AddNote( "You earned $".. money.. " for robbing a shop!" )
			k.m_pRobbedBy:AddMoney( money )
			
			if k and k.m_strRobbedBy then
				self.m_tblPlayers[k.m_strRobbedBy] = nil
			end
			
			self.m_tblRobbing[k] = nil --unref from robbery table
			k.m_intRobStart = nil --remove data
			k.m_pRobbedBy = nil --remove data
			k.m_strRobbedBy = nil --remove data
			
			for i,v in pairs(hands_up) do
				local bone = k:LookupBone(i)
				if bone then
					k:ManipulateBoneAngles(bone, Angle(0,0,0))
				end
			end
			
			k:StopSound( "robbing_alert" )
		end
	end
end