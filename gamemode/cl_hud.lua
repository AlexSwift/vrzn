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
	self:DrawCarHUD()
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
	local hp, maxHp = LocalPlayer():Health(), 100
	healthColor["$pp_colour_colour"] = math.Clamp( hp /maxHp *2 -1, 0, 1 )
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


surface.CreateFont( "HUD::0.075vw", {	font = "Montserrat Regular", size = 0.75 * vw,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.1vw", {	font = "Montserrat Regular", size = vw * 0.1,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.2vw", {	font = "Montserrat Regular", size = vw * 0.2,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.3vw", {	font = "Montserrat Regular", size = vw * 0.3,	weight = 500, antialias = true } )

hook.Add("PostDrawOpaqueRenderables", "drawZones", function( a, b )
    if LocalPlayer():IsSuperAdmin() then
    for k, v in pairs( GAMEMODE.Config.tblZones2 ) do
        if LocalPlayer():GetPos():WithinAABox(v.Min, v.Max) then
            DrawZoneHud( v.Name, v.Safe )
        end
            local zonemin = v.Min
            local zonemax =  v.Max
            local x, y, z = zonemin.x, zonemin.y, zonemin.z
            local x2, y2, z2 = zonemax.x, zonemax.y, zonemax.z
            cam.Start3D()
                render.SetMaterial( Material("cable/redlaser"))
                render.DrawBeam( v.Min,v.Max, 20,0, 20.5, Color(255,0,0,0) )
                render.DrawBeam( Vector(x, y, z), Vector(x2, y, z), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x2, y, z), Vector(x2, y2, z), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x2, y2, z), Vector(x, y2, z), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x, y2, z), Vector(x, y, z), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x, y, z2), Vector(x2, y, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x2, y, z2), Vector(x2, y2, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x2, y2, z2), Vector(x, y2, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x, y2, z2), Vector(x, y, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x, y2, z), Vector(x, y2, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x2, y2, z), Vector(x2, y2, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x, y, z), Vector(x, y, z2), 20,0, 20.5, Color(255,0,0,255) )
                render.DrawBeam( Vector(x2, y, z), Vector(x2, y, z2), 20,0, 20.5, Color(255,0,0,255) )
            cam.End3D()
    end
end
end)
-- hook.Remove("PostDrawOpaqueRenderables", "drawZones")
-- hook.Remove("PostDrawOpaqueRenderables", "drawZones")
function DrawZoneHud( Name, Safe )
    hook.Add( "HUDPaint", "DrawZoneText", function()
        surface.SetFont("HUD::0.2vw")
        local w, h = surface.GetTextSize(Name)
        draw.SimpleText( Name, "HUD::0.2vw", ScrW() - w - 15, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        if Safe then
            surface.SetFont("HUD::0.1vw")
            local tw, th = surface.GetTextSize("Área segura")
            draw.SimpleText( "Área segura", "HUD::0.1vw", ScrW() - tw - 15, h, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        else
            surface.SetFont("HUD::0.1vw")
            local tw, th = surface.GetTextSize("Área não dominada")
            -- draw.SimpleText( "Área não dominada", "HUD::0.1vw", ScrW() - tw - 15, h, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end )
end