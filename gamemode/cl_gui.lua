--[[
	Name: cl_gui.lua
	
		
]]--
-- PrintTable( Entity( 1 ):GetSequenceList() )
local SANDBOX = {}
GM.Gui = (GAMEMODE or GM).Gui or {}
GM.Gui.m_intKeyDelay = 0.15
GM.Gui.m_tblNWMenus = (GAMEMODE or GM).Gui.m_tblNWMenus or {}
GM.Gui.m_tblKeyStates = (GAMEMODE or GM).Gui.m_tblKeyStates or {}
GM.Gui.m_tblVoicePanels = {}


function GM.Gui:Initialize()
	self:BuildCarShop()
	self:BuildCarSpawn()
	self:BuildCopMenus()
	self:BuildJailMenus()
	self:BuildTicketMenu()
	self:BuildPropertyMenus()
	self:BuildCustomPlateMenu()
	self:BuildDrivingTestMenu()
	self:BuildBankMenu()
	self:BuildClothingMenu()
	self:BuildCraftingMenus()
	self:BuildChatRadioMenu()
	self:BuildItemLockerMenu()
	self:BuildGovMenus()
	
	--FFFFFFFFFFFFF GARRY, CALL THE FUCKING CALLBACK, AT ALL TIMES
	g_PanelMoveTo = g_PanelMoveTo or debug.getregistry().Panel.MoveTo
	debug.getregistry().Panel.MoveTo = function( pnl, x, y, length, delay, ease, callback )
		if pnl.x == x and pnl.y == y then callback() return end
		return g_PanelMoveTo( pnl, x, y, length, delay, ease, callback )
	end
end

function GM.Gui:RegisterNWMenu( strID, pnlMenu )
	self.m_tblNWMenus[strID] = pnlMenu
end

function GM.Gui:ShowNWMenu( strID )
	self.m_tblNWMenus[strID]:Open()
end

function GM.Gui:Tick()
	if input.IsKeyDown( KEY_V ) then
		if not ValidPanel( self.m_pnlCarRadioMenu ) then
			self.m_pnlCarRadioMenu = vgui.Create( "SRPRadioRadialMenu" )
			self.m_pnlCarRadioMenu:SetSize( 340, 340 )
			self.m_pnlCarRadioMenu:Center()

			--Some kind of mouse bug?
			self.m_pnlCarRadioMenu:MakePopup()
			self.m_pnlCarRadioMenu:SetVisible( false )
		end

		if IsValid( LocalPlayer():GetVehicle() ) and LocalPlayer():GetVehicle():GetClass() ~= "prop_vehicle_jeep" then return end
		if self.m_pnlCarRadioMenu:IsVisible() or vgui.CursorVisible() or not LocalPlayer():InVehicle() then return end
		if ValidPanel( vgui.GetKeyboardFocus() ) then return end
		self.m_pnlCarRadioMenu:Open()	
	else
		if ValidPanel( self.m_pnlCarRadioMenu ) then
			self.m_pnlCarRadioMenu:Close()
		end
	end

	if input.IsKeyDown( KEY_T ) then
		if not ValidPanel( self.m_pnlActMenu ) then
			self.m_pnlActMenu = vgui.Create( "SRPActRadialMenu" )
			self.m_pnlActMenu:SetSize( 280, 280 )
			self.m_pnlActMenu:Center()

			--Some kind of mouse bug?
			self.m_pnlActMenu:MakePopup()
			self.m_pnlActMenu:SetVisible( false )
		end

		if self.m_pnlActMenu:IsVisible() or vgui.CursorVisible() or LocalPlayer():InVehicle() then return end
		if ValidPanel( vgui.GetKeyboardFocus() ) then return end
		self.m_pnlActMenu:Open()	
	else
		if ValidPanel( self.m_pnlActMenu ) and self.m_pnlActMenu:IsVisible() then
			self.m_pnlActMenu:Close()
		end
	end

	if input.IsKeyDown( KEY_F2 ) then
		if not ValidPanel( self.m_pnlChatRadio ) then return end
		if self.m_pnlChatRadio:IsVisible() or vgui.CursorVisible() then return end
		if ValidPanel( vgui.GetKeyboardFocus() ) then return end
		self.m_pnlChatRadio:Open()	
	else
		if ValidPanel( self.m_pnlChatRadio ) and self.m_pnlChatRadio:IsVisible() then
			self.m_pnlChatRadio:Close()
		end
	end
end

-- function GM.Gui:CreateMove( CUserCmd )
-- 	if not GAMEMODE.m_bInGame then return end
-- 	if not self.m_intLastScroll then self.m_intLastScroll = 0 end
	
-- 	if CurTime() < self.m_intLastScroll then return end
	
-- 	if CUserCmd:GetMouseWheel() > 0 then
-- 		self.m_intLastScroll = CurTime() +0.015
-- 	elseif CUserCmd:GetMouseWheel() < 0 then
-- 		self.m_intLastScroll = CurTime() +0.015
-- 	end
-- end


// Voice chat

local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()
	self.LabelName = vgui.Create( "DLabel", self )
	self.LabelName:SetFont( "GModNotify" )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 8, 0, 0, 0 )
	self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

	//self.ModelPanel = vgui.Create("DModelPanel", self )
	//self.ModelPanel:Dock( LEFT )
	//self.ModelPanel:SetSize( 32, 32 )
	//self.Avatar = vgui.Create( "AvatarImage", self )
	//self.Avatar:Dock( LEFT );
	//self.Avatar:SetSize( 32, 32 )

	self.Color = color_transparent

	self:SetSize( 250, 32 + 8 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )
end

function PANEL:Setup( ply )
	self.ply = ply
	self.LabelName:SetText( ply:Nick() .. ' [' .. ply:GetName() .. ']')

	//self.ModelPanel:SetModel( ply:GetModel() )
	//self.ModelPanel.Entity:SetRenderMode(2)
	//self.ModelPanel.LayoutEntity = function(Entity) end
	//self.ModelPanel:SetFOV(70)
	//self.ModelPanel:SetCamPos(Vector(14, 0, 60))
	//self.ModelPanel:SetLookAt(CAM_LOOK_AT[ply:GetSex()])
	//self.Avatar:SetPlayer( ply )
	local PlayerJob = GAMEMODE.Jobs:GetPlayerJob( ply ) or {}
	self.Color = PlayerJob.TeamColor or team.GetColor( ply:Team() )
	
	self:InvalidateLayout()
end

function PANEL:Paint( w, h )
	if not IsValid( self.ply ) then return end
	draw.RoundedBox( 4, 0, 0, w, h, Color( 0, self.ply:VoiceVolume() * 255, 0, 240 ) )
end

function PANEL:Think()
	if self.fadeAnim then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut( anim, delta, data )
	if anim.Finished then
		if IsValid( PlayerVoicePanels[ self.ply ] ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end

		return
	end
			
	self:SetAlpha( 255 - ( 255 * delta ) )
	// Player models look like shit with alpha turned down :(
		local x, y = self:GetPos()
	self:SetPos(x + (400 * delta), y)
	//self.ModelPanel:SetColor(Color(255, 255, 255, 255 - ( 255 * delta )))
end

derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )

function GM.Gui:PlayerStartVoice( ply ) 
	if not IsValid( LocalPlayer() ) then return end
	if not LocalPlayer():IsAdmin() then return end
	if not IsValid( g_VoicePanelList ) then return end
	
	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE.Gui:PlayerEndVoice( ply )


	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return

	end

	if not IsValid( ply ) then return end

	local pnl = g_VoicePanelList:Add( "VoiceNotify" )
	pnl:Setup( ply )
	
	PlayerVoicePanels[ ply ] = pnl
end
	
function GM.Gui:PlayerEndVoice( ply ) 
	if not IsValid( LocalPlayer() ) then return end
	if not LocalPlayer():IsAdmin() then return end
	if IsValid( PlayerVoicePanels[ ply ] ) then

		if PlayerVoicePanels[ ply ].fadeAnim then return end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

	end
end

local function VoiceClean()
	for k, v in pairs( PlayerVoicePanels ) do
		if not IsValid( k ) then
			GAMEMODE.Gui:PlayerEndVoice( k )
		end
	end
end

timer.Create( "VoiceClean", 10, 0, VoiceClean )

local function CreateVoiceVGUI()
	if IsValid( g_VoicePanelList ) then g_VoicePanelList:Remove() end
	g_VoicePanelList = vgui.Create( "DPanel" )

	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( ScrW() - 300, 100 )
	g_VoicePanelList:SetSize( 250, ScrH() - 320 )
	g_VoicePanelList:SetDrawBackground( false )	
end

hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )

function GM.Gui:HUDShouldDraw( strName )
	-- if strName == "CHudWeaponSelection" then return false end
end

--Thanks gmod, this is a huge mess now
function GM.Gui:Think()
	if not GAMEMODE.m_bInGame then return end
	if vgui.CursorVisible() then return end
	if gui.IsGameUIVisible() then return end
	
	
	if ValidPanel( vgui.GetKeyboardFocus() ) then return end
	if input.IsKeyDown( KEY_F4 ) then
		-- KeyF4Menu = vgui.Create("ErisF4")
	end
end

function GM:OnContextMenuOpen()

		if not self:IsInGame() then return end
		if LocalPlayer():HasWeapon( "weapon_handcuffed" ) or LocalPlayer():HasWeapon( "weapon_ziptied" ) then return end
	
		if not ValidPanel( self.m_pnlQMenu ) then
			self.m_pnlQMenu = vgui.Create( "SRPQMenu" )
			self.m_pnlQMenu:SetSize( math.max(ScrW() *0.66, 800), math.max(ScrH() *0.8, 600) )
			--self.m_pnlQMenu:SetSize( 800, 600 )
			self.m_pnlQMenu:Center()
		end
	
		self.m_pnlQMenu:Refresh()
		self.m_pnlQMenu:SetVisible( true )
		self.m_pnlQMenu:MakePopup()
	
		RestoreCursorPosition()

end

function GM:OnContextMenuClose()
	RememberCursorPosition()
	if ValidPanel( self.m_pnlQMenu ) then
				self.m_pnlQMenu:SetVisible( false )
				CloseDermaMenus()
				RememberCursorPosition()
			end
end

function GM.Gui:StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText, intCharLimit )
	local Window = vgui.Create( "SRP_Frame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window:SetBackgroundColor( Color(35, 35, 35, 175) )

	local InnerPanel = vgui.Create( "DPanel", Window )
		InnerPanel:SetDrawBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )

	local TextEntry = vgui.Create( "DTextEntry", InnerPanel )
		TextEntry:SetText( strDefaultText or "" )
		TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end

		if intCharLimit then
			TextEntry.AllowInput = function( pnl, intKey )
				local text = pnl:GetValue():sub(0, pnl:GetCaretPos())
				if string.len( text ) >= intCharLimit then
					return true
				end
			end
		end

	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )

	local Button = vgui.Create( "SRP_Button", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end

	local ButtonCancel = vgui.Create( "SRP_Button", ButtonPanel )
		ButtonCancel:SetText( strButtonCancelText or "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
		ButtonCancel:MoveRightOf( Button, 5 )

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	w = math.max( w, 400 ) 
	Window:SetSize( w +50, h +25 +75 +10 )
	Window:Center()
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 35 )	
	
	TextEntry:StretchToParent( 5, nil, 5, nil )
	TextEntry:AlignBottom( 5 )
	TextEntry:RequestFocus()
	TextEntry:SelectAllText( true )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	Window:MakePopup()
	Window:DoModal()
	return Window
end

function GM.Gui:Derma_Query( strText, strTitle, ... )
	local Window = vgui.Create( "SRP_Frame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window:SetBackgroundColor( Color(35, 35, 35, 255) )
		
	local InnerPanel = vgui.Create( "DPanel", Window )
		InnerPanel:SetDrawBackground( false )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k = 1, 8, 2 do
		local Text = select( k, ... )
		if Text == nil then break end
		local Func = select( k +1, ... ) or function() end
	
		local Button = vgui.Create( "SRP_Button", ButtonPanel )
			Button:SetText( Text )
			Button:SizeToContents()
			Button:SetTall( 20 )
			Button:SetWide( Button:GetWide() +20 )
			Button.DoClick = function() Window:Close() Func() end
			Button:SetPos( x, 5 )
			
		x = x +Button:GetWide() +5
		ButtonPanel:SetWide( x ) 
		NumOptions = NumOptions +1
	end

	
	local w, h = Text:GetSize()
	w = math.max( w, ButtonPanel:GetWide() )
	Window:SetSize( w +50, h +25 +45 +10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 5 )	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()
	
	if NumOptions == 0 then
		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil
	end
	
	return Window
end

function GM.Gui:Derma_Message( strText, strTitle, strButtonText )
	local Window = vgui.Create( "SRP_Frame" )
		Window:SetTitle( strTitle or "Message" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window:SetBackgroundColor( Color(35, 35, 35, 175) )
		
	local InnerPanel = vgui.Create( "Panel", Window )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )
		
	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )
		
	local Button = vgui.Create( "SRP_Button", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() end
		
	ButtonPanel:SetWide( Button:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	Window:SetSize( w +50, h +25 +45 +10 )
	Window:Center()
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 5 )	
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	Window:MakePopup()
	Window:DoModal()
	return Window
end

--Build all the game ui
function GM.Gui:BuildCarShop()
	if ValidPanel( self.m_pnlCarShop ) then
		self.m_pnlCarShop:Remove()
	end

	self.m_pnlCarShop = vgui.Create( "SRPCarBuyMenu2" )
	self.m_pnlCarShop:SetSize( ScrW(), ScrH() )
	self.m_pnlCarShop:Center()
	self.m_pnlCarShop:Populate()
	self.m_pnlCarShop:SetVisible( false )
	self:RegisterNWMenu( "car_buy", self.m_pnlCarShop )

	if ValidPanel( self.m_pnlCarSell ) then
		self.m_pnlCarSell:Remove()
	end

	self.m_pnlCarSell = vgui.Create( "SRPCarSellMenu" )
	self.m_pnlCarSell:SetTitle( "Sell A Car" )
	self.m_pnlCarSell:SetSize( 800, 480 )
	self.m_pnlCarSell:Center()
	self.m_pnlCarSell:Populate()
	self.m_pnlCarSell:SetVisible( false )
	self:RegisterNWMenu( "car_sell", self.m_pnlCarSell )
end

function GM.Gui:BuildCarSpawn()
	if ValidPanel( self.m_pnlCarSpawn ) then
		self.m_pnlCarSpawn:Remove()
	end

	self.m_pnlCarSpawn = vgui.Create( "SRPCarSpawn" )
	self.m_pnlCarSpawn:SetSize( 800, 480 )
	self.m_pnlCarSpawn:Center()
	self.m_pnlCarSpawn:Populate()
	self.m_pnlCarSpawn:SetVisible( false )
	self:RegisterNWMenu( "car_spawn", self.m_pnlCarSpawn )
end

function GM.Gui:BuildCopMenus()
	if ValidPanel( self.m_pnlCopCarSpawn ) then
		self.m_pnlCopCarSpawn:Remove()
	end

	self.m_pnlCopCarSpawn = vgui.Create( "SRPCopCarSpawn" )
	self.m_pnlCopCarSpawn:SetSize( 800, 480 )
	self.m_pnlCopCarSpawn:Center()
	self.m_pnlCopCarSpawn:Populate()
	self.m_pnlCopCarSpawn:SetVisible( false )
	self:RegisterNWMenu( "cop_car_spawn", self.m_pnlCopCarSpawn )

	if ValidPanel( self.m_pnlCopComputer ) then
		self.m_pnlCopComputer:Remove()
	end
	
	self.m_pnlCopComputer = vgui.Create( "SRPCopComputerSkinnedMenu" )
	self.m_pnlCopComputer:SetSize( 817, 692 )
	self.m_pnlCopComputer:Center()
	self.m_pnlCopComputer:SetVisible( false )
	self:RegisterNWMenu( "cop_car_computer", self.m_pnlCopComputer )
end

function GM.Gui:BuildJailMenus()
	if ValidPanel( self.m_pnlJailTurnIn ) then
		self.m_pnlJailTurnIn:Remove()
	end
	self.m_pnlJailTurnIn = vgui.Create( "SRPJailTurnInMenu" )
	self.m_pnlJailTurnIn:SetSize( 800, 480 )
	self.m_pnlJailTurnIn:Center()
	self.m_pnlJailTurnIn:SetVisible( false )
	self:RegisterNWMenu( "cop_jail_turnin", self.m_pnlJailTurnIn )

	if ValidPanel( self.m_pnlJailFree ) then
		self.m_pnlJailFree:Remove()
	end
	self.m_pnlJailFree = vgui.Create( "SRPJailFreeMenu" )
	self.m_pnlJailFree:SetSize( 800, 480 )
	self.m_pnlJailFree:Center()
	self.m_pnlJailFree:SetVisible( false )
	self:RegisterNWMenu( "cop_jail_free", self.m_pnlJailFree )

	if ValidPanel( self.m_pnlJailBail ) then
		self.m_pnlJailFree:Remove()
	end
	self.m_pnlJailBail = vgui.Create( "SRPJailBailMenu" )
	self.m_pnlJailBail:SetSize( 800, 480 )
	self.m_pnlJailBail:Center()
	self.m_pnlJailBail:SetVisible( false )
	self:RegisterNWMenu( "cop_jail_bail", self.m_pnlJailBail )
end

function GM.Gui:BuildTicketMenu()
	if ValidPanel( self.m_pnlTicketMenu ) then
		self.m_pnlTicketMenu:Remove()
	end

	self.m_pnlTicketMenu = vgui.Create( "SRPTicketMenu" )
	self.m_pnlTicketMenu:SetSize( 800, 480 )
	self.m_pnlTicketMenu:Center()
	self.m_pnlTicketMenu:SetVisible( false )
	self:RegisterNWMenu( "ticket_menu", self.m_pnlTicketMenu )
end

function GM.Gui:BuildPropertyMenus()
	if ValidPanel( self.m_pnlPropertyBuyMenu ) then
		self.m_pnlPropertyBuyMenu:Remove()
	end

	self.m_pnlPropertyBuyMenu = vgui.Create( "SRPPropertyShop" )
	self.m_pnlPropertyBuyMenu:SetSize( 800, 480 )
	self.m_pnlPropertyBuyMenu:Center()
	self.m_pnlPropertyBuyMenu:SetVisible( false )
	self:RegisterNWMenu( "property_buy", self.m_pnlPropertyBuyMenu )
end

function GM.Gui:ShowNPCShopMenu( strNPCID )
	if ValidPanel( self.m_pnlNPCShopMenu ) then
		self.m_pnlNPCShopMenu:Remove()
	end

	self.m_pnlNPCShopMenu = vgui.Create( "SRPNPCShopMenu" )
	self.m_pnlNPCShopMenu:SetSize( 800, 480 )
	self.m_pnlNPCShopMenu:Center()
	self.m_pnlNPCShopMenu:Populate( strNPCID )
	self.m_pnlNPCShopMenu:SetVisible( true )
	self.m_pnlNPCShopMenu:MakePopup()
end

function GM.Gui:ShowNPCSellMenu( strNPCID )
	if ValidPanel( self.m_pnlNPCSellMenu ) then
		self.m_pnlNPCSellMenu:Remove()
	end

	self.m_pnlNPCSellMenu = vgui.Create( "SRPNPCSellMenu" )
	self.m_pnlNPCSellMenu:SetSize( 800, 480 )
	self.m_pnlNPCSellMenu:Center()
	self.m_pnlNPCSellMenu:Populate( strNPCID )
	self.m_pnlNPCSellMenu:SetVisible( true )
	self.m_pnlNPCSellMenu:MakePopup()
end

bState = false

function SetCalcView( pPlayer, vPos, aAngles, iFov )
	if !bState then return end
    local view = {}
    -- print( (math.sin(RealTime()*7) +12) )
    view.origin = Vector(13276, -9954, -260)
	view.angles = Angle((math.sin(RealTime()*0.3) +12), (math.sin(RealTime()*0.3) -90), 0.000000)
	view.fov = 75
    view.drawviewer = true
    -- PrintTable(view)
    return view
end
hook.Add( "CalcView", "CharacterMenuCamera", SetCalcView )

function GM.Gui:ShowCharacterSelection()
	SetCalcView()

	if ValidPanel( self.m_pnlCharCreate ) then
		self.m_pnlCharCreate:Remove()
	end

	if ValidPanel( self.m_pnlCharCreate ) then
		self.m_pnlCharSel:SetVisible( false )
	end
	
	self.m_pnlCharSel = vgui.Create( "AWESOME_CharacterScreen1" )
	self.m_pnlCharSel:SetPos( 0, 0 )
	self.m_pnlCharSel:SetSize( ScrW(), ScrH() )
	self.m_pnlCharSel:Populate( GAMEMODE.Char:GetPlayerCharacters() )
	self.m_pnlCharSel:SetVisible( true )
	self.m_pnlCharSel:MakePopup()
end

function GM.Gui:ShowNewCharacterMenu()
	if ValidPanel( self.m_pnlCharCreate ) then
		self.m_pnlCharCreate:Remove()
	end

	if ValidPanel( self.m_pnlCharSel ) then
		self.m_pnlCharSel:SetVisible( false )
	end

	self.m_pnlCharCreate = vgui.Create( "AWESOME_CharCreate" )
	self.m_pnlCharCreate:SetPos( 0, 0 )
	self.m_pnlCharCreate:SetSize( ScrW(), ScrH() )
	self.m_pnlCharCreate:SetVisible( true )
	self.m_pnlCharCreate:MakePopup()
end

function GM.Gui:BuildCustomPlateMenu()
	if ValidPanel( self.m_pnlCustomPlate ) then
		self.m_pnlCustomPlate:Remove()
	end

	self.m_pnlCustomPlate = vgui.Create( "SRPCustomPlateMenu" )
	self.m_pnlCustomPlate:SetSize( 800, 480 )
	self.m_pnlCustomPlate:Center()
	self.m_pnlCustomPlate:SetVisible( false )
	self:RegisterNWMenu( "custom_plate_menu", self.m_pnlCustomPlate )
end

function GM.Gui:BuildDrivingTestMenu()
	if ValidPanel( self.m_pnlDrivingTestMenu ) then
		self.m_pnlDrivingTestMenu:Remove()
	end

	self.m_pnlDrivingTestMenu = vgui.Create( "SRPDrivingTestMenu" )
	self.m_pnlDrivingTestMenu:SetSize( 800, 480 )
	self.m_pnlDrivingTestMenu:Center()
	self.m_pnlDrivingTestMenu:SetVisible( false )
	self:RegisterNWMenu( "driving_test_menu", self.m_pnlDrivingTestMenu )
end

function GM.Gui:BuildBankMenu()
	if ValidPanel( self.m_pnlBankMenu ) then
		self.m_pnlBankMenu:Remove()
	end

	self.m_pnlBankMenu = vgui.Create( "SRPBankStorageMenu" )
	self.m_pnlBankMenu:SetSize( 800, 480 )
	self.m_pnlBankMenu:Center()
	self.m_pnlBankMenu:SetVisible( false )
	self:RegisterNWMenu( "bank_storage_menu", self.m_pnlBankMenu )

	if ValidPanel( self.m_pnlLostAndFoundMenu ) then
		self.m_pnlLostAndFoundMenu:Remove()
	end

	self.m_pnlLostAndFoundMenu = vgui.Create( "SRPLostAndFoundMenu" )
	self.m_pnlLostAndFoundMenu:SetSize( 800, 480 )
	self.m_pnlLostAndFoundMenu:Center()
	self.m_pnlLostAndFoundMenu:SetVisible( false )
	self:RegisterNWMenu( "lost_and_found_menu", self.m_pnlLostAndFoundMenu )

	if ValidPanel( self.m_pnlBillsMenu ) then
		self.m_pnlBillsMenu:Remove()
	end

	self.m_pnlBillsMenu = vgui.Create( "SRPBillsMenu" )
	self.m_pnlBillsMenu:SetSize( 800, 480 )
	self.m_pnlBillsMenu:Center()
	self.m_pnlBillsMenu:SetVisible( false )
	self:RegisterNWMenu( "bills_menu", self.m_pnlBillsMenu )
end

function GM.Gui:BuildClothingMenu()
	if ValidPanel( self.m_pnlClothingMenu ) then
		self.m_pnlClothingMenu:Remove()
	end

	self.m_pnlClothingMenu = vgui.Create( "SRPClothingMenu" )
	self.m_pnlClothingMenu:SetSize( 800, 600 )
	self.m_pnlClothingMenu:Center()
	self.m_pnlClothingMenu:SetVisible( false )
	self:RegisterNWMenu( "clothing_shop_menu", self.m_pnlClothingMenu )

	if ValidPanel( self.m_pnlClothingItemMenu ) then
		self.m_pnlClothingItemMenu:Remove()
	end

	self.m_pnlClothingItemMenu = vgui.Create( "SRPClothingItemsMenu" )
	self.m_pnlClothingItemMenu:SetSize( ScrW(), ScrH() )
	self.m_pnlClothingItemMenu:Center()
	self.m_pnlClothingItemMenu:SetVisible( false )
	self:RegisterNWMenu( "clothing_items_store", self.m_pnlClothingItemMenu )

	if ValidPanel( self.m_pnlClothingLockerMenu ) then
		self.m_pnlClothingLockerMenu:Remove()
	end

	self.m_pnlClothingLockerMenu = vgui.Create( "SRPJobClothingLockerMenu" )
	self.m_pnlClothingLockerMenu:SetSize( 800, 600 )
	self.m_pnlClothingLockerMenu:Center()
	self.m_pnlClothingLockerMenu:SetVisible( false )
	self:RegisterNWMenu( "job_clothing_locker", self.m_pnlClothingLockerMenu )
end

function GM.Gui:BuildCraftingMenus()
	if ValidPanel( self.m_pnlCraftingTableMenu ) then
		self.m_pnlCraftingTableMenu:Remove()
	end

	self.m_pnlCraftingTableMenu = vgui.Create( "SRPCraftingTableMenu" )
	self.m_pnlCraftingTableMenu:SetSize( 800, 480 )
	self.m_pnlCraftingTableMenu:Center()
	self.m_pnlCraftingTableMenu:SetVisible( false )
	self.m_pnlCraftingTableMenu:SetCraftingGroupData( "Crafting Table", "ent_crafting_table" )
	self:RegisterNWMenu( "crafting_table", self.m_pnlCraftingTableMenu )

	if ValidPanel( self.m_pnlGunSmithingTableMenu ) then
		self.m_pnlGunSmithingTableMenu:Remove()
	end

	self.m_pnlGunSmithingTableMenu = vgui.Create( "SRPCraftingTableMenu" )
	self.m_pnlGunSmithingTableMenu:SetSize( 800, 480 )
	self.m_pnlGunSmithingTableMenu:Center()
	self.m_pnlGunSmithingTableMenu:SetVisible( false )
	self.m_pnlGunSmithingTableMenu:SetCraftingGroupData( "Gun Smithing Table", "ent_gunsmithing_table" )
	self:RegisterNWMenu( "gunsmithing_table", self.m_pnlGunSmithingTableMenu )

	if ValidPanel( self.m_pnlAssemblyTableMenu ) then
		self.m_pnlAssemblyTableMenu:Remove()
	end

	self.m_pnlAssemblyTableMenu = vgui.Create( "SRPAssemblyTableMenu" )
	self.m_pnlAssemblyTableMenu:SetSize( 800, 480 )
	self.m_pnlAssemblyTableMenu:Center()
	self.m_pnlAssemblyTableMenu:SetVisible( false )
	self.m_pnlAssemblyTableMenu:SetCraftingGroupData( "Assembly Table", "ent_assembly_table" )
	self:RegisterNWMenu( "assembly_table", self.m_pnlAssemblyTableMenu )

	if ValidPanel( self.m_pnlFoodTableMenu ) then
		self.m_pnlFoodTableMenu:Remove()
	end
	
	self.m_pnlFoodTableMenu = vgui.Create( "SRPCraftingTableMenu" )
	self.m_pnlFoodTableMenu:SetSize( 800, 480 )
	self.m_pnlFoodTableMenu:Center()
	self.m_pnlFoodTableMenu:SetVisible( false )
	self.m_pnlFoodTableMenu:SetCraftingGroupData( "Food-Prep Table", "ent_foodprep_table" )
	self:RegisterNWMenu( "foodprep_table", self.m_pnlFoodTableMenu )
end

function GM.Gui:BuildChatRadioMenu()
	if ValidPanel( self.m_pnlChatRadio ) then
		self.m_pnlChatRadio:Remove()
	end

	self.m_pnlChatRadio = vgui.Create( "SRPChatRadioMenu" )
	self.m_pnlChatRadio:SetSize( 226, 185 )
	self.m_pnlChatRadio:SetPos( ScrW() -self.m_pnlChatRadio:GetWide() -5, (ScrH() /2) -(self.m_pnlChatRadio:GetTall() /2) )
	self.m_pnlChatRadio:SetVisible( false )
end

function GM.Gui:BuildItemLockerMenu()
	if ValidPanel( self.m_pnlItemLocker ) then
		self.m_pnlItemLocker:Remove()
	end

	self.m_pnlItemLocker = vgui.Create( "SRPJobItemLocker" )
	self.m_pnlItemLocker:SetSize( 800, 480 )
	self.m_pnlItemLocker:Center()
	self.m_pnlItemLocker:SetVisible( false )
	self:RegisterNWMenu( "job_item_locker", self.m_pnlItemLocker )
end

function GM.Gui:BuildGovMenus()
	if ValidPanel( self.m_pnlSSCarSpawn ) then
		self.m_pnlSSCarSpawn:Remove()
	end

	self.m_pnlSSCarSpawn = vgui.Create( "SRPSSCarSpawn" )
	self.m_pnlSSCarSpawn:SetSize( 800, 480 )
	self.m_pnlSSCarSpawn:Center()
	self.m_pnlSSCarSpawn:Populate()
	self.m_pnlSSCarSpawn:SetVisible( false )
	self:RegisterNWMenu( "ss_car_spawn", self.m_pnlSSCarSpawn )
end


function GM.Gui:ShowSalesTruckMenu( entCar )
	if ValidPanel( self.m_pnlSalesTruckMenu ) then
		self.m_pnlSalesTruckMenu:Remove()
	end

	self.m_pnlSalesTruckMenu = vgui.Create( "SRPSalesTruck" )
	self.m_pnlSalesTruckMenu:SetSize( 800, 480 )
	self.m_pnlSalesTruckMenu:Center()
	self.m_pnlSalesTruckMenu:SetEntity( entCar )
	self.m_pnlSalesTruckMenu:Open()
end

function GM.Gui:ShowItemBoxMenu( entItemBox, tblItems )
	if not ValidPanel( self.m_pnlItemBox ) then
		self.m_pnlItemBox = vgui.Create( "SRPItemBoxMenu" )
		self.m_pnlItemBox:SetSize( 800, 480 )
		self.m_pnlItemBox:Center()
		self.m_pnlItemBox:SetVisible( false )
	end

	self.m_pnlItemBox:SetEntity( entItemBox )
	self.m_pnlItemBox:Populate( tblItems )

	if not self.m_pnlItemBox:IsVisible() then
		self.m_pnlItemBox:Open()
	end
end

function GM.Gui:ShowStorageChestMenu( entChest, tblItems )
	if not ValidPanel( self.m_pnlStorageChest ) then
		self.m_pnlStorageChest = vgui.Create( "SRPStorageChestMenu" )
		self.m_pnlStorageChest:SetSize( 800, 480 )
		self.m_pnlStorageChest:Center()
		self.m_pnlStorageChest:SetVisible( false )
	end

	self.m_pnlStorageChest:SetEntity( entChest )
	self.m_pnlStorageChest:Populate( tblItems )

	if not self.m_pnlStorageChest:IsVisible() then
		self.m_pnlStorageChest:Open()
	end
end

function GM.Gui:ShowPropRadioMenu()
	if ValidPanel( self.m_pnlItemRadioMenu ) then
		self.m_pnlItemRadioMenu:Remove()
	end

	self.m_pnlItemRadioMenu = vgui.Create( "SRPItemRadio" )
	self.m_pnlItemRadioMenu:SetDeleteOnClose( true )
	self.m_pnlItemRadioMenu:SetSize( 640, 480 )
	self.m_pnlItemRadioMenu:Center()
	self.m_pnlItemRadioMenu:Refresh()
	
	self.m_pnlItemRadioMenu:MakePopup()
	self.m_pnlItemRadioMenu:SetVisible( true )
end

function GM.Gui:ShowCashRegisterMenu( entRegister, intMoney, tblNearby, tblListedItems )
	if ValidPanel( self.m_pnlCashRegister ) then
		self.m_pnlCashRegister:Remove()
	end

	self.m_pnlCashRegister = vgui.Create( "SRPCashRegisterMenu" )
	self.m_pnlCashRegister:SetEntity( entRegister )
	self.m_pnlCashRegister:SetMoney( intMoney )
	self.m_pnlCashRegister:SetSize( 800, 480 )
	self.m_pnlCashRegister:Center()
	self.m_pnlCashRegister:SetVisible( true )
	self.m_pnlCashRegister:MakePopup()
	self.m_pnlCashRegister:Populate( tblNearby, tblListedItems )
end

function GM.Gui:ShowTrunk(intCarIndex)
	local eCar = ents.GetByIndex(intCarIndex)
	if ValidPanel( self.m_pnlTrunkMenu ) then
	self.m_pnlTrunkMenu:Remove()
	end

	self.m_pnlTrunkMenu = vgui.Create( "SRPTrunkStorageMenu" )
	self.m_pnlTrunkMenu:SetSize( 800, 480 )
	self.m_pnlTrunkMenu:Center()
	self.m_pnlTrunkMenu:SetVisible( false )
	self.m_pnlTrunkMenu:Open(eCar)
end

-- Prefeito
function GM.Gui:ShowMayorVoteWheel(participants)
	if ValidPanel( self.m_pnlMayorVoteMenu ) then self.m_pnlMayorVoteMenu:Remove() self.m_pnlMayorVoteMenu = nil end
	self.m_pnlMayorVoteMenu = vgui.Create( "SRPMayorVoteRadialMenu" )
	self.m_pnlMayorVoteMenu:SetSize( 500, 500 )
	self.m_pnlMayorVoteMenu:Center()
	self.m_pnlMayorVoteMenu:InitializeButtons(participants)
	self.m_pnlMayorVoteMenu:MakePopup()
	timer.Simple(GAMEMODE.Config.MVWaitingTime, function() 
		if ValidPanel( self.m_pnlMayorVoteMenu ) then self.m_pnlMayorVoteMenu:Remove() self.m_pnlMayorVoteMenu = nil end
	end)
end

-- Placa neon
function GM.Gui:NeonEditMenu(intEntIndex)
	local eEnt = ents.GetByIndex(intEntIndex)
	if ValidPanel( self.m_pnlNeonEdit ) then
		self.m_pnlNeonEdit:Remove()
	end
	local color = {
		r = math.floor(eEnt:GetColorText().x),
		g = math.floor(eEnt:GetColorText().y),
		b = math.floor(eEnt:GetColorText().z),
		a = 255
	}
	self.m_pnlNeonEdit = vgui.Create( "SRP_Frame" )
	self.m_pnlNeonEdit:SetSize( 480, 335 )
	self.m_pnlNeonEdit:Center()
	self.m_pnlNeonEdit:SetTitle("Neon sign")
	self.m_pnlNeonEdit:MakePopup()

	self.m_pnlMixer = vgui.Create( "DColorMixer", self.m_pnlNeonEdit )
	self.m_pnlMixer:SetPos(5,30)
	self.m_pnlMixer:SetWide(470)
	self.m_pnlMixer:SetPalette( true )
	self.m_pnlMixer:SetAlphaBar( false )
	self.m_pnlMixer:SetWangs( true )
	self.m_pnlMixer:SetColor( color )

	self.m_pnlTextEntry = vgui.Create( "DTextEntry", self.m_pnlNeonEdit )
	self.m_pnlTextEntry:SetPos( 5, 280 )
	self.m_pnlTextEntry:SetSize( 470, 25 )
	self.m_pnlTextEntry:SetText( eEnt:GetText() )


	local Button = vgui.Create( "SRP_Button", self.m_pnlNeonEdit )
	Button:SetText( "Save" )
	Button:SetTall( 20 )
	Button:SetWide( self.m_pnlNeonEdit:GetWide() )
	Button:SetPos( 0, self.m_pnlNeonEdit:GetTall()-20 )
	Button.DoClick = function() 
		if string.len(self.m_pnlTextEntry:GetValue()) < 30 then
			net.Start("UpdateNeonSign")
				net.WriteEntity(eEnt)
				net.WriteString(self.m_pnlTextEntry:GetValue())
				net.WriteTable(self.m_pnlMixer:GetColor())
			net.SendToServer()
		else
			GAMEMODE.HUD:AddNote( "Text need to be less than 30 symbols!", 0, 5 )
		end
	end
end

-- Sistema de correio

function GM.Gui:BuildMailboxMenu()
	if ValidPanel( self.m_pnlMailboxMenu ) then
		self.m_pnlMailboxMenu:Remove()
	end

	self.m_pnlMailboxMenu = vgui.Create( "SRPMailboxMenu" )
	self.m_pnlMailboxMenu:SetSize( 800, 480 )
	self.m_pnlMailboxMenu:Center()
	self.m_pnlMailboxMenu:SetVisible( false )
	self:RegisterNWMenu( "mailbox_menu", self.m_pnlMailboxMenu )
	
	if ValidPanel( self.m_pnlSendMenu ) then
		self.m_pnlSendMenu:Remove()
	end

	self.m_pnlSendMenu = vgui.Create( "SRPSendMailMenu" )
	self.m_pnlSendMenu:SetSize( 800, 480 )
	self.m_pnlSendMenu:Center()
	self.m_pnlSendMenu:SetVisible( false )
	self:RegisterNWMenu( "send_menu", self.m_pnlSendMenu )
end

function GM.Gui:PassCodeMenu(intEntIndex)
	if ValidPanel( self.m_pnlPassCodeMenu ) then
		self.m_pnlPassCodeMenu:Remove()
	end

	self.m_pnlPassCodeMenu = vgui.Create( "SRP_Frame" )
	self.m_pnlPassCodeMenu:SetSize( 200, 100 )
	self.m_pnlPassCodeMenu:Center()
	self.m_pnlPassCodeMenu:SetTitle("Vault")
	self.m_pnlPassCodeMenu:MakePopup()

	self.m_pnlTextEntry = vgui.Create( "DTextEntry", self.m_pnlPassCodeMenu )
	self.m_pnlTextEntry:SetPos( 0, 40 )
	self.m_pnlTextEntry:SetSize( self.m_pnlPassCodeMenu:GetWide(), 25 )
	self.m_pnlTextEntry:SetText("Password")


	local Button = vgui.Create( "SRP_Button", self.m_pnlPassCodeMenu )
	Button:SetText( "Open" )
	Button:SetTall( 20 )
	Button:SetWide( self.m_pnlPassCodeMenu:GetWide() /2 - 2 )
	Button:SetPos( 0, self.m_pnlPassCodeMenu:GetTall()-20 )
	Button.DoClick = function()
		net.Start("CheckPass")
			net.WriteEntity(ents.GetByIndex(intEntIndex))
			net.WriteString(self.m_pnlTextEntry:GetText())
		net.SendToServer()

		self.m_pnlPassCodeMenu:Remove()
	end

	local ButtonOwner = vgui.Create( "SRP_Button", self.m_pnlPassCodeMenu )
	ButtonOwner:SetText( "Change Pass" )
	ButtonOwner:SetTall( 20 )
	ButtonOwner:SetWide( self.m_pnlPassCodeMenu:GetWide() /2 - 2 )
	ButtonOwner:SetPos( self.m_pnlPassCodeMenu:GetWide() /2  +2, self.m_pnlPassCodeMenu:GetTall()-20 )
	ButtonOwner.DoClick = function()
		net.Start("MenuSetPass")
			net.WriteEntity(ents.GetByIndex(intEntIndex))
			net.WriteString(self.m_pnlTextEntry:GetText())
		net.SendToServer()

		self.m_pnlPassCodeMenu:Remove()
	end
end

function GM.Gui:ChangePassCodeMenu(intEntIndex)
	if ValidPanel( self.m_pnlChangePassCodeMenu ) then
		self.m_pnlChangePassCodeMenu:Remove()
	end

	self.m_pnlChangePassCodeMenu = vgui.Create( "SRP_Frame" )
	self.m_pnlChangePassCodeMenu:SetSize( 200, 100 )
	self.m_pnlChangePassCodeMenu:Center()
	self.m_pnlChangePassCodeMenu:SetTitle("Vault")
	self.m_pnlChangePassCodeMenu:MakePopup()

	self.m_pnlTextEntry = vgui.Create( "DTextEntry", self.m_pnlChangePassCodeMenu )
	self.m_pnlTextEntry:SetPos( 0, 40 )
	self.m_pnlTextEntry:SetSize( self.m_pnlChangePassCodeMenu:GetWide(), 25 )
	self.m_pnlTextEntry:SetText("New password")


	local Button = vgui.Create( "SRP_Button", self.m_pnlChangePassCodeMenu )
	Button:SetText( "Save" )
	Button:SetTall( 20 )
	Button:SetWide( self.m_pnlChangePassCodeMenu:GetWide() )
	Button:SetPos( 0, self.m_pnlChangePassCodeMenu:GetTall()-20 )
	Button.DoClick = function()
		net.Start("SetPass")
			net.WriteEntity(ents.GetByIndex(intEntIndex))
			net.WriteString(self.m_pnlTextEntry:GetText())
		net.SendToServer()

		self.m_pnlChangePassCodeMenu:Remove()
	end
end

function GM.Gui:ShowVault(intVaultIndex)
	local eVault = ents.GetByIndex(intVaultIndex)
	if ValidPanel( self.m_pnlVaultStorageMenu ) then
		self.m_pnlVaultStorageMenu:Remove()
	end

	self.m_pnlVaultStorageMenu = vgui.Create( "SRPVaultStorageMenu" )
	self.m_pnlVaultStorageMenu:SetSize( 800, 480 )
	self.m_pnlVaultStorageMenu:Center()
	self.m_pnlVaultStorageMenu:SetVisible( false )
	self.m_pnlVaultStorageMenu:Open(eVault)
end

-- Coplist
function GM.Gui:ShowCopListMenu()
	if ValidPanel( self.m_pnlCopListMenu ) then
		self.m_pnlCopListMenu:Remove()
	end

	self.m_pnlCopListMenu = vgui.Create( "SRPCopListMenu" )
	self.m_pnlCopListMenu:SetSize( 800, 480 )
	self.m_pnlCopListMenu:Center()
	self.m_pnlCopListMenu:Populate()
	self.m_pnlCopListMenu:SetVisible( true )
	self.m_pnlCopListMenu:MakePopup()
end