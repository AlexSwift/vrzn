
local weapons = {}
local itW = 0
local subW = 0
local selection = -1
local subSelect = 1
local introSel = nil
local selTime = 0
local nextPrecache = 0
local st = false
local alpha = 50
local alpha_target = 0
local scale = (ScrW() / 175 >= 6 and 1) or 0.8

function IsContextOpen()

    return _context_open or false

end

surface.CreateFont("gmrp_1", {  size = 18 * scale,    weight = 1000 * scale,    antialias = true,    blursize = 0,    extended = true,    font = "Montserrat Bold" })

surface.CreateFont("gmrp_2", {    size = 22,    weight = 300 * scale,    antialias = true,    blursize = 0,    extended = true,    font = "Montserrat Bold" })

surface.CreateFont("gmrp_3", {    size = 24,    weight = 600 * scale,    antialias = true,    blursize = 0,    extended = true,    font = "Montserrat Bold" })


local function draw_right()

    if (IsContextOpen() or not LocalPlayer():Alive() or LocalPlayer():InVehicle() or not LocalPlayer():GetActiveWeapon().GetPrintName) then return end
    alpha = Lerp(FrameTime() * 5, alpha, alpha_target)
    local amm = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())

    if (nextPrecache < CurTime()) then
        weapons = {}

        for k, v in pairs(LocalPlayer():GetWeapons()) do
            if (not weapons[v:GetSlot() + 1]) then
                weapons[v:GetSlot() + 1] = {}
            end
            weapons[v:GetSlot() + 1][#weapons[v:GetSlot() + 1] + 1] = v
        end
        nextPrecache = CurTime() + 1
	end
	
    itW = 72

    for k, v in pairs(weapons) do
        st = LocalPlayer():GetActiveWeapon():GetSlot() + 1 == k
        x_pos = Either(st, 64, 32)
		itW = itW + 52
        
        if (st) then
            draw.RoundedBox(30, 48, 128 + itW, 48, 48, Either(subSelect == sk, Color(26, 26, 26, alpha), Color(26, 26, 26, alpha)))
        else
            draw.RoundedBox(30, 48, 128 + itW, 48, 48, Either(subSelect == sk, Color(26, 26, 26, alpha), Color(26, 26, 26, alpha)))
        end

        if (st) then
            draw.SimpleText( k, "gmrp_2", 48 + 24, 128 + itW + 24, Color(240,225,204, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText( k , "gmrp_2", 48 + 24, 128 + itW + 24, Color(240,225,204, Either(st or selection == k, alpha * 0.5, alpha)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
       
        
        if (selection == k) then
            
            

            draw.RoundedBox(30, 48-1, 128 + itW-1, 48+2, 48+2, Color(0,225,78, Either(st or selection == k, alpha * 0.5, 255) ) )
            draw.RoundedBox(30, 48, 128 + itW, 48, 48, Either(subSelect == sk, Color(26, 26, 26, alpha), Color(26, 26, 26, 255)))
            draw.SimpleText( k, "gmrp_2", 48 + 24, 128 + itW + 24, Color(0,225,78, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            subW = 0

            for sk, sv in pairs(v) do
                if (subSelect > #v) then
                    subSelect = 1
                end

                subW = subW + 170
                surface.SetDrawColor(Either(subSelect == sk, Color(0, 166, 166, alpha), Color(30, 30, 30, 255, alpha)))
                draw.RoundedBox(20, 96 + 8-1,  (sk - 1) * 58 + 128 + itW -1, 170, 48, Either(subSelect == sk, Color(0, 255, 78, 255), Color(26, 26, 26, alpha)))
                draw.RoundedBox(20, 96 + 8,  (sk - 1) * 58 + 128 + itW, 170-2, 48-2, Either(subSelect == sk, Color(26, 26, 26, 255), Color(26, 26, 26, alpha)))

                if (IsValid(sv)) then
                    draw.SimpleText(sv:GetPrintName(), "gmrp_1", 116 + 40, 140 + itW + 2 + (sk - 1) * 58, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT)
                end

                if string.find(sv:GetClass(),"swb_") then 
                    AwCircle( 96 + 30,  (sk - 1) * 58 + 128 + itW + 23, 12, Color(236, 70, 70) )
                elseif string.find(sv:GetClass(),"weapon_") then
                    AwCircle( 96 + 30,  (sk - 1) * 58 + 128 + itW + 23, 12, Color(1, 156, 70) )
                elseif string.find(sv:GetClass(),"gmod_") then
                    AwCircle( 96 + 30,  (sk - 1) * 58 + 128 + itW + 23, 12, Color(244, 255, 128) )
                    
                end    

                if (subSelect == sk and IsValid(sv)) then
                    introSel = sv:GetClass()
                    local amm = LocalPlayer():GetAmmoCount(sv:GetPrimaryAmmoType())

					// ammo
					if not (sv:Clip1() == -1 and (amm == 0 or amm == -1)) then
						draw.RoundedBox(20, (96) * 3,  (sk - 1) * 58 + 128 + itW, 200, 48, Either(subSelect == sk, Color(0, 255, 78, alpha+255), Color(26, 26, 26, alpha)))
                        draw.SimpleText("MUNIÇÃO: " ..sv:Clip1() .. "/" .. amm, "gmrp_3", (96) * 3 + 8 + 96, 140 + itW + (sk - 1) * 58, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                    end             

                end
            end

        end
    end

    if (input.IsKeyDown(KEY_ENTER) or input.IsMouseDown(107) and introSel ~= nil) then
        RunConsoleCommand("use", introSel)
        selection = -1
        introSel = nil
        subSelect = -1
        alpha_target = 0
    end

    if (selection ~= -1 and selTime < CurTime() or input.IsMouseDown(108)) then
        selection = -1
        introSel = nil
        subSelect = -1
        alpha_target = 0
    end

end

local isPrev = false
local nextSound = 0

hook.Add("PlayerBindPress", "DisableWeapon", function(ply, bind, pressed)

    if (not ply:Alive() or not pressed) then return end

    if IsValid(ply:GetActiveWeapon()) then
        if (string.StartWith(bind, "+zoom")) then return true end

        if (string.StartWith(bind, "slot")) then
            if (ply:GetActiveWeapon():GetClass() == "gmod_camera") then
                RunConsoleCommand("use", ply:GetWeapons()[2]:GetClass())
                LocalPlayer():EmitSound("ambient/water/rain_drip1.wav", 75, 100, 0.3)
                return true
			end
			
            alpha_target = 255

            if (pressed) then
                selTime = CurTime() + 2
                if (tonumber(string.sub(bind, 5, 6)) == selection) then
                    subSelect = subSelect + 1
                else
                    subSelect = 1
                end

                selection = tonumber(string.sub(bind, 5, 6))
                LocalPlayer():EmitSound("ambient/water/rain_drip1.wav", 75, 100, 0.3)
            end

            return true
        end



        if ((bind == "invnext" or bind == "invprev") and pressed and not input.IsMouseDown(107)) then
            alpha_target = 200
            isPrev = bind ~= "invnext"

            if (selTime > CurTime()) then
                subSelect = subSelect + Either(isPrev, -1, 1)
				local weapons = {}
				
                for k, v in pairs(LocalPlayer():GetWeapons()) do
                    if (not weapons[v:GetSlot() + 1]) then
                        weapons[v:GetSlot() + 1] = {}
					end
                    weapons[v:GetSlot() + 1][#weapons[v:GetSlot() + 1] + 1] = v
                end

                if (weapons[selection] and subSelect > #weapons[selection] or subSelect <= 0) then
					selection = selection + Either(isPrev, -1, 1)
					
                    if (weapons[selection]) then
                        subSelect = 1

                        if (isPrev) then
                            for k = selection, Either(isPrev, 0, 10), Either(isPrev, -1, 1) do
                                if (weapons[k]) then
                                    subSelect = Either(isPrev, #weapons[k], 1)
                                    break
                                end
                            end
                        end
                    end
                end

				if (not weapons[selection]) then
					
                    local b = false

                    for k = selection, Either(isPrev, 0, 10), Either(isPrev, -1, 1) do
                        if (weapons[k]) then
                            selection = k
                            subSelect = Either(isPrev, #weapons[k], 1)
                            b = true
                            break
                        end
                    end

                    if (not b) then
                        selection = 1
                        subSelect = 1
                    end
                end

            elseif (LocalPlayer():GetActiveWeapon():GetSlot()) then
                selection = LocalPlayer():GetActiveWeapon():GetSlot() + 1
            else
                selection = 1
            end

            selTime = CurTime() + 2

            if (pressed and nextSound < CurTime()) then
                nextSound = CurTime() + 0.25
                LocalPlayer():EmitSound("ambient/water/rain_drip1.wav", 75, 100, 0.4)
            end

            return true
        end



        if ((bind == "+attack" or bind == "+attack2") and selection ~= -1) then
            LocalPlayer():EmitSound("ambient/water/rain_drip1.wav", 75, 100, 0.4)
            return true
        end
    end
end)

--ambient/animal/horse_1.wav

hook.Add("HUDPaint", "DrawWeaponSelection", draw_right)