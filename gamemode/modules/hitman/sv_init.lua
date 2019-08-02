HitmanPlus={}
HitmanPlus.Config={}
HitmanPlus.Config.HitTime=15

util.AddNetworkString( "Hit+::RequestHit" )
util.AddNetworkString( "Hit+::AcceptHit" )
util.AddNetworkString( "Hit+::DeleteTimeHud" )
util.AddNetworkString( "Hit+::DeclineHit" )
util.AddNetworkString( "Hit+::PopupYoNDermaa" )

HitmanPlus.HitEventNum=0

function HitmanPlus.StartHit(Hitman,Target,Price,Time)


	for _,v in pairs(player.GetAll()) do
		v:AddNote("Um hit foi aceito, cuidado com o seu cu", 0, 5)
	end
	local sessionid=HitmanPlus.HitEventNum
	hook.Add("PlayerDeath","Hitman+::HitEvent."..sessionid,function( victim, inflictor, attacker )

		if victim==Target and attacker==Hitman and attacker:isHitman() and sessionid==attacker:getHitEventId() then

			for _,v in pairs(player.GetAll()) do
				v:AddNote("O hit matou seu alvo [-/-]PS: Raffa morereira vai dominar o mundo!", 0, 5)
			end
			
			net.Start("Hit+::DeleteTimeHud")
			net.Send(attacker)

			attacker:AddMoney(Price) -- Give the hitman money
			attacker:setBusy(false)
			print("[HIT+]Session ID"..sessionid)
			if timer.Exists("Hit+::Timeout.Id."..sessionid) then
				timer.Remove("Hit+::Timeout.Id."..sessionid)
			end
			hook.Remove("PlayerDeath","Hitman+::HitEvent."..sessionid)
		end

	end)


	timer.Create( "Hit+::Timeout.Id."..sessionid, HitmanPlus.Config.HitTime, 1, function()
		
		hook.Remove("PlayerDeath","Hitman+::HitEvent."..sessionid)
		for _,v in pairs(player.GetAll()) do
			v:AddNote("O hit nao conseguiu completar sua tarefa a tempo, ele eh um merda msm", 0, 5)
		end
	end)
	Hitman:setBusy(true)
	Hitman:setHitEventId(HitmanPlus.HitEventNum)
	HitmanPlus.HitEventNum=HitmanPlus.HitEventNum+1
end

net.Receive( "Hit+::AcceptHit",function( len,pl )
	local Cookie = net.ReadInt(32)
	local Contractor = net.ReadEntity()
	if HitmanPlus.RequestTable[Cookie]["Hitman"] == pl then
		local Target = HitmanPlus.RequestTable[Cookie]["Target"]
		local Price  = HitmanPlus.RequestTable[Cookie]["Price"]
		Contractor:TakeMoney(Price)
		HitmanPlus.StartHit(pl,Target,Price)
		--Deplete the table
		HitmanPlus.RequestTable[Cookie] = {}
	end
end)

net.Receive( "Hit+::DeclineHit",function( len,pl )
	local Cookie = net.ReadInt(32)
	local Contractor = net.ReadEntity()
	if HitmanPlus.RequestTable[Cookie]["Hitman"] == pl then
		HitmanPlus.RequestTable[Cookie] = {}
	end
end)

HitmanPlus.RequestCookie=0
HitmanPlus.RequestTable={}
net.Receive("Hit+::RequestHit",function(len, ply)

	local Price = net.ReadInt(32)
	local TargetSteamId = net.ReadString()
	local HitmanSteamId = net.ReadString()


	--
	local Target = player.GetBySteamID( TargetSteamId )
	local Hitman = player.GetBySteamID( HitmanSteamId )

	-- Hitman:AddNote(Price)
	-- Hitman:AddNote(TargetSteamId)
	-- Hitman:AddNote(HitmanSteamId)
	--
	if Hitman:isHitman() then
		net.Start("Hit+::PopupYoNDermaa")--Popup yes or no derma, this is the hitman confirmation
		net.WriteInt(Price,32)
		net.WriteString(TargetSteamId)
		net.WriteInt(HitmanPlus.RequestCookie,32)
		net.WriteEntity(ply)
		net.Send(Hitman)

		--

		HitmanPlus.RequestTable[HitmanPlus.RequestCookie]={}

		HitmanPlus.RequestTable[HitmanPlus.RequestCookie]["Price"] = Price
		HitmanPlus.RequestTable[HitmanPlus.RequestCookie]["Target"] = Target
		HitmanPlus.RequestTable[HitmanPlus.RequestCookie]["Hitman"] = Hitman

		HitmanPlus.RequestCookie=HitmanPlus.RequestCookie+1
	end
end)

-- hook.Add("GamemodePlayerQuitJob","HitMan+::ChangeJob",function(GAMEMODE, pPlayer,m_intJobID)
-- 	a = GAMEMODE.Jobs:GetPlayerJob( pPlayer ).Id
-- end)
hook.Remove("GamemodePlayerQuitJob","HitMan+::ChangeJob")


local meta = FindMetaTable( "Player" )

function meta:setHitEventId( iEventId )
	return self:SetNWInt("Hitman.curEventId",iEventId )
end

function meta:setBusy( bBool )
	return self:SetNWBool("Hitman.BusyState",bBool )
end
--