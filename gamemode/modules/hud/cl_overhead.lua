FROST = {};

FROST.Settings							= {};

--[[ Mask Detection ]]--


--[[ Misc hud settings ]]--
FROST.Settings.AlwaysShowJobs			= {  };
FROST.RankConvID = {};
FROST.RankConvID[ "STEAM_0:1:79542453" ] = "Desenvolvedor";
FROST.Settings.OrgColor				= Color( 42, 232, 80 );

--[[ Rank&Title ]] --
FROST.RankConv = {};
FROST.RankConv[ "owner" ] = "Dono";
FROST.RankConv[ "superadmin" ] = "Administrador Geral";
FROST.RankConv[ "admin" ] = "Administrador";
FROST.RankConv[ "assistantmanager" ] = "Gerente geral";
FROST.RankConv[ "operator" ] = "Suporte";
FROST.RankConv[ "enforcer" ] = "Supervisor staff";
FROST.RankConv[ "manager" ] = "Gerente";
FROST.RankConv[ "experiente" ] = "Experiente";
FROST.RankConv[ "honoravel" ] = "Honorável";
FROST.RankConv[ "vipbasico" ] = "Importante";
FROST.RankConv[ "viphero" ] = "Herói";
FROST.RankConv[ "member" ] = "Cidadão experiente";
FROST.RankConv[ "user" ] = "Novo na cidade";

--[[ RankColor ]]
FROST.RankColor = {};
FROST.RankColor[ "founder" ] = Color(144, 0, 240);
FROST.RankColor[ "superadmin" ] = Color(0, 4, 255);
FROST.RankColor[ "admin" ] = Color(0, 138, 27);
FROST.RankColor[ "sup" ] = Color(0, 0, 0);
FROST.RankColor[ "imigrante" ] = Color(0, 0, 0);
FROST.RankColor[ "4horas" ] = Color(0, 0, 0);
FROST.RankColor[ "experiente" ] = Color(0, 0, 0);
FROST.RankColor[ "honoravel" ] = Color(255, 0, 216);
FROST.RankColor[ "vipbasico" ] = Color(255, 238, 0);
FROST.RankColor[ "viphero" ] = Color(255, 114, 0);
FROST.RankColor[ "vipmedio" ] = Color(255, 131, 0);
FROST.RankColor[ "user" ] = Color(0, 0, 0);


if( SERVER ) then
	resource.AddFile( "resource/fonts/keepcalm-medium.ttf" );
	resource.AddFile( "resource/fonts/puristabold.ttf" );
	resource.AddFile( "resource/fonts/puristasemibold.ttf" );
	resource.AddFile( "materials/vh_avatar.png" );
	resource.AddFile( "materials/vh_group.png" );

	return;
end

local meta = FindMetaTable( "Player" );



function meta:shouldDraw()


	if( !self:Alive() or (LocalPlayer():GetEyeTrace().Entity !=self) ) then
		 return false 
	end

	if ( GAMEMODE.Buddy:IsBuddyWith( self ) || ( GAMEMODE.Jobs && GAMEMODE.Jobs.GetPlayerJob && GAMEMODE.Jobs:GetPlayerJob( self )	&& GAMEMODE.Jobs:GetPlayerJob( self ).Name && table.HasValue( FROST.Settings.AlwaysShowJobs, GAMEMODE.Jobs:GetPlayerJob( self ).Name ) ) ) 
	then
		return true;
	end

	return self:Team() != 1002;

end


function meta:vhOne()
	if (self:Team() == 2) then 
		return "[".. GAMEMODE.PoliceRanks:GetPrettyRank(self) .. "] ".. self:Nick()
	end
	if 	( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) ) and ( GAMEMODE.Buddy:IsBuddyWith( self ) == false ) then
		return "Indivíduo mascarado"
	elseif ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) ) and ( GAMEMODE.Buddy:IsBuddyWith( self ) ) then
		return self:Name();
	 elseif not ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) ) and ( GAMEMODE.Buddy:IsBuddyWith( self ) ) then
	 	return self:Name();
	else 
		return "#".. math.Round( self:SteamID64()-765611/20000000 );
	end

end

function meta:vhTwo()

	if ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) and ( GAMEMODE.Buddy:IsBuddyWith( self ) == false ) ) then
		return "*Informação oculta*";
	end

	local job = "Emprego";
	if ( IsValid( self ) && GAMEMODE.Jobs && GAMEMODE.Jobs.GetPlayerJob && GAMEMODE.Jobs:GetPlayerJob( self ) && GAMEMODE.Jobs:GetPlayerJob( self ).Name ) then
		job = GAMEMODE.Jobs:GetPlayerJob( self ).Name;

	end

	-- if IsValid( self ) && GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).Name == "Paramedic" then
	-- 	return job .. " | " .. self:Health() .. "% de saúde";
	-- else
		return job .. " | " .. ( FROST.RankConvID[ self:SteamID() ] or FROST.RankConv[ self:GetUserGroup() ] or self:GetUserGroup() );
	-- end

end


function meta:vhThree()
	if ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) and ( GAMEMODE.Buddy:IsBuddyWith( self ) == false ) ) then
		return self:SteamID64();
	end

	return "";

end

function meta:vhOneColor()

	if ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) ) then
		return color_white;
	elseif ( IsValid( self ) && GAMEMODE.Jobs && GAMEMODE.Jobs.GetPlayerJob && GAMEMODE.Jobs:GetPlayerJob( self ) && GAMEMODE.Jobs:GetPlayerJob( self ).Name ) then
		return GAMEMODE.Jobs:GetPlayerJob( self ).TeamColor;
	else
		return color_white;
	end
end

function meta:vhOneGroup()
	if ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(self, "eq_slot_".. 'Face') or "" ) and ( GAMEMODE.Buddy:IsBuddyWith( self ) == false ) ) then
		return "???? ????";
	else
		if self:GetNWInt("org", 0) > 0 then
				return tOrgData[self:GetNWInt("org", 0)]["name"]
		else
			return "Sem grupo";
		end

	end
end

function meta:vhThreeColor()
	if self:GetNWInt("org", 0) > 0 then
		return tOrgData[self:GetNWInt("org", 0)]["color"]
	else
		return Color( 0,255,0 )
	end
end

local function SetupFonts()
	surface.CreateFont( "FROST::NameFont", {
		font = "Bebas Neue Regular",
		size =  49,
		--weight = 400,
		antialias = true,
		shadow = false,
		extended = false,
	} );

	surface.CreateFont( "FROST::JobFont", {
		font = "BuiltTitlingRg-Regular",
		size = 28,
		--weight = 400,
		antialias = true,
		shadow = false,
		italic = true,
	} );

	surface.CreateFont( "FROST::GroupFont", {
		font = "Purista",
		size = 28,
		--weight = 400,
		antialias = true,
		shadow = false,
		italic = true,
	} );

end
SetupFonts();
hook.Add( "InitPostEntity", "FROST::SetupFonts", SetupFonts );

local mat = Material( "materials/gui/hud/teamicon2.png" );
hook.Add( "PreDrawEffects", "HUD::PreDrawEffects", function()

	for i, v in pairs( player.GetAll() ) do

		if( v:GetPos():Distance( LocalPlayer():GetPos() ) > ( 200 or 500 ) || !v:Alive() || v:InVehicle() || v == LocalPlayer()
		|| ( GAMEMODE.Jobs && GAMEMODE.Jobs.GetPlayerJob && GAMEMODE.Jobs:GetPlayerJob( self ) && GAMEMODE.Jobs:GetPlayerJob( v).Name && GAMEMODE.Jobs:GetPlayerJob( v).Name == "Policial" ) ) then
			if( v.vhAvatar && IsValid( v.vhAvatar ) ) then
				v.vhAvatar:SetVisible( false );
			end
			continue;
		end

		local pos = v:GetPos();
		local ang = LocalPlayer():EyeAngles();
		ang:RotateAroundAxis( ang:Forward(), 90 );
		ang:RotateAroundAxis( ang:Right(), 90 );

		pos = pos + Vector( 0, 0, v:OBBMaxs().z - 2 );
		pos = pos + LocalPlayer():GetRight() * 5;
		pos = pos + LocalPlayer():GetAngles():Right() * 2;

		if( !IsValid( v.vhAvatar ) || !ispanel( v.vhAvatar ) || string.Trim( tostring( v.vhAvatar ) ) == "NULL PANEL" ) then
			
				v.vhAvatar = vgui.Create( "AvatarImage" );
				v.vhAvatar:SetPlayer( v, 64 );
				v.vhAvatar:SetSize( 64, 64 );
			
		else
			v.vhAvatar:SetVisible( true );
		end

		local toScreen = pos:ToScreen();


		surface.SetFont( "FROST::JobFont" );
		local twoW, twoH = surface.GetTextSize( v:vhTwo() );
		local threeW, threeH = surface.GetTextSize( v:vhThree() );

		local avatarSize = 74;
		local x = avatarSize + 5;

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 );

		if( v:shouldDraw() ) then
			surface.SetFont( "FROST::NameFont" );
			local oneW, oneH = surface.GetTextSize( v:Nick() );
			oneH = oneH / 2 + 1;
			twoH = twoH / 2 + 2;

			if ( GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(v, "eq_slot_".. 'Face') or "" ) and ( GAMEMODE.Buddy:IsBuddyWith( v ) == false ) ) then
				if( IsValid( v.vhAvatar ) ) then
					v.vhAvatar:Remove();
				end

				surface.SetDrawColor( Color( 20, 20, 20, 210 ) );
				surface.DrawRect( 0, 0, avatarSize, avatarSize );

				surface.SetMaterial( Material( "materials/vh_avatar.png" ) );
				surface.SetDrawColor( color_white );
				surface.DrawTexturedRect( 0, 0, avatarSize, avatarSize );
			else
				v.vhAvatar:SetSize( avatarSize, avatarSize );
				v.vhAvatar:SetVisible( true );
				v.vhAvatar:SetPos( ScrW(), ScrH() );
				v.vhAvatar:PaintAt( 0, 0, avatarSize, avatarSize );
			end

			draw.RoundedBox( 0, 0, 0, 2, 5, Color( 255, 255, 255 ) );
			draw.RoundedBox( 0, 0, 0, 5, 2, Color( 255, 255, 255 ) );

			draw.RoundedBox( 0, 0, avatarSize - 5, 2, 5, Color( 255, 255, 255 ) );
			draw.RoundedBox( 0, 0, avatarSize - 2, 5, 2, Color( 255, 255, 255 ) );

			draw.RoundedBox( 0, avatarSize - 5, 0, 5, 2, Color( 255, 255, 255 ) );
			draw.RoundedBox( 0, avatarSize - 2, 0, 2, 5, Color( 255, 255, 255 ) );

			draw.RoundedBox( 0, avatarSize - 2, avatarSize + 0 - 5, 2, 5, Color( 255, 255, 255 ) );
			draw.RoundedBox( 0, avatarSize - 5, avatarSize + 0 - 2, 5, 2, Color( 255, 255, 255 ) );
			
			
		--	draw.SimpleText( v:vhOne(), "FROST::NameFont", x, -0 - 14, Color( 0, 0, 0 ) );
			draw.SimpleTextOutlined( v:vhOne() , "FROST::NameFont", x + 1, -0 - 7, v:vhOneColor(),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255)  );

			--draw.SimpleText( v:vhTwo(), "FROST::JobFont", x, -0 + oneH + 1, Color( 0, 0, 0 ) );
			draw.SimpleTextOutlined( v:vhTwo(), "FROST::GroupFont", x + 1, - 16 + oneH + 20, color_white,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255) );

			if( type( v:vhThree() ) == "string" ) then
				surface.SetMaterial( mat );
				surface.SetDrawColor(  v:vhThreeColor() );
				surface.DrawTexturedRect( x,-0 + oneH + twoH + 17, 16, 16 );

				--draw.SimpleText( "sem grupo", "FROST::JobFont", x + 18, -0 + oneH + twoH + 20, Color( 255, 255, 255 ) );
				draw.SimpleText( v:vhOneGroup() or "Sem grupo", "FROST::GroupFont", x + 18, -0 + oneH + twoH + 9, v:vhThreeColor() );
			end

		else

			v.vhAvatar:SetVisible( false );
			x = 6;

		end
		cam.End3D2D();
	end
end );

