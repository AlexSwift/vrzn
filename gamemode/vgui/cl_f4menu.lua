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
    -- PrintTable(self.InvShop)
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
    --...........Munição.................................................
    self.AmmoCat = vgui.Create( "DCollapsibleCategory", self.Container )
    self.AmmoCat:SetExpanded( 0 )
    self.AmmoCat:SetLabel( "" )
    self.AmmoCat.Header:SetTall(26)	
    self.AmmoCat.Header.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
        end
        if self.AmmoCat:GetExpanded() then
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
    self.AmmoCat.Header.PaintOver = function()
        draw.SimpleText("Munição", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.AmmoCat.Paint = function() end
    
    ------------------
    self.AmmoList = vgui.Create("AWESOME_Grid")
    self.AmmoList:Dock(FILL)
    self.AmmoList:DockMargin(2, 10, 2, 0)
    self.AmmoList:SetColumns( 2 )
    self.AmmoList:SetHorizontalMargin( 10 )
    self.AmmoList:SetVerticalMargin( 10 )
    self.AmmoList.Paint = nil
    ------------------
    self.AmmoCat:SetContents( self.AmmoList )	
    ------------------
    
    
    
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
        print( v.Cat )
        if strCategory == "ammo" then
            --[ ammo category ]----------------------
            self.AmmoWrapper = vgui.Create("DPanel")
            self.AmmoWrapper:SetTall(60)
            self.AmmoWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end
            self.AmmoList:AddCell(self.AmmoWrapper)
            
            self.IconPanel = self.AmmoWrapper:Add("DPanel")
            self.IconPanel:Dock(LEFT)
            self.IconPanel:SetWide( 60 )
            self.IconPanel.Paint = function( pnl, w, h)
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
            end
            
            self.BuyButton = self.AmmoWrapper:Add("DButton")
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
                surface.DrawTexturedRect( 30-12, 15+6, 24, 24)
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
            self.Label = self.AmmoWrapper:Add( "DLabel" )
            self.Label:Dock(TOP)
            self.Label:SetFont("f4_Label")
            self.Label:SetTextColor( Color(255,255,255) )
            self.Label:SetText( v.Name )
            self.Label:SetTextInset(2, 1)
            self.Label:SizeToContentsY(1)
            ----
            self.PriceLabel = self.AmmoWrapper:Add( "DLabel" )
            self.PriceLabel:Dock(TOP)
            self.PriceLabel:SetFont("f4_Price")
            self.PriceLabel:SetTextColor( Color(0,255,78) )
            self.PriceLabel:SetText("R$ " .. string.Comma( v.Price ) )
            self.PriceLabel:SetTextInset(2, 0)
            self.PriceLabel:SizeToContentsY(2)
            --[ ]--
        elseif strCategory == "shipment" then
            if self.PlayerJob == "Vendedor de Armas" then
                --[ shipment category ]----------------------
                self.EntityWrapper = vgui.Create("DPanel")
                self.EntityWrapper:SetTall(60)
                self.EntityWrapper.Paint = function(pnl,w,h)
                    draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                    if v.Vip then
                        surface.SetDrawColor(255, 255, 255, 90)
                        surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                        surface.DrawTexturedRect(0, 0, w, h)
                    end
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
                    surface.DrawTexturedRect( 30-12, 15+6, 24, 24)
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
            end
        elseif strCategory == "entity" then
            --[ entity category ]--
            self.EntityWrapper = vgui.Create("DPanel")
            self.EntityWrapper:SetTall(60)
            self.EntityWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
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
                surface.DrawTexturedRect( 30-12, 15+6, 24, 24)
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
        elseif v.Cat == "drugs" then
            --[ DORGAS ]--
            self.DrugsWrapper = vgui.Create("DPanel")
            self.DrugsWrapper:SetTall(60)
            self.DrugsWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
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
                surface.DrawTexturedRect( 30-12, 15+6, 24, 24)
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
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
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
                surface.DrawTexturedRect( 30-12, 15+6, 24, 24)
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
    self.AmmoCat:DockMargin(8, 10, 8, 0)
    self.AmmoCat:Dock(TOP)
    
    self.EntityCat:DockMargin(8, 10, 8, 0)
    self.EntityCat:Dock(TOP)
    
    self.DrugsCat:DockMargin(8, 10, 8, 0)
    self.DrugsCat:Dock(TOP)
    
    self.MiscCat:DockMargin(8, 10, 8, 0)
    self.MiscCat:Dock(TOP)
    
    self.Hero:SetTall( 126 )
    
end

vgui.Register("AW_f4_SHOP", PANEL, "DPanel")


--------------------------------------------------------
-- JOBS PANEL
--------------------------------------------------------
surface.CreateFont( "f4_Job", {	font = "Montserrat Bold", extended = false, size = 28, weight = 400, antialias = true, } )
surface.CreateFont( "f4_Salary", {	font = "Montserrat Regular", extended = false, size = 26, weight = 400, antialias = true, } )
local PANEL = {}
function PANEL:Init()
    self.Container = vgui.Create("DScrollPanel", self)
    self.TblJob = GAMEMODE.Jobs.m_tblJobs
    self.PlayerJob = GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).Name
    
    self.Hero = vgui.Create("DPanel", self.Container)
    self.Hero:Dock(TOP)
    self.Hero.Paint = function(pnl, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial( Material("materials/vgui/f4/hero_shop.png") )
        surface.DrawTexturedRect(0, 0, w, 126)
        
        draw.SimpleText("EMPREGOS", "f4_Hero", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    self.CitizenCat = vgui.Create( "DCollapsibleCategory", self.Container )
    self.CitizenCat:SetExpanded( 0 )
    self.CitizenCat:SetLabel( "" )
    self.CitizenCat.Header:SetTall(26)	
    self.CitizenCat.Header.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
        end
        if self.CitizenCat:GetExpanded() then
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
    self.CitizenCat.Header.PaintOver = function()
        draw.SimpleText("Civis", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.CitizenCat.Paint = function() end
    ------------------
    self.CivilList = vgui.Create("AWESOME_Grid")
    self.CivilList:Dock(FILL)
    self.CivilList:DockMargin(2, 10, 2, 0)
    self.CivilList:SetColumns( 2 )
    self.CivilList:SetHorizontalMargin( 10 )
    self.CivilList:SetVerticalMargin( 10 )
    self.CivilList.Paint = nil
    ------------------
    self.CitizenCat:SetContents( self.CivilList )	
    ------------------
    
    --..........................................................................................................................................
    self.LawCat = vgui.Create( "DCollapsibleCategory", self.Container )
    self.LawCat:SetExpanded( 0 )
    self.LawCat:SetLabel( "" )
    self.LawCat.Header:SetTall(26)	
    self.LawCat.Header.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
        end
        if self.LawCat:GetExpanded() then
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
    self.LawCat.Header.PaintOver = function()
        draw.SimpleText("Agentes da lei", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.LawCat.Paint = function() end
    
    ------------------
    self.LawList = vgui.Create("AWESOME_Grid")
    self.LawList:Dock(FILL)
    self.LawList:DockMargin(2, 10, 2, 0)
    self.LawList:SetColumns( 2 )
    self.LawList:SetHorizontalMargin( 10 )
    self.LawList:SetVerticalMargin( 10 )
    self.LawList.Paint = nil
    ------------------
    self.LawCat:SetContents( self.LawList )	
    ------------------
    
    --...........................................................................................................................................
    self.BadCat = vgui.Create( "DCollapsibleCategory", self.Container )
    self.BadCat:SetExpanded( 0 )
    self.BadCat:SetLabel( "" )
    self.BadCat.Header:SetTall(26)	
    self.BadCat.Header.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
        end
        if self.BadCat:GetExpanded() then
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
    self.BadCat.Header.PaintOver = function()
        draw.SimpleText("Fora da lei", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.BadCat.Paint = function() end
    ------------------
    self.BadList = vgui.Create("AWESOME_Grid")
    self.BadList:Dock(FILL)
    self.BadList:DockMargin(2, 10, 2, 0)
    self.BadList:SetColumns( 2 )
    self.BadList:SetHorizontalMargin( 10 )
    self.BadList:SetVerticalMargin( 10 )
    self.BadList.Paint = nil
    ------------------
    self.BadCat:SetContents( self.BadList )	
    ------------------
    
    --...........................................................................................................................................
    self.AnyCat = vgui.Create( "DCollapsibleCategory", self.Container )
    self.AnyCat:SetExpanded( 0 )
    self.AnyCat:SetLabel( "" )
    self.AnyCat.Header:SetTall(26)	
    self.AnyCat.Header.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
        end
        if self.AnyCat:GetExpanded() then
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
    self.AnyCat.Header.PaintOver = function()
        draw.SimpleText("Outros", "f4_Cat", 16, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.AnyCat.Paint = function() end
    ------------------
    self.AnyList = vgui.Create("AWESOME_Grid")
    self.AnyList:Dock(FILL)
    self.AnyList:DockMargin(2, 10, 2, 0)
    self.AnyList:SetColumns( 2 )
    self.AnyList:SetHorizontalMargin( 10 )
    self.AnyList:SetVerticalMargin( 10 )
    self.AnyList.Paint = nil
    ------------------
    self.AnyCat:SetContents( self.AnyList )	
    ------------------
    for k, v in pairs( self.TblJob ) do
        if v.Cat == "law" then 
            --[ Cat Law ]--
            self.LawJobsWrapper = vgui.Create("DPanel")
            self.LawJobsWrapper:SetTall(80)
            self.LawJobsWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end
            self.LawList:AddCell(self.LawJobsWrapper)
            
            self.IconPanel = self.LawJobsWrapper:Add("DPanel")
            self.IconPanel:Dock(LEFT)
            self.IconPanel:SetWide( 80 )
            self.IconPanel.Paint = function( pnl, w, h)
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
            end
            
            self.BecomeButton = self.LawJobsWrapper:Add("DButton")
            self.BecomeButton:Dock(RIGHT)
            self.BecomeButton:SetWide( 80 )
            self.BecomeButton:SetText("")
            self.BecomeButton.Paint = function( pnl, w, h )
                if pnl:IsHovered() then
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
                else
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
                end
                draw.SimpleText("ENTRAR", "f4_Label", w/2, h/2, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            self.BecomeButton.DoClick = function()
                GAMEMODE.Net:RequestJobChange( v.ID )
                self:GetParent():Remove()
            end	
            -----
            self.Icon = self.IconPanel:Add("DModelPanel")
            self.Icon:Dock(FILL)
            self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
            self.PlayerSex = GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_sex", 0) == 0 and "Male" or "Female" == "Male"
            self.Icon:SetModel( GAMEMODE.Player:GetGameVar("char_model_base", "") )
            if v.PlayerModel then
                -- print("Job: ".. v.Name)
                -- PrintTable(  v.PlayerModel )
                if self.PlayerSex == "Male" then
                    self.Icon:SetModel( v.PlayerModel.Male_Fallback )
                else
                    self.Icon:SetModel( v.PlayerModel.Female_Fallback )
                end
            end
            self.Icon:SetLookAng( Angle(-16.247819900513, -183.70745849609, 0) )
            self.Icon:SetCamPos( Vector(75.659217834473, -4.6951079368591, 41.876625061035) )
            self.Icon:SetFOV(15.096068545287)
            self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
            function self.Icon:LayoutEntity( Entity ) return end
            ----
            self.Label = self.LawJobsWrapper:Add( "DLabel" )
            self.Label:Dock(TOP)
            self.Label:SetFont("f4_Job")
            self.Label:SetTextColor( Color(255,255,255) )
            self.Label:SetText( v.Name )
            self.Label:SetTextInset(2, 10)
            self.Label:SizeToContentsY(9)
            ----
            self.SalaryLabel = self.LawJobsWrapper:Add( "DLabel" )
            self.SalaryLabel:Dock(BOTTOM)
            self.SalaryLabel:SetFont("f4_Salary")
            self.SalaryLabel:SetTextColor( Color(0,255,78) )
            self.SalaryLabel:SetText("R$ " .. v.Pay[1].Pay .. " ~ "  .. v.Pay[3].Pay)
            self.SalaryLabel:SetTextInset(2, 0)
            self.SalaryLabel:SizeToContentsY(2)
        elseif v.Cat == "citizen" then
            --[ Cat Civil ]--
            self.CivilJobsWrapper = vgui.Create("DPanel")
            self.CivilJobsWrapper:SetTall(80)
            self.CivilJobsWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end
            self.CivilList:AddCell(self.CivilJobsWrapper)
            
            self.IconPanel = self.CivilJobsWrapper:Add("DPanel")
            self.IconPanel:Dock(LEFT)
            self.IconPanel:SetWide( 80 )
            self.IconPanel.Paint = function( pnl, w, h)
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
            end
            
            self.BecomeButton = self.CivilJobsWrapper:Add("DButton")
            self.BecomeButton:Dock(RIGHT)
            self.BecomeButton:SetWide( 80 )
            self.BecomeButton:SetText("")
            self.BecomeButton.Paint = function( pnl, w, h )
                if pnl:IsHovered() then
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
                else
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
                end
                draw.SimpleText("ENTRAR", "f4_Label", w/2, h/2, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            self.BecomeButton.DoClick = function()
                GAMEMODE.Net:RequestJobChange( v.ID )
                self:GetParent():Remove()
            end	
            -----
            self.Icon = self.IconPanel:Add("DModelPanel")
            self.Icon:Dock(FILL)
            self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
            self.PlayerSex = GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_sex", 0) == 0 and "Male" or "Female" == "Male"
            self.Icon:SetModel( GAMEMODE.Player:GetGameVar("char_model_base", "") )
            if v.PlayerModel then
                if self.PlayerSex == "Male" then
                    self.Icon:SetModel( v.PlayerModel.Male_Fallback )
                else
                    self.Icon:SetModel( v.PlayerModel.Female_Fallback )
                end
            end
            self.Icon:SetLookAng( Angle(-16.247819900513, -183.70745849609, 0) )
            self.Icon:SetCamPos( Vector(75.659217834473, -4.6951079368591, 41.876625061035) )
            self.Icon:SetFOV(15.096068545287)
            self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
            function self.Icon:LayoutEntity( Entity ) return end
            ----
            self.Label = self.CivilJobsWrapper:Add( "DLabel" )
            self.Label:Dock(TOP)
            self.Label:SetFont("f4_Job")
            self.Label:SetTextColor( Color(255,255,255) )
            self.Label:SetText( v.Name )
            self.Label:SetTextInset(2, 10)
            self.Label:SizeToContentsY(9)
            ----
            self.SalaryLabel = self.CivilJobsWrapper:Add( "DLabel" )
            self.SalaryLabel:Dock(BOTTOM)
            self.SalaryLabel:SetFont("f4_Salary")
            self.SalaryLabel:SetTextColor( Color(0,255,78) )
            self.SalaryLabel:SetText("R$ " .. v.Pay[1].Pay .. " ~ "  .. v.Pay[3].Pay)
            self.SalaryLabel:SetTextInset(2, 0)
            self.SalaryLabel:SizeToContentsY(2)
        elseif v.Cat == "bad" then
            --[ Cat Crime ]--
            self.BadJobsWrapper = vgui.Create("DPanel")
            self.BadJobsWrapper:SetTall(80)
            self.BadJobsWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end
            self.BadList:AddCell(self.BadJobsWrapper)
            
            self.IconPanel = self.BadJobsWrapper:Add("DPanel")
            self.IconPanel:Dock(LEFT)
            self.IconPanel:SetWide( 80 )
            self.IconPanel.Paint = function( pnl, w, h)
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
            end
            
            self.BecomeButton = self.BadJobsWrapper:Add("DButton")
            self.BecomeButton:Dock(RIGHT)
            self.BecomeButton:SetWide( 80 )
            self.BecomeButton:SetText("")
            self.BecomeButton.Paint = function( pnl, w, h )
                if pnl:IsHovered() then
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
                else
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
                end
                draw.SimpleText("ENTRAR", "f4_Label", w/2, h/2, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            self.BecomeButton.DoClick = function()
                GAMEMODE.Net:RequestJobChange( v.ID )
                self:GetParent():Remove()
            end	
            -----
            self.Icon = self.IconPanel:Add("DModelPanel")
            self.Icon:Dock(FILL)
            self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
            self.PlayerSex = GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_sex", 0) == 0 and "Male" or "Female" == "Male"
            self.Icon:SetModel( GAMEMODE.Player:GetGameVar("char_model_base", "") )
            if v.PlayerModel then
                if self.PlayerSex == "Male" then
                    self.Icon:SetModel( v.PlayerModel.Male_Fallback )
                else
                    self.Icon:SetModel( v.PlayerModel.Female_Fallback )
                end
            end
            self.Icon:SetLookAng( Angle(-16.247819900513, -183.70745849609, 0) )
            self.Icon:SetCamPos( Vector(75.659217834473, -4.6951079368591, 41.876625061035) )
            self.Icon:SetFOV(15.096068545287)
            self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
            function self.Icon:LayoutEntity( Entity ) return end
            ----
            self.Label = self.BadJobsWrapper:Add( "DLabel" )
            self.Label:Dock(TOP)
            self.Label:SetFont("f4_Job")
            self.Label:SetTextColor( Color(255,255,255) )
            self.Label:SetText( v.Name )
            self.Label:SetTextInset(2, 10)
            self.Label:SizeToContentsY(9)
            ----
            self.SalaryLabel = self.BadJobsWrapper:Add( "DLabel" )
            self.SalaryLabel:Dock(BOTTOM)
            self.SalaryLabel:SetFont("f4_Salary")
            self.SalaryLabel:SetTextColor( Color(0,255,78) )
            self.SalaryLabel:SetText("R$ " .. v.Pay[1].Pay .. " ~ "  .. v.Pay[3].Pay)
            self.SalaryLabel:SetTextInset(2, 0)
            self.SalaryLabel:SizeToContentsY(2)
        else
            --[ Cat Any ]--
            self.AnyJobsWrapper = vgui.Create("DPanel")
            self.AnyJobsWrapper:SetTall(80)
            self.AnyJobsWrapper.Paint = function(pnl,w,h)
                draw.RoundedBox(4	, 0, 0, w, h, Color(19,19,19) )
                if v.Vip then
                    surface.SetDrawColor(255, 255, 255, 90)
                    surface.SetMaterial(Material("materials/vgui/f4/vip_badge.png"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end
            self.AnyList:AddCell(self.AnyJobsWrapper)
            
            self.IconPanel = self.AnyJobsWrapper:Add("DPanel")
            self.IconPanel:Dock(LEFT)
            self.IconPanel:SetWide( 80 )
            self.IconPanel.Paint = function( pnl, w, h)
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
            end
            
            self.BecomeButton = self.AnyJobsWrapper:Add("DButton")
            self.BecomeButton:Dock(RIGHT)
            self.BecomeButton:SetWide( 80 )
            self.BecomeButton:SetText("")
            self.BecomeButton.Paint = function( pnl, w, h )
                if pnl:IsHovered() then
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,200,78), false, true, false, true)
                else
                    draw.RoundedBoxEx(4, 0, 0, w, h, Color(0,255,78), false, true, false, true)
                end
                draw.SimpleText("ENTRAR", "f4_Label", w/2, h/2, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            self.BecomeButton.DoClick = function()
                GAMEMODE.Net:RequestJobChange( v.ID )
                self:GetParent():Remove()
            end	
            -----
            self.Icon = self.IconPanel:Add("DModelPanel")
            self.Icon:Dock(FILL)
            self.Icon:SetSize( self.IconPanel:GetWide(), self.IconPanel:GetTall() )
            self.PlayerSex = GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_sex", 0) == 0 and "Male" or "Female" == "Male"
            self.Icon:SetModel( GAMEMODE.Player:GetGameVar("char_model_base", "") )
            if v.PlayerModel then
                if self.PlayerSex == "Male" then
                    self.Icon:SetModel( v.PlayerModel.Male_Fallback )
                else
                    self.Icon:SetModel( v.PlayerModel.Female_Fallback )
                end
            end
            self.Icon:SetLookAng( Angle(-16.247819900513, -183.70745849609, 0) )
            self.Icon:SetCamPos( Vector(75.659217834473, -4.6951079368591, 41.876625061035) )
            self.Icon:SetFOV(15.096068545287)
            self.Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) )
            function self.Icon:LayoutEntity( Entity ) return end
            ----
            self.Label = self.AnyJobsWrapper:Add( "DLabel" )
            self.Label:Dock(TOP)
            self.Label:SetFont("f4_Job")
            self.Label:SetTextColor( Color(255,255,255) )
            self.Label:SetText( v.Name )
            self.Label:SetTextInset(2, 10)
            self.Label:SizeToContentsY(9)
            ----
            self.SalaryLabel = self.AnyJobsWrapper:Add( "DLabel" )
            self.SalaryLabel:Dock(BOTTOM)
            self.SalaryLabel:SetFont("f4_Salary")
            self.SalaryLabel:SetTextColor( Color(0,255,78) )
            self.SalaryLabel:SetText("R$ " .. v.Pay[1].Pay .. " ~ "  .. v.Pay[3].Pay)
            self.SalaryLabel:SetTextInset(2, 0)
            self.SalaryLabel:SizeToContentsY(2)
        end
    end
    
end

function PANEL:Paint( w, h )
    
end

function PANEL:PerformLayout( w, h )
    self.Container:Dock(FILL)
    
    self.CitizenCat:DockMargin(8, 10, 8, 0)
    self.CitizenCat:Dock(TOP)
    
    self.BadCat:DockMargin(8, 10, 8, 0)
    self.BadCat:Dock(TOP)
    
    self.AnyCat:DockMargin(8, 10, 8, 0)
    self.AnyCat:Dock(TOP)
    
    self.LawCat:DockMargin(8, 10, 8, 0)
    self.LawCat:Dock(TOP)
    
    self.Hero:SetTall( 126 )
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