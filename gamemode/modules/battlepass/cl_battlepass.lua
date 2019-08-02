----------------------------------------------------------------------------------------------
-- NETWORKING  NETWORKING  NETWORKING  NETWORKING  NETWORKING  NETWORKING  NETWORKING  NETWOR
----------------------------------------------------------------------------------------------
net.Receive( "BP::OpenGui", function( len )
	print("Cliente received")
	local Data = net.ReadTable()
	-- local PData = net.ReadTable()
    BattlePass.Achievement[ LocalPlayer():SteamID64() ] = Data
	BattlePass.AchievementList = ACV.Achievements
	
	-- BattlePass.PlayerParsed = util.JSONToTable(PData[1].parsed)
    BattlePassUI(Data)

    -- PrintTable(BattlePass.AchievementList)

end)

net.Receive("BP::PlayerRewards", function(len, ply)
	local PData = net.ReadTable()
	BattlePass.PlayerParsed = util.JSONToTable(PData[1].parsed)
end)


----------------------------------------------------------------------------------------------
-- FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS  
----------------------------------------------------------------------------------------------
local ACVTTime = CurTime()
	hook.Add("Think","ACV Test",function()
		if ACVTTime < CurTime() then
			ACVTTime = CurTime() + 8
		--	ACV_DrawNoticer("ACV_Normal_Say_100")
		end
	end)

	ACV_ClientInventory = ACV_ClientInventory or {}
	net.Receive( "BP::SavedData", function( len )
		local DATA = net.ReadTable()
		ACV_ClientInventory = DATA
	end)
	net.Receive( "BP::SyncData", function( len )
		local DA = net.ReadTable()
		ACV_ClientInventory[DA.LN] = DA.AM
		
		local ADB = ACVTable(DA.LN)
		if DA.AM >= ADB.Max then
			ACV_DrawNoticer(DA.LN)
		end
	end)
	
	function ACV_DrawNoticer(ACVLuaName)
		local ADB = ACVTable(ACVLuaName)
	
			hook.Remove( "HUDPaint", "ACVNotice_HUD" )
			local StartTime = CurTime()
			local PosX = ScrW()/2-250
			local PosY = ScrH()+50
			
			local SizeX,SizeY = 500,100
			
			hook.Add("HUDPaint","ACVNotice_HUD",function()
				local DeltaTime = CurTime() - StartTime
				
				if DeltaTime < ACVCustomizer.CompleteNoticerHUDDuration then
					local AnimationLerp = 100/(1/FrameTime())
					AnimationLerp = AnimationLerp/15
					PosY = Lerp(AnimationLerp,PosY,ScrH()-150)
				else
					local AnimationLerp = 100/(1/FrameTime())
					AnimationLerp = AnimationLerp/25
					PosY = Lerp(AnimationLerp,PosY,ScrH()+50)
				end
						surface.SetDrawColor(0,0,0,250) 
						surface.DrawRect(PosX,PosY,SizeX,SizeY)
						
						surface.SetDrawColor(0,150,255,250)
						surface.DrawRect(PosX,PosY,SizeX,1)
						surface.DrawRect(PosX,PosY+SizeY-1,SizeX,1)
						surface.DrawRect(PosX,PosY,1,SizeY)
						surface.DrawRect(PosX+SizeX-1,PosY,1,SizeY)
						
						
						draw.SimpleText("Achievement Complete!!", "RXF_TrebOut_S30", PosX+SizeX/2, PosY+5, Color(0,200,255,255), TEXT_ALIGN_CENTER)
						render.SetScissorRect( PosX+10, 0, PosX+SizeX -10 , ScrH(), true )
							draw.SimpleText("< " .. ADB.PrintName .. " >", "RXF_TrebOut_S25", PosX+SizeX/2, PosY+35, Color(0,255,255,255), TEXT_ALIGN_CENTER)
							draw.SimpleText("< " .. ADB.Description .. " >", "RXF_TrebOut_S20", PosX+SizeX/2, PosY+70, Color(150,150,255,255), TEXT_ALIGN_CENTER)
						render.SetScissorRect( PosX+10, 0, PosX+SizeX -10, ScrH() , false )				
				
				if DeltaTime > ACVCustomizer.CompleteNoticerHUDDuration+1 then
					hook.Remove( "HUDPaint", "ACVNotice_HUD" )
					return
				end
			end)	

    end
    


function BattlePassUI( Data, PData )
    local frame = vgui.Create("BP::Frame")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:MakePopup()
    -- local background = frame:Add("BP::Canvas")
    -- background:Dock(FILL)


    local navbar = frame:Add("BP::Navbar")
    navbar:Dock(TOP)
    navbar:SetTall( ScrH() * 0.1)
    navbar:SetBody( frame )
    navbar:AddMenu( "Recompensas", "BP::Main")
    navbar:AddMenu( "Missões", "BP::Quests")
    navbar:AddMenu( "Como funciona?", "MenuBackgroundGradient")
    navbar:SetActive( 1 )
    -- navbar:SetTargetData( Data )

    -- navbar:SetActive(1)
    -- navbar:AddPanel( , 1, 0, 0 )
    -- navbar:AddPanel( ,2 ,1, 0 )

 

    
end

concommand.Add("bp", BattlePassUI)
