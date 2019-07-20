--[[
	Name: cl_qmenu_tab_character.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--

surface.CreateFont( "NameLabel", {size = 26, weight = 400, font = "Montserrat Bold"} )
surface.CreateFont( "SubLabel", {size = 20, weight = 400, font = "Montserrat Regular"} )

local Panel = {}
function Panel:Init()
	
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	-- self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "NameLabel" )

	self.m_pnlLevelLabel = vgui.Create( "DLabel", self )
	-- self.m_pnlLevelLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlLevelLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLevelLabel:SetFont( "SubLabel" )

	self.m_pnlXPBar = vgui.Create( "SRP_Progress", self )
	self.m_pnlXPBar:SetBarColor( Color(4,236,86) )
	self.m_pnlXPBar.Think = function()
		if not self.m_strSkillName then return end
		local curXP = GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName )
		local baseXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) -1 )
		local targetXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) )

		curXP = curXP -baseXP
		targetXP = targetXP -baseXP
		self.m_pnlXPBar:SetFraction( curXP /targetXP )
	end

	self.m_pnlXPLabel = vgui.Create( "DLabel", self )
	self.m_pnlXPLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlXPLabel:SetFont( "SubLabel" )
	self.m_pnlXPLabel.Think = function()
		if not self.m_strSkillName then return end
		if GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName ) ~= self.m_intLastXP or -1 then
			self.m_intLastXP = GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName )
			local curXP = GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName )
			local baseXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) -1 )
			local targetXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) )

			curXP = curXP -baseXP
			targetXP = targetXP -baseXP
			self.m_pnlXPLabel:SetText( "Nível " .. GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) .. " ( "..curXP.. "XP / ".. targetXP.. "XP )" )
			self:InvalidateLayout()
		end
	end
end

function Panel:Think()
	if not self.m_strSkillName then return end
	if GAMEMODE.Skills:GetPlayerLevel( self.m_strSkillName ) ~= self.m_intLastLevel or -1 then
		self.m_intLastLevel = GAMEMODE.Skills:GetPlayerLevel( self.m_strSkillName )
		self.m_pnlLevelLabel:SetText( "Level: ".. self.m_intLastLevel )
		self:InvalidateLayout()
	end

end

function Panel:SetSkill( strSkill, tblData )
	if strSkill == "1 Nível do Personagem" then
		local name = string.gsub( strSkill, "1 ", "" )
		self.m_pnlNameLabel:SetText( name )
	else
		self.m_pnlNameLabel:SetText( strSkill )
	end
	self.m_strSkillName = strSkill
	self.m_tblSkill = tblData

	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	draw.RoundedBox(20, 0, 0, intW, intH, Color(45, 45, 45) )
	-- surface.SetDrawColor( 50, 50, 50, 200 )
	-- surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )

	local padding = 5
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( intW/2 - self.m_pnlNameLabel:GetWide()/2, (intH /2) -self.m_pnlNameLabel:GetTall() - 5 )

	local x, y = self.m_pnlNameLabel:GetPos()
	self.m_pnlLevelLabel:SizeToContents()
	self.m_pnlLevelLabel:SetPos( x, y +self.m_pnlNameLabel:GetTall() +padding )

	self.m_pnlXPBar:SetPos( intW/2 - self.m_pnlXPBar:GetWide()/2, y +self.m_pnlNameLabel:GetTall() +padding )
	x, y = self.m_pnlXPBar:GetPos()
	self.m_pnlXPBar:SetSize( intW -x -padding, 25 )

	self.m_pnlXPLabel:SizeToContents()
	self.m_pnlXPLabel:SetPos( x +((intW -x -padding) /2) -(self.m_pnlXPLabel:GetWide() /2), y )


end
vgui.Register( "SRPSkillInfoCard", Panel, "EditablePanel" )

local Panel = {}

function Panel:Init()
	
	self.m_pnlNameLabelZero = vgui.Create( "DLabel", self )
	-- self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabelZero:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabelZero:SetFont( "NameLabel" )

	self.m_pnlLevelLabelZero = vgui.Create( "DLabel", self )
	-- self.m_pnlLevelLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlLevelLabelZero:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLevelLabelZero:SetFont( "SubLabel" )

	self.m_pnlXPBarZero = vgui.Create( "SRP_Progress", self )
	self.m_pnlXPBarZero:SetBarColor( Color(4,236,86) )
	self.m_pnlXPBarZero.Think = function()
		local curXP = zrmdata.xp
		local baseXP = 0
		local targetXP = zrmine.config.Pickaxe_Lvl[zrmdata.lvl].NextXP

		curXP = curXP -baseXP
		targetXP = targetXP -baseXP
		self.m_pnlXPBarZero:SetFraction( curXP /targetXP )
	end

	self.m_pnlXPLabelZero = vgui.Create( "DLabel", self )
	self.m_pnlXPLabelZero:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlXPLabelZero:SetFont( "SubLabel" )
	self.m_pnlXPLabelZero.Think = function()
			self.m_intLastXPZero = zrmdata.xp
			local curXP = zrmdata.xp
			local baseXP = 0
			local targetXP = zrmine.config.Pickaxe_Lvl[zrmdata.lvl].NextXP

			curXP = curXP -baseXP
			targetXP = targetXP -baseXP
			self.m_pnlXPLabelZero:SetText( "Nível " .. zrmdata.lvl .. " ( "..curXP.. "XP / ".. targetXP.. "XP )" )
			self:InvalidateLayout()
	end
	
end

function Panel:Think()




	if self.m_intLastLevelZero ~= zrmdata.lvl then
		self.m_intLastLevelZero = zrmdata.lvl
		self.m_pnlLevelLabelZero:SetText( "Level: ".. self.m_intLastLevelZero )
	end

	self:InvalidateLayout()
end


function Panel:Paint( intW, intH )
	draw.RoundedBox(20, 0, 0, intW, intH, Color(45, 45, 45) )
	-- surface.SetDrawColor( 50, 50, 50, 200 )
	-- surface.DrawRect( 0, 0, intW, intH )
end

function Panel:SetSkill( strSkill, str2)
	
	self.m_pnlNameLabelZero:SetText( strSkill )
	self.m_strSkillNameZero = strSkill
	self.m_tblSkillZero = {}
	self:InvalidateLayout()

end


function Panel:PerformLayout( intW, intH )

	
	local paddingZero = 5
	self.m_pnlNameLabelZero:SizeToContents()
	self.m_pnlNameLabelZero:SetPos( intW/2 - self.m_pnlNameLabelZero:GetWide()/2, (intH /2) -self.m_pnlNameLabelZero:GetTall() - 5 )

	local xZero, yZero = self.m_pnlNameLabelZero:GetPos()
	self.m_pnlLevelLabelZero:SizeToContents()
	self.m_pnlLevelLabelZero:SetPos( xZero, yZero +self.m_pnlNameLabelZero:GetTall() +paddingZero )

	self.m_pnlXPBarZero:SetPos( intW/2 - self.m_pnlXPBarZero:GetWide()/2, yZero +self.m_pnlNameLabelZero:GetTall() +paddingZero )
	xZero, yZero = self.m_pnlXPBarZero:GetPos()
	self.m_pnlXPBarZero:SetSize( intW -xZero -paddingZero, 25 )

	self.m_pnlXPLabelZero:SizeToContents()
	self.m_pnlXPLabelZero:SetPos( xZero +((intW -xZero -paddingZero) /2) -(self.m_pnlXPLabelZero:GetWide() /2), yZero )




end
vgui.Register( "SRPSkillInfoCard2", Panel, "EditablePanel" )
-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlCharModel = vgui.Create( "SRPCharacterPreview", self )
	-- self.m_pnlCharModel.Paint = nil
	self.m_pnlCharModel:SetBackgroundColor( Color(40, 40, 40, 255) )

	
	self.m_pnlSlotContainer = vgui.Create( "EditablePanel", self )
	
	self.m_pnlPrimarySlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlPrimarySlot:SetTitle( "Arma Primária" )
	self.m_pnlPrimarySlot:SetSlotID( "PrimaryWeapon" )
	-- self.m_pnlPrimarySlot.Paint = function()
	-- end

	self.m_pnlSecondarySlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlSecondarySlot:SetTitle( "Arma Secundária" )
	self.m_pnlSecondarySlot:SetSlotID( "SecondaryWeapon" )

	self.m_pnlAltSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlAltSlot:SetTitle( "Arma Extra" )
	self.m_pnlAltSlot:SetSlotID( "AltWeapon" )

	self.m_pnlHeadSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlHeadSlot:SetTitle( "" )
	self.m_pnlHeadSlot:SetSlotID( "Head" )

	self.m_pnlEyesSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlEyesSlot:SetTitle( "" )
	self.m_pnlEyesSlot:SetSlotID( "Eyes" )

	self.m_pnlFaceSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlFaceSlot:SetTitle( "" )
	self.m_pnlFaceSlot:SetSlotID( "Face" )

	self.m_pnlNeckSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlNeckSlot:SetTitle( "" )
	self.m_pnlNeckSlot:SetSlotID( "Neck" )

	self.m_pnlBackSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlBackSlot:SetTitle( "" )
	self.m_pnlBackSlot:SetSlotID( "Back" )

	self.m_pnlSkillList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblSkillCards1 = {}
	self.m_tblSkillCards3 = {}
	self.m_tblSkillCards = {}	
	
end

local MAT_BLEED = Material( "icon16/bullet_red.png" )
local MAT_BROKEN = Material( "icon16/bullet_orange.png" )
local MAT_BANDAGE = Material( "icon16/hourglass_add.png" )

function Panel:Refresh()
	self.m_pnlCharModel:SetModel( LocalPlayer():GetModel() )
	self.m_pnlCharModel:SetSkin( LocalPlayer():GetSkin() )
	self.m_pnlCharModel:SetName(
		GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "name_first" ),
		GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "name_last" )
	)
	for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
		self.m_pnlCharModel.m_entModel:SetBodygroup( v.id, LocalPlayer():GetBodygroup(v.id) )
	end

	for k, v in pairs( self.m_tblSkillCards1 ) do
		if IsValid( v ) then v:Remove() end
	end

	for k, v in pairs( self.m_tblSkillCards ) do
		if IsValid( v ) then v:Remove() end
	end

	self.m_tblSkillCards1 = {}
	self.m_tblSkillCards = {}
	self.m_tblSkillCard3 = {}
	for k, v in SortedPairs( GAMEMODE.Skills:GetSkills() ) do
		self:CreateSkillCard( k, v )
	end
	self:CreateSkillCard("Mineração", "")
	
	-- if IsValid(self.skilpnl3) then self.skilpnl3:Remove() end
		
end

function Panel:CreateSkillCard( strSkill, tblSkillData )
	if strSkill == "1 Nível do Personagem" then
		local pnl2 = vgui.Create( "SRPSkillInfoCard", self.m_pnlSkillList )
		pnl2:SetSkill( strSkill, tblSkillData )
		pnl2.m_pnlParentMenu = self
		self.m_pnlSkillList:AddItem( pnl2 )
		table.insert( self.m_tblSkillCards1, pnl2 )
		return pnl2
	elseif strSkill == "Mineração" then
		if IsValid(pnl3) then pnl3:Remove() end
		pnl3 = vgui.Create("SRPSkillInfoCard2", self.m_pnlSkillList)
		pnl3:SetSkill( strSkill, "..." )
		pnl3.m_pnlParentMenu = self
		self.m_pnlSkillList:AddItem( pnl3 )
		table.insert( self.m_tblSkillCards3, pnl3 )
		return pnl3
	else
		local pnl = vgui.Create( "SRPSkillInfoCard", self.m_pnlSkillList )
		pnl:SetSkill( strSkill, tblSkillData )
		pnl.m_pnlParentMenu = self
		self.m_pnlSkillList:AddItem( pnl )
		table.insert( self.m_tblSkillCards, pnl )
		return pnl
	end

	-- return self.skilpnl3


	
end

function Panel:CreateAddonsCard()

end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCharModel:SetPos( 0, 0 )
	self.m_pnlCharModel:SetSize( intW *0.4, intH )

	self.m_pnlSkillList:SetPos( self.m_pnlCharModel:GetWide() + 10, 0 )
	self.m_pnlSkillList:SetSize( intW - self.m_pnlCharModel:GetWide() - 20, intH-20 )

	for _, pnl2 in pairs( self.m_tblSkillCards1 ) do
		pnl2:DockMargin( 0, 0, 0, 40)
		pnl2:SetTall( 64 )
		pnl2:Dock( TOP )
	end

	for _, pnl in pairs( self.m_tblSkillCards ) do
		pnl:DockMargin( 0, 0, 0, 5)
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end

	
	pnl3:DockMargin( 0, 0, 0, 5)
	pnl3:SetTall( 64 )
	pnl3:Dock( TOP )

	self.m_pnlSlotContainer:SetPos( 0, 0 )
	self.m_pnlSlotContainer:SetSize( self.m_pnlCharModel:GetSize() )

	
	self.m_pnlPrimarySlot:SetSize( self.m_pnlCharModel:GetSize()/2-15, 100 )
	self.m_pnlPrimarySlot:SetPos( 5, self.m_pnlSlotContainer:GetTall() -self.m_pnlPrimarySlot:GetTall() -5 )
	
	self.m_pnlSecondarySlot:SetSize(self.m_pnlCharModel:GetSize()/2-15, 100 )
	self.m_pnlSecondarySlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlSecondarySlot:GetWide() -5,
		self.m_pnlSlotContainer:GetTall() -self.m_pnlPrimarySlot:GetTall() -5
	)
	
	self.m_pnlAltSlot:SetSize( 100, 70 )
	self.m_pnlAltSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlAltSlot:GetWide() -5,
		self.m_pnlSlotContainer:GetTall() -self.m_pnlPrimarySlot:GetTall() -80
	)

	self.m_pnlHeadSlot:SetSize( 70, 70 )
	self.m_pnlHeadSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() /2 - (self.m_pnlHeadSlot:GetWide() /2),
		5
	)

	self.m_pnlEyesSlot:SetSize( 70, 70 )
	self.m_pnlEyesSlot:SetPos( 5, self.m_pnlSlotContainer:GetTall() *0.125 )

	self.m_pnlFaceSlot:SetSize( 70, 70 )
	self.m_pnlFaceSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlFaceSlot:GetWide() - 5,
		self.m_pnlSlotContainer:GetTall() *0.125
	)

	self.m_pnlNeckSlot:SetSize( 70, 70 )
	self.m_pnlNeckSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlNeckSlot:GetWide() - 5,
		self.m_pnlSlotContainer:GetTall() *0.125 +self.m_pnlFaceSlot:GetTall() +5
	)

	self.m_pnlBackSlot:SetSize( 70, 70 )
	self.m_pnlBackSlot:SetPos(
		5,
		self.m_pnlSlotContainer:GetTall() *0.33
	)

	-- self.m_pnlWeightBar:Dock( BOTTOM )
end
vgui.Register( "SRPQMenu_Character", Panel, "EditablePanel" )