
-----------------------------------------------------

-----------------------------------------------------
if SERVER then return end

WeaponSelection = {}
local Time = 0
local Weapon_ID = 0
local WeaponsCount = 0
local Weapons = {}
local TitleOffset = 0

local blur = Material( "pp/blurscreen" )
local function drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	-- for i = 1, layers do
	-- 	blur:SetFloat( "$blur", ( i / layers ) * density )
	-- 	blur:Recompute()

	-- 	render.UpdateScreenEffectTexture()
	-- 	render.SetScissorRect( x, y, x + w, y + h, true )
	-- 		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	-- 	render.SetScissorRect( 0, 0, 0, 0, false )
	-- end
end

// Customize Your Button Color


-- Black/Purple Skin:
local ButtonColor = Color(130,130,130,150)
local AmmoButton = Color(0,255,78,255)


-- Blue/Pink Skin: 
-- local ButtonColor = Color(255, 87, 51)
-- local AmmoButton = Color(100,0,200,150)


surface.CreateFont("WEP_HUD",{font = "Montserrat Bold",size = 22,weight = 400,antialias = true,additive = false, outline = 0, blursize = 0})

local function GetWeaponType(class)
	if (string.find(class,"khr_") or string.find(class,"cw_") or class == "srp_hands") or string.find(class,"doi_") then
		return "weapon"
	elseif (string.find(class,"weapon_") ) then
		return "job"
	else
		return "normal"
	end
end

local function GetWeaponCaching(weps)
	local tmp = {}
	for k,v in pairs(weps) do
		table.insert(tmp,v)
	end
	return tmp
end

function WeaponSelection:Draw()
	local Counter = 0
	local offset = (table.Count(Weapons)*26)
	TitleOffset = offset
	local Translations = {}
	Translations["weapon_physgun"] = "Physgun";
	Translations["weapon_idcard"] = "Identidade";
	Translations["none"] = "Mãos";
	Translations["gmod_camera"] = "Câmera";
	Translations["weapon_fists"] = "Punhos";

	for k, v in pairs(Weapons) do
		-- print( v:GetPrintName() )
		if (v and IsValid(v)) then 
			if Translations[v:GetClass()] then 
				PrintableName = Translations[v:GetClass()]
			else
				PrintableName = v:GetPrintName()
			end

			

			Counter = Counter + 1
			local type = GetWeaponType(v:GetClass())
			if (Counter == Weapon_ID) then
				if (type == "weapon" and v:GetClass() != "fists_weapon" and v:GetClass() != "weapon_fists" and v:GetClass() != "ultra_fists" and v:GetClass() != "stungun") then
					WeaponSelection:DrawAmmo(v,250,(ScrH()/2)- offset)
				end
				WeaponSelection:DrawWeaponItem(PrintableName,45,(ScrH()/2)-offset,type, Color(0,255,78) )
			else
				WeaponSelection:DrawWeaponItem(PrintableName,30,(ScrH()/2)-offset,type)
			end
			
			offset = offset - 53
		end
	end
end

function WeaponSelection:DrawAmmo(weapon,posx,posy)
	local BoxSize_W = 200
	local BoxSize_H = 45
	local BoxColor = AmmoButton
	draw.RoundedBox( 16, posx, posy, BoxSize_W, BoxSize_H, BoxColor )
	draw.SimpleText("MUNIÇÃO : " ..weapon:Clip1() .. "/" ..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()), "WEP_HUD", posx + (BoxSize_W*0.5), posy + (BoxSize_H*0.5), TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function WeaponSelection:DrawWeaponItem( name, posx, posy, type, selectioncolor)
	local BoxSize_W = 200
	local BoxSize_H = 45
	--local BoxColor = Color( 0, 130, 200, 150 )
	local BoxColor = ButtonColor
	local TextColor = Color(255,255,255,255)
	local LineColor = Color(0,0,0,100)
	local LineDecal = 7

	-- drawBlur( posx, posy, BoxSize_W,BoxSize_H, 3, 6, 255 )
	if selectioncolor then
		-- draw.RoundedBox( 8, posx, posy, BoxSize_W, BoxSize_H, Color(26,26,26) )
		draw.RoundedBox( 16, posx, posy, BoxSize_W, BoxSize_H, selectioncolor )
		draw.RoundedBox( 16, posx+1, posy+1, BoxSize_W-2, BoxSize_H-2, Color(26,26,26) )
	else
	draw.RoundedBox( 16, posx, posy, BoxSize_W, BoxSize_H, Color(26,26,26, 250) )
	end
	-- draw.RoundedBox( 0, posx+10, posy, BoxSize_W-148, BoxSize_H, color_white )
	draw.SimpleText(name, "WEP_HUD", posx + (BoxSize_W*0.5) + 7, posy + (BoxSize_H*0.5), TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- draw.RoundedBox(20, posx, posy, 10, BoxSize_H, LineColor)
	
	-- draw.RoundedBoxEx(2, posx+14, posy+BoxSize_H-4, BoxSize_W-28, 3, LineColor, true, true, true, true)
	if (type == "weapon") then
		LineColor = Color(255,66,66)
		AwCircle(posx + 20, posy+ BoxSize_H/2, 10, LineColor)
	elseif (type == "job") then
		LineColor = Color(0,155,78,255)
		AwCircle(posx + 20, posy+ BoxSize_H/2, 10, LineColor)
	else
		LineColor = Color(0,0,0,0)
	end
	


	
end

function WeaponSelection:ShouldDraw()
	if (Time and Time + 1.5 > CurTime()) then
		return true
	end
	return false
end

function WeaponSelection:InitialCall()
	Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())
	local Current_Weapon = LocalPlayer():GetActiveWeapon()
	WeaponsCount = table.Count(Weapons)
	Weapon_ID = table.KeyFromValue(Weapons,Current_Weapon)
    timer.Create( "refresh_weapons", 0.5, 0, function()
		Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())
		WeaponsCount = table.Count(Weapons)
	end)
end

function WeaponSelection:SetSelection(id)
	if (LocalPlayer():InVehicle()) then return false end
	Time = CurTime()
	WeaponSelection:InitialCall()
	Weapon_ID = id
end

-- We Force it to Draw!
function WeaponSelection:Call()
	if (WeaponSelection:ShouldDraw()) then
		Time = CurTime()
	else
		Time = CurTime()
		WeaponSelection:InitialCall()
	end
end

function WeaponSelection:NextWeapon()
	if (WeaponsCount > 0) then
	end
	if (!Weapon_ID) then Weapon_ID = 1 end
	if (WeaponsCount == Weapon_ID) then
		Weapon_ID = 1
	else
		Weapon_ID = Weapon_ID + 1
	end
end

function WeaponSelection:PrevWeapon()
	if (WeaponsCount > 0) then
	end
	if (!Weapon_ID) then Weapon_ID = 1 end
	if (Weapon_ID == 1) then
		Weapon_ID = WeaponsCount
	else
		Weapon_ID = Weapon_ID - 1
	end
end

function WeaponSelection:SelectWeapon()
	if (Weapon_ID and Weapons[Weapon_ID] and IsValid(Weapons[Weapon_ID])) then
		RunConsoleCommand("use",Weapons[Weapon_ID]:GetClass())
		timer.Destroy("refresh_weapons")
		Time = 0
	end
end

function WeaponSelection:Think()

end