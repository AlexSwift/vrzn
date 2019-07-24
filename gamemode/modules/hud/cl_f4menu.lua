
local status = net.ReadBit()
local F4Menu
local F4NavBar

function OpenF4Menu()
	if (F4Menu == nil) then
		F4Menu = vgui.Create( "AWESOME_Frame" )
		F4Menu:SetSize( 932, 600 )
		F4Menu:Center()
		F4Menu:SetTitle("VRZN Menu")
		-- F4Menu:MakePopup()
		-- F4Menu:SetDeleteOnClose(false)

		F4NavBar = vgui.Create( "AWESOME_Sidebar", F4Menu )
		F4NavBar:SetBody(F4Menu)
		F4NavBar:Dock( LEFT ) 
		F4NavBar:AddMenu("jobs", "Lista de Jobs", "AW_f4_JOBS")
		F4NavBar:AddMenu( "entities", "Loja de itens","AW_f4_SHOP")
		F4NavBar:AddMenu( "commands", "Lista de comandos","AW_f4_COMMANDS")
		F4NavBar:SetActive( 1 )
		gui.EnableScreenClicker(true)
	else
		if F4Menu:IsVisible() then
			F4Menu:SetVisible(false)
			gui.EnableScreenClicker(false)
		else
			F4Menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
	end
end

concommand.Add("open_f4_menu", OpenF4Menu)

function OpenF2Menu()
	local eTraceHit = LocalPlayer():GetEyeTrace()
	if (eTraceHit.Entity:GetClass() == "prop_door_rotating") and ((eTraceHit.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 100))  then
		PopupProprietiesDerma()
	end

	if (eTraceHit.Entity:GetClass() == "player") and ((eTraceHit.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 80))  then
		PopupPlayerDerma()
	end

end
		
concommand.Add("open_f2_menu", OpenF2Menu)


function PopupProprietiesDerma()
	local eTraceHit = LocalPlayer():GetEyeTrace()
	local Door = LocalPlayer():GetEyeTrace().Entity
	local DoorData = GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()]
	if !DoorData then return end
	local PropertyData =  GAMEMODE.Property.m_tblProperties[DoorData.Name]
	if  PropertyData.Government then return end
	if !eTraceHit.Entity:IsValid() then return end
	if (eTraceHit.Entity:GetClass() == "prop_door_rotating") and ((eTraceHit.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 100))  then

	if DoorData.Owner:IsWorld() then
		DoorWheel = 2

		DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
		
		DoorWheel:SetSize(ScrW(),ScrH())
		DoorWheel:SetDoorTitle(DoorData.Name)
		DoorWheel:SetKeyboardInputEnabled(false)
		DoorWheel:Center()
		DoorWheel:MakePopup()

		local tbl = {}
		local options = {
			[1] = {
				mat = Material("materials/vgui/elements/house.png"),
				name = DoorData.Name,
				price = PropertyData.Price,
				action = "Alugar"
			},
			[2] = {
				mat = Material("materials/vgui/icons/error.png"),
				name = "Cancelar",
				price = DoorData.Name,
				action = "Cancelar"
			}
		} 
		DoorWheel:SetContents(options)
	end

	if DoorData.Owner == LocalPlayer() then
		DoorWheel = 3
		DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
		DoorWheel:SetSize(ScrW(),ScrH())
		DoorWheel:SetDoorTitle(DoorData.Name)
		DoorWheel:SetKeyboardInputEnabled(false)
		DoorWheel:Center()
		DoorWheel:MakePopup()

		local tbl = {}
		local options = {
			[1] = {
				mat = Material("materials/vgui/icons/house.png"),
				name = "Minha propriedade",
				action = "Vender"
			},
			[2] = {
				mat = Material("materials/vgui/icons/error.png"),
				name = "Cancelar",
				price = DoorData.Name,
				action = "Cancelar"
			},
			[3] = {
				mat = Material("materials/vgui/icons/doors-open.png"),
				name = "Trancar portas",
				price = DoorData.Name,
				action = "Trancar"
			}
		} 
		DoorWheel:SetContents(options)
	end

	if  !(DoorData.Owner:IsWorld()) and !(DoorData.Owner == LocalPlayer())  then
		local Buddy =  GAMEMODE.Buddy:GetBuddyData( DoorData.Owner:GetCharacterID() )
		if Buddy then
			if Buddy.Settings.ShareDoors == true then
				DoorWheel = 3
				DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
				DoorWheel:SetSize(ScrW(),ScrH())
				DoorWheel:SetDoorTitle(DoorData.Name)
				DoorWheel:SetKeyboardInputEnabled(false)
				DoorWheel:Center()
				DoorWheel:MakePopup()

				local tbl = {}
				local options = {
					[1] = {
						mat = Material("materials/vgui/icons/error.png"),
						name = "Cancelar",
						price = DoorData.Name,
						action = "Cancelar"
					},
					[2] = {
						mat = Material("materials/vgui/icons/doors-open.png"),
						name = "Trancar portas",
						price = DoorData.Name,
						action = "Trancar"
					},
					[3] = {
						mat = Material("materials/vgui/icons/house.png"),
						name = "Deixar Mensagem",
						action = "Mensagem"
					},
				} 
				DoorWheel:SetContents(options)
			else
				DoorWheel = 2
				DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
				DoorWheel:SetSize(ScrW(),ScrH())
				DoorWheel:SetDoorTitle(DoorData.Name)
				DoorWheel:SetKeyboardInputEnabled(false)
				DoorWheel:Center()
				DoorWheel:MakePopup()

				local tbl = {}
				local options = {
					[1] = {
						mat = Material("materials/vgui/icons/house.png"),
						name = "Deixar Mensagem",
						action = "Mensagem"
					},
					[2] = {
						mat = Material("materials/vgui/icons/error.png"),
						name = "Cancelar",
						price = DoorData.Name,
						action = "Cancelar"
					}
				} 
				DoorWheel:SetContents(options)
			end
		else
			
			DoorWheel = 2
				DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
				DoorWheel:SetSize(ScrW(),ScrH())
				DoorWheel:SetDoorTitle(DoorData.Name)
				DoorWheel:SetKeyboardInputEnabled(false)
				DoorWheel:Center()
				DoorWheel:MakePopup()

				local tbl = {}
				local options = {
					[1] = {
						mat = Material("materials/vgui/icons/house.png"),
						name = "Deixar Mensagem",
						action = "Mensagem"
					},
					[2] = {
						mat = Material("materials/vgui/icons/error.png"),
						name = "Cancelar",
						price = DoorData.Name,
						action = "Cancelar"
					}
				} 
				DoorWheel:SetContents(options)
		end


	-- 	 if GAMEMODE.Buddy.m_tblCurBuddies[DoorData.Owner:GetCharacterID()] then
	-- 		if GAMEMODE.Buddy.m_tblCurBuddies[DoorData.Owner:GetCharacterID()].ShareDoors then
	-- 			print("é amigo e dá a porta")
	-- 			DoorWheel = 3
	-- 			DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
	-- 			DoorWheel:SetSize(ScrW(),ScrH())
	-- 			DoorWheel:SetDoorTitle(DoorData.Name)
	-- 			DoorWheel:SetKeyboardInputEnabled(false)
	-- 			DoorWheel:Center()
	-- 			DoorWheel:MakePopup()

	-- 			local tbl = {}
	-- 			local options = {
	-- 				[1] = {
	-- 					mat = Material("materials/vgui/icons/error.png"),
	-- 					name = "Cancelar",
	-- 					price = DoorData.Name,
	-- 					action = "Cancelar"
	-- 				},
	-- 				[2] = {
	-- 					mat = Material("materials/vgui/icons/doors-open.png"),
	-- 					name = "Trancar portas",
	-- 					price = DoorData.Name,
	-- 					action = "Trancar"
	-- 				}
	-- 			} 
	-- 			DoorWheel:SetContents(options)
	-- 		end
	-- 	else
	-- 		DoorWheel = 2
	-- 		DoorWheel = vgui.Create("Proprieties.Menu.Wheel2")
	-- 		DoorWheel:SetSize(ScrW(),ScrH())
	-- 		DoorWheel:SetDoorTitle(DoorData.Name)
	-- 		DoorWheel:SetKeyboardInputEnabled(false)
	-- 		DoorWheel:Center()
	-- 		DoorWheel:MakePopup()

	-- 		local tbl = {}
	-- 		local options = {
	-- 			[1] = {
	-- 				mat = Material("materials/vgui/icons/house.png"),
	-- 				name = "Deixar Mensagem",
	-- 				action = "Mensagem"
	-- 			},
	-- 			[2] = {
	-- 				mat = Material("materials/vgui/icons/error.png"),
	-- 				name = "Cancelar",
	-- 				price = DoorData.Name,
	-- 				action = "Cancelar"
	-- 			}
	-- 		} 
	-- 		DoorWheel:SetContents(options)
	-- 	 end
		
	end


	end
end

function PopupPlayerDerma()
	local eTraceHit = LocalPlayer():GetEyeTrace()
	local player = eTraceHit.Entity
	if (eTraceHit.Entity:GetClass() == "player") and ((eTraceHit.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 80)) then
		PlayerWheel = 3
		PlayerWheel = vgui.Create("PlayerRadial")
		PlayerWheel:SetSize(ScrW(),ScrH())
		PlayerWheel:SetKeyboardInputEnabled(false)
		PlayerWheel:Center()
		PlayerWheel:MakePopup()
		PlayerWheel:SetPlayerName( player )
		local tbl = {}
		local options = {
			[1] = {
				mat = Material("materials/vgui/icons/add-friend.png"),
				name = "Adicionar",
				action = "Adicionar Amigo"
			},
			[2] = {
				mat = Material("materials/vgui/icons/error.png"),
				name = "Cancelar",
				nick = player:Nick(),
				action = "Cancelar"
			},
			[3] = {
				mat = Material("materials/vgui/icons/incomes.png"),
				name = "Dinheiro",
				nick = player:Nick(),
				action = "Dar Dinheiro"
			}
		} 
		PlayerWheel:SetContents(options)
	end

end