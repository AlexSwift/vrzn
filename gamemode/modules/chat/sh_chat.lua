GM.Chat = {}
if SERVER then
	function GM.Chat:PlayerSay( pPlayer, strText, bTeamOnly )
		if strText:sub( 1, 5 ) == "/ad " and not bTeamOnly then
			-- if pPlayer:CanAfford( GAMEMODE.Config.AdvertPrice ) then
				-- pPlayer:TakeMoney( GAMEMODE.Config.AdvertPrice )
				-- pPlayer:AddNote( "Your advertisement cost you $".. string.Comma(GAMEMODE.Config.AdvertPrice) )
				return strText
			-- else
			-- 	pPlayer:AddNote( "Advertisements cost $".. string.Comma(GAMEMODE.Config.AdvertPrice).. ". You can't afford that." )
			-- 	return ""
			-- end
		elseif strText == "/preso" then
			if GAMEMODE.Jail:IsPlayerInJail( pPlayer ) then
				pPlayer:AddNote( "Não pode utilizar na jail!" )
				return ""
			end
			if pPlayer:InVehicle() then
				pPlayer:AddNote( "Saia do veículo primeiro.!" )
				return ""
			end
			if pPlayer.m_intLastUnstuckTime then
				if pPlayer.m_intLastUnstuckTime > CurTime() then
					local time = math.Round( pPlayer.m_intLastUnstuckTime -CurTime() )
					pPlayer:AddNote( "Espere ".. time.. " segundos antes de executar novamente." )
					return ""
				end
			end
			GAMEMODE.Util:UnstuckPlayer( pPlayer )
			pPlayer.m_intLastUnstuckTime = CurTime() +30
			pPlayer:AddNote( "Você agora deve estar livre.!" )
			return ""
		elseif strText:sub( 1, 11 ) == "/transmitir " and not bTeamOnly then
			if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_MAYOR then return strText else return "" end
		end
		return strText or ""
	end
else
	function GM.Chat:ModifyForChatTypes( tblArgs, pPlayer, strText )
		local find = string.find( strText, "//" )
		if find == 1 then
			strText = string.sub( strText, find +2 )
			strText = string.Trim( strText )
			table.insert( tblArgs, Color(60, 200, 60) )
			table.insert( tblArgs, "( GERAL ) " )
			return strText, -1
		end
		find = string.find( strText, "/ooc" )
		if find == 1 then
			strText = string.sub( strText, find +5 )
			strText = string.Trim( strText )
			table.insert( tblArgs, Color(60, 200, 60) )
			table.insert( tblArgs, "( GERAL ) " )
			return strText, -1
		end
		find = string.find( strText, "/ad" )
		if find == 1 then
			strText = string.sub( strText,find +5 )
			table.insert( tblArgs, Color(60, 200, 60) )
			table.insert( tblArgs, "( ADVERT ) " )
			return strText, -1
		end
		
		find = string.find(strText,"/a ")
		if find == 1 then
			strText = string.sub(strText,find+3)
			table.insert( tblArgs, Color(60, 200, 60) )
			table.insert( tblArgs, "( ADVERT ) " )
			return strText, -1
		end
		find = string.find( strText, "/transmitir" )
		if find == 1 then
			strText = string.sub( strText,find +11 )
			table.insert( tblArgs, Color(60, 200, 60) )
			table.insert( tblArgs, "( Anúncio do prefeito ) " )
			return strText, -1
		end		
		return strText, 500
	end
	
	function GM.Chat:OnPlayerChat( pPlayer, strText, bTeamOnly, bIsDead )
		if not IsValid( LocalPlayer() ) then return end
		local pos = LocalPlayer():GetPos()
		local otherpos = IsValid( pPlayer ) and pPlayer:GetPos() or Vector( 0 )
		local chatdist = 500
		local tab = {}
		strText, chatdist = self:ModifyForChatTypes( tab, pPlayer, strText )
		
		if bTeamOnly then
			if pPlayer == LocalPlayer() then
				chat.AddText( Color(255, 100, 100), "Por favor, utilize o chat normal ( Y )" )
			end
			return true
		end
		
		if chatdist > 0 then 
			if pos:Distance( otherpos ) > chatdist then
				return true
			end
		end
		
		if IsValid( pPlayer ) then
			table.insert( tab, pPlayer )
		else
			table.insert( tab, Color(0, 0, 0) )
			table.insert( tab, "Console" )
		end
		table.insert( tab, Color(255, 255, 255) )
		table.insert( tab, ": "..strText )
		chat.AddText( unpack( tab ) )
		return true
	end
end
