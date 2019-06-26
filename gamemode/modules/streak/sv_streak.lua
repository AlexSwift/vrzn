if SERVER then
	require('mysqloo');

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
		local table_create = streakSQL:query([[CREATE TABLE IF NOT EXISTS kill_streak (
			id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
			steamid BIGINT NOT NULL,
			last_clain BIGINT NOT NULL,
			streak INT NOT NULL DEFULT '0'
		);]])
		table_create:start()
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

	--

end
