local vw = ScrW() 
surface.CreateFont( "BP::Title", {	font = "Montserrat Bold", extended = false,	size = vw * 0.015,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::SubTitle", {	font = "Montserrat Regular", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::Nav", {	font = "Montserrat Bold", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::Level", {	font = "Montserrat Bold", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::XP", {	font = "Montserrat Bold", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::SeasonLabel", {	font = "Montserrat Regular", extended = false,	size = vw * 0.035,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::SeasonCounter", {	font = "Montserrat Bold", extended = false,	size = vw * 0.037,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::SeasonTitle", {	font = "Montserrat Regular", extended = false,	size = vw * 0.020,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::XPLabel", {	font = "Montserrat Bold", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::RewardXPLabel", {	font = "Montserrat Bold", extended = false,	size = vw * 0.020,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::RewardLabel", {	font = "Montserrat Bold", extended = false,	size = vw * 0.040,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::RewardGot", {	font = "Montserrat Bold", extended = false,	size = vw * 0.070,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::QuestTitle", {	font = "Montserrat Bold", extended = false,	size = vw * 0.016,	weight = 500,	antialias = true, } )
surface.CreateFont( "BP::MW::QuestDesc", {	font = "Montserrat Regular", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )
-- surface.CreateFont( "BP::5", {	font = "Montserrat Bold", extended = false,	size = vw * 0.012,	weight = 500,	antialias = true, } )

------------------------------------------------------------------------------------------
-- FRAME FRAME FRAME FRAME FRAME FRAME FRAME FRAME  FRAME  FRAME  FRAME  FRAME  FRAME 
------------------------------------------------------------------------------------------

local panel = {}

function panel:Init()

end

function panel:Paint(w,h)
    surface.SetDrawColor(26, 26, 26, 255)
    surface.DrawRect(0, 0, w, h)

end

function panel:PerformLayout(w, h)

end


vgui.Register("BP::Frame", panel, EditablePanel)


------------------------------------------------------------------------------------------
-- NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR NAVBAR  NAVBAR  NAVBAR  NAVBAR 
-----------------------------------------------------------------------------------------

local panel = {}

AccessorFunc(panel, "m_body", "Body")

function panel:Init()
    self.Buttons = {}
    self.Panels = {}

    self.Title = self:Add("DPanel")
    self.Title.Paint = function( _ , w, h )
        surface.SetFont("BP::Title")
        local tw, th = surface.GetTextSize("PASSE DE BATALHA")

        surface.SetFont("BP::SubTitle")
        local tw2, th2 = surface.GetTextSize("Majestic.BRASILRP")

        draw.SimpleText("PASSE DE BATALHA", "BP::Title", 22, (self:GetTall()/2) - (th/2), Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Majestic.BRASILRP", "BP::SubTitle", 22, (self:GetTall()/2) + (th2/2), Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(100, 100, 100, 100)
        surface.DrawRect( w-1, h/4, 1, h/2)
    end

    self.Close = self:Add("DButton")
    self.Close:SetTextColor( Color(200, 60, 60, 255) )
    self.Close:SetFont("BP::Nav")
    self.Close:SetText("FECHAR")
    self.Close.DoClick = function()
        self:GetParent():Remove()
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
    dButton:SetFont("BP::Nav")
    dButton:SetText( Name )
    dButton:Dock(LEFT)
    dButton:SizeToContentsX(ScrW()*0.05)
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

    self.Panels[i] = self:GetBody():Add( panel or "DPanel")
    panel = self.Panels[i]

    panel:SetSize( self:GetBody():GetWide(), self:GetBody():GetTall() - self:GetTall() )
    if i ~= 1 then
        panel:SetPos( self:GetBody():GetWide(), self:GetTall() )
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
        OldPanel:MoveTo(-self:GetBody():GetWide(), self:GetTall(), 0.2, 0, 1, function() end)
    else
        local OldPanel = self.Panels[id]
    --     OldPanel:SetPos( self:GetBody():GetWide(), self:GetTall() )
        OldPanel:MoveTo( self:GetBody():GetWide(), self:GetTall(), 0.2, 0, 1, function() end)
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
        -- Panel:SetPos( self:GetBody():GetWide(), self:GetTall() )
        Panel:MoveTo(0, self:GetTall(), 0.2, 0, 1, function() end)
        Panel:SetVisible(true)
    -- else
    --     local Panel = self.Panels[id]
    --     Panel:SetPos( 0, self:GetTall() )
    --     Panel:MoveTo(self:GetBody():GetWide(), self:GetTall(), 1, 0, 1, function() end)
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

vgui.Register("BP::Navbar", panel, "DPanel")


------------------------------------------------------------------------------------------
-- SeasonWrapper SeasonWrapper SeasonWrapper SeasonWrapper SeasonWrapper SeasonWrapper 
-----------------------------------------------------------------------------------------
local panel = {}

function panel:Init()

    self.DoneQuests = 0
    self.TotalQuests = 0
    
    self.SeasonIcon = self:Add("DImage")
    self.SeasonIcon:SetMaterial(BattlePass.Config["icon"])

    self.SeasonLabel = self:Add("DLabel")
    self.SeasonLabel:SetText("Temporada")
    self.SeasonLabel:SetTextColor( Color(255,255,255) )
    self.SeasonLabel:SetFont("BP::MW::SeasonLabel")

    self.SeasonCounter = self:Add("DLabel")
    self.SeasonCounter:SetText( "0" .. BattlePass.Season.Number )
    self.SeasonCounter:SetTextColor( Color(255,255,255) )
    self.SeasonCounter:SetFont("BP::MW::SeasonCounter")

    self.SeasonTitle = self:Add("DLabel")
    self.SeasonTitle:SetText( " - " .. BattlePass.Season[BattlePass.Season.Number] )
    self.SeasonTitle:SetTextColor( Color(255,255,255,150) )
    self.SeasonTitle:SetFont("BP::MW::SeasonTitle")

    //xp
    self.XPLabel = self:Add("DLabel")
    self.XPLabel:SetText("XP")
    self.XPLabel:SetTextColor( Color(255,255,255) ) 
    self.XPLabel:SetFont("BP::MW::XPLabel")

    self.XPBar = vgui.Create( "SRP_Progress", self )
	self.XPBar:SetBarColor( Color(4,236,86) )
	self.XPBar.Think = function()
		local curXP = self.DoneQuests
		local targetXP = self.TotalQuests
        -- self.DoneQuests .. " / " .. self.TotalQuests
        -- targetXP = targetXP - baseXP
        fraction = curXP / targetXP
        
		self.XPBar:SetFraction( fraction )
    end
     

    self.QuestsLabel = self:Add("DLabel")
    self.QuestsLabel:SetFont("BP::MW::XPLabel")

    
    self:UpdateAchieve()


end

function panel:UpdateAchieve()
    for k, v in pairs(BattlePass.AchievementList) do
        self.TotalQuests = self.TotalQuests+1
        if BattlePass.Achievement[LocalPlayer():SteamID64()].PlayerQuestData[k] == BattlePass.AchievementList.Max then
            self.DoneQuests = self.DoneQuests + 1
        end
    end
end

function panel:Paint(w,h)
    if self.TotalQuests == 0 then
        for k, v in pairs(BattlePass.AchievementList) do
            self.TotalQuests = self.TotalQuests + 1
            if BattlePass.Achievement[LocalPlayer():SteamID64()].PlayerQuestData[k] == BattlePass.AchievementList.Max then
                self.DoneQuests = self.DoneQuests + 1
            end
        end
    else
        self.QuestsLabel:SetText("Missões Concluídas: " .. self.DoneQuests .. " / " .. self.TotalQuests)
    end
end

function panel:PerformLayout(w, h)
    self:DockPadding(0, 0, 0, 0)
    self.SeasonIcon:SetSize( h/2, h/2 )
    self.SeasonIcon:SetPos( 0, h/4 )

    self.SeasonLabel:SizeToContentsY(5)
    self.SeasonLabel:SizeToContentsX(0)
    self.SeasonLabel:SetPos( self.SeasonIcon:GetWide() , self.SeasonLabel:GetTall())

    self.SeasonCounter:SizeToContentsY(0)
    self.SeasonCounter:SizeToContentsX(0)
    self.SeasonCounter:SetPos( self.SeasonIcon:GetWide() + self.SeasonLabel:GetWide() + 10, self.SeasonLabel:GetTall())

    self.SeasonTitle:SizeToContentsY(5)
    self.SeasonTitle:SizeToContentsX(0)
    self.SeasonTitle:SetPos(  self.SeasonIcon:GetWide() + self.SeasonLabel:GetWide() + self.SeasonCounter:GetWide() + 10, self.SeasonLabel:GetTall() + 10)

    //XP
    self.XPLabel:SizeToContentsY(5)
    self.XPLabel:SizeToContentsX(0)
    self.XPLabel:SetPos(  self.SeasonIcon:GetWide() + 10, self.SeasonLabel:GetTall() + self.XPLabel:GetTall() + 40)

    self.XPBar:SetWide( self.SeasonLabel:GetWide() *2 )
    self.XPBar:SetPos( self.XPLabel:GetWide() + self.SeasonIcon:GetWide() + 15, self.SeasonLabel:GetTall() + self.XPLabel:GetTall() + 40)

    self.QuestsLabel:SizeToContents()
    self.QuestsLabel:SetPos(  self.SeasonIcon:GetWide() + 10, self.XPBar:GetTall() + self.SeasonLabel:GetTall() + self.XPLabel:GetTall() + self.QuestsLabel:GetTall() + 40)

    
end

function panel:Think()

end


vgui.Register("BP::SeasonWrapper", panel, "DPanel")

------------------------------------------------------------------------------------------
-- RewardWrapper RewardWrapper RewardWrapper RewardWrapper RewardWrapper RewardWrapper Re
-----------------------------------------------------------------------------------------

local panel = {}

function panel:Init()
    self.level = 0
    self.Table = {}
    -- self.Container = self:Add("DPanel")

    
    self.Header = self:Add("DPanel")
    self.Header:Dock(TOP)
    self.Header:SetTall(ScrH()*0.05)
    self.Header.Paint = function(_,w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(66,66,66))
    end

    self.lvlLabel = self.Header:Add("DLabel")
    self.lvlLabel:Dock(FILL)
    self.lvlLabel:SetFont("BP::MW::RewardXPLabel")
    self.lvlLabel:SetColor( Color(255,255,255) )
    self.lvlLabel:SetContentAlignment(5)

    self.VipBlock = self:Add("DButton")
    self.VipBlock:SetText("")
    self.VipBlock:Dock(TOP)
    self.VipBlock:DockMargin(0, ScrH()*0.02, 0, ScrH()*0.01)
    self.VipBlock:SetTall( ScrH()*0.2 )
    -- self.VipBloc

    self.FreeBlock = self:Add("DButton")
    self.FreeBlock:SetText("")
    self.FreeBlock:Dock(TOP)
    self.FreeBlock:DockMargin(0, ScrH()*0.01, 0, ScrH()*0.02)
    self.FreeBlock:SetTall( ScrH()*0.2 )
    self.FreeBlock.Paint = nil
end


function panel:Paint(w,h)
    if self.level ~= 0 then return end
    

end

function panel:SetupValues( table )
    self.level = 0
    for k, v in SortedPairs(table) do
        self.level = k
        self.table = v
        if GAMEMODE.Skills:GetPlayerLevel( "Passe de Batalha" ) >= self.level then
            self.Header.Paint = function(_,w,h)
                draw.RoundedBox(4, 0, 0, w, h, Color(0,255,78))
            end
            self.lvlLabel:SetText(self.level)
            self.Paint = function(s,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46))
            end
        else
            self.Paint = nil
            self.Header.Paint = function(_,w,h)
                draw.RoundedBox(4, 0, 0, w, h, Color(66,66,66))
            end
            self.lvlLabel:SetText(self.level)
        end
       if v[1].Free then
            local Rarity = v[1].Free.Rarity
            local Image = v[1].Free.Image
            local Name = v[1].Free.Name
            local ID =  v[1].Free.ID

            self.FreeBlock.DoClick = function(_)
                net.Start("BP::RequestReward")
                    net.WriteString(Name)
                    net.WriteInt(ID, 32)
                    net.WriteInt(self.level, 32)
                    net.WriteBool(false)
                net.SendToServer()

                self.FreeBlock.PaintOver = function(_,w,h)
                    if self.level <= GAMEMODE.Skills:GetPlayerLevel( "Passe de Batalha" ) then
                        draw.SimpleText("✔", "BP::MW::RewardGot", self.FreeBlock:GetWide()/2, self.FreeBlock:GetTall()/2, Color(0,255,78,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        -- surface.SetDrawColor( Color(0,255,78) )
                        -- surface.SetMaterial( Material("materials/vgui/pb/check.png") )
                        -- surface.DrawTexturedRectRotated(w/2, h/2, w-self.VipBlock:GetWide()/2, h-self.VipBlock:GetTall()/2,0)
                    end
                end
            end
            self.FreeBlock.Paint = function(_,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(66,66,66) )
                surface.SetDrawColor(BattlePass.RarityColor[Rarity])
                surface.SetMaterial(Material("materials/vgui/elements/gradient-bottom.png"))
                surface.DrawTexturedRect(0, 0, w, h)

                if BattlePass.PlayerParsed[ID] then
                    draw.SimpleText("✓", "BP::MW::RewardGot", self.FreeBlock:GetWide()/2, self.FreeBlock:GetTall()/2, Color(0,255,78,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    -- surface.SetDrawColor( Color(0,255,78) )
                    -- surface.SetMaterial( Material("materials/vgui/pb/check.png" ,"smooth") )
                    -- surface.DrawTexturedRectRotated(w/2, h/2, w-self.VipBlock:GetWide()/2, h-self.VipBlock:GetTall()/2,0)
                end
            end
            self.FreeBlock:SetCursor("hand")
        else
            self.FreeBlock.Paint = nil
            self.FreeBlock.DoClick = function() end
            self.FreeBlock:SetCursor("arrow")
        end
        if v[1].Vip then
            print( ply:CheckGroup( "vip" ) )
            local Rarity = v[1].Vip.Rarity
            local Image = v[1].Vip.Image
            -- print( Image )
            local Name = v[1].Vip.Name
            local ID = v[1].Vip.ID

            local tooltip = vgui.Create("Panel")
            tooltip:SetSize(ScrH()*0.5,ScrH()*0.5)

            local tooltipbg = tooltip:Add("DPanel")
            tooltipbg:Dock(FILL)
            tooltipbg.Paint = function(_,w,h)
                draw.RoundedBox(4, 0, 0, w, h, Color(26,26,26,255) )
                surface.SetDrawColor( BattlePass.RarityColor[Rarity] )
                surface.SetMaterial( Material("materials/vgui/elements/gradient-bottom.png") )
                surface.DrawTexturedRect( 0, 0, w, h )
            end
            local tooltipimage = tooltip:Add("DImage")
            tooltipimage:SetSize(256,256)
            tooltipimage:SetMaterial( Image )
            tooltipimage:Dock(FILL)
            -- tooltip:SetSize(256,256)
            tooltip:SetVisible(false)

            self.VipBlock:SetTooltipPanel(tooltip)

            self.VipBlock.DoClick = function(_)
                if not ply:CheckGroup( "vip" ) then return end
                net.Start("BP::RequestReward")
                    net.WriteString(Name)
                    net.WriteInt(ID, 32)
                    net.WriteInt(self.level, 32)
                    net.WriteBool(true)
                net.SendToServer()
                
                self.VipBlock.PaintOver = function(_,w,h)
                    if self.level <= GAMEMODE.Skills:GetPlayerLevel( "Passe de Batalha" ) then
                        draw.SimpleText("✓", "BP::MW::RewardGot", self.FreeBlock:GetWide()/2, self.FreeBlock:GetTall()/2, Color(0,255,78,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        -- surface.SetDrawColor( Color(0,255,78) )
                        -- surface.SetMaterial( Material("materials/vgui/pb/check.png") )
                        -- surface.DrawTexturedRectRotated(w/2, h/2, w-self.VipBlock:GetWide()/2, h-self.VipBlock:GetTall()/2,0)
                    end
                end

            end
            self.VipBlock.Paint = function(_,w,h)
                draw.RoundedBox( 0, 0, 0, w, h, Color(66,66,66) )
                surface.SetDrawColor( BattlePass.RarityColor[Rarity] )
                surface.SetMaterial( Material("materials/vgui/elements/gradient-bottom.png") )
                surface.DrawTexturedRect( 0, 0, w, h )
                surface.SetDrawColor( Color(255,255,255) )
                surface.SetMaterial( Image )
                surface.DrawTexturedRectRotated( w/2, h/2, w, h, 0 )

                if BattlePass.PlayerParsed[ID] then
                    draw.SimpleText("✓", "BP::MW::RewardGot", self.FreeBlock:GetWide()/2, self.FreeBlock:GetTall()/2, Color(0,255,78,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                    -- surface.SetDrawColor( Color(0,255,78) )
                    -- surface.SetMaterial( Material("materials/vgui/pb/check.png") )
                    -- surface.DrawTexturedRectRotated(w/2, h/2, w-self.VipBlock:GetWide()/2, h-self.VipBlock:GetTall()/2,0)
                end
            end

            self.VipBlock:SetCursor("hand")
        else
            self.VipBlock.Paint = nil
            self.VipBlock.DoClick = function() end
            self.VipBlock:SetCursor("arrow")
        end

    end
end

function panel:PerformLayout(w, h)
 
    
end

function panel:Think()

end


vgui.Register("BP::RewardColumn", panel, "DPanel")


local panel = {}

function panel:Init()
    self.Scroller = self:Add("DHorizontalScroller")
    self.Scroller:Dock(FILL)
    self.Scroller:DockMargin(ScrW()*0.02, 0, ScrW()*0.02, 0)
    self.Scroller:SetOverlap(-10)

    self.FirstContainer = self:Add("DPanel")
    self.FirstContainer:SetWide(ScrW()*0.12)
    self.FirstContainer.Paint = function(s,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46))
    end

    self.FirstHeader = vgui.Create("DPanel", self.FirstContainer)
    self.FirstHeader:SetTall(ScrH()*0.05)
    self.FirstHeader:Dock(TOP)
    self.FirstHeader.Paint = function(_,w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(0,255,78))
    end

    self.FirstlvlLabel = self.FirstHeader:Add("DLabel")
    self.FirstlvlLabel:Dock(FILL)
    self.FirstlvlLabel:SetFont("BP::MW::RewardXPLabel")
    self.FirstlvlLabel:SetColor( Color(255,255,255) )
    self.FirstlvlLabel:SetText("Nível")
    self.FirstlvlLabel:SetContentAlignment(5)

    self.FirstVipBlock = self.FirstContainer:Add("DPanel")
    self.FirstVipBlock:Dock(TOP)
    self.FirstVipBlock:DockMargin(0, ScrH()*0.02, 0, ScrH()*0.01)
    self.FirstVipBlock:SetTall( ScrH()*0.2 )
    self.FirstVipBlock:SetMouseInputEnabled(true)

    self.FirstVipBlock.Paint = function(_,w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(239,177,0) )
        draw.SimpleText("VIP","BP::MW::RewardLabel", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    -- self.VipBloc

    self.FirstFreeBlock = self.FirstContainer:Add("DPanel")
    self.FirstFreeBlock:Dock(TOP)
    self.FirstFreeBlock:DockMargin(0, ScrH()*0.01, 0, ScrH()*0.02)
    self.FirstFreeBlock:SetTall( ScrH()*0.2 )
    self.FirstFreeBlock.Paint = function(_,w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(66,66,66) )
        draw.SimpleText("Grátis","BP::MW::RewardLabel", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.Scroller:AddPanel(self.FirstContainer)

    local rewardtable = {}
    for k, v in pairs(BattlePass.Reward) do 
        rewardtable[k] = { v }
        self.RewardPanel = vgui.Create("BP::RewardColumn",self.Scroller)
        self.RewardPanel:SetupValues( rewardtable )
        self.RewardPanel:SetWide(ScrW()*0.12)
        
        self.Scroller:AddPanel(self.RewardPanel)
    end
end


function panel:Paint(w,h)
    -- draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35) )
end

function panel:PerformLayout(w, h)
   
    
end

function panel:Think()

end


vgui.Register("BP::RewardsWrapper", panel, "DPanel")

------------------------------------------------------------------------------------------
-- BATTLEPASS BATTLEPASS BATTLEPASS BATTLEPASS BATTLEPASS BATTLEPASS BATTLEPASS BATTLEPASS
-----------------------------------------------------------------------------------------
local panel = {}

function panel:Init()

    self.SeasonWrapper = self:Add("BP::SeasonWrapper")

    self.RewardsWrapper = self:Add("BP::RewardsWrapper")
    

end


function panel:Paint(w,h)

end

function panel:PerformLayout(w, h)
    self.SeasonWrapper:Dock( TOP )
    self.SeasonWrapper:SetTall( self:GetTall()/3 )

    self.RewardsWrapper:Dock(FILL)
    
end

function panel:Think()

end

function CurrentID(id)
    return id
end

function panel:Slide()

    
end


vgui.Register("BP::Main", panel, "DPanel")

------------------------------------------------------------------------------------------
-- QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS QUESTS 
------------------------------------------------------------------------------------------
local PANEL = {}

AccessorFunc( PANEL, "Padding", "Padding" )
AccessorFunc( PANEL, "pnlCanvas", "Canvas" )

function PANEL:Init()
    self.LoadedQuests = 0
	self.pnlCanvas = vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )

		self:PerformLayout()
		self:InvalidateParent()

	end

	-- Create the scroll bar
	self.VBar = vgui.Create( "DVScrollBar", self )
	self.VBar:Dock( RIGHT )

	self:SetPadding( 0 )
	self:SetMouseInputEnabled( true )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
    self:SetPaintBackground( false )

end

function PANEL:AddItem( pnl )

	pnl:SetParent( self:GetCanvas() )

end

function PANEL:OnChildAdded( child )

	self:AddItem( child )

end

function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )

end

function PANEL:GetVBar()

	return self.VBar

end

function PANEL:GetCanvas()

	return self.pnlCanvas

end

function PANEL:InnerWidth()

	return self:GetCanvas():GetWide()

end

function PANEL:Rebuild()

	self:GetCanvas():SizeToChildren( false, true )

	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, ( self:GetTall() - self:GetCanvas():GetTall() ) * 0.5 )

	end

end

function PANEL:OnMouseWheeled( dlta )

	return self.VBar:OnMouseWheeled( dlta )

end

function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )

end

function PANEL:ScrollToChild( panel )

	self:PerformLayout()

	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()

	y = y + h * 0.5
	y = y - self:GetTall() * 0.5

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 )

end

function PANEL:PerformLayout()

	local Tall = self.pnlCanvas:GetTall()
	local Wide = self:GetWide()
	local YPos = 0

	self:Rebuild()

	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()

	if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )

	self:Rebuild()

	if ( Tall != self.pnlCanvas:GetTall() ) then
		self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
	end

end

function PANEL:Clear()

	return self.pnlCanvas:Clear()

end

function PANEL:Paint(w,h)
    if self.LoadedQuests == 0 then
        local Category = {}
        local Count = {}
        local Counter = 0
        for k, v in SortedPairs(BattlePass.AchievementList) do
            
            self.LoadedQuests = self.LoadedQuests + 1
            if not IsValid(Category[v.Category]) then
                Category[v.Category] = vgui.Create("DPanel", self.pnlCanvas)
                Category[v.Category]:Dock(TOP)
                Category[v.Category].Paint = nil
                Category[v.Category].Header = Category[v.Category]:Add("DLabel")
                Category[v.Category].Header:SetTextInset(10, 0)
                Category[v.Category].Header:SetTextColor( Color(255,255,255) )
                Category[v.Category].Header:SetFont("BP::MW::SeasonTitle")
                Category[v.Category].Header:SetText(v.Category)
                Category[v.Category].Header:Dock(TOP)
                Category[v.Category].Header:DockMargin(10, 10, 10, 10)
                Category[v.Category].Header:SizeToContentsY(20)
                Category[v.Category].Header.Paint = function( _, w, h)
                    draw.RoundedBox(4, 0, 0, w, h, Color(19,19,19) )
                end
                -- Category[v.Category]:SetTall( 64 * )
            end
        end
       
        for k, v in SortedPairs(BattlePass.AchievementList) do
            if Count[v.Category] == nil then Count[v.Category] = 0 end
            local PlayerData = BattlePass.Achievement[LocalPlayer():SteamID64()].PlayerQuestData
            Count[v.Category] = Count[v.Category] + 1
            self.AchieveWrapper = Category[v.Category]:Add("DPanel")
            self.AchieveWrapper:DockMargin(10, 0, 10, 10)
            self.AchieveWrapper:SetTall(64)
            self.AchieveWrapper:Dock(TOP)
            self.AchieveWrapper.Paint = function(_,w,h)               
                -- surface.SetDrawColor(150, 150, 150, 100)
                -- surface.SetMaterial(Material("materials/vgui/sp/texture.png", "noclamp"))
                -- surface.DrawTexturedRectUV(0, 0, w, 64, 0, 0, 64, 64)

                -- surface.SetMaterial( Material( "materials/vgui/sp/dotpattern.png", "noclamp" ) )
                -- surface.SetDrawColor( Color(150,150,150,50) )
                -- surface.DrawTexturedRectUV( 0, 0, w, h, 0, 0, w / 72, h / 64 )

            end

            self.Icon = self.AchieveWrapper:Add("DImage")
            self.Icon:SetMaterial(v.Icon)
            self.Icon:Dock(LEFT)
            self.Icon:SetSize( self.AchieveWrapper:GetTall(), self.AchieveWrapper:GetTall() )
            self.Icon:DockMargin(0, 0, 16, 0)
            -- PrintTable(v)

            self.label = self.AchieveWrapper:Add("DLabel")
            self.label:SetTextColor(Color(255,255,255))
            self.label:SetFont("BP::MW::QuestTitle")
            self.label:SetText(v.PrintName)
            self.label:SetTall( self.AchieveWrapper:GetTall()/3)
            self.label:SetContentAlignment( 1 )
            self.label:Dock(TOP)

            self.Desclabel = self.AchieveWrapper:Add("DLabel")
            self.Desclabel:SetTextColor( Color(255,255,255) )
            self.Desclabel:SetFont("BP::MW::QuestDesc")
            self.Desclabel:SetText(v.Description)
            self.Desclabel:SetTall( self.AchieveWrapper:GetTall()/3)
            self.label:SetContentAlignment( 1 )
            self.Desclabel:Dock(TOP)
            
            self.XPBar = self.AchieveWrapper:Add("SRP_Progress")
            self.XPBar:SetBarColor( Color(4,236,86) )
            self.XPBar:Dock(TOP)
            self.XPBar:SetTall( self.AchieveWrapper:GetTall()/3)
            -- self.XPBar:SetContentAlignment( 1 )
            -- self.XPBar.Think = function()  
            local fraction = 0             
            if PlayerData[k] then
                fraction = (PlayerData[k] / v.Max)
            end 
            self.XPBar:SetFraction( fraction )
            -- end
        end

        for k, v in SortedPairs(BattlePass.AchievementList) do
            Category[v.Category]:SetTall( 74 * Count[v.Category] + Category[v.Category].Header:GetTall() + 10)
        end
    end

end

vgui.Register("BP::Quests", PANEL, "DPanel")


------------------------------------------------------------------------------------------
-- HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP HELP  
-----------------------------------------------------------------------------------------
local panel = {}

function panel:Init()

end


function panel:Paint(w,h)

end

function panel:PerformLayout(w, h)
    -- print(self.Panels.y)
    
end

function panel:Think()

end

function CurrentID(id)
    return id
end

function panel:Slide()

    
end


vgui.Register("BP::Help", panel, "DPanel")


































--
-- The delay before a tooltip appears
--
local tooltip_delay = CreateClientConVar( "tooltip_delay", "0.4", true, false )

local PANEL = {}

function PANEL:Init()
    self.Lerp = 0
    self:SetAlpha(self.Lerp)
	self:SetDrawOnTop( true )
	self.DeleteContentsOnClose = false
	self:SetText( "" )
	self:SetFont( "Default" )

end

function PANEL:UpdateColours( skin )

	return self:SetTextStyleColor( skin.Colours.TooltipText )

end

function PANEL:SetContents( panel, bDelete )

	panel:SetParent( self )

	self.Contents = panel
	self.DeleteContentsOnClose = bDelete or false
	self.Contents:SizeToContents()
	self:InvalidateLayout( true )

	self.Contents:SetVisible( false )

end

function PANEL:PerformLayout()

	if ( IsValid( self.Contents ) ) then

		self:SetWide( self.Contents:GetWide())
		self:SetTall( self.Contents:GetTall() )
		self.Contents:SetPos( 0, 0 )
		self.Contents:SetVisible( true )

	else

		local w, h = self:GetContentSize()
		self:SetSize( w, h)
		self:SetContentAlignment( 5 )

	end

end

local Mat = Material( "vgui/arrow" )

function PANEL:DrawArrow( x, y )

	self.Contents:SetVisible( true )

	surface.SetMaterial( Mat )
	surface.DrawTexturedRect( self.ArrowPosX + x, self.ArrowPosY + y, self.ArrowWide, self.ArrowTall )

end

function PANEL:PositionTooltip()

	if ( !IsValid( self.TargetPanel ) ) then
		self:Remove()
		return
	end

	self:PerformLayout()

	local x, y = input.GetCursorPos()
	local w, h = self:GetSize()

	local lx, ly = self.TargetPanel:LocalToScreen( 0, 0 )

	-- y = y + ScrH()80.5

	-- y = math.min( y, ly - h * 1.5 )
	-- if ( y < 2 ) then y = 2 end

	-- Fixes being able to be drawn off screen
	self:SetPos( x+30, y-self:GetTall()/2 )

end

function PANEL:Paint( w, h )    
    self.Lerp = Lerp( RealFrameTime()*5, self.Lerp, 255)
    self:SetAlpha(self.Lerp)
	self:PositionTooltip()
	-- derma.SkinHook( "Paint", "Tooltip", self, w, h )

end

function PANEL:OpenForPanel( panel )

	self.TargetPanel = panel
	self:PositionTooltip()

	if ( tooltip_delay:GetFloat() > 0 ) then

		self:SetVisible( false )
		timer.Simple( tooltip_delay:GetFloat(), function()

			if ( !IsValid( self ) ) then return end
			if ( !IsValid( panel ) ) then return end

			self:PositionTooltip()
			self:SetVisible( true )

		end )
	end

end

function PANEL:Close()

	if ( !self.DeleteContentsOnClose && IsValid( self.Contents ) ) then

		self.Contents:SetVisible( false )
		self.Contents:SetParent( nil )

	end

	self:Remove()

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( "DButton" )
	ctrl:SetText( "Hover me" )
	ctrl:SetWide( 200 )
	ctrl:SetTooltip( "This is a tooltip" )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DTooltip", "", PANEL, "DLabel" )

































local PANEL = {}
 
function PANEL:Init()
    -- left to right
    self.gradientH = Material("gui/gradient")
    -- top to bottom
    self.gradientV = Material("gui/gradient_down")
end
 
function PANEL:Paint(w, h)
    -- Black background.
    local colorm = Color(0, 0, 0, 255)
    -- Time by a factor of 10 to speed it up.
    local t = CurTime()*10
    -- How much the color differs between sides.
    local spread = 30
    -- Color progression in a clock-wise manner.
    local colorl = HSVToColor((t+spread*0)%360, 1, 1)
    local colort = HSVToColor((t+spread*1)%360, 1, 1)
    local colorr = HSVToColor((t+spread*2)%360, 1, 1)
    local colorb = HSVToColor((t+spread*3)%360, 1, 1)
 
    -- Lower the alpha of each gradient to 50
    -- so that when they layer over eachother they
    -- won't be too bright.
    local a = 50
    colorl.a = a
    colorr.a = a
    colort.a = a
    colorb.a = a
 
    -- Clear the background.
    surface.SetDrawColor(colorm)
    surface.DrawRect(0, 0, w, h)
 
    -- Draw left gradient.
    surface.SetDrawColor(colorl)
    surface.SetMaterial(self.gradientH)
    surface.DrawTexturedRect(0, 0, w, h)
 
    -- Draw right gradient.
    surface.SetDrawColor(colorr)
    surface.SetMaterial(self.gradientH)
    surface.DrawTexturedRectUV(0, 0, w, h, 1, 0, 0, 1)
 
    -- Draw top gradient.
    surface.SetDrawColor(colort)
    surface.SetMaterial(self.gradientV)
    surface.DrawTexturedRect(0, 0, w, h)
 
    -- Draw bottom gradient.
    surface.SetDrawColor(colorb)
    surface.SetMaterial(self.gradientV)
    surface.DrawTexturedRectUV(0, 0, w, h, 0, 1, 1, 0)
end
 
vgui.Register("MenuBackgroundGradient", PANEL)