	
	function drawtest()



		local frame = vgui.Create( "AWESOME_Frame" )
		frame:SetSize( 932, 600 )
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("VRZN Menu")

		local NavBar = vgui.Create( "AWESOME_Sidebar", frame )
		NavBar:SetBody(frame)
		NavBar:Dock( LEFT ) 
		NavBar:AddMenu("jobs", "Lista de Jobs", "AW_f4_JOBS")
		NavBar:AddMenu( "entities", "Loja de itens","AW_f4_SHOP")
		NavBar:AddMenu( "commands", "Lista de comandos","AW_f4_COMMANDS")
		NavBar:SetActive( 1 )

		

		-- local CategoryContentOne = vgui.Create( "DCheckBoxLabel" )	// This section creates a checkbox and
		-- CategoryContentOne:SetText( "God mode" )					 // sets up its settings
		-- CategoryContentOne:SetConVar( "sbox_godmode" )
		-- CategoryContentOne:SetValue( 0 )
		-- CategoryContentOne:SizeToContents()
		-- DermaList:AddItem( CategoryContentOne )						// Add the checkbox to the category

		-- local CategoryContentTwo = vgui.Create( "DLabel" )			// Make some more content
		-- CategoryContentTwo:SetText( "Hello" )
		-- DermaList:AddItem( CategoryContentTwo )						// Add it to the categoryDCollapsible:SetContents( DermaList )	// Set the contents of the category to the list
		
	end


concommand.Add("testar", drawtest)