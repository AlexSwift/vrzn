--[[
	Name: cl_menu_qmenu.lua
-----------------------------------------------------------------
-- @package     VrZn - Custom Gamemode (SRP BASE)
-- @author     Nodge
-- @build       Beta 1
-----------------------------------------------------------------
]]--


local Panel = {}
function Panel:Init()
	self.m_pnlTabs = vgui.Create( "SRP_PropertySheet", self )
	self.m_pnlTabs:SetPadding( 0 )
	self.m_pnlTabInventory = self.m_pnlTabs:AddSheet( "", vgui.Create("SRPQMenu_Inventory",  self), "materials/vgui/elements/backpack.png" ).Panel
	self.m_pnlTabCharacter = self.m_pnlTabs:AddSheet( "", vgui.Create("SRPQMenu_Character", self), "materials/vgui/elements/character.png" ).Panel
	self.m_pnlTabBuddies = self.m_pnlTabs:AddSheet( "", vgui.Create("SRPQMenu_Buddies", self), "materials/vgui/elements/friends.png"  ).Panel
	self.m_pnlTabSettings = self.m_pnlTabs:AddSheet( "", vgui.Create("SRPQMenu_Settings", self), "materials/vgui/elements/settings.png"  ).Panel
end

function Panel:Refresh()
	self.m_pnlTabInventory:Refresh()
	self.m_pnlTabCharacter:Refresh()
	self.m_pnlTabBuddies:Rebuild()
	self.m_pnlTabSettings:Refresh()
end
function Panel:Paint( w, h)
	draw.RoundedBox(8, 0, 72, w, h - 72, Color(26, 26, 26, 255) )
end
function Panel:PerformLayout( intW, intH )
	self.m_pnlTabs:SetPos( 0, 0 )
	self.m_pnlTabs:SetSize( intW, intH )
end
vgui.Register( "SRPQMenu", Panel, "SRP_FramePanel" )