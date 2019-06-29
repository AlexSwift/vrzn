--[[
	© 2017 Thriving Ventures Limited, do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local MOTD = ""

net.Receive("MOTDUpdateClient", function()
	if (SCOREBOARD) then
		SCOREBOARD.MotdPanel:OpenURL("https://monolithservers.com/motd")
	end
end)

hook.Add("ScoreboardHide", "HideScoreboard", function()
	if (ValidPanel(SCOREBOARD)) then
		SCOREBOARD:Hide()
		SCOREBOARD.Alpha = 0
	end
end)

hook.Add("ScoreboardShow", "ShowScoreboard", function()
	if (not ValidPanel(SCOREBOARD)) then
		SCOREBOARD = vgui.Create("DMonoBoard")
	end

	if (ValidPanel(SCOREBOARD)) then
		SCOREBOARD:Show()

		-- if (LocalPlayer():GetActiveQuest() == "tutorial" and LocalPlayer():GetQuestState() == 1) then
		-- 	LocalPlayer().QuestState = 2
		-- end
	end

	return false
end)

local PANEL = {}
PANEL.List = {}

function PANEL:Init()
	self:SetSize(1018, 707)
	self:Center()
	self:MakePopup()
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:SetTitle("")
	self.Scroll = vgui.Create("DScrollPanel", self)
	self.Scroll:SetSize(492, 500)
	self.Scroll:SetPos(16, 116)
	self:DoRightPanel()
	self:Hide()
end

net.Receive("ReloadScoreboard", function()
	if (ValidPanel(SCOREBOARD)) then
		SCOREBOARD:Reload()
	end
end)

function PANEL:DoRightPanel()
	self.MotdPanel = vgui.Create("Awesomium", self)
	self.MotdPanel:SetPos(540 + 16, 104)
	-- self.MotdPanel:OpenURL("https://monolithservers.com/motd")
	self.MotdPanel:SetSize(442, 520)

	local usergrp = {founder = true, manager = true, director = true, developer = true, senioradmin = true}
	if (usergrp[LocalPlayer():GetUserGroup()]) then
		self.p = vgui.Create("DButton", self)
		self.p:SetPos(540 + 16 + 422 / 2 - 64, 595 + 42)
		self.p:SetText("Preciso de ajuda.")
		self.p:SetSize(128, 32)
		self.p.Paint = function(s,w,h)
			surface.SetDrawColor(s:IsHovered() && Color(230, 126, 34) || Color(255, 255, 255, 0))
			surface.DrawRect(0,0,w,h)
			-- draw.RoundedBox(8, 0, 0, w, h, Color(46,46,46) )
		end

		self.p.DoClick = function(s)
			local fram = vgui.Create("DFrame")
			fram:SetSize(800, 550)
			fram:SetTitle("MOTD Editor")
			fram.HTML = vgui.Create("DTextEntry", fram)
			fram.HTML:SetSize(800 - 32, 600 - 128 - 16)
			fram.HTML:SetPos(16, 32)
			fram.HTML:SetMultiline(true)
			fram.HTML:SetTabbingDisabled(false)

			http.Fetch("https://monolithservers.com/motd-html?time=" .. os.time(), function(b)
				fram.HTML:SetText(b)
			end)

			fram.Send = vgui.Create("DButton", fram)
			fram.Send:SetSize(800 - 32, 32)
			fram.Send:SetPos(16, 550 - 32 - 16)
			fram.Send:SetText("Save and broadcast")

			fram.Send.DoClick = function()
				net.Start("MOTDUpdate")
				net.WriteString(fram.HTML:GetValue())
				net.SendToServer()
				fram:Close()
			end

			fram:Center()
			fram:MakePopup()
		end
	end
end

local back = Material("vgui/elements/tabbg.png")
PANEL.Alpha = 0

function PANEL:Paint(w, h)
	self.Alpha = Lerp(FrameTime() * 7, self.Alpha, 255)
	surface.SetMaterial( back )
	surface.SetDrawColor(255, 255, 255, self.Alpha)
	surface.DrawTexturedRectRotated(w / 2, h / 2, 1920, 1080, 0)
	draw.SimpleText(player.GetCount() .. "/" .. game.MaxPlayers(), "HUD::0.2vw", w - 24, 32, Color(235, 235, 235, self.Alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	draw.SimpleText("Mjsv.VRZN", "HUD::0.2vw", w - 24, 9, Color(235, 235, 235, self.Alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	draw.SimpleText(string.FormattedTime( os.time(), "%02i:%02i:%02i" ), "HUD::0.2vw", 24, 20, Color(235, 235, 235, self.Alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	-- draw.SimpleText("Pressione espaço para ver os jobs", "HUD::0.2vw", w / 2, h - 25, Color(235, 235, 235, self.Alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)

	local usergrp = {founder = true, manager = true, director = true, developer = true, senioradmin = true}
	if (usergrp[LocalPlayer():GetUserGroup()]) then
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(w - 480, h - 78, 442, 48)
	end
end

PANEL.NextReload = 0
PANEL.Mode = false

function PANEL:Think()
	if (#self.List < 128 and player.GetCount() ~= #self.List) then
		self:Reload()
	end

	if (self.NextReload < CurTime()) then
		self.NextReload = CurTime() + 3
		self:Reload()
	end
end

function PANEL:Reload()
	local allPlayers = player.GetAll()

	table.sort(allPlayers, function(a, b)
		return serverguard.player:GetImmunity(a) > serverguard.player:GetImmunity(b)
	end)

	for k, v in pairs(self.List) do
		v:Remove()
	end

	for k, v in pairs(allPlayers) do
		local tbl = vgui.Create("PlayerCard", self.Scroll)
		tbl:SetPos(10, 44 * (k - 1))
		tbl:SetPlayer(v)
		tbl.Player = v
		table.insert(self.List, tbl)
	end
end

function PANEL:Clean()
	for k, v in pairs(self.List) do
		v:Remove()
	end

	self.List = {}
end

derma.DefineControl("DMonoBoard", "Scoreboard", PANEL, "DFrame")
local TIE = {}
TIE.Player = nil
TIE.Avatar = nil
TIE.PColor = nil
local tie = Material("mrp/menu_stuff/player_list.png")

function TIE:Init()
	self:SetSize(470, 40)
	self:SetText("")
end

function TIE:Paint(w, h)
	surface.SetMaterial(tie)
	-- surface.SetDrawColor(255, 255, 255, self:GetParent():GetParent().Alpha)
	-- surface.DrawTexturedRect(0, 0, w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(46,46,46))

	if (IsValid(self.Player)) then
		if self.Player:Team() then
			self.PColor = Color(235,235,235)
		else
			self.PColor = Color(235,235,235)
		end

		if (self.Player:Nick() ~= "" and not input.IsKeyDown(KEY_SPACE)) then
			draw.SimpleText(self.Player:Nick(), "HUD::0.1vw", 58, 18, Color(self.PColor.r, self.PColor.g, self.PColor.b, self:GetParent():GetParent().Alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(self.Player:Nick() .." - ".. GAMEMODE.Jobs:GetPlayerJob( self.Player ).Name, "HUD::0.1vw", 58, 18, Color(self.PColor.r, self.PColor.g, self.PColor.b, self:GetParent():GetParent().Alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(self.Player:Ping(), "HUD::0.1vw", w - 44, 18, Color(180, 180, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		local clr = Color(235,235,235)
		if(serverguard.ranks.stored[serverguard.player:GetRank(self.Player)]) then
			clr = serverguard.ranks.stored[serverguard.player:GetRank(self.Player)].color
			draw.SimpleText(serverguard.ranks.stored[serverguard.player:GetRank(self.Player)].name, "HUD::0.1vw", 320, 18, Color(clr.r * 1.3, clr.g * 1.3, clr.b * 1.3, 175 + math.cos(RealTime() * 3 + self.Player:EntIndex()) * 75), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(serverguard.ranks.stored[serverguard.player:GetRank(self.Player)].name, "HUD::0.1vw", 320, 18, Color(clr.r * 1.3, clr.g * 1.3, clr.b * 1.3, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		self:GetParent():GetParent():GetParent():Clean()
	end
end

function TIE:SetPlayer(ply)
	self.Player = ply
	self.Avatar = vgui.Create("AvatarMask", self)
	self.Avatar:SetSize(32, 32)
	self.Avatar:SetPos(4, 4)
	self.Avatar:SetPlayer(ply, 32)
end

function TIE:DoClick(b)
	if (IsValid(self.Player)) then
		local men = DermaMenu()
		men.Player = self.Player

		men:AddOption("Copiar nome da steam", function()
			SetClipboardText(men.Player:Nick())
		end)

		men:AddOption("Copiar nome do personagem", function()
			SetClipboardText(men.Player:FirstName() .. " " .. men.Player:LastName())
		end)

		men:AddOption("Copiar STEAMID", function()
			SetClipboardText(men.Player:SteamID())
		end)

		men:AddOption("Ver perfil", function()
			gui.OpenURL("https://steamcommunity.com/profiles/" .. men.Player:SteamID64())
		end)

		if (LocalPlayer():IsAdmin()) then
			men:AddOption("!bring", function()
				RunConsoleCommand("say", "!bring " .. men.Player:Nick())
			end)
		end

		if (LocalPlayer():IsAdmin()) then
			men:AddOption("!Goto", function()
				RunConsoleCommand("say", "!goto " .. men.Player:Nick())
			end)
		end

		men:AddOption("Cancelar", function() end)
		men:Open()
	end
end

derma.DefineControl("PlayerCard", "Player tier", TIE, "DButton")

local function MakeCirclePoly(_x, _y, _r, _points)
	local _u = (_x + _r * 320) - _x
	local _v = (_y + _r * 320) - _y
	local _slices = (2 * math.pi) / _points
	local _poly = {}

	for i = 0, _points - 1 do
		local _angle = (_slices * i) % _points
		local x = _x + _r * math.cos(_angle)
		local y = _y + _r * math.sin(_angle)

		table.insert(_poly, {
			x = x,
			y = y,
			u = _u,
			v = _v
		})
	end

	return _poly
end

local MASK = {}

function MASK:Init()
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetPaintedManually(true)
	self.material = Material("effects/flashlight001")
	self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function MASK:PerformLayout()
	self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function MASK:SetSteamID(...)
	self.Avatar:SetSteamID(...)
end

function MASK:SetPlayer(...)
	self.Avatar:SetPlayer(...)
end

function MASK:OnSizeChanged(w, h)
	self.Avatar:SetSize(self:GetWide(), self:GetTall())
	self.points = math.Max((self:GetWide() / 4), 32)
	self.poly = MakeCirclePoly(self:GetWide() / 2, self:GetTall() / 2, self:GetWide() / 2, self.points)
end

function MASK:DrawMask(w, h)
	draw.RoundedBox(w/4, 0, 0, w, h, color_white)
	draw.NoTexture()
	surface.SetMaterial(self.material)
	surface.SetDrawColor(color_white)
	surface.DrawPoly(self.poly)
end

function MASK:Paint(w, h)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)
	self:DrawMask(w, h)
	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)
	self.Avatar:SetPaintedManually(false)
	self.Avatar:PaintManual()
	self.Avatar:SetPaintedManually(true)
	render.SetStencilEnable(false)
	render.ClearStencil()
end

vgui.Register("AvatarMask", MASK)
SCOREBOARD = SCOREBOARD or nil

function cleanScoreboard()
	if ValidPanel(SCOREBOARD) then
		SCOREBOARD:Remove()
		SCOREBOARD = nil
	end
end

cleanScoreboard()
