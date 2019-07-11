require('mysqloo')

AwesomeOrgs = AwesomeOrgs or {}
AwesomeOrgsData = AwesomeOrgsData or {}

local Org = Org or {}
local Org_MySQL = Org_MySQL or {}
Org_MySQL.Enable = true
Org_MySQL.Host = 'localhost'
Org_MySQL.User = 'root'
Org_MySQL.Pass = ''
Org_MySQL.Port = 3306
Org_MySQL.Data = 'vrzn'


util.AddNetworkString("org_invite")
util.AddNetworkString("org_senddata")
util.AddNetworkString("org_start")

util.AddNetworkString('org_deposit')
util.AddNetworkString('org_takemoney')

local p = FindMetaTable("Player")

function p:IsInOrganization()
	if (Org_MySQL.Enable == true) then 
		return tonumber( GAMEMODE.Player:GetSharedGameVar( self, "group_id" ), 0) > 0
	else
		return tonumber(self:GetPData("org", 0)) > 0
	end
end

function p:GetOrganizationID()
	if (Org_MySQL.Enable == true) then 
		return tonumber( GAMEMODE.Player:GetSharedGameVar( self, "group_id" ), 0)
	else
		return tonumber(self:GetPData("org", 0))
	end
end

function p:GetOrganization()
	return AwesomeOrgsData[self:GetOrganizationID()]
end

function p:GetOrganizationName()
	return AwesomeOrgsData[self:GetOrganizationID()] and AwesomeOrgsData[self:GetOrganizationID()].name or "None."
end


if (isbool(Org_MySQL.Enale) and Org_MySQL.Enable == true) then
	require('mysqloo')

	Org_MySQL_Connection = mysqloo.connect( Org_MySQL.Host, Org_MySQL.User, Org_MySQL.Pass, Org_MySQL.Data, Org_MySQL.Port )
    
	function Org_MySQL_Connection.OnConnected( q )
		print("[Organizations-Database] Conectado com sucesso!")
	end

	function Org_MySQL_Connection.OnConnectionFailed ( q, err )
		print("[Organizations-Database] Falha ao conectar! \n[Organizations] Erro: "..err)
	end

	Org_MySQL_Connection:setAutoReconnect( true )
	Org_MySQL_Connection:connect()
	print("[Organizations]Trying to create Main table")
	local Org_MySQL_Table = Org_MySQL_Connection:query([[CREATE TABLE IF NOT EXISTS organizations(
		id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
		name TINYTEXT NOT NULL,
		owner BIGINT NOT NULL,
		coowner BIGINT NOT NULL,
		org_upgrades VARCHAR(255) NOT NULL,
		money BIGINT NOT NULL DEFAULT 0,
		color VARCHAR(255) NOT NULL DEFAULT 'color(48, 175, 255)',
		motd VARCAHR(255) NOT NULL,
		icon VARCHAR(255) NOT NULL
	);]])

	function Org_MySQL_Table:onSuccess ( q )
		print("[Organizations] Main table created!")
	end

	function Org_MySQL_Table:onError ( q, err )
		print("[Organizations] Main table already exists!")
	end

	Org_MySQL_Table:start()

elseif (isbool(Org_MySQL.Enable) and Org_MySQL.Enable == false) then
	file.CreateDir("organizations")
end

hook.Add("GamemodePlayerSelectCharacter", "OrgStuff", function(pPlayer)
	AwesomeOrgs:ValidateOrg(pPlayer)

	net.Start("org_senddata")
	net.WriteBuffer(AwesomeOrgsData)
	net.Send(pPlayer)
end)

net.Receive("org_start", function(len, ply)
	if tonumber(ply:GetPData("org", 0)) ~= 0 then return end
	--if not ply:WithinTalkingRange() then return end
	--if ply:GetTalkingNPC().UID ~= "mayor_jobs" then return end
	--local orgName = net.ReadString()
	local orgTable = net.ReadTable()

	AwesomeOrgs:StartOrg(ply, orgTable["name"], orgTable["motd"], orgTable["color"])
end)

net.Receive('org_takemoney', function(_, pl)
	local count = net.ReadInt(32)
	local id = net.ReadInt(31)
	if( (AwesomeOrgsData[id]) and (AwesomeOrgs:GetMoney(id) >= count ) and (AwesomeOrgsData[id]['owner'] == pl:SteamID64()) )then
		AwesomeOrgs:AddMoney(id, -count)
		pl:AddMoney(count)
		pl:ChatPrint('Você sacou R$'..count..' do banco do grupo!')
	else
		pl:ChatPrint('O grupo não possui dinheiro suficiente!')
	end
end)

net.Receive('org_deposit', function(_, pl)
	local count = net.ReadInt(32)
	local id = net.ReadInt(31)
	if( (AwesomeOrgsData[id]) and pl:CanAfford(count) )then
		AwesomeOrgs:AddMoney(id, count)
		pl:TakeMoney(count)
		pl:AddNote('R$'..count..'depositados no banco da organização')
	else
		pl:ChatPrint('Você não possui dinheiro suficiente!')
	end
end)

function AwesomeOrgs:GetOrgData(id)
	if AwesomeOrgsData[id] then return AwesomeOrgsData[id] end
	if Org_MySQL == true then
		local getOrg = Org_MySQL_Connection:query("SELECT owner, name, motd, money, color, caracters.player_id FROM organizations WHERE id = "..id..";")
		getOrg.onSuccess = function ( q )
			if not checkQuery(q) then
				return
			else
				orgData = q:getData()[0]
				orgOwner = orgData["owner"]
				orgName = orgData["name"]
				orgMotd = orgData["motd"]
				regularMembers = orgData['players.player_id']
				orgMoney = orgData["money"]
				orgColor = orgData["color"]
			end
		end
		getOrg.onError = function ( q, err )
			print("[Organizations] Unespected to error on ID: ".. id)
			print("[Organizations] Error: "..err)
			orgOwner = 0
			orgName = "Nom existing"
			orgMotd = "No existing"
			orgMoney = 0
			orgColor = color(48, 175, 255)
		end
		getOrg:start()
	else
		if not file.Exists("organizations/" .. id .. ".dat", "DATA") then return end
		local orgData = file.Read("organizations/" .. id .. ".dat", "DATA")
		orgData = util.JSONToTable(orgData)
		orgOwner = orgData["owner"]
		orgName = orgData["name"]
		orgMotd = orgData["motd"]
		regularMembers = orgData["members"]
		orgMoney = orgData["money"] or 0
		orgColor = orgData["color"] or color(48, 175, 255)
	end

	AwesomeOrgsData[id] = {
		owner = orgOwner,
		name = orgName,
		motd = orgMotd,
		members = regularMembers,
		money = orgMoney,
		color = orgColor
	}

	return AwesomeOrgsData[id]
end

function AwesomeOrgs:SaveOrg(id)
	if Org_MySQL == false then
		if id == 0 then return end
		local orgData = AwesomeOrgsData[id]
		if not orgData then return end
		orgData = util.TableToJSON(orgData)
		file.Write("organizations/" .. id .. ".dat", orgData)
		self:NetworkOrg()
	else
		print("TODO")
	end
end

function AwesomeOrgs:GetMoney(id)
	if Org_MySQL == true then
		local getOrg = Org_MySQL_Connection:query("SELECT money FROM organizations WHERE id = "..id..";")
		getOrg.onSuccess = function ( q )
			if not checkQuery(q) then
				return
			else
				orgData = q:getData()[0]
				orgMoney = orgData["money"]
			end
		end
		getOrg.onError = function ( q, err )
			print("[Organizations] Unespected to error on ID: ".. id)
			print("[Organizations] Error: "..err)
			orgMoney = 0
		end
		getOrg:start()
	else
		if not file.Exists("organizations/" .. id .. ".dat", "DATA") then return end
		local orgData = file.Read("organizations/" .. id .. ".dat", "DATA")
		orgData = util.JSONToTable(orgData)
		local orgMoney = orgData["money"] or 0
	end

	return orgMoney
end

function AwesomeOrgs:AddMoney(id, count)
	if count == nil then return end
	if Org_MySQL == true then
		local prev_money = AwesomeOrgsData[id].money
		local after_money = AwesomeOrgsData[id]['money'] + count
		local getOrg = Org_MySQL_Connection:query("UPDATE organizations SET money = "..after_money.." WHERE id = "..id..";")
		getOrg.onSuccess = function ( q )
			AwesomeOrgsData[id]['money'] = after_money
		end
		getOrg.onError = function ( q, err )
			print("[Organizations] Unespected to error on ID: ".. id)
			print("[Organizations] Error: "..err)
		end
		getOrg:start()
	else
		if not file.Exists("organizations/" .. id .. ".dat", "DATA") then return end
		AwesomeOrgsData[id]['money'] = AwesomeOrgsData[id]['money'] + count
		self:SaveOrg(id)
	end
end

timer.Create("HibernateOrgs", 60, 0, function()
	for k, v in pairs(AwesomeOrgsData) do
		local data = v
		local shouldHibernate = true
		local owner = player.GetBySteamID64(data["owner"])

		if IsValid(owner) then
			shouldHibernate = false
			continue
		end

		for _, id in pairs(data["members"]) do
			local ent = player.GetBySteamID64(id)

			if IsValid(ent) then
				shouldHibernate = false
				continue
			end
		end

		if shouldHibernate then
			AwesomeOrgs:SaveOrg(k)
			AwesomeOrgsData[k] = nil
			AwesomeOrgs:NetworkOrg()
		end
	end
end)

function AwesomeOrgs:NetworkOrg()
	net.Start("org_senddata")
		net.WriteBuffer(AwesomeOrgsData)
	net.Broadcast()
end

local function isOrgIDFree(id)
	if Org_MySQL.Enable == false then
		if file.Exists("organizations/" .. id .. ".dat", "DATA") then return false end
		return true
	else
		local Query = Org_MySQL_Connection:query("SELECT id FROM organizations WHERE id = "..id..";")
		Query.onSuccess = function ( q )
			if not q:getData() then
				return false
			else
				return true
			end
		end
		Query.onError = function ( q, err )
			print("[Organizations] Error: "..err)
		end
		Query:start()
	end
end

local function generateOrgID()
	-- if Org_MySQL.Enable == false then
		local id = math.random(1, 5000)
		-- if not isOrgIDFree(id) then return generateOrgID() end

		return id
	-- end
end

function AwesomeOrgs:StartOrg(pPlayer, namestr, strmotd, tcolor)
	if not pPlayer:CanAfford(50000) then
		pPlayer:AddNote("Você não pode pagar por uma organização. ($50,000)")

		return
	end

	local curid = tonumber(pPlayer:GetPData("org", 0))

	if curid ~= 0 then
		pPlayer:AddNote("Você deve deixar a organização para criar outra.")

		return
	end
	local id = generateOrgID()

	local char_id = GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_id" )

	pPlayer:TakeMoney(50000)
	if (isbool(Org_MySQL.Enale) and Org_MySQL.Enable == true) then
		local newOrg = Org_MySQL_Connection:query([[INSERT INTO organizations (id, name, owner, motd, color) VALUES (]]..id..[[']]..namestr..[[', ]]..pPlayer:SteamID64()..[[", ']]..strmotd..[[', ']]..tcolor..[[');
			UPDATE characters SET group_id = ]]..id..[[ WHERE player_id = ]]..char_id..[[;]])
		newOrg.onSuccess = function (q)
			print("[Organizations] New organization!")
		end
		newOrg.onError = function ( q, err )
			print("[Organizations] Falied to create organization from Player ID 64:  "..pPlayer:SteamID64())
			print("[Organizations] Error: "..err)
		end
		newOrg:start()
	else
		

		local orgData = {
			owner = pPlayer:SteamID64(),
			name = namestr,
			motd = strmotd,
			members = {pPlayer:SteamID64()},
			money = 0,
			color = tcolor
        }
        PrintTable( orgData )
		-- AwesomeOrgsData[id] = orgData
		-- self:SaveOrg(id)
	end

	pPlayer:SetPData("org", id)
	pPlayer:SetNWInt("org", id)
	pPlayer:AddNote("Parabéns, sua organização " .. orgData["name"] .. " foi criada.")
end

function AwesomeOrgs:LeaveOrg(pPlayer)
	local orgid = tonumber(pPlayer:GetPData("org", 0))

	if orgid == 0 then
		pPlayer:AddNote("Você não pode sair de uma organização em que você não está! como você chegou a este ponto? fale com o nodge.")

		return
	end
	local char_id = GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_id" )
	if Org_MySQL == true then
		local mLeaveOrg = Org_MySQL_Connection:query("UPDATE characters SET group_id = 0 WHERE player_id = "..char_id..";")
		mLeaveOrg.onSuccess = function ( q )
			print("[Organizations] Char id "..char_id.." saiu do grupo.")
			pPlayer:AddNote("Você deixou " .. orgdata["name"] .. ".")
			pPlayer:SetPData("org", 0)
			pPlayer:SetNWInt("org", 0)
		end
		mLeaveOrg.onError = function ( q, err )
			print("[Organizations] Erro ao sair do grupo. Erro de char id:: "..char_id)
			print("[Organizations] Error log: "..err)
		end
		mLeaveOrg:start()
	else
		local orgdata = self:GetOrgData(orgid)

		if not orgdata then

			pPlayer:SetPData("org", 0)
			pPlayer:SetNWInt("org", 0)

			return
		end

		if orgdata["owner"] and orgdata["owner"] == pPlayer:SteamID64() then
			AwesomeOrgs:DisbandOrg(pPlayer)

			return
		end

		table.RemoveByValue(orgdata["members"], pPlayer:SteamID64())
		self:SaveOrg(orgid)
		pPlayer:AddNote("Você deixou " .. orgdata["name"] .. ".")
			pPlayer:SetPData("org", 0)
			pPlayer:SetNWInt("org", 0)
	end

end

function AwesomeOrgs:DisbandOrg(pPlayer)
	local orgid = tonumber(pPlayer:GetPData("org", 0))

	if orgid == 0 then
		pPlayer:AddNote("Você não pode deixar uma organização sem estar em uma.")

		return
	end
	local orgdata = self:GetOrgData(orgid)

	if Org_MySQL == true then
		local mDisbandOrd = Org_MySQL_Connection:query("SELECT owner, name FROM organizations WHERE id = "..orgid..";")
		mDisbandOrd.onSuccess = function ( q )
			local org = q:getData()[0]
			if org.owner == pPlayer:SteamID64() then
				print("[Organizations] Organization ID: "..orgid.." disbandished")
				local Disband_MSG = Org_MySQL_Connection:query("UPDATE caracters SET group_id WHERE group_id = "..orgid.."; DELETE FROM organizations WHERE id = "..orgid..";")
				Disband_MSG.onSuccess = function ( q )
					if checkQuery(q) then
						local qdata = q:getData()
						for k, v in pairs(org.members) do
							local ply = player.GetBySteamID64(v)

							if ( IsValid(ply) ) then
								ply:SetPData("org", 0)
								ply:SetNWInt("org", 0)
								ply:AddNote("Você foi expulso de(a) " .. org.name .. " por que a organização foi destruída.")
							end

						end
					end
					local SetDefault = Org_MySQL_Connection:query("UPDATE caracters SET group_id = 0;"):start()
				end
				Disband_MSG.onError = function (q, err)
					print("[Organizations] Couldn't disbandish org ID: "..orgid)
					print("[Organizations] MySQL Error: ".. err)
				end
				Disband_MSG:start()
			else
				pPlayer:AddNote("Você não pode destruir um grupo sem ser o dono dele.")
			end
		end
		mDisbandOrd.onError = function ( q, err )
			print("[Organizations] Couldn't disbandish org ID: "..orgid)
			print("[Organizations] MySQL Error: ".. err)
		end
		mDisbandOrd:start()
	else


		if not orgdata then
			pPlayer:SetPData("org", 0)
			pPlayer:SetNWInt("org", 0)

			return
		end

		if orgdata["owner"] and orgdata["owner"] ~= pPlayer:SteamID64() then
			pPlayer:AddNote("Você não pode destruir um grupo sem ser o dono dele.")

			return
		end

		for k, v in pairs(orgdata["members"]) do
			local ply = player.GetBySteamID64(v)

			if IsValid(ply) then
				ply:SetPData("org", 0)
				ply:SetNWInt("org", 0)
				ply:AddNote("Você foi expulso de(a) " .. orgdata["name"] .. " por que a organização foi destruída.")
			end
		end

		pPlayer:AddNote("você destruiu sua organização.")
		pPlayer:SetNWInt("org", 0)
		pPlayer:SetPData("org", 0)
		AwesomeOrgsData[orgid] = nil
		if not file.Exists("organizations/" .. orgid .. ".dat", "DATA") then return end
		file.Delete("organizations/" .. orgid .. ".dat")
	end
end

function AwesomeOrgs:DisbandOrgByID(id)
	local orgdata = self:GetOrgData(id)
	if not orgdata then return end
	AwesomeOrgsData[id] = nil
	if Org_MySQL == false then
		if not file.Exists("organizations/" .. id .. ".dat", "DATA") then return end
		file.Delete("organizations/" .. id .. ".dat")
	else
		local Query = Org_MySQL_Connection:query("DELETE FROM organizations WHERE id="..id.."; UPDATE characters SET group_id = 0 WHERE group_id = "..id..";"):start()
	end
end

function AwesomeOrgs:ValidateOrg(pPlayer)
	local orgid = tonumber(pPlayer:GetPData("org", 0))
	if orgid == 0 then return end
	local orgdata = self:GetOrgData(orgid)

	if not orgdata then
		pPlayer:SetPData("org", 0)
		pPlayer:SetNWInt("org", 0)

		return
	end

	local members = orgdata["members"] or {}
	self:NetworkOrg()

	if not table.HasValue(members, pPlayer:SteamID64()) then
		pPlayer:SetPData("org", 0)
		pPlayer:SetNWInt("org", 0)
		pPlayer:AddNote("Você foi kickado de(a) " .. orgdata["name"] .. " organização enquanto estava fora.")
		self:SaveOrg(orgid)
	else
		pPlayer:SetNWInt("org", orgid)
		self:NetworkOrg()
	end
end

function AwesomeOrgs:KickPlayer(pPlayer, sid64)
	local orgid = tonumber(pPlayer:GetPData("org", 0))

	if orgid == 0 then
		pPlayer:AddNote("Você não pode expulsar ninguém se não estiver numa organização.")

		return
	end

	local orgdata = self:GetOrgData(orgid)

	if not orgdata then
		pPlayer:SetPData("org", 0)
		pPlayer:SetNWInt("org", 0)

		return
	end

	if orgdata["owner"] and orgdata["owner"] ~= pPlayer:SteamID64() then
		pPlayer:AddNote("Você não pode kickar ninguém se você não é dono da organização!")

		return
	end

	local members = orgdata["members"]

	if not table.HasValue(members, sid64) then
		pPlayer:AddNote("Fatal Error: Player does not exist in member list. Contact an administrator if this continues to happen.")

		return
	end

	local org = self:GetOrgData(orgid)

	table.RemoveByValue(org["members"], sid64)
	local ply = player.GetBySteamID64(sid64)

	if IsValid(ply) then
		if (Org_MySQL.Enable == true) then
			local char_id = GAMEMODE.Player:GetSharedGameVar( ply, "char_id" )
			local byeMemb = Org_MySQL_Connection:query("UPDATE characters SET group_id = 0 WHERE id = "..char_id..";")
			byeMemb.onSuccess = function ( q )
				print("[Organizations] Removed "..char_id.." from "..org["name"])
			end
			byeMemb.onError = function (q, err)
				print("[Organizations] Failed to remove "..char_id.."!")
				print("[Organizations] Error"..err)
			end
			byeMemb:start()
		end

		for _, id in pairs(org["members"]) do
			local ent = player.GetBySteamID64(id)

			if IsValid(ent) then
				ent:AddNote(ply:Nick() .. " foi kickado da organização.")
			end
		end

		ply:SetPData("org", 0)
		ply:SetNWInt("org", 0)
		ply:AddNote("Você foi kickado da organização " .. org["name"] .. ".")
		self:SaveOrg(orgid)
	end
end

function AwesomeOrgs:PlayerJoin(pPlayer, orgid)
	local plyorgid = tonumber(pPlayer:GetPData("org", 0))
	local neworg = self:GetOrgData(orgid)

	if plyorgid ~= 0 then
		local orgdata = self:GetOrgData(plyorgid)

		if orgdata then
			if orgdata["owner"] and orgdata["owner"] == pPlayer:SteamID64() then
				self:DisbandOrgByID(id)
			end

			table.RemoveByValue(orgdata["members"], pPlayer:SteamID64())
			self:SaveOrg(plyorgid)
			table.insert(neworg["members"], pPlayer:SteamID64())
			pPlayer:SetPData("org", orgid)
			pPlayer:SetNWInt("org", orgid)
		else
			table.insert(neworg["members"], pPlayer:SteamID64())
			pPlayer:SetPData("org", orgid)
			pPlayer:SetNWInt("org", orgid)
		end
	elseif plyorgid == 0 then
		table.insert(neworg["members"], pPlayer:SteamID64())
		pPlayer:SetPData("org", orgid)
		pPlayer:SetNWInt("org", orgid)
		self:SaveOrg(orgid)
	end
end

function AwesomeOrgs:PlayerInvite(pPlayer, sid64)
	local pInvited = player.GetBySteamID64(sid64)
	if not IsValid(pInvited) then return end
	local orgid = tonumber(pPlayer:GetPData("org", 0))
	if orgid == 0 then return end
	local data = self:GetOrgData(orgid)
	if data["owner"] and data["owner"] ~= pPlayer:SteamID64() then return end
	pInvited.ORGPending = orgid
	net.Start("org_invite")
	net.WriteInt(orgid, 16)
	net.Send(pInvited)
end


local function checkQuery(query)
	local playerInfo = query:getData()
	if playerInfo ~= nil then
		return true
	else
		return false
	end
end











concommand.Add("org_accept", function(ply, cmd, args)
	if not ply.ORGPending then return end
	local orgd = AwesomeOrgs:GetOrgData(ply.ORGPending)
	if not orgd then return end

	for _, id in pairs(orgd["members"]) do
		local ent = player.GetBySteamID64(id)

		if IsValid(ent) then
			ent:AddNote(ply:Nick() .. " entrou pra organização.")
		end
	end

	ply:AddNote("você entrou na organização " .. orgd["name"] .. ".")
	AwesomeOrgs:PlayerJoin(ply, ply.ORGPending)
end)

concommand.Add("org_invite", function(ply, cmd, args)
	local sid64 = args[1]
	if not sid64 then return end
	AwesomeOrgs:PlayerInvite(ply, sid64)
end)

concommand.Add("org_kick", function(ply, cmd, args)
	local sid64 = args[1]
	if not sid64 then return end
	AwesomeOrgs:KickPlayer(ply, sid64)
end)

concommand.Add("org_leave", function(ply, cmd, args)
	AwesomeOrgs:LeaveOrg(ply)
end)

concommand.Add("org_update", function(ply, cmd, args)
	local id = tonumber(args[1])
	if not id then return end
	local plyorgid = tonumber(ply:GetPData("org", 0))
	if plyorgid == 0 then return end
	local orgdata = AwesomeOrgs:GetOrgData(plyorgid)
	if orgdata["owner"] and orgdata["owner"] ~= ply:SteamID64() then return end
		if id == 1 then
		-- Motd
		local motd = tostring(args[2])
		orgdata["motd"] = motd
		AwesomeOrgs:NetworkOrg()
	elseif id == 2 then
		-- Name
		local name = tostring(args[2])
		if string.len(name) < 3 then
			ply:AddNote("O nome da sua organização deve ser maior que isso.")

			return
		elseif string.len(name) > 19 then
			ply:AddNote("Nome da sua organização é muito curto.")
		end

		orgdata["name"] = name
		AwesomeOrgs:NetworkOrg()
	end
end)

