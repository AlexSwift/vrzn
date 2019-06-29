--[[
Name: cl_hud.lua


]]--


local PANEL = {}
local cos, sin, rad = math.cos, math.sin, math.rad

AccessorFunc( PANEL, "m_masksize", "MaskSize", FORCE_NUMBER )

function PANEL:Init()
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetPaintedManually(true)
	self:SetMaskSize( 24 )
end

function PANEL:PerformLayout()
	self.Avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer( id )
	self.Avatar:SetPlayer( id, self:GetWide() )
end

function PANEL:Paint(w, h)
	render.ClearStencil() -- some people are so messy
	render.SetStencilEnable(true)
	
	render.SetStencilWriteMask( 1 )
	render.SetStencilzoneminMask( 1 )
	
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )
	
	local _m = self.m_masksize
	
	local circle, t = {}, 0
	for i = 1, 360 do
		t = rad(i*720)/720
		circle[i] = { x = w/2 + cos(t)*_m, y = h/2 + sin(t)*_m }
	end
	draw.NoTexture()
	surface.SetDrawColor(color_white)
	surface.DrawPoly(circle)
	
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
	
	self.Avatar:SetPaintedManually(false)
	self.Avatar:PaintManual()
	self.Avatar:SetPaintedManually(true)
	
	render.SetStencilEnable(false)
	render.ClearStencil() -- you&#39;re welcome, bitch.
end

vgui.Register("AvatarCircleMask", PANEL)


GM.HUD = {}
GM.HUD.m_tblNotes = {}

GM.HUD.m_convBlur = CreateClientConVar( "motion_blur", "0", false, false )
GM.HUD.m_matBlur = Material( "pp/blurscreen.png", "noclamp" )
GM.HUD.m_matLogo = Material( "santosrp/logo.png", "smooth" )
GM.HUD.m_matDeathOverlay = Material( "santosrp/vignette_death.png", "unlitgeneric ignorez" )

GM.HUD.m_tblNoticeMaterial = {}
GM.HUD.m_tblNoticeMaterial[NOTIFY_GENERIC] = Material( "vgui/notices/generic" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_ERROR] = Material( "vgui/notices/error" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_UNDO] = Material( "vgui/notices/undo" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_HINT] = Material( "vgui/notices/hint" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_CLEANUP] = Material( "vgui/notices/cleanup" )

local block = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudCrosshair"] = true,
	["CHudSecondaryAmmo"] = true,
}
hook.Add( "HUDShouldDraw", "BlockHL2HUD", function( strName )
	if block[strName] then return false end
end )

function GM.HUD:Paint()
	if self.m_convBlur:GetBool() then
		DrawMotionBlur( 0.055, 1, 0.001 )
	end
	
	-- surface.SetDrawColor( 255, 255, 255, 255 )
	-- surface.SetMaterial( self.m_matLogo )
	-- surface.DrawTexturedRect( 0, 0, 88, 46 )
	
	
	
	GAMEMODE.Jail:PaintJailedHUD()
	-- self:DrawCarHUD()
	self:DrawChopShopOverlay()
	-- DrawCardHud()
	--self:DrawDeathOverlay()
end

function GM.HUD:Think()
	self:UpdateNotes()
end

function GM.HUD:DrawRobberyOverlay()
	local start = LocalPlayer():GetNWFloat("robbery_timer", -1)
	local endtime = LocalPlayer():GetNWFloat("robbery_duration", -1)
	if start == -1 then return end
	if CurTime() > start + endtime then return end
	local text = "Robbery - Time Left: " .. GAMEMODE.Util:FormatTime((start + endtime) - CurTime())
	surface.SetFont("DermaLarge")
	local tw, th = surface.GetTextSize(text)
	local y = math.max(ScrH() * 0.05, 100)
	surface.SetDrawColor(40, 40, 40, 150)
	self:DrawFancyRect(0, y, tw + 30, th + 10, 90, 80)
	draw.SimpleTextOutlined(text, "DermaLarge", 5, y + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 255))
end


function GM.HUD:DrawMayorOverlay()
	if GAMEMODE.Config.MayorVoteHUD:GetInt() == 1 then return end
	local candidates = LocalPlayer():GetNWFloat("mayor_candidates", 0)
	local cooldown = GetGlobalInt("MayorCooldown") - CurTime()
	local text = ""
	
	--print(GAMEMODE.Jobs:MayorAlive())
	if GAMEMODE.Jobs:MayorAlive() then
		for _, ply in pairs(player.GetAll()) do
			if GAMEMODE.Jobs:PlayerIsJob(ply, JOB_MAYOR) then
				text = "Current Mayor: " .. ply:Nick()
			end
		end
	elseif #player.GetAll() < GAMEMODE.Config.MVPeopleNeedOnline then
		text = "Need " .. (GAMEMODE.Config.MVPeopleNeedOnline - #player.GetAll()) .. " more players online to start the election."
	elseif candidates < GAMEMODE.Config.MVPeopleNeedRegistred then
		text = "Need " .. (GAMEMODE.Config.MVPeopleNeedRegistred - candidates) .. " more candidates to start the election."
	else
		text = "Election will occure in: " .. GAMEMODE.Util:FormatTime(math.floor(cooldown))
	end
	
	surface.SetFont("DermaLarge")
	local tw, th = surface.GetTextSize(text)
	local y = math.max(ScrH() * 0.05, 50)
	surface.SetDrawColor(40, 40, 40, 150)
	self:DrawFancyRect(0, y, tw + 30, th + 10, 90, 80)
	draw.SimpleTextOutlined(text, "DermaLarge", 5, y + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 255))
end


function GM.HUD:DrawCityWorkerJob()
	local pPlayer = LocalPlayer()
	if not pPlayer:GetCharacter() then return end
	if pPlayer:Team() ~= JOB_CITYWORKER then return end
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("icon16/money.png"))
	
	for k, v in pairs(ents.FindByClass('ent_hydrant')) do
		if v:GetBroken() then
			local entpos = v:GetPos():ToScreen()
			surface.DrawTexturedRect(entpos.x, entpos.y - 25, 16, 16)
			draw.SimpleText("Fix a leaking hydrant!", "CopMenuFont", entpos.x, entpos.y, color_white, 1, 1)
		end
	end
	
	for k, v in pairs(ents.FindByClass('ent_road_debris')) do
		local entpos = v:GetPos():ToScreen()
		surface.DrawTexturedRect(entpos.x, entpos.y - 25, 16, 16)
		draw.SimpleText("Clear the road of debris!", "CopMenuFont", entpos.x, entpos.y, color_white, 1, 1)
	end
	
	for k, v in pairs(ents.FindByClass('ent_mow_grass')) do
		local entpos = v:GetPos():ToScreen()
		surface.DrawTexturedRect(entpos.x, entpos.y - 25, 16, 16)
		draw.SimpleText("Mow the grass!", "CopMenuFont", entpos.x, entpos.y, color_white, 1, 1)
	end
end


local CircleMat = Material("sgm/playercircle")
local color_config = {}
color_config["superadmin"] = function() return util.CleanGlow(0.3, Color(255, 255, 255), HSVToColor(CurTime() * 60 % 360, 1, 1)) end
color_config["founder"] = function() return util.CleanGlow(0.1, Color(255, 55, 55), Color(55, 255, 255)) end
local num = 65

function GM:DrawPlayerRing(pPlayer)
	if IsValid(pPlayer:GetActiveWeapon()) and pPlayer:GetActiveWeapon():GetClass() ~= "god_s" then return end
	if pPlayer:IsUncon() then return end
	if pPlayer:IsIncapacitated() then return end
	if IsValid(pPlayer:GetVehicle()) then return end
	if pPlayer:GetColor().a ~= 255 then return end
	local trace = {}
	trace.start = pPlayer:GetPos() + Vector(0, 0, 50)
	trace.endpos = trace.start + Vector(0, 0, -300)
	trace.filter = pPlayer
	local tr = util.TraceLine(trace)
	
	if not tr.HitWorld then
		tr.HitPos = pPlayer:GetPos()
	end
	
	local color = color_config[pPlayer:GetUserGroup()] and color_config[pPlayer:GetUserGroup()]() or Color(255, 255, 255)
	color.a = 100
	local size = pPlayer:IsSuperAdmin() and num + math.sin(CurTime() * 1) * 7 or num + math.sin(CurTime() * 1) * 5
	render.SetMaterial(CircleMat)
	render.DrawQuadEasy(tr.HitPos + tr.HitNormal, tr.HitNormal, size, size, color)
end

hook.Add("PrePlayerDraw", "DrawPlayerRing", function(ply)
	GAMEMODE:DrawPlayerRing(ply)
end)

function GM.HUD:DrawFancyRect( intX, intY, intW, intH, intSlantLeft, intSlantRight, matMaterial )
	intSlantLeft, intSlantRight = math.rad(intSlantLeft), math.rad(intSlantRight)
	
	local ladj = (intSlantLeft == 90 or intSlantLeft == 270) and 0 or ((1 /math.tan(intSlantLeft)) *intH)
	local radj = (intSlantRight == 90 or intSlantRight == 270) and 0 or ((1 /math.tan(intSlantRight)) *intH)
	
	local tl = ladj > 0 and ladj or 0
	local bl = ladj > 0 and 0 or -ladj
	local tr = radj > 0 and 0 or -radj
	local br = radj > 0 and radj or 0
	
	if matMaterial then surface.SetMaterial( matMaterial ) else draw.NoTexture() end
	surface.DrawPoly{
		{ x = intX +tl, y = intY },
		{ x = intX +intW -tr, y = intY },
		{ x = intX +intW -br, y = intY +intH },
		{ x = intX +bl, y = intY +intH }
	}
end

local healthColor = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
function GM.HUD:RenderScreenspaceEffects()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("materials/vgui/elements/vignett.png"))
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	local hp, maxHp = LocalPlayer():Health(), 100
	healthColor["$pp_colour_colour"] = math.Clamp( hp /maxHp*10 -1, 0, 1 )
	DrawColorModify( healthColor )
end

--Notifications
function GM.HUD:KillNote( uid )
	if not IsValid( self.m_tblNotes[uid] ) then return end
	self.m_tblNotes[uid].StartTime = SysTime()
	self.m_tblNotes[uid].Length = 0.8
end

function GM.HUD:AddNote( text, type, length )
	local parent = nil
	if GetOverlayPanel then parent = GetOverlayPanel() end
	
	local Panel = vgui.Create( "SRPNoticePanel", parent )
	Panel.StartTime = SysTime()
	Panel.Length = length and length or 8
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() +200
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetType( type )
	Panel:SetPos( Panel.fx, Panel.fy )
	
	table.insert( self.m_tblNotes, Panel )
	surface.PlaySound( "ui/beepclear.wav" )
end

function GM.HUD:UpdateNotice( i, Panel, Count )
	local x = Panel.fx
	local y = Panel.fy
	local w = Panel:GetWide()
	local h = Panel:GetTall()
	w = w
	h = h +16
	
	local ideal_y = (ScrH() *0.66) -(Count -i) *(h -12)
	local ideal_x = ScrW() -w
	local timeleft = Panel.StartTime -(SysTime() -Panel.Length)
	
	-- Cartoon style about to go thing
	if timeleft < 0.7 then
		ideal_x = ideal_x -50
	end
	-- Gone!
	if timeleft < 0.2 then
		ideal_x = ideal_x +w *2
	end
	
	local spd = FrameTime() *15
	y = y +Panel.VelY *spd
	x = x +Panel.VelX *spd
	
	local dist = ideal_y -y
	Panel.VelY = Panel.VelY +dist *spd *1
	if math.abs( dist ) < 2 and math.abs( Panel.VelY ) < 0.1 then Panel.VelY = 0 end
	
	local dist = ideal_x -x
	Panel.VelX = Panel.VelX +dist *spd *1
	if math.abs( dist ) < 2 and math.abs( Panel.VelX ) < 0.1 then Panel.VelX = 0 end
	
	-- Friction.. kind of FPS independant.
	Panel.VelX = Panel.VelX *(0.95 -FrameTime() *8 )
	Panel.VelY = Panel.VelY *(0.95 -FrameTime() *8 )
	Panel.fx = x
	Panel.fy = y
	Panel:SetPos( Panel.fx, Panel.fy )
end

function GM.HUD:UpdateNotes()
	local i = 0
	local Count = table.Count( self.m_tblNotes )
	for key, Panel in pairs( self.m_tblNotes ) do
		i = i +1
		self:UpdateNotice( i, Panel, Count )
	end
	
	for k, Panel in pairs( self.m_tblNotes ) do
		if not IsValid( Panel ) or Panel:KillSelf() then self.m_tblNotes[k] = nil end
	end
end

function GM.HUD:DrawDeathOverlay()
	if LocalPlayer():Alive() or not LocalPlayer():GetCharacterID() then return end
	
	DrawMotionBlur( 0.055, 1, 0.001 )
	surface.SetMaterial( self.m_matDeathOverlay )
	surface.SetDrawColor( Color(255, 255, 255, 255) )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	
	if LocalPlayer():InVehicle() then
		local text = "Stabilized"
		draw.SimpleText( text, "Trebuchet24", ScrW() /2, 200, Color(0, 200, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "Trebuchet24", ScrW() /2 +2, 200+2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		local timeelapsed = CurTime() -(LocalPlayer():GetNWFloat("DeathStart") or 0)
		local text = string.ToMinutesSeconds( math.max(GAMEMODE.Config.DeathWaitTime -timeelapsed, 0) )
		draw.SimpleText( text, "Trebuchet24", ScrW() /2, 200, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "Trebuchet24", ScrW() /2 +2, 200 +2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function GM.HUD:DrawChopShopOverlay()
	local start = LocalPlayer():GetNWFloat( "chop_shop_timer", -1 )
	local endtime = LocalPlayer():GetNWFloat( "chop_duration", -1 )
	
	if start == -1 then return end
	if CurTime() > start +endtime then return end
	
	local text = "Chop Shop - Time Left: ".. GAMEMODE.Util:FormatTime( (start +endtime) -CurTime() )
	
	surface.SetFont( "DermaLarge" )
	local tw, th = surface.GetTextSize( text )
	local y = math.max( ScrH() *0.05, 50 )
	
	surface.SetDrawColor( 40, 40, 40, 150 )
	self:DrawFancyRect( 0, y, tw +30, th +10, 90, 80 )
	
	draw.SimpleTextOutlined(
	text,
	"DermaLarge",
	5,
	y +5,
	Color( 255, 255, 255, 255 ),
	TEXT_ALIGN_LEFT,
	TEXT_ALIGN_LEFT,
	1,
	Color( 0, 0, 0, 255 )
)
end

local PANEL = {}
PANEL.Done = false
PANEL.maskSize = 16 --Defult for 32

function PANEL:Init()
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetPaintedManually(true)
end

function PANEL:PerformLayout()
	self.Avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetMaskSize(size)
	self.maskSize = size
end

local vw = ScrW() / 10
local pah = ScrH() * 6.666666666666667 / 100
local paw = ScrW() * 3.75 / 100
// ZONES HUD + SCREEN SIZED FONTS

surface.CreateFont( "HUD::0.075vw", {	font = "Montserrat Regular", size = 0.75 * vw,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.1vw", {	font = "Montserrat Regular", size = vw * 0.1,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.2vw", {	font = "Montserrat Regular", size = vw * 0.2,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.3vw", {	font = "Montserrat Regular", size = vw * 0.3,	weight = 500, antialias = true } )

-- local function CreateZoneTimer()
-- 	timer.Create( "ZoneTimer", 1.5, 0, function() 
-- 		local ZoneTable = {}
-- 		for k, v in pairs( GAMEMODE.Config.tblZones2 ) do
-- 			if LocalPlayer():GetPos():WithinAABox(v.Min, v.Max) then
-- 				ZoneTable = v
-- 				-- DrawTimerHud( v.Name, true)
-- 			end
-- 		end
-- 		DrawZoneHud( ZoneTable.Name, ZoneTable.Safe )
-- 	end )
-- end
-- hook.Add( "DrawZoneInfo", "Zone::Timer", CreateZoneTimer )
-- -- hook.Remove( "Move", "Timer Example")

-- -- timer.Create("ZoneChecker", 1, 0, function()
-- -- 	LocalPlayer():ChatPrint("timer 1 rodou")
-- -- 	for k, v in pairs( GAMEMODE.Config.tblZones2 ) do
-- -- 		if LocalPlayer():GetPos():WithinAABox(v.Min, v.Max) then
-- -- 			DrawZoneHud( v.Name, v.Safe )
-- -- 			-- DrawTimerHud( v.Name, true)
-- -- 		end
-- -- 	end
-- -- end)

-- -- hook.Add("Tick", "drawZones", function( a, b )

-- -- end)

-- function DrawZoneHud( Name, Safe )
-- 	hook.Add( "HUDPaint", "DrawZoneText", function()
-- 		if Safe then
-- 			surface.SetFont("HUD::0.3vw")
-- 			local w, h = surface.GetTextSize(Name)
-- 			draw.SimpleText( Name, "HUD::0.3vw", ScrW()/2 - w/2, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

-- 			surface.SetFont("HUD::0.1vw")
-- 			local tw, th = surface.GetTextSize("OFF RP")
-- 			draw.SimpleText( "OFF RP", "HUD::0.1vw", ScrW()/2 - tw/2, h, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
-- 		else
-- 			surface.SetFont("HUD::0.2vw")
-- 			local w, h = surface.GetTextSize(Name)
-- 			-- draw.RoundedBox(16, ScrW() - w - 15 - 8, 2, w + 16, h + 4, Color(30,30,30,50) )

-- 			draw.SimpleText( Name, "HUD::0.2vw", ScrW() - w - 15, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

-- 			surface.SetFont("HUD::0.1vw")
-- 			local tw, th = surface.GetTextSize("Área não dominada")
-- 			-- draw.SimpleText( "Área não dominada", "HUD::0.1vw", ScrW() - tw - 15, h, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
-- 		end
-- 		if timer.Exists("ZoneChecker") then 
-- 			LocalPlayer():ChatPrint("Removendo o timer 1")
-- 			timer.Remove("ZoneChecker")
-- 		else
-- 			timer.Start("ZoneChecker")
-- 		end
-- 	end )
-- end

surface.CreateFont( "BSYS::CrateTimer", {
	font = "Montserrat Bold",	size = 32,	weight = 500,	antialias = true, } )
	
	hook.Add( "Think", "OpenCrateDerma", function()
		local eTraceHit = LocalPlayer():GetEyeTrace()
		if !eTraceHit.Entity:IsValid() then return end
		-- if eTraceHit == nil then return end
		if (eTraceHit.Entity:GetClass() == "prop_door_rotating") and ((eTraceHit.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 150))  then
			if input.IsKeyDown( KEY_F2 ) then 
				local Door = LocalPlayer():GetEyeTrace().Entity
				local DoorData = GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()]
				if !DoorData then return end
				local PropertyData =  GAMEMODE.Property.m_tblProperties[DoorData.Name]			
				if !PropertyData then return end
				if not time then
					time = CurTime() + ( 1 )
					hook.Add( "HUDPaint", "hHoldingButton", function()
						variavel = CurTime() + 1
						if time then			
							local DoorData = GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()]
							if !DoorData then return end
							local PropertyData =  GAMEMODE.Property.m_tblProperties[DoorData.Name]			
							if !PropertyData then return end
							local PropertyName = DoorData.Name
							
							if  PropertyData.Government then return end
							if (eTraceHit.Entity:GetClass() == "prop_door_rotating") and ((eTraceHit.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 150))  then
								if time > CurTime() then
									local iOpenT = 1
									diff=(time-(CurTime()+iOpenT))*-1
									RevDiff=time-CurTime()
									---
									draw.NoTexture()
									Col = Color( 255,255, 255, 100)
									surface.SetDrawColor( Col )
									drawArc(ScrW()/2 ,ScrH()/2, 50, 15, 0, ToNumber(diff,360,iOpenT))
									----
									surface.SetFont( "BSYS::CrateTimer" )
									surface.SetTextColor( Color( 255,255,255) )
									local flWidth, flHeight = surface.GetTextSize( math.Round(RevDiff,1) )
									surface.SetTextPos( ScrW()/2 - flWidth / 2 ,ScrH()/2 - flHeight / 2  )
									surface.DrawText( math.Round(RevDiff,1))
								end
								
							else
								time = nil
								LocalPlayer():ChatPrint("Deixou de olhar")
							end
							
						end
					end )
				end 
				if CurTime() > time and not open then
					local Door = LocalPlayer():GetEyeTrace().Entity
					local DoorData = GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()]
					if !DoorData then return end
					local PropertyData =  GAMEMODE.Property.m_tblProperties[DoorData.Name]			
					if !PropertyData then return end
					if  PropertyData.Government then return end
					-- if DoorData.Owner ~= LocalPlayer() then return end
					-- if !DoorData.Owner:IsWorld() then return end				
					hook.Remove( "HUDPaint", "hHoldingButton" )
					
					open = true
					local mw = vgui.Create("DFrame")
					mw:SetSize(500,400)
					mw:SetTitle("")
					mw:MakePopup()
					mw:SetPos(ScrW()/2 - mw:GetWide()/2, ScrH()/2 - mw:GetWide()/2 - 50)
					mw:DockMargin(0, 0, 0, 0)
					mw:ShowCloseButton(false)
					mw:SetDraggable(false)
					mw.Paint = function()
					end
					
					local mwh = mw:Add("DPanel")
					mwh:Dock(TOP)
					mwh:SetTall(100)
					mwh.Paint = function(pnl, w, h)
						local aX, aY = pnl:LocalToScreen()
						BSHADOWS.BeginShadow()
						draw.RoundedBox(pnl:GetTall()/2, aX, aY, w, h, Color(26,26,26))
						BSHADOWS.EndShadow(1, 1, 2, 200)
					end
					
					local hi = mwh:Add("DImage")
					hi:SetImage( "materials/vgui/elements/house.png")
					hi:Dock(LEFT)
					hi:SetWide( mwh:GetTall())
					
					local hn = mwh:Add("DLabel")
					hn:SetText("")
					hn:Dock(FILL)
					hn.Paint = function(pnl, w, h)
						surface.SetFont("DoorMenuFont")
						t1w, t1h = surface.GetTextSize("Opções da propriedade")
						surface.SetTextColor(255, 255, 255, 255)
						surface.SetTextPos( 0, h/2-t1h)
						surface.DrawText("Opções da propriedade")
						
						surface.SetFont("DoorMenuFont2")
						surface.SetTextColor(255, 255, 255, 180)
						t2w, t2h = surface.GetTextSize("n24, Rua Gole de Skol")
						surface.SetTextPos( 0, h/2)
						surface.DrawText( DoorData.Name )
					end
					if DoorData.Owner:IsWorld() then
						local cc = mw:Add("DButton")
						cc:DockMargin(mw:GetWide()/6, 10, mw:GetWide()/6, 5)
						cc:Dock(TOP)
						cc:SetTall(40)
						cc:SetTextColor( Color(255,255,255) )
						cc:SetFont("DoorMenuButtonFont")
						cc:SetText("Alugar: R$".. PropertyData.Price)
						cc.Paint = function(pnl, w, h)
							local aX, aY = pnl:LocalToScreen()
							BSHADOWS.BeginShadow()
							draw.RoundedBox(pnl:GetTall()/2, aX, aY, w, h, Color(36,36,36) )
							BSHADOWS.EndShadow(1, 1, 2, 200)
						end
						cc.DoClick = function()
							GAMEMODE.Net:RequestBuyProperty( DoorData.Name )
							mw:Remove()
						end
					end
					if DoorData.Owner == LocalPlayer() then
						local sc = mw:Add("DButton")
						sc:DockMargin(mw:GetWide()/6, 10, mw:GetWide()/6, 5)
						sc:Dock(TOP)
						sc:SetTall(40)
						sc:SetTextColor( Color(255,255,255) )
						sc:SetFont("DoorMenuButtonFont")
						sc:SetText("Vender")
						sc.Paint = function(pnl, w, h)
							local aX, aY = pnl:LocalToScreen()
							BSHADOWS.BeginShadow()
							draw.RoundedBox(pnl:GetTall()/2, aX, aY, w, h, Color(36,36,36) )
							BSHADOWS.EndShadow(1, 1, 2, 200)
						end
						sc.DoClick = function()
							GAMEMODE.Net:RequestSellProperty( DoorData.Name )
							mw:Remove()
						end
					end
					
					-- local cdc = mw:Add("DButton")
					-- cdc:DockMargin(mw:GetWide()/6, 10, mw:GetWide()/6, 5)
					-- cdc:Dock(TOP)
					-- cdc:SetTall(40)
					-- cdc:SetTextColor( Color(255,255,255) )
					-- cdc:SetFont("DoorMenuButtonFont")
					-- cdc:SetText("Trancar todas as portas")
					-- cdc.Paint = function(pnl, w, h)
					-- 	local aX, aY = pnl:LocalToScreen()
					-- 	BSHADOWS.BeginShadow()
					-- 	draw.RoundedBox(pnl:GetTall()/2, aX, aY, w, h, Color(36,36,36) )
					-- 	BSHADOWS.EndShadow(1, 1, 2, 200)
					-- end
					
					local cb = vgui.Create("SRP_Button", mw)
					cb:DockMargin(mw:GetWide()/6, 10, mw:GetWide()/6, 5)
					cb:Dock(TOP)
					cb:SetTall(40)
					cb:SetTextColor( Color(255,255,255) )
					cb:SetFont("DoorMenuButtonFont")
					cb:SetText("Voltar")
					cb.Paint = function(pnl, w, h)
						local aX, aY = pnl:LocalToScreen()
						BSHADOWS.BeginShadow()
						draw.RoundedBox(pnl:GetTall()/2, aX, aY, w, h, Color(36,36,36) )
						BSHADOWS.EndShadow(1, 1, 2, 200)
					end
					cb.DoClick = function()
						mw:Remove()
					end
					
				end
			else
				open = false 
				time = nil
			end
		else return
		end
	end )
	
	surface.CreateFont( "DoorMenuFont", {size = 32, weight = 400, font = "Montserrat Bold"} )
	surface.CreateFont( "DoorMenuButtonFont", {size = 32, weight = 400, font = "Montserrat Regular"} )
	surface.CreateFont( "DoorMenuFont2", {size = 26, weight = 400, font = "Montserrat Regular"} )
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	-- LIB SPACE
	-----------------------------
	---@ Awesome Derma/Client LIB
	---@ Author: Nodge
	---@ Função de tempo removida da lib MRP
	-----------------------------
	function AWDrawTimeCountdown( Initial, Final, Colour)
		hook.Add("HUDPaint", "AWESOME::TimeCountdown", function()
			local start, finish = Initial, Final
			local curTime = CurTime()
			local scrW, scrH = ScrW(), ScrH()
			
			if finish > curTime then
				local fraction = 1 - math.TimeFraction(start, finish, curTime)
				local alpha = fraction * 255
				
				if alpha > 0 then
					running = true
					local w, h = scrW * 0.35, 28
					local x, y = (scrW * 0.5) - (w * 0.5), (scrH * 0.725) - (h * 0.5)
					
					surface.SetDrawColor(35, 35, 35, 255)
					-- surface.DrawRect(x, y, w, h)
					draw.RoundedBox(8, x, y, w, h, Color(35, 35, 35, 255) )
					
					surface.SetDrawColor(0, 0, 0, 120)
					-- surface.DrawOutlinedRect(x, y, w, h)
					draw.RoundedBox(8, x, y, w, h, Color(0, 0, 0, 255) )
					
					surface.SetDrawColor( 0, 0, 0, 255 )
					-- surface.DrawRect(x + 4, y + 4, (w * fraction) - 8, h - 8)
					draw.RoundedBox(8, x+4, y+4,  (w * fraction) - 8, h - 8, Color( 26,26,26,255 ) )
					
					-- surface.SetDrawColor( Color.r, Color.g, Color.b, Color.a )
					-- surface.DrawRect(x + 4, y + 4, (w * fraction) - 8, h - 8)
					draw.RoundedBox(8, x + 4,y  + 4,  (w * fraction) - 8, h - 8, Colour)
					
					surface.SetFont("MRP_ActionText")
					local boxX, boxY = scrW / 2, scrH * 0.1
					
					
					-- draw.SimpleText("Tempo Restante", "PropProtectFont", x + 2, y - 22, color_black)
					draw.SimpleText("Tempo Restante", "PropProtectFont", x, y - 24, color_white)
					
					local remainingTime = string.FormattedTime(math.max(finish - curTime, 0), "%02i:%02i:%02i")
					-- draw.SimpleText(remainingTime, "PropProtectFont", x + w, y - 22, color_black, TEXT_ALIGN_RIGHT)
					draw.SimpleText(remainingTime, "PropProtectFont", x + w, y - 24, color_white, TEXT_ALIGN_RIGHT)
				end
			end
		end)
	end
	-----------------------------
	---@ Awesome Derma/Client LIB
	---@ Author: Nodge
	---@ Desenha um arco vazado, baseado na hud do DayZ
	-----------------------------
	
	function drawArc( x, y, radius, thickness, start, endp )
		local outcir = {}
		local incir = {}
		
		local start = math.floor(start)
		local endp = math.floor(endp)
		
		
		if (start>endp) then
			local swap = endp
			endp = start
			start = swap
		end
		
		local inr = radius - thickness
		for i = start, endp do
			local a = math.rad(i)
			table.insert(incir, {x = x+(math.cos(a))*inr, y = y+(-math.sin(a))*inr})
		end
		
		for i = start, endp do
			local a = math.rad(i)
			table.insert(outcir, {x = x+(math.cos(a))*radius, y = y+(-math.sin(a))*radius})
		end
		
		local comcir = {}
		for i=0,#incir*2 do
			local p,q,r
			p = outcir[math.floor(i/2)+1]
			r = incir[math.floor((i+1)/2)+1]
			if (i%2) == 0 then
				q = outcir[math.floor((i+1)/2)]
			else
				q = incir[math.floor((i+1)/2)]
			end
			table.insert(comcir, {p,q,r})
		end
		
		for k,v in ipairs(comcir) do
			surface.DrawPoly(v)
		end
		
	end
	
	function ToNumber(arg, arg2, max)
		finished = arg/max*arg2
		return finished
	end
	
	function drawCircle( x, y, radius )
		local cir = {}
		local seg = 100
		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end
		
		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		
		surface.DrawPoly( cir )
	end
	
	