-- =================================
-- NADMOD PP - Prop Protection
-- By Nebual@nebtown.info 2012
-- Menus designed after SpaceTech's Simple Prop Protection
-- =================================
if !NADMOD then 
	NADMOD = {}
	NADMOD.PropOwners = {}
	NADMOD.PPConfig = {}
	NADMOD.Friends = {}
end

local Props = NADMOD.PropOwners
net.Receive("nadmod_propowners",function(len) 
	local num = net.ReadUInt(16)
	for k=1,num do
		local id,str = net.ReadUInt(16), net.ReadString()
		if str == "-" then Props[id] = nil 
		elseif str == "W" then Props[id] = "World"
		elseif str == "O" then Props[id] = "Ownerless"
		else Props[id] = str
		end
	end
end)

local nadmod_overlay_convar = CreateConVar("nadmod_overlay", 2, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "0 - Disables NPP Overlay. 1 - Minimal overlay of just owner info. 2 - Includes model, entityID, class")
surface.CreateFont( "PropProtectFont", {size = 16, weight = 550, font = "Montserrat Bold"} )
surface.CreateFont( "DoorHudFont", {size = 16, weight = 550, font = "Montserrat Bold"} )
hook.Add("HUDPaint", "NADMOD.HUDPaint", function()
	local nadmod_overlay_setting = nadmod_overlay_convar:GetInt()
	if nadmod_overlay_setting == 0 then return end
	local tr = LocalPlayer():GetEyeTrace()
	if !tr.HitNonWorld then return end
	local ent = tr.Entity
	local dist = ent:GetPos():Distance( LocalPlayer():GetPos() )
	if dist <= 130 then
		if ent:IsValid() && !ent:IsPlayer() then
			local text = "Objeto"
			if LocalPlayer():IsSuperAdmin() then
				text = "Dropado por: " .. (Props[ent:EntIndex()] or "N/A")
			else
				text = "Prop de jogador"
			end
			if Props[ent:EntIndex()] == "World" and tostring(ent:GetClass() ) != "prop_door_rotating" then text = "Objeto do mapa" end
				local PropertyData
				local PropertyName
				local Door = ent
				local DoorData = GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()]
				if not DoorData then DoorData = {} end
				if DoorData then 
					PropertyData =  GAMEMODE.Property.m_tblProperties[DoorData.Name]
					PropertyName = DoorData.Name
					-- OwnerName = GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()].Owner
				end
			if tostring(ent:GetClass() ) == "prop_door_rotating" then
				if !PropertyData then return end
				if PropertyData.Government then return end
				if !GAMEMODE.Property.m_tblDoorCache[Door:EntIndex()].Owner:IsWorld() then return end
				Notify = "APERTE"
				Notify2  = "PARA ABRIR O MENU DE CASA"

				surface.SetFont("DoorHudFont")
				n1w, n1h = surface.GetTextSize(Notify)
				n2w, n2h = surface.GetTextSize(Notify2)

				bw = n1w + n2w + 20  
				bh = n1h + 10
				BSHADOWS.BeginShadow()
				draw.RoundedBox(8, ScrW()/2 - bw/2, ScrH()/2 + (ScrH()*30/100), bw + 52, bh, Color(26,26,26))
				BSHADOWS.EndShadow(1, 1, 2, 200)
				draw.SimpleText("APERTE", "DoorHudFont", ScrW()/2 - bw/2 + 10, ScrH()/2 + (ScrH()*30/100) + 5, Color(255,255,255,255))
				draw.SimpleText("PARA ABRIR O MENU DE CASA", "DoorHudFont", ScrW()/2 - bw/2 + n1w + 10 + 42 + 10, ScrH()/2 + (ScrH()*30/100) + 5, Color(255,255,255,255))

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(Material("materials/vgui/keys/f2.png"))
				surface.DrawTexturedRect(ScrW()/2 - bw/2 + n1w + 10 + 10, ScrH()/2 + (ScrH()*30/100) -8, 32, 32)

			end
			if tostring(ent:GetClass() ) == "prop_door_rotating" then return end
			surface.SetFont("PropProtectFont")
			local Width, Height = surface.GetTextSize(text)
			local boxWidth = Width + 25
			local boxHeight = Height + 16
			if nadmod_overlay_setting > 1 then
				local text2 = "'"..string.sub(table.remove(string.Explode("/", ent:GetModel() or "?")), 1,-5).."' ["..ent:EntIndex().."]"
				local text3 = ent:GetClass()
				local w2,h2 = surface.GetTextSize(text2)
				local w3,h3 = surface.GetTextSize(text3)
				boxWidth = math.Max(Width) + 25
				boxHeight = boxHeight
				BSHADOWS.BeginShadow()
				draw.RoundedBox(8, ScrW()/2 - (boxWidth/2), (ScrH()) - boxHeight-15, boxWidth, boxHeight, Color(26, 26, 26))
				BSHADOWS.EndShadow(2, 2, 4, 255)
				draw.SimpleText(text, "PropProtectFont", (ScrW()/2) - (Width / 2), (ScrH()) - boxHeight/2 - Height - 8, Color(255, 255, 255, 255))
				-- draw.SimpleText(text2, font, ScrW() - (w2 / 2) - 20, ScrH()/2 - 200 + Height, Color(255, 255, 255, 255), 1, 1)
				draw.SimpleText(text3, font, ScrW() - (w3 / 2) - 20, ScrH()/2 - 200 + Height + h2, Color(255, 255, 255, 255), 1, 1)
			else
				BSHADOWS.BeginShadow()
				draw.RoundedBox(8, ScrW()/2 - (boxWidth/2), (ScrH()) - boxHeight-15, boxWidth, boxHeight, Color(26, 26, 26))
				BSHADOWS.EndShadow(1, 1, 4, 100)
				draw.SimpleText(text, "PropProtectFont", (ScrW()/2) - (Width / 2), (ScrH()) - boxHeight/2 - Height - 8, Color(255, 255, 255, 255))
			end
		end
	end
end)

function NADMOD.CleanCLRagdolls()
	for k,v in pairs(ents.FindByClass("class C_ClientRagdoll")) do v:SetNoDraw(true) end
	for k,v in pairs(ents.FindByClass("class C_BaseAnimating")) do v:SetNoDraw(true) end
end
net.Receive("nadmod_cleanclragdolls", NADMOD.CleanCLRagdolls)

-- =============================
-- NADMOD PP CPanels
-- =============================
net.Receive("nadmod_ppconfig",function(len)
	NADMOD.PPConfig = net.ReadTable()
	for k,v in pairs(NADMOD.PPConfig) do
		local val = v
		if isbool(v) then val = v and "1" or "0" end
		
		CreateClientConVar("npp_"..k,val, false, false)
		RunConsoleCommand("npp_"..k,val)
	end
	NADMOD.AdminPanel(NADMOD.AdminCPanel, true)
end)

concommand.Add("npp_apply",function(ply,cmd,args)
	for k,v in pairs(NADMOD.PPConfig) do
		if isbool(v) then NADMOD.PPConfig[k] = GetConVar("npp_"..k):GetBool()
		elseif isnumber(v) then NADMOD.PPConfig[k] = GetConVarNumber("npp_"..k)
		else NADMOD.PPConfig[k] = GetConVarString("npp_"..k)
		end
	end
	net.Start("nadmod_ppconfig")
		net.WriteTable(NADMOD.PPConfig)
	net.SendToServer()
end)

function NADMOD.AdminPanel(Panel, runByNetReceive)
	if Panel then
		if !NADMOD.AdminCPanel then NADMOD.AdminCPanel = Panel end
	end
	Panel:ClearControls()

	local nonadmin_help = Panel:Help("")
	nonadmin_help:SetAutoStretchVertical(false)
	if not runByNetReceive then 
		RunConsoleCommand("npp_refreshconfig")
		timer.Create("NADMOD.AdminPanelCheckFail",0.75,1,function()
			nonadmin_help:SetText("Waiting for the server to say you're an admin...")
		end)
		if not NADMOD.PPConfig then
			return
		end
	else
		timer.Remove("NADMOD.AdminPanelCheckFail")
	end
	Panel:SetName("NADMOD PP Admin Panel")
	
	Panel:CheckBox(	"Switcher do SPP", "npp_toggle")
	Panel:CheckBox(	"Staffs podem mover tudo", "npp_adminall")
	local use_protection = Panel:CheckBox(	"Proteger props do [E]", "npp_use")
	use_protection:SetToolTip("Impede outros jogadores de apertarem objetos.")
	
	local txt = Panel:Help("Timer da varredura")
	txt:SetAutoStretchVertical(false)
	txt:SetContentAlignment( TEXT_ALIGN_CENTER )
	local autoclean_admins = Panel:CheckBox(	"Varrer admins", "npp_autocdpadmins")
	autoclean_admins:SetToolTip("1 O NODGE É PICA")
	local autoclean_timer = Panel:NumSlider("Autoclean Timer", "npp_autocdp", 0, 1200, 0 )
	autoclean_timer:SetToolTip("0 Desabilita")
	Panel:Button(	"Apply Settings", "npp_apply") 
	
	local txt = Panel:Help("                     Cleanup Panel")
	txt:SetContentAlignment( TEXT_ALIGN_CENTER )
	txt:SetFont("DermaDefaultBold")
	txt:SetAutoStretchVertical(false)
	
	local counts = {}
	for k,v in pairs(NADMOD.PropOwners) do 
		counts[v] = (counts[v] or 0) + 1 
	end
	local dccount = 0
	for k,v in pairs(counts) do
		if k != "World" and k != "Ownerless" then dccount = dccount + v end
	end
	for k, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			Panel:Button( ply:Nick().." ("..(counts[ply:Nick()] or 0)..")", "nadmod_cleanupprops", ply:EntIndex() ) 
			dccount = dccount - (counts[ply:Nick()] or 0)
		end
	end
	
	Panel:Help(""):SetAutoStretchVertical(false) -- Spacer
	Panel:Button("Cleanup Disconnected Players Props ("..dccount..")", "nadmod_cdp")
	Panel:Button("Varrer NPCS", 			"nadmod_cleanclass", "npc_*")
	Panel:Button("Varrer Ragdolls", 		"nadmod_cleanclass", "prop_ragdol*")
	Panel:Button("Varrer Ragdolls 2 (NÃO USE)", "nadmod_cleanclragdolls")
	Panel:Button("Limpar as cordas", "nadmod_cleanworldropes")
end

-- net.Receive("nadmod_ppfriends",function(len)
-- 	NADMOD.Friends = net.ReadTable()
-- 	for _,tar in pairs(player.GetAll()) do
-- 		CreateClientConVar("npp_friend_"..tar:SteamID64(),NADMOD.Friends[tar:SteamID()] and "1" or "0", false, false)
-- 		RunConsoleCommand("npp_friend_"..tar:SteamID64(),NADMOD.Friends[tar:SteamID()] and "1" or "0")
-- 	end
-- end)

-- concommand.Add("npp_applyfriends",function(ply,cmd,args)
-- 	for _,tar in pairs(player.GetAll()) do
-- 		NADMOD.Friends[tar:SteamID()] = GetConVar("npp_friend_"..tar:SteamID64()):GetBool()
-- 	end
-- 	net.Start("nadmod_ppfriends")
-- 		net.WriteTable(NADMOD.Friends)
-- 	net.SendToServer()
-- end)

-- function NADMOD.ClientPanel(Panel)
-- 	RunConsoleCommand("npp_refreshfriends")
-- 	Panel:ClearControls()
-- 	if !NADMOD.ClientCPanel then NADMOD.ClientCPanel = Panel end
-- 	Panel:SetName("NADMOD - Client Panel")
	
-- 	Panel:Button("Cleanup Props", "nadmod_cleanupprops")
-- 	Panel:Button("Clear Clientside Ragdolls", "nadmod_cleanclragdolls")
	
-- 	local txt = Panel:Help("                     Friends Panel")
-- 	txt:SetContentAlignment( TEXT_ALIGN_CENTER )
-- 	txt:SetFont("DermaDefaultBold")
-- 	txt:SetAutoStretchVertical(false)
	
-- 	local Players = player.GetAll()
-- 	if(table.Count(Players) == 1) then
-- 		Panel:Help("No Other Players Are Online")
-- 	else
-- 		for _, tar in pairs(Players) do
-- 			if(IsValid(tar) and tar != LocalPlayer()) then
-- 				Panel:CheckBox(tar:Nick(), "npp_friend_"..tar:SteamID64())
-- 			end
-- 		end
-- 		Panel:Button("Apply Friends", "npp_applyfriends")
-- 	end
-- end

function NADMOD.SpawnMenuOpen()
	if NADMOD.AdminCPanel then
		NADMOD.AdminPanel(NADMOD.AdminCPanel)
	end
	if NADMOD.ClientCPanel then
		NADMOD.ClientPanel(NADMOD.ClientCPanel)
	end
end
hook.Add("SpawnMenuOpen", "NADMOD.SpawnMenuOpen", NADMOD.SpawnMenuOpen)

function NADMOD.PopulateToolMenu()
	spawnmenu.AddToolMenuOption("Utilities", "VRZN - Prop protect", "Admin", "Admin", "", "", NADMOD.AdminPanel)
	-- spawnmenu.AddToolMenuOption("Utilities", "VRZN - Prop protect", "Client", "Client", "", "", NADMOD.ClientPanel)
end
hook.Add("PopulateToolMenu", "NADMOD.PopulateToolMenu", NADMOD.PopulateToolMenu)

net.Receive("nadmod_notify", function(len)
	local text = net.ReadString()
	notification.AddLegacy(text, NOTIFY_GENERIC, 5)
	surface.PlaySound("ambient/water/drip"..math.random(1, 4)..".wav")
	print(text)
end)
