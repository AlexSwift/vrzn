local meta = FindMetaTable("Player");

----------------------------------------------------------------------------------------------
-- NETWORKING NETWORKING NETWORKING NETWORKING NETWORKING NETWORKING NETWORKING NETWORKING 
----------------------------------------------------------------------------------------------
util.AddNetworkString( "BP::OpenGui" )
util.AddNetworkString( "BP::SyncData" )
util.AddNetworkString( "BP::SavedData" )
util.AddNetworkString( "BP::RequestReward" )
util.AddNetworkString( "BP::PlayerRewards" )
----------------------------------------------------------------------------------------------
-- DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA 
----------------------------------------------------------------------------------------------
function meta:GetSIDs()
    return string.gsub(self:SteamID(),":","_")
end

function meta:LoadACVs()
    local Data = {}
    if file.Exists( "acv/" .. self:GetSIDs() .. ".txt" ,"DATA") then
        Data = util.JSONToTable(file.Read( "acv/" .. self:GetSIDs() .. ".txt","DATA" ))
    end
    
    self.ACVData = Data
    
    net.Start( "BP::SavedData" )
    net.WriteTable( Data )
    net.Send(self)
    
end

function meta:SaveACVs()
    if !self.ACVData then return end
    
    local Data = self.ACVData or {}
    
    file.Write("acv/" .. self:GetSIDs() .. ".txt", util.TableToJSON(Data));
end

function meta:ACV_Increase(luaname,amount)
    local ADB = ACVTable(luaname)
    if !ADB then return end
    local Max = ADB.Max
    local Min = ADB.Min
    
    self.ACVData[luaname] = self.ACVData[luaname] or Min

    if self.ACVData[luaname] >= Max then return end
    
    self.ACVData[luaname] = self.ACVData[luaname] + amount

    if self.ACVData[luaname] >= Max then -- Clear

        self.ACVData[luaname] = Max

        for k,v in pairs(player.GetAll()) do
            v:ChatPrint(" Player, " .. self:Nick() .. " has finished the achievement : " .. ADB.PrintName .. " !!")
        end

        if ADB.OnClear then
            ADB:OnClear(self)
        end

    end

    if self.ACVData[luaname] < Min then

        self.ACVData[luaname] = Min

    end
    
    net.Start( "BP::SyncData" )
    net.WriteTable({LN=luaname,AM=self.ACVData[luaname]})
    net.Send(self)
    
    self:SaveACVs()
end

function meta:BP_Open( pPlayer )
    print("Server sending")
    pPlayer = pPlayer or self
    
    net.Start( "BP::OpenGui" )
    net.WriteTable( { 
        PlayerQuestData = pPlayer.ACVData or {},
        pPlayer = pPlayer
    } )
    -- local Data = BattlePassGetPlayerRetrieved( self )
    -- net.WriteTable(Data)
    net.Send(self)
end

-- ---------=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
net.Receive("BP::RequestReward", function(len , ply)
    ItemName = net.ReadString()
    ItemID = net.ReadInt(32)
    Level = net.ReadInt(32)
    Vip = net.ReadBool()
    BattlePassRequestReward( ply, ItemName, ItemID, Level, vip )

end)
function BattlePassRequestReward( ply, name, id, level, vip )
    if vip then
        if not ply:CheckGroup( "vip" ) then 
        ply:AddNote("Essa é uma recompensa exclusiva para vips.")    
        return end
    end
    
    if GAMEMODE.Skills:GetPlayerLevel( ply, "Passe de Batalha" ) < level then 
        ply:AddNote("Você Não possui nível suficiente para pegar esta recompensa")
        return
    end
    if not ( BattlePassGetPlayerRetrieved( ply ) ) then 
        BattlePassPlayerInsert( ply, "{}" )
    end
    local Data = BattlePassGetPlayerRetrieved( ply )
    local Table = util.JSONToTable(Data[1].parsed)
    if Table[id] then ply:AddNote("Você já coletou esta recompensa.") return end

    local itemData = GAMEMODE.Inv:GetItem( name )
    local curWeight, curVolume = GAMEMODE.Inv:ComputeWeightAndVolume( ply:GetInventory() )
    local maxWeight, maxVolume = GAMEMODE.Inv:ComputePlayerInventorySize( ply )
    if curWeight + itemData.Weight > maxWeight then 
        ply:AddNote( "Você não tem espaço no inventário!", 0, 2 )
    return end
    local sID = tostring(id)
    Table[sID] = true
    table.insert(Data, sIDTable)
    local json = util.TableToJSON(Table)

    BattlePassUpdatePlayer( ply, json )

    GAMEMODE.Inv:GivePlayerItem( ply, name, 1)
    ply:AddNote(name .. " Foi para o seu inventário!", 0, 3)

end



function BattlePassInitializeDB()
    sql.Query([[CREATE TABLE IF NOT EXISTS `battlepass` (
    `steamid` char(18) NOT NULL,
    `parsed` char(300) NOT NULL DEFAULT '{}',
    PRIMARY KEY (`steamid`)
    );]])
end
hook.Add("Initialize", "BattlePassDBStart")

function BattlePassUpdatePlayer( ply, json )
    sql.Query([[UPDATE battlepass 
    SET parsed = ']] .. json .. [[' 
    WHERE steamid = ']] .. ply:SteamID64() .. [[' 
    ;]])
end

function BattlePassPlayerInsert( ply )
    local currentdata = BattlePassGetPlayerRetrieved( ply )
    if currentdata then 
        print("Usuário já possui uma entrada no banco de dados")
        return end
    json = "{}"
   return sql.Query("INSERT INTO battlepass VALUES ('" .. ply:SteamID64() .. "', '" .. json .. "');")
end
hook.Add("PlayerInitialSpawn", "BattlePassPlayerInsert", BattlePassPlayerInsert )


function BattlePassSendPlayerUpdate( ply )
    -- print(ply:Nick())
    local Data = BattlePassGetPlayerRetrieved( ply )
    if not Data then 
        BattlePassPlayerInsert( ply )
        Data = BattlePassGetPlayerRetrieved( ply )
    end
    net.Start("BP::PlayerRewards")
    net.WriteTable(Data)
    net.Send(ply)
end


function BattlePassGetPlayerRetrieved( ply )
    return sql.Query([[SELECT parsed 
    FROM battlepass 
    WHERE steamid = ']] .. ply:SteamID64() .. [['
    ;]])
end

function paumole(ply)
    -- local table = {}
    -- table["1"] = true
    -- table["2"] = true
    -- table["3"] = true
    -- local json = util.TableToJSON(table)
    -- print("Função chamada.")
    -- local pplayer
    -- BattlePassInitializeDB()
    for k, v in pairs(player.GetAll()) do
        pplayer = v
    end
    BattlePassPlayerInsert(pplayer)
    -- BattlePassRequestReward( pplayer, "Barra de Ferro", 1 )
    -- print(pplayer:Nick())
    -- BattlePass:UpdatePlayer( pplayer, json )
    -- local data = BattlePassGetPlayerRetrieved( pplayer )
    -- if !IsValid(data) then
    --     BattlePass:PlayerInsert( pplayer, json )
    -- return 
    --     BattlePass:UpdatePlayer( pplayer, json )
    -- end
    -- print( data[1].parsed )
end

concommand.Add("jesusdepaumole", paumole)


----------------------------------------------------------------------------------------------
-- HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK HOOK    
----------------------------------------------------------------------------------------------
hook.Add("PlayerSay","SkillVGUI OpenCMD",function( pPlayer,text )
    if text == "!passe" then
        pPlayer:BP_Open( pPlayer )
    end
end)

hook.Add("PlayerSay","BattlePass PlayerRewards",function( pPlayer,text )
    if text == "!passe" then
        BattlePassSendPlayerUpdate( pPlayer )
    end
end)

hook.Add("Initialize", "ACV Dir Check", function()
    file.CreateDir("acv")
end)

hook.Add( "PlayerInitialSpawn", "ACV Load", function(ply)
    ply:LoadACVs()
end)

hook.Add( "PlayerDisconnected", "ACV Save", function(ply)
    ply:SaveACVs()
end	)
