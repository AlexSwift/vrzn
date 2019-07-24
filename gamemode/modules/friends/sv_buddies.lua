--[[
	Name: sv_buddies.lua
	For: TalosLife
	By: TalosLife
]]--
util.AddNetworkString("frp_askbuddy")-- ASCP POI
GM.Buddy = {}

function GM.Buddy:GetPlayerBuddyID( pPlayer, pOther )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end

	local buddyID = pOther:GetCharacterID()
	if saveTable.Buddies[buddyID] then
		return buddyID
	end
end

function GM.Buddy:GetPlayerByBuddyID( intBuddyID )
	for k, v in pairs( player.GetAll() ) do
		if not v:GetCharacterID() then continue end
		if v:GetCharacterID() == tonumber( intBuddyID ) then
			return v
		end
	end
end

function GM.Buddy:GetPlayerBuddyData( pPlayer, intBuddyID )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	return saveTable.Buddies[intBuddyID]
end

function GM.Buddy:IsPlayerBuddyWith( pPlayer, pOther )
	if not IsValid( pOther ) then return false end
	
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return false end
	if not pOther:GetCharacterID() then return false end

	return saveTable.Buddies[pOther:GetCharacterID()] or false
end

function GM.Buddy:IsCarShared( pPlayer, pOwner )
	if not self:IsPlayerBuddyWith( pOwner, pPlayer ) then return false end
	return self:GetPlayerBuddyData( pOwner, pPlayer:GetCharacterID() ).Settings.ShareCar
end

function GM.Buddy:IsDoorShared( pPlayer, pOwner )
	if not self:IsPlayerBuddyWith( pOwner, pPlayer ) then return false end
	return self:GetPlayerBuddyData( pOwner, pPlayer:GetCharacterID() ).Settings.ShareDoors
end

function GM.Buddy:IsItemShared( pPlayer, pOwner )
	if not self:IsPlayerBuddyWith( pOwner, pPlayer ) then return false end
	return self:GetPlayerBuddyData( pOwner, pPlayer:GetCharacterID() ).Settings.ShareItems
end

function GM.Buddy:PlayerAddBuddy( pPlayer, intBuddyID )-- ASCP POI
	local otherPlayer = self:GetPlayerByBuddyID( intBuddyID )
	if not IsValid( otherPlayer ) then return end
	net.Start("frp_askbuddy")
	net.WriteEntity(pPlayer)
	net.WriteInt(intBuddyID,16)
	net.Send(otherPlayer)
	print("ID requisitado: "..intBuddyID)
	print("====================")
end

function ascp1337( otherPlayer, pPlayer,intBuddyID )
	print("recursividade")
	print(pPlayer)
	print(otherPlayer)
	print("id do cliente que foi requisitado: "..intBuddyID)
	if not IsValid( otherPlayer ) then return end
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not otherPlayer:GetCharacterID() then return end
	saveTable.Buddies = saveTable.Buddies or {}
	saveTable.Buddies[intBuddyID] = {
		Settings = {
			ShareCar = false,
			ShareDoors = false,
			ShareItems = false,
		},
		LastName = otherPlayer:Nick()
	}
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
end

util.AddNetworkString("frp_AcceptedBuddy")--ASCP POI--
net.Receive("frp_AcceptedBuddy",function(pl)
	print("aceitou \n")
	--intBuddyID = net.ReadInt(16)
	local otherPlayer = net.ReadEntity()
	local pPlayer = net.ReadEntity() 
	intBuddyID	=  net.ReadInt(16)
	print(pPlayer)
	print(otherPlayer)
	print("id do cliente que requisitou:",intBuddyID)
	local meuid = GAMEMODE.Player:GetSharedGameVar(pPlayer, "char_id", "") 
	if not IsValid( otherPlayer ) then return end
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not otherPlayer:GetCharacterID() then return end

	saveTable.Buddies = saveTable.Buddies or {}
	saveTable.Buddies[intBuddyID] = {
		Settings = {
			ShareCar = false,
			ShareDoors = false,
			ShareItems = false,
		},
		LastName = otherPlayer:Nick()
	}
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
	ascp1337(pPlayer, otherPlayer, meuid)
end)
function ascp1337pt2( pPlayer, intBuddyID )
	print("Jogador 2: \n =======")
	print(pPlayer)
	print(intBuddyID)
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	saveTable.Buddies[intBuddyID] = nil
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
end
function GM.Buddy:PlayerRemoveBuddy( pPlayer, intBuddyID )
	print("Remover parceiro \n Jogador 1:\n ========")
	print(pPlayer)
	print(intBuddyID)--
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	saveTable.Buddies[intBuddyID] = nil
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
	local meuid = GAMEMODE.Player:GetSharedGameVar(pPlayer, "char_id", "")
	local otherPlayer = self:GetPlayerByBuddyID( intBuddyID )
	ascp1337pt2(otherPlayer, meuid)
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "Buddies", saveTable.Buddies )
end

function GM.Buddy:PlayerUpdateBuddyKey( pPlayer, intBuddyID, strKey, vaValue )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	if not saveTable.Buddies[intBuddyID] then return end
	if saveTable.Buddies[intBuddyID].Settings[strKey] == nil then return end
	if vaValue == nil then return end
	
	saveTable.Buddies[intBuddyID].Settings[strKey] = vaValue
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "Buddies", saveTable.Buddies )
end

hook.Add( "GamemodePlayerSelectCharacter", "SendBuddyData", function( pPlayer )
	GAMEMODE.Net:SendFullBuddyUpdate( pPlayer )
end )