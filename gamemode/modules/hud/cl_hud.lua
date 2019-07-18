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
	
	GAMEMODE.Jail:PaintJailedHUD()
	self:DrawChopShopOverlay()
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
surface.CreateFont( "Chatbox", {font = "Montserrat Regular", size = 16,	weight = 500, antialias = true } )
surface.CreateFont( "Chatbox2", {font = "Montserrat Bold", size = 16,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.075vw", {	font = "Montserrat Regular", size = 0.75 * vw,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.1vw", {	font = "Montserrat Regular", size = vw * 0.1,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.2vw", {	font = "Montserrat Regular", size = vw * 0.2,	weight = 500, antialias = true } )
surface.CreateFont( "HUD::0.3vw", {	font = "Montserrat Regular", size = vw * 0.3,	weight = 500, antialias = true } )

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
	
	local HudMargin = 20
	surface.CreateFont( "XPHudLabel", {	font = "Montserrat Bold",	extended = false,	size = 28,	weight = 500,	antialias = true,	} )
	surface.CreateFont( "NameHudLabel", {	font = "Montserrat Bold",	extended = false,	size = 36,	weight = 500,	antialias = true,	} )
	surface.CreateFont( "MoneyHudLabel", {	font = "Montserrat Bold",	extended = false,	size = 28,	weight = 500,	antialias = true,	} )
	surface.CreateFont( "BankHudLabel", {	font = "Montserrat Regular",	extended = false,	size = 34,	weight = 500,	antialias = true,	} )
	surface.CreateFont( "SalaryHudLabel", {	font = "Montserrat Regular",	extended = false,	size = 22,	weight = 500,	antialias = true,	} )	

	

	function AwDownload(filename, url, callback, errorCallback)
		local path = "threebow/downloads/"..filename
		local dPath = "data/"..path
	
		if(file.Exists(path, "DATA")) then return callback(dPath) end
		if(!file.IsDir(string.GetPathFromFilename(path), "DATA")) then file.CreateDir(string.GetPathFromFilename(path)) end
	
		errorCallback = errorCallback || function(reason)
			error("Threebow Lib: Download de arquivo falho ("..url..") ("..reason..")")
		end
	
		http.Fetch(url, function(body, size, headers, code)
			if(code != 200) then return errorCallback(code) end
			file.Write(path, body)
			callback(dPath)
		end, errorCallback)
	end

	hook.Add("GamemodeGameStatusChanged", "DrawHudAfterLoading", function()
		local steamid = LocalPlayer():SteamID64()
		if steamid == "1234567890" then steamid = "76561198119350635" end

		awcache.AvatarLoader.GetMaterial( steamid, function(mat)
			awcache.AvatarLoader.CachedMaterials[steamid] = mat
		end)
		
		local AwMaterialAvatar = awcache.AvatarLoader.CachedMaterials[steamid]
		local  SmoothXpBar = 0
		local  SmoothHpBar = 0
		local  SmoothArmorBar = 0
		hook.Add("HUDPaint", "Testing", function()
			local NicePlayerName = string.Explode( " ", LocalPlayer():Nick() )

			local Health = LocalPlayer():Health()
			local MaxHealth = LocalPlayer():GetMaxHealth()

			local Armor = LocalPlayer():Armor()
			local MaxArmor = 100

			local Level = GAMEMODE.Skills:GetPlayerLevel("1 Nível do Personagem")
			local XP = GAMEMODE.Skills:GetPlayerXP("1 Nível do Personagem") - GAMEMODE.Skills:GetXPForLevel( "1 Nível do Personagem", GAMEMODE.Skills:GetPlayerLevel("1 Nível do Personagem") -1 )
			local BaseXP = GAMEMODE.Skills:GetXPForLevel( "1 Nível do Personagem", GAMEMODE.Skills:GetPlayerLevel("1 Nível do Personagem") -1 )
			local MaxXP = GAMEMODE.Skills:GetXPForLevel( "1 Nível do Personagem", GAMEMODE.Skills:GetPlayerLevel("1 Nível do Personagem") ) - BaseXP
			
			local job = GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() )
			local salary1 = "R$ " .. string.VrznMoney( GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).Pay[1].Pay )
			local salary2 = "R$ " .. string.VrznMoney( GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).Pay[4].Pay )

			local Money = "R$ " .. string.VrznMoney( LocalPlayer():GetMoney() )
			local Bank = "R$ " .. string.VrznMoney( LocalPlayer():GetBankMoney() )

			// AVATAR

			SmoothXpBar=Lerp(2*RealFrameTime(),SmoothXpBar,(1 - XP/MaxXP) * 360)

			AwMaskInverse(
				function()
					surface.SetDrawColor(255, 255, 255, 255)
					-- surface.DrawRect(HudMargin/2, ScrH() - HudMargin - 110, 150, (1 - XP/MaxXP) * 120)
					AwArc(50 + HudMargin, ScrH() - 50 - HudMargin, 0, SmoothXpBar, 58, Color(255,255,255), 30, "XPBar")
				end
				,
				function()
					AwCircle( 50 + HudMargin, ScrH() - 50 - HudMargin, 55, Color(67, 255, 124))
				end
			)

			AwMask( 
				function()
					AwCircle( 50 + HudMargin, ScrH() - 50 - HudMargin, 50, Color(255,0,0))
					
				end
			, 
				function()
					surface.SetDrawColor(255, 255, 255, 255)
					if AwMaterialAvatar then
						surface.SetMaterial( AwMaterialAvatar )
					end
					surface.DrawTexturedRect(HudMargin, ScrH() - HudMargin - 100 , 100, 100)
				end
			)

			// Nível :)
			AwCircle( Circle["XPBar"].x, Circle["XPBar"].y, 15, Color(26,26,26))
			draw.SimpleText(GAMEMODE.Skills:GetPlayerLevel("1 Nível do Personagem"), "XPHudLabel", Circle["XPBar"].x, Circle["XPBar"].y-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			// Nome
			draw.SimpleText(NicePlayerName[1] .. " " .. NicePlayerName[2], "NameHudLabel", HudMargin + 100 + 17, ScrH() - HudMargin - 99, Color(50,50,50), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText(NicePlayerName[1] .. " " .. NicePlayerName[2], "NameHudLabel", HudMargin + 100 + 16, ScrH() - HudMargin - 100, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			

			// HP
			draw.RoundedBox(6, HudMargin + 100 + 16, ScrH() - HudMargin - 60, 200, 12, Color(46,46,46))
			if Health > MaxHealth then Health = 100 end
			SmoothHpBar = Lerp( 5 * RealFrameTime(), SmoothHpBar, (Health/MaxHealth) * 200)
			draw.RoundedBox(6, HudMargin + 100 + 16, ScrH() - HudMargin - 60, SmoothHpBar, 12, Color(255,56,56))
			
			// Armor
			draw.RoundedBox(6, HudMargin + 100 + 16, ScrH() - HudMargin - 40, 200, 12, Color(46,46,46))
			if Armor > MaxArmor then Armor = 100 end
			SmoothArmorBar = Lerp( 5 * RealFrameTime(), SmoothArmorBar, (Armor/MaxArmor) * 200)
			draw.RoundedBox(6, HudMargin + 100 + 16, ScrH() - HudMargin - 40, SmoothArmorBar, 12, Color(82,192,249))
			
			// Monetary
			surface.SetFont("BankHudLabel")
			local bw, bh = surface.GetTextSize(Bank)
			draw.SimpleText(Money, "MoneyHudLabel", HudMargin + 100 + 16, ScrH() - bh - HudMargin + 5, Color(0,255,78), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(" - ".. salary1 .. "/hr", "MoneyHudLabel", HudMargin + 100 + bw, ScrH() - bh - HudMargin + 5, Color(0,255,78, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			-- draw.SimpleText(Bank , "BankHudLabel", HudMargin, 28, Color(0,255,78), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			-- draw.SimpleText("+ " .. salary1 .. "/hr", "SalaryHudLabel", HudMargin + bw + 6, bh, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				
		end)
	end)

	function hudrefresh()
		hook.Run("GamemodeGameStatusChanged")
	end
		concommand.Add("restorehud", hudrefresh)