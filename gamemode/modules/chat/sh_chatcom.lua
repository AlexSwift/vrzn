local plugin = serverguard.plugin.New()

plugin.unique = "sg_monolith"
plugin.name = "Monolith Servers"
plugin.author = "Coderall"
plugin.version = "2.0"
plugin.description = "Adds various commands related to Monolith."
plugin.gamemodes = {"vrzn", "darkrp", "sandbox"}

serverguard.phrase:Add("english", "command_clearfires", {
	SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has extinguished all fires."
})

-- La commands
do
	local command = {}

	command.help = "Drop money on the ground."
	command.command = "drop"
	command.arguments = {"amount"}
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.aliases = {"dropmoney", "dropcash"}

	function command:Execute(ply, silent, args)

        ply:AddNote("You have to insert a positive number", 3, 1)
    end
end


do
	local command = {}

	command.help = "Join our Discord website."
	command.command = "discord"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.aliases = {"teamspeak"}

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("https://discord.gg/uj6NRBS")')
	end

	plugin:AddCommand(command)
end



do
	local command = {}

	command.help = "View the changelog in Steam browser."
	command.command = "changelog"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("https://monolithservers.com/forums/topic/510-monolith-rp-beta-changelog/")')
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Read the Steam Guide."
	command.command = "guide"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("https://monolithservers.com/forums/forum/28-guides/")')
		-- above link is temporary until the Steam Guide has been made
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "View the content for the server."
	command.command = "content"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.aliases = {"downloads", "addons"}

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=932041100")')
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "View the rules for the server."
	command.command = "rules"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("https://monolithservers.com/forums/topic/215-server-rules/")')
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "View the our Steam group."
	command.command = "steam"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.aliases = {"steamgroup"}

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("http://steamcommunity.com/groups/MonolithServers")')
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "View our Premium Membership page."
	command.command = "store"
	command.bDisallowConsole = true
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.aliases = {"donate", "premium", "subscribe"}

	function command:Execute(ply, silent, args)
		ply:SendLua('gui.OpenURL("https://monolithservers.com/store")')
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Extinguishes all fires."
	command.command = "clearfires"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Clear Fires"}

	function command:Execute(ply, silent, args)
		for k, fire in pairs(ents.FindByClass("sent_fire_source")) do
			SafeRemoveEntity(fire)
		end

		for k, fire in pairs(ents.FindByClass("env_fire")) do
			SafeRemoveEntity(fire)
		end

		if (not silent) then
			serverguard.Notify(nil, SGPF("command_clearfires", serverguard.player:GetName(ply)))
		end
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Gives money to a player."
	command.arguments = {"player", "amount", "reason"}
	command.command = "givemoney"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Give Money"}

	function command:Execute(ply, silent, args)
			local target = util.FindPlayer(args[1], player, true)
			local reason = tostring(args[3])


		if (IsValid(target)) then
			target:AddMoney(tonumber(args[2]))

			Monolith.Logger:LogEntry(
					Monolith.Logger.LOG_ADMINISTRATION,
					Monolith.Logger:PrintPlayer(ply) .. " has used the give money command to spawn: " .. Monolith.Logger:PrintPlayer(target) .. " $" .. args[2] .. " with reason: '" .. reason .. "'"
			)

			if (IsValid(ply)) then
				ply:AddNotification("Gave " .. target:Name() .. " $" .. args[2] .. "!", 3, 1)
				target:AddNotification("$" .. args[2] .. " received for " .. reason .. ".", 3, 1)
			end
		else
			ply:AddNotification("Couldn't find player with that identifier.", 3, 1)
		end
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Sets the players name."
	command.arguments = {"player", "firstname", "lastname"}
	command.command = "setname"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Set Player Names"}

	function command:Execute(ply, silent, args)
		local target = util.GetPlayerByName(args[1])

		if IsValid(target) then

			local first_name = args[2]
			local last_name = args[3]

			if (not first_name or #first_name < 3 or #first_name > 15) or (not last_name or #last_name < 3 or #last_name > 15) then
				ply:AddNotification("Invalid name. Must be 3-15 characters.")

			end

			target:SetPlayerName(first_name, last_name, true)

			if IsValid(ply) then
				ply:AddNotification("Player Name set.", 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Forces the player to change their identity."
	command.arguments = {"player"}
	command.command = "forceidentity"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Force Identity Change"}

	function command:Execute(ply, silent, args)
		local target = util.GetPlayerByName(args[1])

		if IsValid(target) then
			target:SendLua("InitMenu()")

			if IsValid(ply) then
				ply:AddNotification("Forced the player to go through an identity change.", 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Gives XP to a player."
	command.arguments = {"player", "amount"}
	command.command = "givexp"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Give XP"}

	function command:Execute(ply, silent, args)
		local b = util.GetPlayerByName(args[1])

		if (IsValid(b)) then
			b:GiveExp(tonumber(args[2]))

			if (IsValid(ply)) then
				ply:AddNotification("Gave them the XP.", 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Gives job XP to a player."
	command.arguments = {"player", "amount"}
	command.command = "givejobxp"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Give Job XP"}

	function command:Execute(ply, silent, args)
		local b = util.GetPlayerByName(args[1])

		if (IsValid(b)) then
			b:GiveJobXP(tonumber(args[2]), ply:Nick() .. " admin command")

			if (IsValid(ply)) then
				ply:AddNotification("Gave them the XP.", 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Gives skill XP to a player."
	command.arguments = { "player", "skillID", "amount" }
	command.command = "giveskillxp"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = { "Give Skill XP" }

	function command:Execute( ply, silent, args )
		local target = util.GetPlayerByName( args[1] )
		local skillId = args[2]
		local amount = tonumber( args[3] )

		if not Monolith.Skills:SkillExists( skillId ) then ply:AddNotification( "Not a valid skill.", 3, 1 ) return end
		if IsValid( target ) then
			target:AddSkillXP( skillId, amount )

			if IsValid( ply ) then
				ply:AddNotification( string.format( "You gave %s %s %s XP.", target:Nick(), amount, skillId ), 3, 1 )
			end
		end
	end

	plugin:AddCommand( command )
end

do
	local command = {}

	command.help = "Unemploy a player."
	command.arguments = {"player"}
	command.command = "unemploy"
	command.immunity = SERVERGUARD.IMMUNITY.LESS
	command.permissions = {"Unemploy"}
	command.aliases = {"demote"}

	function command:Execute(ply, silent, args)
		local b = util.GetPlayerByName(args[1])

		if (IsValid(b)) then
			b:Unemploy()
			b:AddNotification(ply:Nick() .. " unemployed you!", 3, 1)

			if (IsValid(ply)) then
				ply:AddNotification("Unemployed them.", 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Revive yourself."
	command.command = "revive"
	command.permissions = {"Revive"}

	function command:Execute(ply, silent, args)
		local b = util.GetPlayerByName(args[1]) or ply

		if (IsValid(b)) then
			b.Lpos = b:GetPos()
			b:Spawn()
			b:SetPos(b.Lpos)
			b.Lpos = nil
			b:AddNotification(ply:Nick() .. " force-revived you", 3, 1)

			if (IsValid(ply)) then
				ply:AddNotification("You force-revived " .. b:Nick(), 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Remove your job cooldown."
	command.command = "cds"
	command.permissions = {"Remove Job Cooldown"}
	command.aliases = {"jobcooldown"}

	function command:Execute(ply, silent, args)
		ply.JobCooldown = 0
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Clears all tickets for a player."
	command.arguments = {"player"}
	command.command = "cleartickets"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Clear Tickets"}

	function command:Execute(ply, silent, args)
		local b = util.GetPlayerByName(args[1])

		if (IsValid(b)) then
			for k, v in pairs(TicketData) do
				if (b == v.Victim) then
					table.RemoveByValue(TicketData, v)
				end
			end

			b:SetNW2Bool("HasTickets", false)

			if (IsValid(ply)) then
				ply:AddNotification("Cleared all tickets for them.", 3, 1)
			end
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Appeal a ticket you've received."
	command.command = "appeal"
	command.bDisallowConsole = true

	function command:Execute(ply, silent, args)
		if (ply:GetJobCategory() != "Police") then
			return ply:AddNotification("You are not a part of law enforcement.", 3, 1)
		end
		local found = false

		for k, v in pairs(TicketData) do
			if (v.ForAppeal) then
				if (v.Victim == ply) then
					ply:AddNotification("You can't appeal your own tickets", 3, 1)
					break
				end
				found = v
				v.ForAppeal = false
				break
			end
		end

		if (not found) then
			ply:AddNotification("All tickets are/were appealed!", 3, 1)
		else
			net.Start("WriteAppealing")
			net.WriteTable(found)
			net.Send(ply)
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Blacklist a player."
	command.arguments = {"player", "jobname"}
	command.command = "blacklistadd"
	command.permissions = {"Blacklist Add"}
	command.immunity = SERVERGUARD.IMMUNITY.ANY

	function command:Execute(ply, silent, args)
		local jobs = Monolith.Blacklist.GetJobsByName(args[2])
		if (#jobs == 1) then
			Monolith.Blacklist.AddEntry(args[1], jobs[1])
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Remove blacklist from a player."
	command.arguments = {"player", "jobname"}
	command.command = "blacklistremove"
	command.permissions = {"Blacklist Remove"}
	command.immunity = SERVERGUARD.IMMUNITY.ANY

	function command:Execute(ply, silent, args)
		local jobs = Monolith.Blacklist.GetJobsByName(args[2])
		if (#jobs == 1) then
			Monolith.Blacklist.RemoveEntry(args[1], jobs[1])
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Open the blacklist menu."
	command.command = "blacklist"
	command.permissions = {"Blacklist"}

	function command:Execute(ply, silent, args)
		Monolith.Blacklist.OpenMenu(ply)
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Exit the minigame."
	command.command = "exit"

	function command:Execute(ply, silent, args)
		if ply:InGame() then
			ply:SetGame(false)
			net.Start("ClearGame")
			net.Send(ply)
			ply:KillSilent()
			ply:Spawn()
		end
	end

	plugin:AddCommand(command)
end

do
	local command = {}

	command.help = "Force an event."
	command.command = "events"
	command.permissions = {"Events"}

	function command:Execute(ply, silent, args)
		ply:ConCommand("open_events") -- command is SA only
	end

	plugin:AddCommand(command)
end


do
	local command = {}

	command.help = "Unarrests a player"
	command.arguments = {"player"}
	command.command = "unarrest"
	command.immunity = SERVERGUARD.IMMUNITY.ANY
	command.permissions = {"Force-Unarrest Player"}

	function command:Execute(ply, silent, args)
		local target = util.GetPlayerByName(args[1])

		if (IsValid(target)) then
			target:Handcuff(false, true)

			if (IsValid(ply)) then
				ply:AddNotification("You unarrested " .. target:GetFullName(), 3, 1)
				target:AddNotification("You were unarrested by " .. ply:GetFullName(), 3, 1)
			end
		else
			ply:AddNotification("Couldn't find player with that identifier.", 3, 1)
		end
	end

	plugin:AddCommand(command)
end

-- Register that shit
serverguard.plugin.Register(plugin)
