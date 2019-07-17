
	local icontbl = {}
	icontbl["topazio"] = awcache.UI.Materials.topazio
	icontbl["safira"] = awcache.UI.Materials.safira
	icontbl["ametista"] = awcache.UI.Materials.ametista
	icontbl["ruby"] = awcache.UI.Materials.ruby

local function SetupFonts()
	surface.CreateFont( "OverHead::NameFont", {
		font = "Montserrat Bold",
		size =  49,
		--weight = 400,
		antialias = true,
		shadow = false,
		extended = false,
	} );

	surface.CreateFont( "OverHead::JobFont", {
		font = "Montserrat Bold",
		size = 32,
		--weight = 400,
		antialias = true,
		shadow = false,
		italic = true,
	} );

	surface.CreateFont( "OverHead::RankFont", {
		font = "Montserrat Regular",
		size = 28,
		--weight = 400,
		antialias = true,
		shadow = false,
		italic = true,
	} );

end
SetupFonts();
hook.Add( "InitPostEntity", "FROST::SetupFonts", SetupFonts );

local meta = FindMetaTable( "Player" );


function meta:shouldDraw()
	if( !self:Alive() or (LocalPlayer():GetEyeTrace().Entity !=self) ) then
		 return false 
	end

	if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 500) || !self:Alive() || self:InVehicle() || v == LocalPlayer() then
		return false;
	end

	return self:Team() != 1002;
end

function meta:ObjName()	
		return self:Nick() ;
end

function meta:ObjRank()	
	return serverguard.ranks.stored[self:GetUserGroup()].name ;
end

function meta:ObjColor()
	return serverguard.ranks.stored[self:GetUserGroup()].color
end

function meta:ObjJob()
	return GAMEMODE.Jobs:GetPlayerJob( self )
end

function meta:ObjGroup()
	return "Sem Organização"
end


hook.Add( "PreDrawEffects", "HUD::PreDrawEffects", function()

	for i, v in pairs( player.GetAll() ) do

		local steamid = v:SteamID64()
		if not awcache.AvatarLoader.CachedMaterials[v:SteamID64()] then
			print("Obtendo novo avatar")
			awcache.AvatarLoader.GetMaterial( v:SteamID64(), function(mat)
				awcache.AvatarLoader.CachedMaterials[v:SteamID64()] = mat
			end)
		end
	
		local pos = v:GetPos();
		local ang = LocalPlayer():EyeAngles();
		ang:RotateAroundAxis( ang:Forward(), 90 );
		ang:RotateAroundAxis( ang:Right(), 90 );

		pos = pos + Vector( 0, 0, v:OBBMaxs().z - 2 );
		pos = pos + LocalPlayer():GetRight() * 5;
		pos = pos + LocalPlayer():GetAngles():Right() * 2;

		local toScreen = pos:ToScreen();

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 );
		-- print( LocalPlayer():GetLicense() )
			if( v:shouldDraw() ) then

				// Player name
				local nw, nh = draw.SimpleText( v:ObjName(), "OverHead::NameFont", 116, 0, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)		
								
				// Player Avatar
				AwArc(50, 50, 0, 360, 51, v:ObjColor(), 35, "rank_border")

				AwMask( 
				function()
					AwArc(50, 50, 0, 360, 50, Color(255,255,255), 35, "jesus")
				end
				, 
				function()
					
					surface.SetMaterial( awcache.AvatarLoader.CachedMaterials[v:SteamID64()] )
					surface.DrawTexturedRect(0, 0, 100, 100)

				end
				)

				// Player Job
				local jw, jh = draw.SimpleText( v:ObjJob().Name, "OverHead::JobFont", 116, nh-10, v:ObjJob().TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)	

				// Player org
				local ow, oh = draw.SimpleText( v:ObjGroup(), "OverHead::RankFont", 116, nh-20+jh, v:ObjJob().Color or Color(255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				
				// Player Rank
				if icontbl[v:GetUserGroup()] then
					AwArc(90, 10, 0, 360, 24, v:ObjColor(), 25, "rank_border")
					AwArc(90, 10, 0, 360, 22, Color(26,26,26), 25, "rank_fill")
					-- draw.RoundedBox(4, 116, nh, 36, 36, v:ObjColor() )
					-- draw.RoundedBox(4, 117, nh+1, 34, 34, Color(26,26,26) )

					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( icontbl[v:GetUserGroup()])
					surface.DrawTexturedRect(74.5, -6, 32, 32)
				end

				// Gun license

				-- if icontbl[v:GetUserGroup()] then
					AwArc(50, 100, 0, 360, 19, v:ObjColor(), 25, "gun_border")
					AwArc(50, 100, 0, 360, 18, Color(26,26,26), 25, "gun_fill")
					-- draw.RoundedBox(4, 116, nh, 36, 36, v:ObjColor() )
					-- draw.RoundedBox(4, 117, nh+1, 34, 34, Color(26,26,26) )

					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( awcache.UI.Materials.gunlicense )
					surface.DrawTexturedRect(35, 85, 32, 32)
					
				-- end
				-- awcache.UI.Materials.gunlicense

			end
		cam.End3D2D();
	end
end );










































local PANEL = {}

EMOTES:CreateFont("EMOTES.Radial.Title", 30)
EMOTES:CreateFont("EMOTES.Radial.Desc", 20)

function PANEL:Init()
	EMOTES.Radial = self

	self.centerX = ScrW() / 2
	self.centerY = ScrH() / 2
	self.size = 6
	self.pointsPerSection = 360 / self.size
	self.hovered = -1
	self.contents = {}
	self.radius = 250
	self.highlightAlpha = 0

	self:SetAlpha(0)
	self:AlphaTo(235, 0.15)

	self.emotes = LocalPlayer():Emotes()

	self.emoteName = "Select an emote"
end

function PANEL:SetContents(tbl)
	for i, v in pairs(self.contents) do
		if (IsValid(v)) then v:Remove() end
	end

	for i, v in pairs(tbl) do
		local emote = EMOTES.Config.Emotes[v]
		if (!emote) then continue end

		local panel = self:Add(emote.animatedMat and "EMOTES.AnimatedTexture" or "DPanel")
		panel.emoteId = v
		panel.id = i
		if (emote.animatedMat) then
			panel:SetImages(emote.animatedMat)
			local normal = emote.times and emote.times.normal
			local idle = emote.times and emote.times.normal
			panel:SetTimes(normal, idle)
			panel:SetMouseInputEnabled(false)
			panel:PostInit()
			panel:SetPaused(true)
			panel.OnCursorEntered = function(pnl)
				pnl:SetPaused(false)
			end
			panel.OnCursorExited = function(pnl)
				pnl:SetPaused(true)
			end
		else
			panel.mat = emote.mat
			panel.Paint = function(pnl, w, h)
				surface.SetMaterial(pnl.mat)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
		panel.DoClick = function(pnl)
			LocalPlayer():ConCommand("emote " .. pnl.emoteId)
		end

		self.contents[i] = panel
	end
end

function PANEL:PerformLayout(w, h)
	for i, v in pairs(self.contents) do
		local ang = (i - 1) * self.pointsPerSection + (self.pointsPerSection / 2)
		ang = math.rad(ang)
		local w = 64
		local h = w
		local r = self.radius * (3 / 4)
		local sin = math.sin(ang) * r
		local cos = math.cos(ang) * r
		local x = self.centerX - w / 2 + sin
		local y = self.centerY - h / 2 - cos

		v:SetSize(w, h)
		v:SetPos(x, y)
	end
end

function PANEL:Think()
	local keyDown = input.IsKeyDown(EMOTES.Config.Key)
	if (keyDown) then return end

	self:Close()
end

function PANEL:Close()
	if (self.closing) then return end
	if (self.hovered != -1) then
		self:Pressed(self.hovered + 1)
	end

	self.closing = true
	self:AlphaTo(0, 0.15, nil, function()
		self:Remove()
	end)
end

function PANEL:Paint(w, h)
	EMOTES:DrawBlur(self, 4)

	self:DrawRadial(w, h)

	draw.SimpleText(self.emoteName, "EMOTES.Radial.Title", self.centerX, self.centerY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	if (self.emotes) then
		local canEmote, str = self.emotes:CanEmote()
		str = str or EMOTES:GetPhrase("radial.canEmote")

		draw.SimpleText(str, "EMOTES.Radial.Desc", self.centerX, self.centerY, str != "You can emote" and Color(230, 58, 64) or Color(190, 190, 190), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
end

function PANEL:Left(index)
	local panel = self.contents[index]
	if (!IsValid(panel)) then return end
	if (panel.OnCursorExited) then panel:OnCursorExited() end
end

function PANEL:Entered(index)
	if (index == -1) then
		self.emoteName = EMOTES:GetPhrase("radial.selectEmote")
	end

	local panel = self.contents[index]
	if (!IsValid(panel)) then self.emoteName = EMOTES:GetPhrase("radial.empty") return end
	if (panel.OnCursorEntered) then panel:OnCursorEntered() end

	self.emoteName = EMOTES.Config.Emotes[panel.emoteId].name or "UNKNOWN EMOTE (" .. panel.id .. ")"
end

function PANEL:Pressed(index)
	local panel = self.contents[index]
	if (!IsValid(panel)) then return end
	if (panel.DoClick) then panel:DoClick() end
end

function PANEL:OnMousePressed(keyCode)
	if (keyCode == MOUSE_LEFT) then
		self:Close()
	end
end

function PANEL:DrawRadial(w, h)
	EMOTES:MaskInverse(function()
		EMOTES:DrawCircle(self.centerX, self.centerY, self.radius / 2, 90, color_white)

		--[[
		for i = 0, 359, self.pointsPerSection do
			EMOTES:DrawArc(self.centerX, self.centerY, i, 2, self.radius, color_white, 90)
		end
		--]]
		
	end, function()
		EMOTES:DrawCircle(self.centerX, self.centerY, self.radius / 2 - 10, 90, color_white)

		local angle = 360 - (math.deg(math.atan2(gui.MouseX() - self.centerX, gui.MouseY() - self.centerY)) + 180)
		for i = 0, 359, self.pointsPerSection do
			local j = i / self.pointsPerSection
			local selected = angle >= i and angle < (i + self.pointsPerSection)
			local r = self.radius / 2
			local xDist = math.abs(self.centerX - gui.MouseX())
			local yDist = math.abs(self.centerY - gui.MouseY())
			local dist = math.sqrt(xDist ^ 2 + yDist ^ 2)
			if (dist < r) then
				if (self.hovered != -1) then
					self:Left(self.hovered + 1)
					self:Entered(-1)
					self.hovered = -1
				end
				
				selected = nil
			end
			if (selected and self.hovered != j) then
				self:Left(self.hovered + 1)
				self:Entered(j + 1)
				self.hovered = j
			end
			EMOTES:DrawArc(self.centerX, self.centerY, i, self.pointsPerSection, self.radius, Color(30, 30, 30), 90)
		end

		EMOTES:MaskInverse(function()
			EMOTES:DrawCircle(self.centerX, self.centerY, self.radius / 2, 90, color_white)
			
			--[[
			for i = 0, 359, self.pointsPerSection do
				EMOTES:DrawArc(self.centerX, self.centerY, i, 2, self.radius, color_white, 90)
			end
			--]]
		end, function()
			EMOTES:DrawArc(self.centerX, self.centerY, self.hovered * self.pointsPerSection, self.pointsPerSection, self.radius, ColorAlpha(EMOTES.Config.Accent, self.hovered != -1 and 255 or 0), 90)
		end)
	end)
end

vgui.Register("EMOTES.Radial", PANEL)

function EMOTES:CreateRadial()
	local frame = vgui.Create("EMOTES.Radial")
	frame:SetSize(ScrW(), ScrH())
	frame:Center()
	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)
	local tbl = {}
	local emotes = LocalPlayer():Emotes()
	for i, v in pairs(emotes:GetWheel()) do
		tbl[i] = v
	end

	frame:SetContents(tbl)
end