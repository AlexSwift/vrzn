--[[
	Name: cl_buddies.lua
		by: Asriel + CodeRed

]]
--
surface.CreateFont("BuddyFont", {
	size = 128,
	weight = 500,
	font = "DermaLarge"
})

GM.Buddy = (GAMEMODE or GM).Buddy or {}
GM.Buddy.m_tblCurBuddies = (GAMEMODE or GM).Buddy.m_tblCurBuddies or {}
--GM.Buddy.m_matBuddyIcon = Material("icon16/user.png", "smooth")

function GM.Buddy:GetPlayerBuddyID(pPlayer)
	if not pPlayer:GetCharacterID() then return end
	local buddyID = pPlayer:SteamID()

	return self.m_tblCurBuddies[buddyID] and buddyID or nil
end

function GM.Buddy:GetPlayerByBuddyID(intBuddyID)
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == intBuddyID then return v end
	end
end

function GM.Buddy:GetBuddyData(intBuddyID)
	return self.m_tblCurBuddies[intBuddyID]
end

function GM.Buddy:IsBuddyWith(pPlayer)
	if not IsValid(pPlayer) then return false end

	return self.m_tblCurBuddies[pPlayer:SteamID()] or false
end

function GM.Buddy:SetBuddyTable(tblBuddies)
	self.m_tblCurBuddies = tblBuddies
end

function GM.Buddy:GetBuddyTable()
	return self.m_tblCurBuddies
end

function GM.Buddy:PaintBuddyCard(pPlayer)
	if (pPlayer:GetMoveType() == MOVETYPE_NOCLIP) then return end
	surface.SetFont("BuddyFont")

	if pPlayer:IsPolice() and LocalPlayer():IsPolice() then
		local tW, tH = surface.GetTextSize(pPlayer:Nick() .. " - " .. GAMEMODE.PoliceRanks:GetPrettyRank(pPlayer))
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(-(tW / 2), tH / 2)
		surface.DrawText(pPlayer:Nick() .. " - " .. GAMEMODE.PoliceRanks:GetPrettyRank(pPlayer))
	else
--		local tW, tH = surface.GetTextSize(pPlayer:Nick())
--		surface.SetTextColor(255, 255, 255, 255)
--		surface.SetTextPos(-(tW / 2), tH / 2)
--		surface.DrawText(pPlayer:Nick())
--		local iconSize = 128
--		surface.SetMaterial(self.m_matBuddyIcon)
--		surface.SetDrawColor(255, 255, 255, 255)
--		surface.DrawTexturedRect(-(tW / 2)+340 - iconSize - 24, (tH / 2), iconSize, iconSize)
	end
end

--function GM.Buddy:PaintNameTag(pPlayer)
--	surface.SetFont("BuddyFont")
--	local tW, tH = surface.GetTextSize(pPlayer:Nick())
--	surface.SetTextColor(255, 255, 255, 255)
--	surface.SetTextPos(-(tW / 2), tH / 2)
	-- surface.DrawText(pPlayer:Nick())
--end
 

function GM.Buddy:PostDrawTranslucentRenderables()
	local pos, offset = nil, Vector( 0, 0, 50 )
	local ang = Angle( 0, LocalPlayer():EyeAngles().y -90, 90 )
	local myPos = LocalPlayer():GetPos()

	for k, v in pairs( player.GetAll() ) do
		if v == LocalPlayer() then continue end
		
		if self:IsBuddyWith( v ) then
			parceiro = true
			ent =  v
			if ent:GetPos():DistToSqr( myPos ) > GAMEMODE.Config.RenderDist_Level2 ^2 then continue end
			pos = ent:LocalToWorld( ent:OBBCenter() ) +offset
			cam.Start3D2D( pos, ang, 0.035 )
				self:PaintBuddyCard( v )
			cam.End3D2D()
		else
			ent =  v
			if ent:GetPos():DistToSqr( myPos ) > 350 ^2 then continue end
			pos = ent:LocalToWorld( ent:OBBCenter() ) +offset
			cam.Start3D2D( pos, ang, 0.035 )
			cam.End3D2D()
		end
	end
end



	---------------------------------------------------
	-- FONTS
	---------------------------------------------------
	surface.CreateFont( "Roboto_Title", { 
		font = "Roboto", 
		extended = false,
		size = 25,
		weight = 800,
		antialias = true,
	})
	
	surface.CreateFont( "Roboto_Button", {
		font = "Roboto", 
		extended = false,
		size = 15,
		weight = 500,
		antialias = true,
	})
	
	surface.CreateFont( "Roboto_Subtext", {
		font = "Roboto",
		extended = false,
		size = 18,
		weight = 400,
		antialias = true,
	})	
	
	---------------------------------------------------
	-- POPUP CONFIGURATION
	---------------------------------------------------
	local main_color = Color(32, 34, 37)
	local secondary_color = Color(54, 57, 62) 
	local text_color = Color(255, 255, 255)
	
	local button_color = Color(47, 49, 54)
	local button_hovered_color = Color(66, 70, 77)
	
	local header_color = Color(255, 255, 255)
	
	local subtext_color = Color(0, 195, 165)
	local subtext_message = ""
	
	local width = 350
	local height = 135
	
	local disable_multicore_button = "Deny"
	
		
	local function MakePopupWindow()
	
		local parceiro = net.ReadEntity()
		local id = net.ReadInt(16)
		local header_message = "The player [#"..parceiro:Nick().."] "..parceiro:Name().." Want's to add you as a friend"
		local popup = vgui.Create("DFrame")
		popup:SetTitle("Add friend")
		popup:SetSize( width, height )
		popup:SetPos( 0, 0 )
		popup:MakePopup()
		popup:SetCursor("crosshair")
		popup:SetKeyboardInputEnabled(false)
		popup:SetMouseInputEnabled(true)
		popup:ShowCloseButton(false)
		function popup.Paint(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, main_color)
			draw.RoundedBox(0, 1, 1, w - 2, h - 2, secondary_color)
		end
	
		local btns = vgui.Create("DPanel", popup)
		btns:SetDrawBackground(false)
		btns:Dock(BOTTOM)
		btns:DockMargin(4, 4, 4, 4)
				
		local title = vgui.Create("DLabel", popup)
		title:SetText(header_message)
		title:SetFont("Roboto_Title")
		title:SetPos( 0, 0 )
		title:SetTextColor( text_color )
		title:SetContentAlignment(8)
		title:Dock(FILL)
		title:DockMargin(0, 0, 0, 0)
	
		local subtext = vgui.Create("DLabel", popup)
		subtext:SetText( header_message )
		subtext:SetFont("Roboto_Subtext")
		subtext:SetPos( 0, 0 )
		subtext:SetTextColor( subtext_color )
		subtext:SetContentAlignment(5)
		subtext:Dock(FILL)
		subtext:DockMargin(0, 0, 0, 0)
			
		local button_enable = vgui.Create("DButton", btns)
		button_enable:SetText( "Aceitar" )
		button_enable:SetFont("Roboto_Button")
		button_enable:SetPos( 0, 0 )
		button_enable:SetTextColor( header_color )
		button_enable:SetWide(popup:GetWide() * 0.5 - 14)
		button_enable:Dock(LEFT)
		function button_enable.Paint(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, button_color)
			
			if (s.Hovered) then
				draw.RoundedBox(0, 0, 0, w, h, button_hovered_color)																																																			-- Copyright 76561198110511213
			end
		end
		button_enable:SetTextColor( text_color )
		button_enable.DoClick = function()
			ply = LocalPlayer()
			net.Start("frp_AcceptedBuddy")
				net.WriteEntity(ply)
				net.WriteEntity(parceiro)
				net.WriteInt(id,16)
			net.SendToServer()
			popup:Remove()
		end
	
		local button_disable = vgui.Create("DButton", btns)
		button_disable:SetText( disable_multicore_button )
		button_disable:SetFont("Roboto_Button")
		button_disable:SetPos( 0, 0 )
		button_disable:SetWide(popup:GetWide() * 0.5 - 14)
		button_disable:Dock(RIGHT)
		function button_disable.Paint(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
			
			if (s.Hovered) then
				draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
			end
		end
		button_disable:SetTextColor( text_color )
		button_disable.DoClick = function()
			popup:Remove()
		end
		
	end	
	net.Receive("frp_askbuddy",MakePopupWindow)
	