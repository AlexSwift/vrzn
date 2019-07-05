local PANEL = {}
surface.CreateFont( "f4_Hero", {	font = "Montserrat Bold", extended = false, size = 36, weight = 400, antialias = true, } )
surface.CreateFont( "f4_Cat", {	font = "Montserrat Bold", extended = false, size = 22, weight = 400, antialias = true, } )
surface.CreateFont( "f4_Label", {	font = "Montserrat Bold", extended = false, size = 22, weight = 400, antialias = true, } )
surface.CreateFont( "f4_Price", {	font = "Montserrat Regular", extended = false, size = 22, weight = 400, antialias = true, } )
function PANEL:Init()
	self.InvShop = {}
	for k, v in pairs( GAMEMODE.Inv.m_tblItemRegister ) do 
		if v.F4 == true then
			-- print(v.Value)
			Item = { { Name = v.Name, Cat = v.Cat, Model = v.Model, Price = v.Value, } }
			table.Add( self.InvShop, Item )
		end
	end
	PrintTable(self.InvShop)
	self.PlayerJob = GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).Name
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
--...........CARREGAMENTO.................................................
if self.PlayerJob == "Vendedor de Armas" then
	self.ShipmentCat = vgui.Create( "DCollapsibleCategory", self.Container )
	self.ShipmentCat:SetExpanded( 0 )
	self.ShipmentCat:SetLabel( "" )
	self.ShipmentCat.Header:SetTall(26)	
	self.ShipmentCat.Header.Paint = function(pnl, w, h)
		if pnl:IsHovered() then
			draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
		end
		if self.ShipmentCat:GetExpanded() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
			-- surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/right-pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		end
	end
	self.ShipmentCat.Header.PaintOver = function()
		draw.SimpleText("Carregamentos", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	self.ShipmentCat.Paint = function() end

	------------------
	self.ShipmentList = vgui.Create("AWESOME_Grid")
	self.ShipmentList:Dock(FILL)
	self.ShipmentList:DockMargin(2, 10, 2, 0)
	self.ShipmentList:SetColumns( 2 )
	self.ShipmentList:SetHorizontalMargin( 10 )
	self.ShipmentList:SetVerticalMargin( 10 )
	self.ShipmentList.Paint = nil
	------------------
	self.ShipmentCat:SetContents( self.ShipmentList )	
	------------------
end

--............ENTIDADE................................................
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
		if self.EntityCat:GetExpanded() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
			-- surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/right-pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		end
	end
	self.EntityCat.Header.PaintOver = function()
		draw.SimpleText("Entidades", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	self.EntityCat.Paint = function() end

	------------------
	self.EntityList = vgui.Create("AWESOME_Grid")
	self.EntityList:Dock(FILL)
	self.EntityList:DockMargin(2, 10, 2, 0)
	self.EntityList:SetColumns( 2 )
	self.EntityList:SetHorizontalMargin( 10 )
	self.EntityList:SetVerticalMargin( 10 )
	self.EntityList.Paint = nil
	------------------
	self.EntityCat:SetContents( self.EntityList )	
	------------------

--............DORGAS................................................
	self.DrugsCat = vgui.Create( "DCollapsibleCategory", self.Container )
	self.DrugsCat:SetExpanded( 0 )
	self.DrugsCat:SetLabel( "" )
	self.DrugsCat.Header:SetTall(26)	
	self.DrugsCat.Header.Paint = function(pnl, w, h)
		if pnl:IsHovered() then
			draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
		end
		if self.DrugsCat:GetExpanded() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
			-- surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/right-pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		end
	end
	self.DrugsCat.Header.PaintOver = function()
		draw.SimpleText("Drogas", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	self.DrugsCat.Paint = function() end

	------------------
	self.DrugsList = vgui.Create("AWESOME_Grid")
	self.DrugsList:Dock(FILL)
	self.DrugsList:DockMargin(2, 10, 2, 0)
	self.DrugsList:SetColumns( 2 )
	self.DrugsList:SetHorizontalMargin( 10 )
	self.DrugsList:SetVerticalMargin( 10 )
	self.DrugsList.Paint = nil
	------------------
	self.DrugsCat:SetContents( self.DrugsList )	
	------------------

--............OUTROS................................................
	self.MiscCat = vgui.Create( "DCollapsibleCategory", self.Container )
	self.MiscCat:SetExpanded( 0 )
	self.MiscCat:SetLabel( "" )
	self.MiscCat.Header:SetTall(26)	
	self.MiscCat.Header.Paint = function(pnl, w, h)
		if pnl:IsHovered() then
			draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
		end
		if self.MiscCat:GetExpanded() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
			-- surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( Material("materials/vgui/f4/right-pointer.png") )
			surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
		end
	end
	self.MiscCat.Header.PaintOver = function()
		draw.SimpleText("Outros", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	self.MiscCat.Paint = function() end

	------------------
	self.MiscList = vgui.Create("AWESOME_Grid")
	self.MiscList:Dock(FILL)
	self.MiscList:DockMargin(2, 10, 2, 0)
	self.MiscList:SetColumns( 2 )
	self.MiscList:SetHorizontalMargin( 10 )
	self.MiscList:SetVerticalMargin( 10 )
	self.MiscList.Paint = nil
	------------------
	self.MiscCat:SetContents( self.MiscList )	
	------------------


	self:Populate( self.InvShop )
end

function PANEL:Populate( tblItems )
	for k, v in pairs( tblItems ) do
		local strCategory = v.Cat

		if strCategory == "shipment" then
			if self.PlayerJob == "Vendedor de Armas" then
		--[ shipment category ]----------------------
			self.EntityWrapper = vgui.Create("DPanel")
			self.EntityWrapper:SetTall(60)
			self.EntityWrapper.Paint = function(pnl,w,h)
				draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
			end
			self.ShipmentList:AddCell(self.EntityWrapper)

			self.IconPanel = self.EntityWrapper:Add("DPanel")
			self.IconPanel:Dock(LEFT)
			self.IconPanel:SetWide( 60 )
			self.IconPanel.Paint = function( pnl, w, h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
			end
			
			self.BuyButton = self.EntityWrapper:Add("DButton")
			self.BuyButton:Dock(RIGHT)
			self.BuyButton:SetWide( 60 )
			self.BuyButton:SetText("")
			self.BuyButton.Paint = function( pnl, w, h )
				if pnl:IsHovered() then
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
				else
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
				end
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( Material("materials/vgui/icons/buy.png") )
				surface.DrawTexturedRect(self.BuyButton:GetWide()/2 -12, (self.BuyButton:GetTall()/2)+6, 24, 24)
			end
			self.BuyButton.DoClick = function()
			end	
			-----
			self.Icon = self.IconPanel:Add("DModelPanel")
			self.Icon:Dock(FILL)
			self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
			self.Icon:SetModel( v.Model )
			self.Icon:SetLookAng( Angle(26.631, -41.827, 0.000) )
			self.Icon:SetCamPos( Vector(-54.672073, 48.589230, 46.368576 ) )
			self.Icon:SetFOV(35.637013445461)
			self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
			function self.Icon:LayoutEntity( Entity ) return end
			----
			self.Label = self.EntityWrapper:Add( "DLabel" )
			self.Label:Dock(TOP)
			self.Label:SetFont("f4_Label")
			self.Label:SetTextColor( Color(255,255,255) )
			self.Label:SetText( v.Name )
			self.Label:SetTextInset(2, 1)
			self.Label:SizeToContentsY(1)
			----
			self.PriceLabel = self.EntityWrapper:Add( "DLabel" )
			self.PriceLabel:Dock(TOP)
			self.PriceLabel:SetFont("f4_Price")
			self.PriceLabel:SetTextColor( Color(0,255,78) )
			self.PriceLabel:SetText("R$ " .. string.Comma( v.Price ) )
			self.PriceLabel:SetTextInset(2, 0)
			self.PriceLabel:SizeToContentsY(2)
		--[ ]--
		elseif strCategory == "entity" then
		--[ entity category ]--
			self.EntityWrapper = vgui.Create("DPanel")
			self.EntityWrapper:SetTall(60)
			self.EntityWrapper.Paint = function(pnl,w,h)
				draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
			end
			self.EntityList:AddCell(self.EntityWrapper)

			self.IconPanel = self.EntityWrapper:Add("DPanel")
			self.IconPanel:Dock(LEFT)
			self.IconPanel:SetWide( 60 )
			self.IconPanel.Paint = function( pnl, w, h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
			end
			
			self.BuyButton = self.EntityWrapper:Add("DButton")
			self.BuyButton:Dock(RIGHT)
			self.BuyButton:SetWide( 60 )
			self.BuyButton:SetText("")
			self.BuyButton.Paint = function( pnl, w, h )
				if pnl:IsHovered() then
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
				else
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
				end
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( Material("materials/vgui/icons/buy.png") )
				surface.DrawTexturedRect(self.BuyButton:GetWide()/2 -12, self.BuyButton:GetTall()/2-12, 24, 24)
			end
			self.BuyButton.DoClick = function()
			end	
			-----
			self.Icon = self.IconPanel:Add("DModelPanel")
			self.Icon:Dock(FILL)
			self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
			self.Icon:SetModel( v.Model )
			self.Icon:SetLookAng( Angle(26.631, -41.827, 0.000) )
			self.Icon:SetCamPos( Vector(-54.672073, 48.589230, 46.368576 ) )
			self.Icon:SetFOV(35.637013445461)
			self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
			function self.Icon:LayoutEntity( Entity ) return end
			----
			self.Label = self.EntityWrapper:Add( "DLabel" )
			self.Label:Dock(TOP)
			self.Label:SetFont("f4_Label")
			self.Label:SetTextColor( Color(255,255,255) )
			self.Label:SetText( v.Name )
			self.Label:SetTextInset(2, 1)
			self.Label:SizeToContentsY(1)
			----
			self.PriceLabel = self.EntityWrapper:Add( "DLabel" )
			self.PriceLabel:Dock(TOP)
			self.PriceLabel:SetFont("f4_Price")
			self.PriceLabel:SetTextColor( Color(0,255,78) )
			self.PriceLabel:SetText("R$ " .. string.Comma( v.Price ) )
			self.PriceLabel:SetTextInset(2, 0)
			self.PriceLabel:SizeToContentsY(2)
		end
		elseif v.Cat == "drugs" then
			--[ DORGAS ]--
			self.DrugsWrapper = vgui.Create("DPanel")
			self.DrugsWrapper:SetTall(60)
			self.DrugsWrapper.Paint = function(pnl,w,h)
				draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
			end
			self.DrugsList:AddCell(self.DrugsWrapper)

			self.IconPanel = self.DrugsWrapper:Add("DPanel")
			self.IconPanel:Dock(LEFT)
			self.IconPanel:SetWide( 60 )
			self.IconPanel.Paint = function( pnl, w, h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
			end
			
			self.BuyButton = self.DrugsWrapper:Add("DButton")
			self.BuyButton:Dock(RIGHT)
			self.BuyButton:SetWide( 60 )
			self.BuyButton:SetText("")
			self.BuyButton.Paint = function( pnl, w, h )
				if pnl:IsHovered() then
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
				else
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
				end
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( Material("materials/vgui/icons/buy.png") )
				surface.DrawTexturedRect(self.BuyButton:GetWide()/2 -12, self.BuyButton:GetTall()/2-12, 24, 24)
			end
			self.BuyButton.DoClick = function()
				GAMEMODE.Net:RequestBuyF4Item( v.Name, v.Price )
			end	
			-----
			self.Icon = self.IconPanel:Add("DModelPanel")
			self.Icon:Dock(FILL)
			self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
			self.Icon:SetModel( v.Model )
			self.Icon:SetLookAng( Angle(26.631, -41.827, 0.000) )
			self.Icon:SetCamPos( Vector(-54.672073, 48.589230, 46.368576 ) )
			self.Icon:SetFOV(35.637013445461)
			self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
			function self.Icon:LayoutEntity( Entity ) return end
			----
			self.Label = self.DrugsWrapper:Add( "DLabel" )
			self.Label:Dock(TOP)
			self.Label:SetFont("f4_Label")
			self.Label:SetTextColor( Color(255,255,255) )
			self.Label:SetText( v.Name )
			self.Label:SetTextInset(2, 1)
			self.Label:SizeToContentsY(1)
			----
			self.PriceLabel = self.DrugsWrapper:Add( "DLabel" )
			self.PriceLabel:Dock(TOP)
			self.PriceLabel:SetFont("f4_Price")
			self.PriceLabel:SetTextColor( Color(0,255,78) )
			self.PriceLabel:SetText("R$ " .. string.Comma( v.Price ) )
			self.PriceLabel:SetTextInset(2, 0)
			self.PriceLabel:SizeToContentsY(2)

		else
			--[ Any category ]--
			self.MiscWrapper = vgui.Create("DPanel")
			self.MiscWrapper:SetTall(60)
			self.MiscWrapper.Paint = function(pnl,w,h)
				draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
			end
			self.MiscList:AddCell(self.MiscWrapper)

			self.IconPanel = self.MiscWrapper:Add("DPanel")
			self.IconPanel:Dock(LEFT)
			self.IconPanel:SetWide( 60 )
			self.IconPanel.Paint = function( pnl, w, h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
			end
			
			self.BuyButton = self.MiscWrapper:Add("DButton")
			self.BuyButton:Dock(RIGHT)
			self.BuyButton:SetWide( 60 )
			self.BuyButton:SetText("")
			self.BuyButton.Paint = function( pnl, w, h )
				if pnl:IsHovered() then
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
				else
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
				end
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( Material("materials/vgui/icons/buy.png") )
				surface.DrawTexturedRect(self.BuyButton:GetWide()/2 -12, self.BuyButton:GetTall()/2-12, 24, 24)
			end
			self.BuyButton.DoClick = function()
			end	
			-----
			self.Icon = self.IconPanel:Add("DModelPanel")
			self.Icon:Dock(FILL)
			self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
			self.Icon:SetModel( v.Model )
			self.Icon:SetLookAng( Angle(26.631, -41.827, 0.000) )
			self.Icon:SetCamPos( Vector(-54.672073, 48.589230, 46.368576 ) )
			self.Icon:SetFOV(35.637013445461)
			self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
			function self.Icon:LayoutEntity( Entity ) return end
			----
			self.Label = self.MiscWrapper:Add( "DLabel" )
			self.Label:Dock(TOP)
			self.Label:SetFont("f4_Label")
			self.Label:SetTextColor( Color(255,255,255) )
			self.Label:SetText( v.Name )
			self.Label:SetTextInset(2, 1)
			self.Label:SizeToContentsY(1)
			----
			self.PriceLabel = self.MiscWrapper:Add( "DLabel" )
			self.PriceLabel:Dock(TOP)
			self.PriceLabel:SetFont("f4_Price")
			self.PriceLabel:SetTextColor( Color(0,255,78) )
			self.PriceLabel:SetText("R$ " .. string.Comma( v.Price ) )
			self.PriceLabel:SetTextInset(2, 0)
			self.PriceLabel:SizeToContentsY(2)
		end
	end

end

function PANEL:Paint( w, h )
	draw.RoundedBox(0, 0, 0, w, h, Color(33,33,33) )
end

function PANEL:PerformLayout(w, h )
	if self.PlayerJob == "Vendedor de Armas" then
		self.ShipmentCat:DockMargin(8, 10, 8, 0)
		self.ShipmentCat:Dock(TOP)
	end
	self.EntityCat:DockMargin(8, 10, 8, 0)
	self.EntityCat:Dock(TOP)

	self.DrugsCat:DockMargin(8, 10, 8, 0)
	self.DrugsCat:Dock(TOP)

	self.MiscCat:DockMargin(8, 10, 8, 0)
	self.MiscCat:Dock(TOP)

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