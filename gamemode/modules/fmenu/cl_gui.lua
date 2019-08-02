local vw = ScrW() 
surface.CreateFont( "F4::Title", {	font = "Montserrat Bold", extended = false,	size = vw * 0.015,	weight = 500,	antialias = true, } )
surface.CreateFont( "F4::SubTitle", {	font = "Montserrat Regular", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
surface.CreateFont( "F4::Nav", {	font = "Montserrat Bold", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )

surface.CreateFont( "F4::CatHeader", {	font = "Montserrat Regular", extended = false,	size = vw * 0.02,	weight = 500,	antialias = true, } )
surface.CreateFont( "F4::JobName", {	font = "Montserrat Regular", extended = false,	size = vw * 0.02,	weight = 500,	antialias = true, } )

surface.CreateFont( "F4::RulesHeader", {	font = "Montserrat Bold", extended = false,	size = vw * 0.1,	weight = 500,	antialias = true, } )
surface.CreateFont( "F4::RulesText", {	font = "Montserrat Regular", extended = false,	size = vw * 0.015,	weight = 500,	antialias = true, } )
------------------------------------------------------------
-- MAIN WINDOW MAIN WINDOW MAIN WINDOW MAIN WINDOW MAIN WIND
------------------------------------------------------------

local panel = {}

function panel:Init()
    
end

function panel:PerformLayout(w, h)
    
end

function panel:Paint(w,h)
    draw.RoundedBox( 0, 0, 0, w, h, Color(26,26,26) )
end

vgui.Register("F4::Frame", panel, "EditablePanel")



------------------------------------------------------------
-- NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR N
------------------------------------------------------------

local panel = {}

AccessorFunc(panel, "n_body", "NavBody")

function panel:Init()
    self.Buttons = {}
    self.Panels = {}

    self.Title = self:Add("DPanel")
    self.Title.Paint = function( _ , w, h )
        surface.SetFont("F4::Title")
        local tw, th = surface.GetTextSize("F4 MENU")

        surface.SetFont("F4::SubTitle")
        local tw2, th2 = surface.GetTextSize("Majestic.BRASILRP")

        draw.SimpleText("F4 MENU", "F4::Title", 22, (self:GetTall()/2) - (th/2), Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Majestic.BRASILRP", "F4::SubTitle", 22, (self:GetTall()/2) + (th2/2), Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(100, 100, 100, 100)
        surface.DrawRect( w-1, h/4, 1, h/2)
    end

    self.Close = self:Add("DButton")
    self.Close:SetTextColor( Color(200, 60, 60, 255) )
    self.Close:SetFont("F4::Nav")
    self.Close:SetText("FECHAR")
    self.Close.DoClick = function()
        gui.EnableScreenClicker(false)
        self:GetParent():SetVisible(false)
    end
    self.Close.OnCursorEntered = function( _, w, h)
            _:SetTextColor( Color(255, 255, 255, 255) )
    end
    self.Close.OnCursorExited = function( _, w, h)
        _:SetTextColor( Color(200, 60, 60, 255) )
    end
    self.Close.Paint = nil
    

end


function panel:AddMenu( Name, panel )

    local bLerp = 0
    local rbLerp = 255
    local i = table.Count(self.Buttons) + 1
    self.Buttons[i] = self:Add("DButton")
    local dButton = self.Buttons[i]
    dButton.id = i
    dButton:SetFont("F4::Nav")
    dButton:SetText( Name )
    dButton:Dock(LEFT)
    dButton:SizeToContentsX(ScrW()*0.03)
    dButton.Paint = function( _, w, h)
        if self.active == _.id then 
            bLerp = Lerp( RealFrameTime()*3, bLerp, 255 )
            _:SetTextColor( Color( bLerp, bLerp, bLerp ) )
        else
            bLerp = Lerp( RealFrameTime()*3, bLerp, 255 )
            _:SetTextColor( Color( 150, 150, 150 ) )
        end
    end
    dButton.DoClick = function(pnl)
        bLerp = 150
        self:SetInactive(self.active, pnl.id)
        self:SetActive( pnl.id, self.active )

    end

    self.Panels[i] = self:GetNavBody():Add( panel or "DPanel")
    panel = self.Panels[i]

    panel:SetSize( self:GetNavBody():GetWide(), self:GetNavBody():GetTall() - self:GetTall() )
    if i ~= 1 then
        panel:SetPos( self:GetNavBody():GetWide(), self:GetTall() )
    else
        panel:SetPos( 0, self:GetTall())
    end
    panel:SetVisible( true )
       
            

end
function panel:SetInactive(id,newid)
 
    local dButton = self.Buttons[id]
    if ( !IsValid( dButton ) ) then return end
    local inactiveButton = self.Buttons[self.active]
    if ( IsValid( inactiveButton ) ) then
        if ( IsValid( inactiveButton ) ) then

            local inactivePanel = self.Panels[self.active]
            if ( IsValid( inactivePanel ) ) then
                inactivePanel:SetVisible(true)
            end
            
        end
    end
    if newid == id then return end
    if newid > id then
        local OldPanel = self.Panels[id]
        -- OldPanel:SetPos( 0, sel  f:GetTall() )
        OldPanel:MoveTo(-self:GetNavBody():GetWide(), self:GetTall(), 0.2, 0, 1, function() end)
    else
        local OldPanel = self.Panels[id]
    --     OldPanel:SetPos( self:GetNavBody():GetWide(), self:GetTall() )
        OldPanel:MoveTo( self:GetNavBody():GetWide(), self:GetTall(), 0.2, 0, 1, function() end)
    end
end

function panel:SetActive(id,oldid)
 
    local dButton = self.Buttons[id]
    if ( !IsValid( dButton ) ) then return end
    local activeButton = self.Buttons[self.active]
    if ( IsValid( activeButton ) ) then

        local activePanel = self.Panels[self.active]
        if ( IsValid( activePanel ) ) then
            activePanel:SetVisible(true)
        end
        
    end
    oldid = oldid or 0
    self.active = id
    -- if oldid < id then
        local Panel = self.Panels[id]
        -- Panel:SetPos( self:GetNavBody():GetWide(), self:GetTall() )
        Panel:MoveTo(0, self:GetTall(), 0.2, 0, 1, function() end)
        Panel:SetVisible(true)
    -- else
    --     local Panel = self.Panels[id]
    --     Panel:SetPos( 0, self:GetTall() )
    --     Panel:MoveTo(self:GetNavBody():GetWide(), self:GetTall(), 1, 0, 1, function() end)
    --     Panel:SetVisible(true)
    -- end
 
        
    -- Panel:SetVisible(true)
    
end



function panel:Paint(w,h)
local aw, ah = self:LocalToScreen()
        BSHADOWS.BeginShadow()
            surface.SetDrawColor(26, 26, 26, 255)
            surface.DrawRect(aw, ah, w, h)
        BSHADOWS.EndShadow(1, 1, 3, 200)
end

function panel:PerformLayout(w, h)
    self.Title:Dock(LEFT)
    self.Title:SetWide( ScrW() * 0.15)

    self.Close:Dock(RIGHT)
    self.Close:DockMargin(0, 0, 22, 0)
    self.Close:SetWide( ScrH() * 0.1)
end

-- function PANEL:UpdateList(CategoryName)
-- 	self.CurCategoryName = CategoryName
	
-- 	local Sort = {}
-- 	for _,DB in pairs(ACV.AchievementsByCategory[CategoryName] or {}) do
-- 		table.insert(Sort,table.Copy(DB))
-- 	end
-- 	table.SortByMember(Sort, "Order", function(a, b) return a > b end)
	
-- 	local Count = 0

-- 	end
-- end


-- function PANEL:BuildCategory()
-- 	self.CategoryList:Clear()
--     self:UpdateList(CategoryName)
	
-- 	for k,v in pairs(ACV.AchievementsByCategory) do
-- 		if k != "All" then
-- 			CreateCategoryButton(k)
-- 		end

-- end

vgui.Register("F4::Navbar", panel, "DPanel")





------------------------------------------------------------
-- JOBCARD JOBCARD JOBCARD JOBCARD JOBCARD JOBCARD JOBCARD J
------------------------------------------------------------

------------------------------------------------------------
-- JOBPANEL JOBPANEL JOBPANEL JOBPANEL JOBPANEL JOBPANEL JOB
------------------------------------------------------------

local panel = {}

local RightPointer = Material("materials/vgui/f4/right-pointer.png")
local DownPointer = Material("materials/vgui/f4/pointer.png")
local gradientleft = Material("materials/vgui/elements/gradient-left.png")

function panel:Init()
    self.JobTable = GAMEMODE.Jobs.m_tblJobs
    self.PlayerJob = GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() )
    self.JobCategory = {}
    self.ItemCategory = {}
    self.JobContainer = {}
    
    self.LeftContainer = self:Add("DScrollPanel")
    self.LeftContainer:Dock(LEFT)
    self.LeftContainer:DockMargin(5, 10, 5, 0)
    self.LeftContainer.Paint = function(s,w,h)
        -- draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
    end
    self.LeftContainer.Scroll = self.LeftContainer:GetVBar()

    function self.LeftContainer.Scroll:Paint( w, h )
        -- draw.RoundedBox( 8, w/2-2, 0, w/2+4, h, AwTheme.Colors.Primary )
    end

    function self.LeftContainer.Scroll.btnUp:Paint( w, h )
        draw.RoundedBox( 4, w/2-2, 0, w/2, h, Color(255,255,255,40) )
    end
    function self.LeftContainer.Scroll.btnDown:Paint( w, h )
        draw.RoundedBox( 4, w/2-2, 0, w/2, h, Color(255,255,255,40) )
    end
    function self.LeftContainer.Scroll.btnGrip:Paint( w, h )
        draw.RoundedBox( 8, w/2-2, 0, w/2, h, Color(0,255,78) )
    end


    
    self.RightContainer = self:Add("DScrollPanel")
    self.RightContainer:Dock(FILL)
    self.RightContainer.Paint = function(s,w,h)
        -- draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
    end
    self.RightContainer.Scroll = self.RightContainer:GetVBar()

    function self.RightContainer.Scroll:Paint( w, h )
        -- draw.RoundedBox( 8, w/2-2, 0, w/2+4, h, AwTheme.Colors.Primary )
    end

    function self.RightContainer.Scroll.btnUp:Paint( w, h )
        draw.RoundedBox( 4, w/2-2, 0, w/2, h, Color(255,255,255,40) )
    end
    function self.RightContainer.Scroll.btnDown:Paint( w, h )
        draw.RoundedBox( 4, w/2-2, 0, w/2, h, Color(255,255,255,40) )
    end
    function self.RightContainer.Scroll.btnGrip:Paint( w, h )
        draw.RoundedBox( 8, w/2-2, 0, w/2, h, Color(0,255,78) )
    end

    
    
    -- self.RulesPanel = self.RightContainer:Add("DPanel")
    -- self.RulesPanel:Dock(FILL)
    -- self.RulesPanel.Paint = nil

    self.RulesLabel = self.RightContainer:Add("DPanel")
    self.RulesLabel:Dock(TOP)
    self.RulesLabel:SetTall(ScrH()*0.1)
    self.RulesLabel.Paint = function(s,w,h)
        draw.SimpleText("SELECIONE UM EMPREGO", "F4::CatHeader", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    self.RulesText = self.RightContainer:Add("DLabel")
    self.RulesText:Dock(TOP)
    self.RulesText:DockMargin(10, 0, 10, 0)
    -- self.RulesText:SetEditable(true)
    self.RulesText:SetText("")
    self.RulesText:SetFont("F4::RulesText")
    self.RulesText.Paint = function(s,w,h)
        -- draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
    end
 
    self.BecomeButton = self:Add("DButton")
    self.BecomeButton:Dock(BOTTOM)
    self.BecomeButton:SetFont("F4::CatHeader")
    self.BecomeButton:SetColor( Color(255,255,255 ) )
    self.BecomeButton:SetText("ACEITAR")
    self.BecomeButton:SetTall( ScrH() * 0.06)
    self.BecomeButton:SetVisible(false)
    self.BecomeButton:DockMargin(0, 0, 5, 5)
    self.BecomeButton.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0,255,78) )
    end




    self:Populate(self.JobTable)

end

function panel:Populate(table)
    -- if self.PlayerJob.Name == table.Name then return end

    self.CategoryCount = 0

    -- if v.Cat == table.Cat then
    --     self.CategoryCount = self.CategoryCount + 1
    -- end


    
    for k, v in SortedPairsByMemberValue( table, "Cat") do

        if not IsValid(self.JobCategory[v.Cat]) then

            self.JobCategory[v.Cat] = vgui.Create( "F4Category", self.LeftContainer )
            self.JobCategory[v.Cat]:SetExpanded( 0 )
            self.JobCategory[v.Cat]:SetLabel( "" )
            self.JobCategory[v.Cat].Header:SetTall(48)	
            self.JobCategory[v.Cat].Header.Paint = function(pnl, w, h)
                if pnl:IsHovered() then
                    draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
                else
                    draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
                end
                if self.JobCategory[v.Cat]:GetExpanded() then
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial( DownPointer )
                    surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
                else
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial( RightPointer )
                    surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
                end
            end
            self.JobCategory[v.Cat].Header.PaintOver = function(s,w,h)
                draw.SimpleText(v.Cat, "F4::CatHeader", 16, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            self.JobCategory[v.Cat].Paint = function() end
            self.JobCategory[v.Cat]:Dock(TOP)
    
        end

    end

    for k, v in pairs( table ) do

        -- self.JobContainer = self.JobCategory[v.Cat]:Add("DButton")
        -- self.JobContainer:Dock(FILL)
        -- self.JobContainer:DockMargin(2, 10, 2, 0)
        -- self.JobContainer.Paint = function() end

        self.JobContainer = self.JobCategory[v.Cat]:Add("Container")
        self.JobContainer:Dock(TOP)
        self.JobContainer:DockMargin(5, 5, 5, 5)
        self.JobContainer:SetTall(80)
        self.JobContainer.DoClick = function() 
            print(v.Name)
        end

        self.IconPanel = self.JobContainer:Add("DPanel")
        self.IconPanel:Dock(LEFT)
        self.IconPanel:SetWide( 80 )
        self.IconPanel.Paint = function( pnl, w, h)
            draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
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

        self.JobWrapper = self.JobContainer:Add("DButton")
        self.JobWrapper:SetText("")
        self.JobWrapper:Dock(FILL)
        self.JobWrapper.Paint = function(s,w,h)
            if v.Vip then
                draw.RoundedBox(4, 0, 0, w, h, Color(19,19,19) )
                surface.SetDrawColor(0, 255, 78, 80)
                surface.SetMaterial(gradientleft)
                surface.DrawTexturedRect(0, 0, w, h)
                draw.SimpleText("VIP", "F4::RulesHeader", w/2, h/2, Color(255,255,255,60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.RoundedBox(4, 0, 0, w, h, Color(19,19,19) )
            end
        end
        self.JobWrapper.DoClick = function(s)
            self.RightContainer:SetWide(self:GetWide()/2)
            self:SetRules( v )
        end

        self.JobName = self.JobWrapper:Add("DLabel")
        self.JobName:Dock(TOP)
        self.JobName:SetTextInset(16,0)
        self.JobName:SetContentAlignment(4)
        self.JobName:SetTextColor( Color(255,255,255) )
        self.JobName:SetFont("F4::JobName")
        self.JobName:SetText(v.Name)
        self.JobName:SizeToContentsY(5)

        self.JobSalary = self.JobWrapper:Add("DLabel")
        self.JobSalary:Dock(BOTTOM)
        self.JobSalary:SetTextInset(16,0)
        self.JobSalary:SetContentAlignment(7)
        self.JobSalary:SetTextColor( Color(0,255,75) )
        self.JobSalary:SetFont("F4::JobName")
        self.JobSalary:SetText( "R$ " .. v.Pay[1].Pay .. " ~ "  .. v.Pay[3].Pay )
        self.JobSalary:SizeToContentsY(5)


    end
        

        -- -- -- print( self.CategoryCount)
        -- self.JobContainer[v.Cat]:SetTall( 80 * self.CategoryCount)
        

    -- end -- fim loop

end


function panel:PerformLayout(w, h)

    self.LeftContainer:SetWide(self:GetWide()/2)
    
end


function panel:SetRules( table )
    self.RulesLabel.Paint = function(s,w,h)
        local tw, th = draw.SimpleText("REGRAS E INSTRUÇÕES", "F4::CatHeader", w/2, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(table.Name, "F4::CatHeader", w/2, th/2 + h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.RulesText:SetText( table.Text )
    self.RulesText:SetTall( self.RightContainer:GetTall() - self.RulesLabel:GetTall() - self.BecomeButton:GetTall() )
    self.RulesText:SetContentAlignment(8)
    self.RulesText:SetWrap( true )
    -- if IsValid(self.RulesPanel) then self.RulesPanel:Remove() end

    self.BecomeButton:SetVisible(true)
    self.BecomeButton.DoClick = function()
        GAMEMODE.Net:RequestJobChange( table.ID )
        RunConsoleCommand( "open_f4_menu", 0 )
    end


end

function panel:Paint(w,h)
end

vgui.Register("F4::JobPanel", panel, "DPanel")





------------------------------------------------------------
-- ENTITY LIST ENTITY LIST ENTITY LIST ENTITY LIST ENTITY LI
------------------------------------------------------------

local panel = {}

function panel:Init()
    self.EntCategory = {}
    self.PlayerJob = GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() )
    self.Itemtbl = GAMEMODE.Inv.m_tblItemRegister
    
    self.Container = self:Add("DScrollPanel")
    self.Container:Dock(FILL)
    self.Container.Paint = function(s,w,h)
        -- draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
    end
    self.Container.Scroll = self.Container:GetVBar()

    function self.Container.Scroll:Paint( w, h )
        -- draw.RoundedBox( 8, w/2-2, 0, w/2+4, h, AwTheme.Colors.Primary )
    end

    function self.Container.Scroll.btnUp:Paint( w, h )
        draw.RoundedBox( 4, w/2-2, 0, w/2, h, Color(255,255,255,40) )
    end
    function self.Container.Scroll.btnDown:Paint( w, h )
        draw.RoundedBox( 4, w/2-2, 0, w/2, h, Color(255,255,255,40) )
    end
    function self.Container.Scroll.btnGrip:Paint( w, h )
        draw.RoundedBox( 8, w/2-2, 0, w/2, h, Color(0,255,78) )
    end



    self:Populate( self.Itemtbl )

    
    

end

function panel:Populate(table)
    -- PrintTable(table)
    for k, v in SortedPairsByMemberValue( table, "Cat") do
        if v.Cat and v.Cat ~= "Carregamentos" then 

            -- print(v.Cat)
            if not IsValid(self.EntCategory[v.Cat]) then

                self.EntCategory[v.Cat] = self.Container:Add("F4Category" )
                self.EntCategory[v.Cat]:SetExpanded( 0 )
                self.EntCategory[v.Cat]:SetLabel( "" )
                self.EntCategory[v.Cat].Header:SetTall(48)	
                self.EntCategory[v.Cat].Header.Paint = function(pnl, w, h)
                    if pnl:IsHovered() then
                        draw.RoundedBox( 5, 0, 0, w, h, Color(26,26,26) )
                    else
                        draw.RoundedBox( 5, 0, 0, w, h, Color(19,19,19) )
                    end
                    if self.EntCategory[v.Cat]:GetExpanded() then
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial( DownPointer )
                        surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
                    else
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial( RightPointer )
                        surface.DrawTexturedRect(w - 32, h/2 - 8, 16, 16)
                    end
                end
                self.EntCategory[v.Cat].Header.PaintOver = function(s,w,h)
                    draw.SimpleText(v.Cat, "F4::CatHeader", 16, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
                self.EntCategory[v.Cat].Paint = function() end
                self.EntCategory[v.Cat]:Dock(TOP)
        
            end
        end
    end
    for k, v in SortedPairsByMemberValue( table, "Cat") do
        if v.F4 and v.Cat ~= "Carregamentos" then 
            
            self.EntContainer = self.EntCategory[v.Cat]:Add("Container")
            self.EntContainer:Dock(TOP)
            self.EntContainer:DockMargin(5, 5, 5, 5)
            self.EntContainer:SetTall(80)
            self.EntContainer.DoClick = function() 
                print(v.Name)
            end

            self.IconPanel = self.EntContainer:Add("DPanel")
            self.IconPanel:Dock(LEFT)
            self.IconPanel:SetWide( 80 )
            self.IconPanel.Paint = function( pnl, w, h)
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(66,66,66), true, false, true, false)
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

            self.EntWrapper = self.EntContainer:Add("DButton")
            self.EntWrapper:SetText("")
            self.EntWrapper:Dock(FILL)
            self.EntWrapper.Paint = function(s,w,h)
                if v.Vip then
                    draw.RoundedBox(4, 0, 0, w, h, Color(19,19,19) )
                    surface.SetDrawColor(0, 255, 78, 80)
                    surface.SetMaterial(gradientleft)
                    surface.DrawTexturedRect(0, 0, w, h)
                    draw.SimpleText("VIP", "F4::RulesHeader", w/2, h/2, Color(255,255,255,60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.RoundedBox(4, 0, 0, w, h, Color(19,19,19) )
                end
            end
            self.EntWrapper.DoClick = function(s)
                self.RightContainer:SetWide(self:GetWide()/2)
                self:SetRules( v )
            end

            self.EntName = self.EntWrapper:Add("DLabel")
            self.EntName:Dock(TOP)
            self.EntName:SetTextInset(16,0)
            self.EntName:SetContentAlignment(4)
            self.EntName:SetTextColor( Color(255,255,255) )
            self.EntName:SetFont("F4::JobName")
            self.EntName:SetText(v.Name)
            self.EntName:SizeToContentsY(5)

            self.EntPrice = self.EntWrapper:Add("DLabel")
            self.EntPrice:Dock(BOTTOM)
            self.EntPrice:SetTextInset(16,0)
            self.EntPrice:SetContentAlignment(7)
            self.EntPrice:SetTextColor( Color(0,255,75) )
            self.EntPrice:SetFont("F4::JobName")
            self.EntPrice:SetText( "R$ " .. v.Value )
            self.EntPrice:SizeToContentsY(5)


        end
    end



end

function panel:Paint()
end

function panel:PerformLayout()
end

vgui.Register("F4::EntPanel", panel, "DPanel")



























local PANEL = {

	Init = function( self )

		self:SetContentAlignment( 4 )
		self:SetTextInset( 5, 0 )
		self:SetFont( "DermaDefaultBold" )

	end,

	DoClick = function( self )

		self:GetParent():Toggle()

	end,

	UpdateColours = function( self, skin )

		if ( !self:GetParent():GetExpanded() ) then
			self:SetExpensiveShadow( 0, Color( 0, 0, 0, 200 ) )
			return self:SetTextStyleColor( skin.Colours.Category.Header_Closed )
		end

		self:SetExpensiveShadow( 1, Color( 0, 0, 0, 100 ) )
		return self:SetTextStyleColor( skin.Colours.Category.Header )

	end,

	Paint = function( self )

		-- Do nothing!

	end,

	GenerateExample = function()

		-- Do nothing!

	end

}

derma.DefineControl( "DCategoryHeader", "Category Header", PANEL, "DButton" )

local PANEL = {}

AccessorFunc( PANEL, "m_bSizeExpanded",		"Expanded", FORCE_BOOL )
AccessorFunc( PANEL, "m_iContentHeight",	"StartHeight" )
AccessorFunc( PANEL, "m_fAnimTime",			"AnimTime" )
AccessorFunc( PANEL, "m_bDrawBackground",	"PaintBackground", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDrawBackground",	"DrawBackground", FORCE_BOOL ) -- deprecated
AccessorFunc( PANEL, "m_iPadding",			"Padding" )
AccessorFunc( PANEL, "m_pList",				"List" )

function PANEL:Init()

	self.Header = vgui.Create( "DCategoryHeader", self )
	self.Header:Dock( TOP )
	self.Header:SetSize( 20, 20 )

	self:SetSize( 16, 16 )
	self:SetExpanded( true )
	self:SetMouseInputEnabled( true )

	self:SetAnimTime( 0.2 )
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

	self:SetPaintBackground( true )
	self:DockMargin( 0, 0, 0, 2 )
	self:DockPadding( 0, 0, 0, 0 )

end

function PANEL:Add( strName )

	local button = vgui.Create( "DPanel", self )
	button.Paint = nil
	button:Dock( TOP )

	self:InvalidateLayout( true )
	self:UpdateAltLines()

	return button

end

function PANEL:UnselectAll()

	local children = self:GetChildren()
	for k, v in pairs( children ) do

		if ( v.SetSelected ) then
			v:SetSelected( false )
		end

	end

end

function PANEL:UpdateAltLines()

	local children = self:GetChildren()
	for k, v in pairs( children ) do
		v.AltLine = k % 2 != 1
	end

end

function PANEL:Think()

	self.animSlide:Run()

end

function PANEL:SetLabel( strLabel )

	self.Header:SetText( strLabel )

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "CollapsibleCategory", self, w, h )

	return false

end

function PANEL:SetContents( pContents )

	self.Contents = pContents
	self.Contents:SetParent( self )
	self.Contents:Dock( FILL )

	if ( !self:GetExpanded() ) then

		self.OldHeight = self:GetTall()

	elseif ( self:GetExpanded() && IsValid( self.Contents ) && self.Contents:GetTall() < 1 ) then

		self.Contents:SizeToChildren( false, true )
		self.OldHeight = self.Contents:GetTall()
		self:SetTall( self.OldHeight )

	end

	self:InvalidateLayout( true )

end

function PANEL:SetExpanded( expanded )

	self.m_bSizeExpanded = tobool( expanded )

	if ( !self:GetExpanded() ) then
		if ( !self.animSlide.Finished && self.OldHeight ) then return end
		self.OldHeight = self:GetTall()
	end

end

function PANEL:Toggle()

	self:SetExpanded( !self:GetExpanded() )

	self.animSlide:Start( self:GetAnimTime(), { From = self:GetTall() } )

	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

	local open = "1"
	if ( !self:GetExpanded() ) then open = "0" end
	self:SetCookie( "Open", open )

	self:OnToggle( self:GetExpanded() )

end

function PANEL:OnToggle( expanded )

	-- Do nothing / For developers to overwrite

end

function PANEL:DoExpansion( b )

	if ( self:GetExpanded() == b ) then return end
	self:Toggle()

end

function PANEL:PerformLayout()

	if ( IsValid( self.Contents ) ) then

		if ( self:GetExpanded() ) then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end

	end

	if ( self:GetExpanded() ) then

		if ( IsValid( self.Contents ) && #self.Contents:GetChildren() > 0 ) then self.Contents:SizeToChildren( false, true ) end
		self:SizeToChildren( false, true )

	else

		if ( IsValid( self.Contents ) && !self.OldHeight ) then self.OldHeight = self.Contents:GetTall() end
		self:SetTall( self.Header:GetTall() )

	end

	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()

	self.animSlide:Run()
	self:UpdateAltLines()

end

function PANEL:OnMousePressed( mcode )

	if ( !self:GetParent().OnMousePressed ) then return end

	return self:GetParent():OnMousePressed( mcode )

end

function PANEL:AnimSlide( anim, delta, data )

	self:InvalidateLayout()
	self:InvalidateParent()

	if ( anim.Started ) then
		if ( !IsValid( self.Contents ) && ( self.OldHeight || 0 ) < self.Header:GetTall() ) then
			-- We are not using self.Contents and our designated height is less
			-- than the header size, something is clearly wrong, try to rectify
			self.OldHeight = 0
			for id, pnl in pairs( self:GetChildren() ) do
				self.OldHeight = self.OldHeight + pnl:GetTall()
			end
		end

		if ( self:GetExpanded() ) then
			data.To = math.max( self.OldHeight, self:GetTall() )
		else
			data.To = self:GetTall()
		end
	end

	if ( IsValid( self.Contents ) ) then self.Contents:SetVisible( true ) end

	self:SetTall( Lerp( delta, data.From, data.To ) )

end

function PANEL:LoadCookies()

	local Open = self:GetCookieNumber( "Open", 1 ) == 1

	self:SetExpanded( Open )
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

end


derma.DefineControl( "F4Category", "Collapsable Job Panel", PANEL, "Panel" )