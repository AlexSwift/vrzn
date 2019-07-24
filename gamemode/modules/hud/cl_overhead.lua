
	local icontbl = {}
	icontbl["topazio"] = awcache.UI.Materials.topazio
	icontbl["safira"] = awcache.UI.Materials.safira
	icontbl["ametista"] = awcache.UI.Materials.ametista
	icontbl["ruby"] = awcache.UI.Materials.ruby

local function SetupFonts()
	surface.CreateFont( "OverHead::NameFont", {
		font = "Montserrat Bold",
		size =  49,
		--weight = 400,
		antialias = true,
		shadow = false,
		extended = false,
	} );

	surface.CreateFont( "OverHead::JobFont", {
		font = "Montserrat Bold",
		size = 32,
		--weight = 400,
		antialias = true,
		shadow = false,
		italic = true,
	} );

	surface.CreateFont( "OverHead::RankFont", {
		font = "Montserrat Regular",
		size = 28,
		--weight = 400,
		antialias = true,
		shadow = false,
		italic = true,
	} );

end
SetupFonts();
hook.Add( "InitPostEntity", "FROST::SetupFonts", SetupFonts );

local meta = FindMetaTable( "Player" );


function meta:shouldDraw()
	if( !self:Alive() or (LocalPlayer():GetEyeTrace().Entity !=self) ) then
		 return false 
	end

	if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 500) || !self:Alive() || self:InVehicle() || v == LocalPlayer() then
		return false;
	end

	return self:Team() != 1002;
end

function meta:ObjName()	
		return self:Nick() ;
end

function meta:ObjRank()	
	return serverguard.ranks.stored[self:GetUserGroup()].name ;
end

function meta:ObjColor()
	return serverguard.ranks.stored[self:GetUserGroup()].color
end

function meta:ObjNameColor()
	if self:GetWanted() then
		return Color(255, (math.sin(RealTime()*10) +1)*127.5 , (math.sin(RealTime()*10) +1)*127.5)
	else
		return Color(255,255,255)
	end
end

function meta:ObjJob()
	return GAMEMODE.Jobs:GetPlayerJob( self )
end

function meta:ObjGroup()
	return "Sem Organização"
end


hook.Add( "PreDrawEffects", "HUD::PreDrawEffects", function()
	
	local bone = LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) 
	if not bone then return end
	-- print( LocalPlayer():GetBonePosition(bone) ) 

	for i, v in pairs( player.GetAll() ) do

		local steamid = v:SteamID64()
		if not awcache.AvatarLoader.CachedMaterials[v:SteamID64()] then
			print("Obtendo novo avatar")
			awcache.AvatarLoader.GetMaterial( v:SteamID64(), function(mat)
				awcache.AvatarLoader.CachedMaterials[v:SteamID64()] = mat
			end)
		end
	
		local pos = v:GetBonePosition(bone);
		local ang = LocalPlayer():EyeAngles();
		ang:RotateAroundAxis( ang:Forward(), 90 );
		ang:RotateAroundAxis( ang:Right(), 90 );
		if v:Crouching() then
			pos = pos + Vector( 0, 0, v:OBBMaxs().z - 25 );
		else
			pos = pos + Vector( 0, 0, v:OBBMaxs().z - 65 );
		end
		pos = pos + LocalPlayer():GetRight() * 5;
		pos = pos + LocalPlayer():GetAngles():Right() * 2;

		local toScreen = pos:ToScreen();

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 );
	
			if( v:shouldDraw() ) then

				// Player name
				local nw, nh = draw.SimpleText( v:ObjName(), "OverHead::NameFont", 116, 0, v:ObjNameColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)		
								
				// Player Avatar
				AwArc(50, 50, 0, 360, 51, v:ObjColor(), 35, "rank_border")

				AwMask( 
				function()
					AwArc(50, 50, 0, 360, 50, Color(255,255,255), 35, "jesus")
				end
				, 
				function()
					
					surface.SetMaterial( awcache.AvatarLoader.CachedMaterials[v:SteamID64()] )
					surface.DrawTexturedRect(0, 0, 100, 100)

				end
				)

				// Player Job
				local jw, jh = draw.SimpleText( v:ObjJob().Name, "OverHead::JobFont", 116, nh-10, v:ObjJob().TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)	

				// Player org
				local ow, oh = draw.SimpleText( v:ObjGroup(), "OverHead::RankFont", 116, nh-20+jh, v:ObjJob().Color or Color(255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				
				// Player Rank
				if icontbl[v:GetUserGroup()] then
					AwArc(90, 10, 0, 360, 24, v:ObjColor(), 25, "rank_border")
					AwArc(90, 10, 0, 360, 22, Color(26,26,26), 25, "rank_fill")
					-- draw.RoundedBox(4, 116, nh, 36, 36, v:ObjColor() )
					-- draw.RoundedBox(4, 117, nh+1, 34, 34, Color(26,26,26) )

					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( icontbl[v:GetUserGroup()])
					surface.DrawTexturedRect(74.5, -6, 32, 32)
				end

				// Gun license

				if v:GetLicense() then
					AwArc(50, 100, 0, 360, 19, v:ObjColor(), 25, "gun_border")
					AwArc(50, 100, 0, 360, 18, Color(26,26,26), 25, "gun_fill")
					-- draw.RoundedBox(4, 116, nh, 36, 36, v:ObjColor() )
					-- draw.RoundedBox(4, 117, nh+1, 34, 34, Color(26,26,26) )

					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( awcache.UI.Materials.gunlicense )
					surface.DrawTexturedRect(35, 85, 32, 32)
					
				end
				-- awcache.UI.Materials.gunlicense

			end
		cam.End3D2D();
	end
end );





































