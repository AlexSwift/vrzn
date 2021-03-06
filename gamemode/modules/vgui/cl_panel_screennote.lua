--[[
	Name: cl_panel_screennote.lua
	For: TalosLife
	By: Team Garry, Rustic7
]]--
surface.CreateFont( "NotifyFont", {	font = "Montserrat Bold",	extended = false,	size = 22,	weight = 500,	antialias = true } )
local Panel = {}
function Panel:Init()
	self.m_pnlLabel = vgui.Create( "DLabel", self )
	self.m_pnlLabel:SetFont( "NotifyFont" )
	self.m_pnlLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.m_pnlLabel:SetExpensiveShadow( 0, Color( 0, 0, 0, 200 ) )
	self.m_pnlLabel:SetContentAlignment( 5 )
	
	self:SetBackgroundColor( Color( 20, 20, 20, 255*0.6 ) )
end

function Panel:SetText( txt )
	self.m_pnlLabel:SetText( txt )
	self:SizeToContentsX()
end

function Panel:SizeToContents()
	self.m_pnlLabel:SizeToContents()
	local width = self.m_pnlLabel:GetWide()
	if IsValid( self.m_pnlImage ) then
		width = width +32 + 32
	end
	
	width = width +20
	self:SetWidth( width )
	self:SetHeight( 32 +6 )
	
	self:InvalidateLayout()
end

function Panel:SetType( t )
	self.m_pnlImage = vgui.Create( "DImageButton", self )
	self.m_pnlImage:SetMaterial( GAMEMODE.HUD.m_tblNoticeMaterial[t] )
	self.m_pnlImage:SetSize( 64, 64 )
	self.m_pnlImage.DoClick = function()
		self.StartTime = 0
	end
	
	self:SizeToContents()
end

function Panel:KillSelf()
	if self.StartTime +self.Length < SysTime() then
		self:Remove()
		return true
	end

	return false
end

function Panel:Paint( intW, intH )
	
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	-- GAMEMODE.HUD:DrawFancyRect( 0, 0, intW, intH, 110, 90 )
	draw.RoundedBox(4, 0, 0, intW, intH, Color(255,255,255) )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		surface.SetMaterial( GAMEMODE.HUD.m_matBlur )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i = 0, 1, 0.33 do
			GAMEMODE.HUD.m_matBlur:SetFloat( '$blur', 5 *i )
			GAMEMODE.HUD.m_matBlur:Recompute()
			render.UpdateScreenEffectTexture()

			local x, y = self:GetPos()
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
	render.SetStencilEnable( false )

	surface.SetDrawColor( 5, 5, 5, 20 )
	-- GAMEMODE.HUD:DrawFancyRect( 0, 0, intW, intH, 110, 90 )
	local start = self.StartTime
	local finish = self.StartTime + self.Length
	local curtime = SysTime()
	local fraction = math.TimeFraction(start, finish, curtime)
	-- print( fraction )

	draw.RoundedBox(0, 48, 0, fraction * intW, intH, Color(26,26,26,200))
	
	draw.RoundedBoxEx(16, 0, 0, 32 + 32, intH, Color(26,26,26,255), true, false, true, false)
	


end

function Panel:PerformLayout( intW, intH )
	self:SetTall(60)

	local padding = 10
	self.m_pnlLabel:SizeToContents()
	self.m_pnlLabel:SetPos( intW -self.m_pnlLabel:GetWide() -padding, (intH /2) -(self.m_pnlLabel:GetTall() /2) )

	local leftInset = 16
	self.m_pnlImage:SetSize( 32, 32 )
	self.m_pnlImage:SetPos( leftInset, (intH /2) -(self.m_pnlImage:GetTall() /2) )
end

vgui.Register( "SRPNoticePanel", Panel, "DPanel" )