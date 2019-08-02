HitmanPlus={}

-----MAIN FUNCS

function popupMainDerma( hitman )
	local Person = hitman
	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( ScrW()*0.4, ScrH()*0.6 )
	Frame:SetTitle( "" )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( true )
	Frame:DockMargin(0, 0, 0, 0)
	Frame:DockPadding(0, 0, 0, 0)
	Frame.Paint = function(s,w,h)
		draw.RoundedBox(4, 0, 0, w, h, Color(26,26,26))
	end
	Frame:Center()
	Frame:MakePopup()
	

	local Header = Frame:Add("DPanel")
	Header:Dock( TOP )
	Header:SetTall( Frame:GetTall()*0.15 )
	Header.Paint = function(s,w,h)
		surface.SetFont("F4::Title")
        local tw, th = surface.GetTextSize("HITMAN")

        surface.SetFont("F4::SubTitle")
		local tw2, th2 = surface.GetTextSize("Majestic.BRASILRP")
		
		local aw, ah = s:LocalToScreen()
		BSHADOWS.BeginShadow()
			surface.SetDrawColor(26, 26, 26, 255)
			surface.DrawRect(aw, ah, w, h)
		BSHADOWS.EndShadow(1, 1, 3, 200)

		draw.SimpleText("HITMAN", "F4::Title", 22, (s:GetTall()/2) - (th/2), Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Majestic.BRASILRP", "F4::SubTitle", 22, (s:GetTall()/2) + (th2/2), Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


	end

	local Close = Header:Add(DButton)
	Close:Dock(RIGHT)
	Close.Paint = nil
	Close:DockMargin(0,0,16,0)
	Close.DoClick = function(s)
		
		Frame:Close()
	end
	Close:SetText("FECHAR")
	Close:SetFont("F4::Nav")
	Close:SetTextColor(Color(200, 60, 60, 255))


	local LeftContainer = Frame:Add("DScrollPanel")
	LeftContainer:Dock(LEFT)
	-- LeftContainer:
	LeftContainer:SetWide( Frame:GetWide()/2 )
	LeftContainer.Paint = function(s,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(36,36,36) )
	end

	for k, v in pairs(player.GetAll()) do
		local PlayerWrapper = LeftContainer:Add("DButton")
		PlayerWrapper:Dock( TOP )
		PlayerWrapper:SetText("")
		PlayerWrapper:SetTall(30)
		PlayerWrapper:DockMargin(8, 8, 8, 0)
		PlayerWrapper.Paint = function(s,w,h)
			draw.RoundedBox(2, 0, 0, w, h, Color(19,19,19) )
		end
		PlayerWrapper.DoClick = function()
			Frame:SetTarget( v )
		end

		local PlayerAvatar = PlayerWrapper:Add("AvatarImage")
		PlayerAvatar:SetWide(30)
		PlayerAvatar:Dock(LEFT)
		PlayerAvatar:SetPlayer(v, 30)

		local PlayerName = PlayerWrapper:Add("DLabel")
		PlayerName:Dock(TOP)
		PlayerName:SetText(v:Nick())
		PlayerName:SetFont("F4::Nav")
		PlayerName:SetContentAlignment( 4 )
		PlayerName:SetTextInset(16, 0)
		PlayerName:SetTextColor( Color(255,255,255) )

	end

	local RightContainer = Frame:Add("DPanel")
	RightContainer:Dock( RIGHT )
	RightContainer:SetWide( Frame:GetWide()/2 )
	RightContainer.Paint = function()
	end

	local ModelPanel = RightContainer:Add("DModelPanel")
	ModelPanel:Dock(TOP)
	ModelPanel:SetTall( Frame:GetTall()*0.8 - Header:GetTall())

	local HitContainer = RightContainer:Add("DPanel")
	HitContainer:Dock(TOP)
	HitContainer:SetTall( Frame:GetTall()*0.2 - 40)
	HitContainer.Paint = function(s,w,h)
		draw.RoundedBox(8, 0, 0, w, h, Color(60,60,60) )
	end


	
	local Price = vgui.Create( "DNumSlider", HitContainer )
	Price:Dock(FILL)
	Price:SetText( "Preço do HIT" )
	Price:SetMin( 0 )
	Price:SetMax( 50000 )
	Price:SetDecimals( 0 )

	local HitButton = RightContainer:Add("DButton")
	HitButton:Dock(BOTTOM)
	HitButton:DockMargin(5,5,5,5)
	HitButton:SetTall(30)
	HitButton.Paint = function(s,w,h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0,255,78) )
	end
	HitButton:SetText("PROPOR CONTRATO")
	HitButton:SetTextColor( Color(255,255,255) )
	HitButton:SetFont("F4::Nav")
	HitButton.DoClick = function()
		if Price:GetValue() == 0 then GAMEMODE.HUD:AddNote( "Você precisa por um valor", 3, 4 ) return end
		-- if not HitTarget then GAMEMODE.HUD:AddNote( "Selecione um jogador", 3, 4 ) return end
		net.Start("Hit+::RequestHit")
			net.WriteInt( Price:GetValue() ,32)
			net.WriteString( HitTarget:SteamID() )
			net.WriteString( Person:SteamID() )
		net.SendToServer()
		Frame:Remove()
	end

	Frame.SetTarget = function(s, player)
		ModelPanel:SetModel( player:GetModel(), player:GetSkin() )
		HitTarget = player
	end

end

-----HOOK SHIT

-- hook.Add("HUDPaint","Hit.FancyHint",function()
-- 	local OtherPly = LocalPlayer():GetEyeTrace().Entity
-- 	if not IsValid(OtherPly) then return end
-- 	-- print(GAMEMODE.Jobs:GetPlayerJob( OtherPly ).Name)
-- 	-- if GAMEMODE.Jobs:GetPlayerJob( OtherPly ).Name == "Hitman" then 
-- 	if LocalPlayer():GetPos():Distance(OtherPly:GetPos()) < 100 then
-- 		if OtherPly:IsPlayer() then
-- 			if OtherPly:isHitman() then
-- 				draw.DrawText("HITMAN [F2] PARA CONTRATAR","PropProtectFont",ScrW()*0.5,ScrH()*0.85,Color(255,255,255,255),TEXT_ALIGN_CENTER)
-- 			end
-- 		end
-- 	-- end
-- 	end
-- end)
hook.Remove("HUDPaint","Hit.FancyHint")

hook.Remove( "KeyPress", "Hit+::PressDerma")


-----NET SHIT

net.Receive("Hit+::DeleteTimeHud",function(len)
	hook.Remove("HUDPaint", "AWESOME::TimeCountdown::Hit.DrawTimeLeft")
end)
net.Receive("Hit+::PopupYoNDermaa",function(len, ply)
	
	local Price = net.ReadInt(32)
	local TargetSteamId = net.ReadString()
	local Cookie = net.ReadInt(32)
	local Contractor = net.ReadEntity()

	--
	local Target = player.GetBySteamID( TargetSteamId )
	--
	-- Target:AddNote("Chegou sim")

	GAMEMODE.Gui:Derma_Query("Você deseja matar "..Target:Nick().." por "..string.VrznMoney( Price ).."?","Majestic.HITMAN", "Sim",
	function()
		net.Start( "Hit+::AcceptHit" )
		net.WriteInt(Cookie,32)
		net.WriteEntity(Contractor)
		net.SendToServer()
		AWDrawTimeCountdown( CurTime(), CurTime()+HitmanPlus.Config.HitTime, Color(255,255,255), "Hit.DrawTimeLeft")
	end, "Não", 
	function()
		net.Start( "Hit+::DeclineHit" )
		net.WriteInt(Cookie,32)
		net.WriteEntity(Contractor)
		net.SendToServer()
	end)
end)


