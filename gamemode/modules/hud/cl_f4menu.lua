
-- local status = net.ReadBit()
-- local F4Menu
-- local F4NavBar

-- function OpenF4Menu()
-- 	if (F4Menu == nil) then
-- 		F4Menu = vgui.Create( "AWESOME_Frame" )
-- 		F4Menu:SetSize( 932, 600 )
-- 		F4Menu:Center()
-- 		F4Menu:SetTitle("VRZN Menu")
-- 		-- F4Menu:MakePopup()
-- 		-- F4Menu:SetDeleteOnClose(false)

-- 		F4NavBar = vgui.Create( "AWESOME_Sidebar", F4Menu )
-- 		F4NavBar:SetBody(F4Menu)
-- 		F4NavBar:Dock( LEFT ) 
-- 		F4NavBar:AddMenu("jobs", "Lista de Jobs", "AW_f4_JOBS")
-- 		F4NavBar:AddMenu( "entities", "Loja de itens","AW_f4_SHOP")
-- 		F4NavBar:AddMenu( "commands", "Lista de comandos","AW_f4_COMMANDS")
-- 		F4NavBar:SetActive( 1 )
-- 		gui.EnableScreenClicker(true)
-- 	else
-- 		if F4Menu:IsVisible() then
-- 			F4Menu:SetVisible(false)
-- 			gui.EnableScreenClicker(false)
-- 		else
-- 			F4Menu:SetVisible(true)
-- 			gui.EnableScreenClicker(true)
-- 		end
-- 	end
-- end

-- concommand.Add("open_f4_menu", OpenF4Menu)



		