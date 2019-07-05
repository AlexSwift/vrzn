if SERVER then
	require('mysqloo')

	local streakSQL = mysqloo.connect(GM.Config.SQLHostName, GM.Config.SQLUserName, GM.Config.SQLPassword, GM.Config.SQLDBName)

	function streakSQL:onConnected()
		print("[Streak] StreakSQL Connected")
		streakSQL:setAutoReconnect( true )
	end

	function streakSQL:onConnectionFailed( db, err )
		print("[Streak] StreakSQL Error: "..err)
	end
	streakSQL:connect()

	function streakSQL_CreateTB()
		local table_create = streakSQL:query([[CREATE TABLE IF NOT EXISTS streak_reward (
			id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
			steamid BIGINT NOT NULL,
			last_clain BIGINT NOT NULL,
			streak INT NOT NULL DEFULT '0'
		);]])
		table_create:start()
	end

	local function checkQuery(query)
	    local playerInfo = query:getData()
	    if playerInfo[1] ~= nil then
			return true
	    else
			return false
	    end
	end

	streakSQL_CreateTB()
	timer.Create( "streakSQL_Timer", 600, 0, function()
		if ( strakSQL:status() == 0 ) then
			if ( table.Count( player.GetAll() ) == 0 ) then
				streakSQL:connect()
				print("[Streak] StreakSQL connection reestablished.")
			end
		end
	end)

	local function update_Reward ( tbl, steamid )
		local Streak_Update = streakSQL:query("UPDATE INTO streak_reward SET last_clain = "..os.time()..", streak = "..tbl.streak + 1 .." WHERE steamid = "..steamid:SteamID64())
		Streak_Update.onSuccess = function ( qu ) print('[Streak] Novo streak salvo') end
		Streak_Update.onError = function ( qu, erru ) print('[Streak] Falha ao registrar novo streak. \n[Streak] Error: '..erru) end
		Streak_Update:start()
	end

	function GetReward( ply, tblReward, Time)
		if ( IsValid( ply ) ) then 
			local Streak_GET = streakSQL:query("SELECT last_clain, streak FROM streak_reward WHERE steamid = "..ply:SteamID64()..";")
			Streak_GET.onSuccess = function( q )
				if not ( checkQuery(q) ) then
					local Streak_Initial = streakSQL:query("INSERT INTO streak_reward (steamid, last_clain, streak) VALUES ("..ply:SteamID64()..", "..os.time()..", 1);")
					Streak_Initial.onSuccess = function ( qi )
						print("[Streak] Novo usuário registrado "..ply:Nick().."!")
						new_streak = 1
						last_get = os.time()
					end
					Streak_Initial.onError = function ( qi, erri )
						print("[Streak] Falha ao registrar novo usuário.\n[Streak] Error: "..erri)
					end
					Streak_initial:start()
				else
					local row = q:getData()[1]
					if ( ( os.time() - row.last_clain ) == 24*( 60*60 ) ) then
						last_reward = os.time()
						update_Reward( row, ply )
					else
						last_reward = row.last_clain
					end
				end
			end
			Streak_GET.onError = function ( q, err )
				print("[Streak] Streak Get Error: "..err)
			end
			Streak_GET:start()
		end 
		--Adiciona ao usuário com STEAMID: +1 Streak, Atualizao Lastclaim com Time
	end

end
