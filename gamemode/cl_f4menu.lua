local PANEL = {}
surface.CreateFont( "f4_Hero", {	font = "Montserrat Bold", extended = false, size = 36, weight = 500, antialias = true, } )
surface.CreateFont( "f4_Cat", {	font = "Montserrat Bold", extended = false, size = 22, weight = 500, antialias = true, } )
function PANEL:Init()

	self.Container = vgui.Create("DScrollPanel", self)
	self.Container:Dock(FILL)
	

	self.Hero = vgui.Create("DPanel", self.Container)
	self.Hero:Dock(TOP)
	self.Hero.Paint = function(pnl, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial( Material("materials/vgui/f4/hero_shop.png") )
		surface.DrawTexturedRect(0, 0, w, 126)

		draw.SimpleText("ITENS E ENTIDADES", "f4_Hero", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.EntityCat = vgui.Create( "DCollapsibleCategory", self.Container )
	self.EntityCat:SetExpanded( 0 )
	self.EntityCat:SetLabel( "" )
	self.EntityCat.Header:SetTall(26)	
	self.EntityCat.Header.Paint = function(pnl, w, h)
		if pnl:IsHovered() then
			draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
		end
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial( Material("materials/vgui/f4/pointer.png") )
		if self.EntityCat:GetExpanded() then
			surface.DrawTexturedRectRotated(w - 16, 16-2, 16, 16, 90)
			-- surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		else
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		end
	end
	self.EntityCat.Header.PaintOver = function()
		draw.SimpleText("Carregamentos", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	self.EntityCat.Paint = function() end

	------------------
	self.EntityPanel = vgui.Create( "SRP_ScrollPanel", DermaPanel )
	------------------
	self.EntityCat:SetContents( self.EntityPanel )	

		

end

-- function ()
-- end
function PANEL:Paint( w, h )
	draw.RoundedBox(0, 0, 0, w, h, Color(33,33,33) )
end

function PANEL:PerformLayout(w, h )
	self.EntityCat:DockMargin(8, 24, 8, 0)
	self.EntityCat:Dock(TOP)

	self.Hero:SetTall( 126 )

end

vgui.Register("AW_f4_SHOP", PANEL, "DPanel")


local PANEL = {}
function PANEL:Init()
end

function PANEL:Paint( w, h )
	
end

function PANEL:PerformLayout( w, h )
end

vgui.Register("AW_f4_JOBS", PANEL, "DPanel")


local PANEL = {}
function PANEL:Init()
end

function PANEL:Paint( w, h )
end

function PANEL:PerformLayout( w, h )
end

vgui.Register("AW_f4_COMMANDS", PANEL, "DPanel")