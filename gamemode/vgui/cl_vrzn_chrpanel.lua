--[[
	Name: cl_menu_character_create.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


--- --------------------------------------------------------------
--- Seleção de personagens V2.0 ----------------------------------
--- --------------------------------------------------------------
function ScreenPercent( dimension, percentage)
    if dimension ~= w || h then return end
    if dimension == w then
        return (ScrW() * percentage) / 100
    else
        return (ScrH() * percentage) / 100
    end
end

--- --------------------------------------------------------------
--- Cards ----------------------------------
--- --------------------------------------------------------------
surface.CreateFont("CS::PlayButton", { font = "Montserrat Bold", extended = false, size = 26, weight = 500, antialias = true } )
surface.CreateFont("CS::CharacterName", { font = "Montserrat Bold", extended = false, size = 32, weight = 500, antialias = true } )
surface.CreateFont("CS::Title", { font = "Montserrat Bold", extended = false, size = 52, weight = 500, antialias = true } )
surface.CreateFont("CS::Label", { font = "Montserrat Bold", extended = false, size = 28, weight = 500, antialias = true } )

local PANEL = {}

function PANEL:Init()
    bState = true
    SetCalcView()
    self:SetTall( 64 )
    self.Icon = vgui.Create("DImage", self)
    self.Icon:Dock(LEFT)
    self.Icon:DockMargin(16, 16, 0, 16)
    self.Icon:SetWide(32)
    self.Icon:SetImageColor( Color(026,26,26) )
    self.Icon:SetImage("materials/vgui/elements/user.png")

end

function PANEL:SetCharacter( id, datatbl )
    self.CharacterID = id
    self.CharacterTable = datatbl
    self:SetText("")
end

function PANEL:BuildClientModel( id, tbl )
    datatbl = tbl
    if IsValid( CharacterCreationPreviewModel ) then
		CharacterCreationPreviewModel:Remove()
	end

	CharacterCreationPreviewModel = ClientsideModel( datatbl.Model, RENDERGROUP_BOTH )
	CharacterCreationPreviewModel:SetSkin( datatbl.Skin )

	local min, max = CharacterCreationPreviewModel:GetRenderBounds()
	local center = (min +max) *-0.50
	CharacterCreationPreviewModel:SetPos( Vector(13246.850585938, -10012.842773438, -319.39776611328) )
	CharacterCreationPreviewModel:SetAngles( Angle(0,60, 0) )

    CharacterCreationPreviewModel:ResetSequence( CharacterCreationPreviewModel:LookupSequence("pose_standing_04") )
    
    self.m_intLastPaint = 0
end

function PANEL:Paint( w, h )
    draw.RoundedBox(0, 0, 0, w, h, Color( 255,255,255 ) )
    draw.SimpleText( self.CharacterTable.Name.First .. " " .. self.CharacterTable.Name.Last, "CS::CharacterName", 64, h/2, Color(26,26,26), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if self:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color( 255,255,255 ) )
        surface.SetDrawColor(200,200,200, 255)
        surface.SetMaterial( Material("materials/vgui/elements/gradient-left.png") )
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText( self.CharacterTable.Name.First .. " " .. self.CharacterTable.Name.Last, "CS::CharacterName", 64, h/2, Color(26,26,26), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:EnablePlayButton()
    if ValidPanel(CSPlayButton) then CSPlayButton:Remove() end
    local container = self:GetParent()
    CSPlayButton = vgui.Create( "DButton", container:GetParent() )
    CSPlayButton:DockMargin(2 * self:GetWide()/3, 0, 0, 0)
    CSPlayButton:Dock( TOP )
    CSPlayButton:SetTall( 64 )
    CSPlayButton:SetText("")
    CSPlayButton.Paint = function( pnl, w, h )
        draw.RoundedBox(8, 0, 0, w, h, Color(26,26,26) )
        draw.RoundedBox(8, 1, 1, w-2, h-2, Color(255,255,255) )
        draw.SimpleText("JOGAR", "CS::PlayButton", w/2, h/2, Color(26,26,26,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    CSPlayButton.DoClick = function()
        CharacterCreationPreviewModel:Remove()
        bState = true
        GAMEMODE.Net:RequestSelectCharacter( self.CharacterID )
        local container = self:GetParent()
        local nav = container:GetParent()
        nav:GetParent():Remove()
        bState = false
    end
end

function PANEL:DoClick()
   self:BuildClientModel( self.CharacterID, self.CharacterTable )
   self:EnablePlayButton()
end

function PANEL:PerformLayout()
    self:DockMargin(0, 0, 0, 30)
    self:Dock( TOP )
end

vgui.Register("AWESOME_CaracterSlot", PANEL, "DButton")









--- --------------------------------------------------------------
--- Painel principal ---------------------------------------------
--- --------------------------------------------------------------
local bState = false



local PANEL = {}
function PANEL:Init()
    bState = true
    self.SelectedCharacter = 0
    self.CharacterCards = {}

    self.CloseButton = vgui.Create("SRP_Button", self)
    self.CloseButton:SetSize(24, 24)
    self.CloseButton:SetText("X")
    self.CloseButton:SetPos( ScrW() - self.CloseButton:GetWide() )
    self.CloseButton.DoClick = function()
        RunConsoleCommand("disconnect")
        self:Remove()
        bState = false 
        if CharacterCreationPreviewModel then
        CharacterCreationPreviewModel:Remove()
        end
    end
    -- 
    local NavW = ScreenPercent( w, 40)
    self.LeftNav = vgui.Create( "DPanel", self )
    self.LeftNav:DockPadding( 0 , ScreenPercent( h, 5), 0, 50)
    self.LeftNav:SetWide( NavW )
    self.LeftNav:Dock( LEFT )
    self.LeftNav.Paint = function(pnl, w, h)
        surface.SetDrawColor(26,26,26, 255)
        surface.SetMaterial( Material("materials/vgui/elements/gradient-left.png") )
        surface.DrawTexturedRect(0, 0, w, h)
    end
    --
    self.SelectCharacterLabel = vgui.Create("DPanel", self.LeftNav)
    self.SelectCharacterLabel:Dock( TOP )
    self.SelectCharacterLabel:DockMargin(30, 0, 0, 0)
    self.SelectCharacterLabel:SetTall( 80 )
    self.SelectCharacterLabel.Paint = function(pnl, w, h)
        draw.SimpleText("Seleção de personagem", "CS::Title", 0, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end
    --
    local CharacterCount = 1
    if  GAMEMODE.Config.VIP2Groups[LocalPlayer():GetUserGroup()] then CharacterCount = 2 end
    if  GAMEMODE.Config.VIP3Groups[LocalPlayer():GetUserGroup()] then CharacterCount = 3 end
    self.LeftNavButtonsContainer = vgui.Create( "DPanel", self.LeftNav )
    self.LeftNavButtonsContainer:DockMargin(30, 0, 0, 0)
    self.LeftNavButtonsContainer:SetTall( (64 * ( CharacterCount ) ) + ( 30 * ( CharacterCount ) ) )
    self.LeftNavButtonsContainer:Dock(TOP)
    self.LeftNavButtonsContainer.Paint = nil
    --

end


function PANEL:ShowLoadingScreen()
	local x, y = self.m_pnlCharContainer:GetPos()
	local w, h = self.m_pnlCharContainer:GetSize()

	self.m_pnlCharContainer:MoveTo( -w, y, 0.25, 0, 2, function()
		self.m_pnlCharContainer:SetVisible( false )
	end )

	self.m_pnlLoadingMenu:SetPos( self:GetWide(), y )
	self.m_pnlLoadingMenu:SetSize( w, h )
	self.m_pnlLoadingMenu:SetVisible( true )
	self.m_pnlLoadingMenu:MoveTo( 0, y, 0.25, 0, 2, function()
		self.m_pnlLoadingMenu:SetVisible( true )
	end )

	self.m_pnlTitleLabel:SetText( "Loading..." )
	self.m_pnlTitleLabel:SizeToContents()
	self.m_pnlTitleLabel:SetPos( (self:GetWide() /2) -(self.m_pnlTitleLabel:GetWide() /2), 5 )
end


function PANEL:Paint()

end

function PANEL:PerformLayout()
end

function PANEL:Populate( tblChars )
    for k, v in pairs( self.CharacterCards ) do
		if ValidPanel( v ) then
			v:Remove()
		end
	end

	self.CharacterCards = {}
	for id, data in pairs( tblChars ) do
		local card = vgui.Create( "AWESOME_CaracterSlot", self.LeftNavButtonsContainer)
        card:SetCharacter( id, data )


		table.insert( self.CharacterCards, card )
	end

    if table.Count( self.CharacterCards ) < GAMEMODE.Config.MaxCharacters then
        -- print("Tá sobrando slot")
		local NewCharCard = vgui.Create( "DButton",  self.LeftNavButtonsContainer )
        NewCharCard:SetText( "" )
        NewCharCard:Dock(TOP)
        NewCharCard:SetTall( 64 )
        NewCharCard.DoClick = function()
            self:Remove()
            if ValidPanel(CSPlayButton) then CSPlayButton:Remove() end
			OpenNewCharMenu() 
        end
        NewCharCard.Paint = function(pnl, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color( 255,255,255 ) )
            draw.SimpleText( "Novo Personagem", "CS::CharacterName", 64, h/2, Color(26,26,26), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            if pnl:IsHovered() then

                draw.RoundedBox(0, 0, 0, w, h, Color( 255,255,255 ) )
                surface.SetDrawColor(200,200,200, 255)
                surface.SetMaterial( Material("materials/vgui/elements/gradient-left.png") )
                surface.DrawTexturedRect(0, 0, w, h)
                draw.SimpleText( "Novo Personagem", "CS::CharacterName", 64, h/2, Color(26,26,26), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end
        --
        NewCharCardIcon = vgui.Create("DImage", NewCharCard)
        NewCharCardIcon:Dock(LEFT)
        NewCharCardIcon:DockMargin(16, 16, 0, 16)
        NewCharCardIcon:SetWide(32)
        NewCharCardIcon:SetImageColor( Color(026,26,26) )
        NewCharCardIcon:SetImage("materials/vgui/elements/user-add.png")

        
		table.insert( self.CharacterCards, NewCharCard )
	end
end

function PANEL:DoClick()
    self:Remove()
end

vgui.Register("AWESOME_CharacterScreen1", PANEL, EditablePanel)




--- --------------------------------------------------------------
--- Painel Novo Personagem ---------------------------------------
--- --------------------------------------------------------------
local PANEL = {}

function PANEL:Init()
    -- BuildPreview( mdl, skin)
    self.m_strFirstName = "Insira um nome"
	self.m_strLastName = "Insira um sobrenome"
	self.m_intSex = 0
	self.m_intSkin = 0


    self.BackButton = vgui.Create("SRP_Button", self)
    self.BackButton:SetSize(60, 40)
    self.BackButton:SetText("< Voltar")
    self.BackButton:SetPos( ScrW()/2 - 30, 0 )
    self.BackButton.DoClick = function()
        self:Remove()
        OpenCharMenu()
        bState = false
    end

    self.CloseButton = vgui.Create("SRP_Button", self)
    self.CloseButton:SetSize(24, 24)
    self.CloseButton:SetText("X")
    self.CloseButton:SetPos( ScrW() - self.CloseButton:GetWide() )
    self.CloseButton.DoClick = function()
        self:Remove()
        RunConsoleCommand("disconnect")
        bState = false
        if CharacterCreationPreviewModel then
            CharacterCreationPreviewModel:Remove()
        end
    end
    -- 
    local NavW = ScreenPercent( w, 40)
    self.LeftNav = vgui.Create( "DPanel", self )
    self.LeftNav:DockPadding( 0 , 0, 0, 50)
    self.LeftNav:SetWide( NavW )
    self.LeftNav:Dock( LEFT )
    self.LeftNav.Paint = nil
    --
    self.CreateCharacterLabel = vgui.Create("DLabel", self.LeftNav)
    self.CreateCharacterLabel:Dock( TOP )
    self.CreateCharacterLabel:SetTextColor( Color(255,255,255) )
    self.CreateCharacterLabel:SetFont("CS::Title")
    self.CreateCharacterLabel:SetText("Criação de personagem")
    self.CreateCharacterLabel:DockMargin(60, 0, 0, 0)
    self.CreateCharacterLabel:SizeToContentsY()
    -- self.CreateCharacterLabel.Paint = function(pnl, w, h)
    --     draw.SimpleText("Criação de personagem", "CS::Title", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    -- end
    self.CreateCharacterLabel:SizeToContentsY(2)
    --
    self.LeftNavButtonsContainer = vgui.Create( "DPanel", self.LeftNav )
    self.LeftNavButtonsContainer:DockMargin(30, 0, 0, 0)
    self.LeftNavButtonsContainer:DockPadding(30,60,60,0)
    self.LeftNavButtonsContainer:SetTall(   ScreenPercent( h, 50) )
    self.LeftNavButtonsContainer:Dock(TOP)
    self.LeftNavButtonsContainer.Paint = nil

    self.NameLabel = vgui.Create("DLabel", self.LeftNavButtonsContainer)
    self.NameLabel:DockMargin(0, 0, 0, 3)
    self.NameLabel:Dock(TOP)
    self.NameLabel:SetFont("CS::Label")
    self.NameLabel:SetTextColor( Color(255,255,255) )
    self.NameLabel:SizeToContentsY()
    --
    self.NameLabel:SetText("Nome do personagem")
    self.NameInput = vgui.Create( "DTextEntry", self.LeftNavButtonsContainer )
    self.NameInput:DockMargin(0,0,0,10)
    self.NameInput:Dock(TOP)
    self.NameInput:SetTall( 32 )
    self.NameInput:SetValue("Insira um nome")
    self.NameInput:SelectAllOnFocus(true)
    self.NameInput.Paint = function( pnl, w, h )
        draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
        draw.SimpleText( pnl:GetValue(), "CS::Label", 10, 0, Color(26,26,26,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.NameInput.OnGetFocus = function(pnl)
        pnl:SetValue("")
        pnl.Paint = function(pnl, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
            draw.SimpleText( pnl:GetValue(), "CS::Label", 10, 0, Color(26,26,26,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetFont("CS::Label")
            local tw, th = surface.GetTextSize(pnl:GetValue())
            surface.SetDrawColor(26,26,26, (math.sin(RealTime()*7) +1)*127.5)
            surface.DrawRect(tw + 10, 4 , 2, h - 6)
        end
    end
    self.NameInput.OnLoseFocus = function(pnl)
        pnl.Paint = function( pnl, w, h )
            draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
            draw.SimpleText( pnl:GetValue(), "CS::Label", 10, 0, Color(26,26,26,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    --------
    self.EnableOption = nil
    self.LastNameLabel = vgui.Create("DLabel", self.LeftNavButtonsContainer)
    self.LastNameLabel:DockMargin( 0, 10, 0, 0)
    self.LastNameLabel:Dock(TOP)
    self.LastNameLabel:SetFont("CS::Label")
    self.LastNameLabel:SetTextColor( Color(255,255,255) )
    self.LastNameLabel:SizeToContentsY()
    self.LastNameLabel:SetText("Sobrenome do personagem")
    --
    self.LastNameInput = vgui.Create( "DTextEntry", self.LeftNavButtonsContainer )
    self.LastNameInput:DockMargin(0,0,0,0)
    self.LastNameInput:Dock(TOP)
    self.LastNameInput:SetTall( 32 )
    self.LastNameInput:SelectAllOnFocus(true)
    self.LastNameInput:SetValue("Insira um Sobrenome")
    self.LastNameInput.Paint = function( pnl, w, h )
        draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
        draw.SimpleText( pnl:GetValue(), "CS::Label", 10, 0, Color(26,26,26,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    self.LastNameInput.OnGetFocus = function(pnl)
        pnl:SetValue("")
        pnl.Paint = function(pnl, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
            draw.SimpleText( pnl:GetValue(), "CS::Label", 10, 0, Color(26,26,26,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetFont("CS::Label")
            local tw, th = surface.GetTextSize(pnl:GetValue())
            surface.SetDrawColor(26,26,26, (math.sin(RealTime()*7) +1)*127.5)
            surface.DrawRect(tw + 10, 4 , 2, h - 6)
        end
    end
    self.LastNameInput.OnLoseFocus = function(pnl)
        pnl.Paint = function( pnl, w, h )
            draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
            draw.SimpleText( pnl:GetValue(), "CS::Label", 10, 0, Color(26,26,26,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end
    self.LastNameInput.OnTextChanged = function(pnl)
    end
    -------------
    self.OfensiveWarning = vgui.Create("DPanel", self.LeftNavButtonsContainer)
    self.OfensiveWarning:DockMargin(0,15,0,5)
    self.OfensiveWarning:Dock(TOP)
    self.OfensiveWarning:SetTall(48)
    self.OfensiveWarning.Paint = function( pnl, w, h )
        surface.SetDrawColor(200,0,40, 255)
        surface.SetMaterial( Material("materials/vgui/elements/gradient-left.png") )
        surface.DrawTexturedRect(0, 0, w, h)

        draw.SimpleText("Não utilize um Nick/Nome Ofensivo", "CS::Label", 16, h/2-2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    -------
    self.SexLabel = vgui.Create("DLabel", self.LeftNavButtonsContainer)
    self.SexLabel:DockMargin( 0, 10, 0, 0)
    self.SexLabel:Dock(TOP)
    self.SexLabel:SetFont("CS::Label")
    self.SexLabel:SetTextColor( Color(255,255,255) )
    self.SexLabel:SizeToContentsY()
    self.SexLabel:SetText("Sexo do personagem")
    --
    self.SexBtn = vgui.Create("DButton", self.LeftNavButtonsContainer)
    self.SexBtn:Dock( TOP )
    self.SexBtn:SetTall(32)
    self.SexBtn:SetFont("CS::Label")
    self.SexBtn:SetText("Masculino")
    self.SexBtn.Paint = function( pnl, w, h )
        if pnl:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, Color(200,200,200))
            pnl:SetTextColor( Color(26,26,26) )
        else
            draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
        end
    end
    self.SexBtn.DoClick = function()
        self.m_intSex = self.m_intSex == 1 and 0 or 1
        self.SexBtn:SetText( self.m_intSex == 0 and "Masculino" or "Feminino" )
		self:SetSex()
    end
    -------
    self.SkinLabel = vgui.Create("DLabel", self.LeftNavButtonsContainer)
    self.SkinLabel:DockMargin( 0, 10, 0, 0)
    self.SkinLabel:Dock(TOP)
    self.SkinLabel:SetFont("CS::Label")
    self.SkinLabel:SetTextColor( Color(255,255,255) )
    self.SkinLabel:SizeToContentsY()
    self.SkinLabel:SetText("Modelo do personagem")
    --
    self.m_pnlModelList = vgui.Create( "DPanelList", self.LeftNavButtonsContainer )
	self.m_pnlModelList:SetTall( ScreenPercent(h,20) )
    self.m_pnlModelList:DockMargin( 0, 0, 0, 15)
    self.m_pnlModelList:Dock(TOP)
	self.m_pnlModelList:EnableHorizontal( true ) 
	self.m_pnlModelList:EnableVerticalScrollbar( false ) 
	self.m_pnlModelList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 255,255,255, 125 )
		surface.DrawRect( 0, 0, intW, intH )
    end
    self:PopulateModelList()

    self.PrevSkinbtn = vgui.Create("DButton", self)
    self.PrevSkinbtn:DockMargin(ScrW()/5, 0, 0, 0)
    self.PrevSkinbtn:Dock(LEFT)
    self.PrevSkinbtn:SetFont("CS::Label")
    self.PrevSkinbtn:SetWide(60)
    self.PrevSkinbtn:SetText("<")
    self.PrevSkinbtn.Paint = function(pnl, w, h)
        draw.RoundedBox(30, 0, h/2 -28, w, 60, Color(255,255,255) )
    end
    self.PrevSkinbtn.DoClick = function()
        self:LastSkin()
    end
    ----
    self.NextSkinbtn = vgui.Create("DButton", self)
    self.NextSkinbtn:DockMargin(0, 0, 20, 0)
    self.NextSkinbtn:Dock(RIGHT)
    self.NextSkinbtn:SetFont("CS::Label")
    self.NextSkinbtn:SetWide(60)
    self.NextSkinbtn:SetText(">")
    self.NextSkinbtn.Paint = function(pnl, w, h)
        draw.RoundedBox(30, 0, h/2 -28, w, 60, Color(255,255,255) )
    end
    self.NextSkinbtn.DoClick = function()
        self:NextSkin()
    end

    self.DoneBtn = vgui.Create("DButton", self.LeftNavButtonsContainer)
    self.DoneBtn:Dock( TOP )
    self.DoneBtn:SetTall(32)
    self.DoneBtn:SetFont("CS::Label")
    self.DoneBtn:SetText("FINALIZAR PERSONAGEM")
    self.DoneBtn.Paint = function( pnl, w, h )
        if pnl:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, Color(200,200,200))
            pnl:SetTextColor( Color(26,26,26) )
        else
            draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
        end
    end
    self.DoneBtn.DoClick = function()
        CharacterCreationPreviewModel:Remove()
        GAMEMODE.Net:RequestCreateCharacter{
			Name = {
				First = self.NameInput:GetValue(),
				Last = self.LastNameInput:GetValue(),
			},
			Model = self.m_strModel,
			Sex = self.m_intSex,
			Skin = self.m_intSkin,
        }
        self:Remove()
        bState = false
    end
end

function PANEL:PopulateModelList()

    local models = GAMEMODE.Config.PlayerModels[self.m_intSex == 0 and "Male" or "Female"]
	self.m_pnlModelList:Clear( true )

	for k, v in pairs( models ) do
		local modelIcon = vgui.Create( "SpawnIcon" )
		modelIcon:SetSize( 64, 64 )
		modelIcon:SetModel( k )
		modelIcon:SetToolTip( nil )
		modelIcon.PaintOver = function()
		end
		modelIcon.DoClick = function()
			self.m_strModel = k
			self.m_intSkin = 0
			-- self.m_pnlSkinLabel:SetText( "Character Skin (0)" )
            PANEL:BuildPreview( k, self.m_intSkin)
			self:InvalidateLayout()
		end

		self.m_pnlModelList:AddItem( modelIcon )
	end

	self:InvalidateLayout()
end

function PANEL:SetSex()
    self:PopulateModelList()

	--Pick a random model
	local models = GAMEMODE.Config.PlayerModels[self.m_intSex == 0 and "Male" or "Female"]
	local count = table.Count( models )
	local randomIDX = math.random( 1, count )
	local i = 0
	for k, v in pairs( models ) do
		i = i +1
		if i == randomIDX then self.m_strModel = k break end
	end

	self.m_intSkin = 0
    -- self.m_pnlSkinLabel:SetText( "Character Skin (0)" )
    self:BuildPreview( self.m_strModel, self.m_intSkin)
	self:InvalidateLayout()
end

function PANEL:NextSkin()
    if not IsValid( CharacterCreationPreviewModel ) then return end
	self.m_intSkin = self.m_intSkin +1
	if self.m_intSkin > CharacterCreationPreviewModel:SkinCount() -1 then
		self.m_intSkin = 0
	end

	if not GAMEMODE.Util:ValidPlayerSkin( self.m_strModel, self.m_intSkin ) then
		self:NextSkin()
		return
	end
    CharacterCreationPreviewModel:SetSkin( self.m_intSkin )
end

function PANEL:LastSkin()
    if not IsValid( CharacterCreationPreviewModel ) then return end
	self.m_intSkin = self.m_intSkin -1
	if self.m_intSkin < 0 then
		self.m_intSkin = 0
	end

	if not GAMEMODE.Util:ValidPlayerSkin( self.m_strModel, self.m_intSkin ) then
		self:LastSkin()
		return
	end
        CharacterCreationPreviewModel:SetSkin( self.m_intSkin )
	self:InvalidateLayout()
end

function PANEL:BuildPreview( mdl, skin)
    if IsValid( CharacterCreationPreviewModel ) then
		CharacterCreationPreviewModel:Remove()
	end

	CharacterCreationPreviewModel = ClientsideModel( mdl, RENDERGROUP_BOTH )
	CharacterCreationPreviewModel:SetSkin( skin )

	CharacterCreationPreviewModel:SetPos( Vector(13246.850585938, -10012.842773438, -319.39776611328) )
	CharacterCreationPreviewModel:SetAngles( Angle(0,60, 0) )

    CharacterCreationPreviewModel:ResetSequence( CharacterCreationPreviewModel:LookupSequence("pose_standing_01") )
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(26,26,26, 150)
    surface.SetMaterial( Material("materials/vgui/elements/gradient-bottom.png") )
    surface.DrawTexturedRect(0, 0, w, h)

end

function PANEL:PerformLayout()
end


vgui.Register("AWESOME_CharCreate", PANEL, "EditablePanel")







function OpenCharMenu() 
    if bState == false then bState = true else bState = false end
    SetCalcView()

    local CharacterSelectionDerma = vgui.Create("AWESOME_CharacterScreen1")
    CharacterSelectionDerma:SetSize( ScrW(), ScrH() )
    CharacterSelectionDerma:Center()
    CharacterSelectionDerma:MakePopup()
    CharacterSelectionDerma:Populate( GAMEMODE.Char:GetPlayerCharacters() )

    -- PrintTable(GAMEMODE.Char:GetPlayerCharacters())
    -- if ValidPanel( m_pnlCharCreate ) then
	-- 	m_pnlCharCreate2:Remove()
	-- end

	-- if ValidPanel( m_pnlCharCreate ) then
	-- 	m_pnlCharSel2:SetVisible( false )
	-- end
	
	-- m_pnlCharSel2 = vgui.Create( "SRPCharacterSelection2" )
	-- m_pnlCharSel2:SetPos( 0, 0 )
	-- m_pnlCharSel2:SetSize( ScrW(), ScrH() )
	-- m_pnlCharSel2:Populate( GAMEMODE.Char:GetPlayerCharacters() )
	-- m_pnlCharSel2:SetVisible( true )
	-- m_pnlCharSel2:MakePopup()
end


concommand.Add("openchar", OpenCharMenu)

function OpenNewCharMenu()
   if CharacterCreationPreviewModel then  CharacterCreationPreviewModel:Remove() end
    
    local CreateNewCharPanel = vgui.Create("AWESOME_CharCreate")
    CreateNewCharPanel:SetSize( ScrW(), ScrH() )
    CreateNewCharPanel:MakePopup()

    --


    -- print( NameInput:GetValue() )

end





-- hook.Add( "GamemodeLoadingCharacter", "ShowLoadingMenu", function()
--     local LoadingPanel = vgui.Create("DPanel")
--     LoadingPanel:SetSize( ScrW(), ScrH() )
--     timer.Create("RemoveLoading", 3, 1, function 
--         LoadingPanel:Remove()
--     end)
-- end )