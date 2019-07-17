
AddCSLuaFile()
ALERT = {}
ALERT.__index = __index
ALERT.Items = {}

tblZones = {

	rp_downtown_v2_insonic = {
		{ 
		name                   = "Cassino",
		from                   = Vector(-5690, -8366, -200),
		to                     = Vector(-3637, -7172, 500)
		},
		{
		name                   = "Bairro Capitalista",
		from                   = Vector(-5722, -7150, -200),
		to                     = Vector( 1087, -4340, 500)
		},
		{
		name                   = "Zona Sul",
		from                   = Vector(1156, -7372, -200),
		to                     = Vector(3784, -4916, 300)
		},
		{
		name                   = "Praia",
		from                   = Vector(7564, -4769, -200),
		to                     = Vector(1983, -664, 500)
		},
		{
		name                   = "Bairro do trabalhador",
		from                   = Vector(1346, -2092, -200),
		to                     = Vector(-341, -616, 500)
		},
		{
		name                   = "Centro da cidade",
		from                   = Vector(-2895, -2415, -200),
		to                     = Vector(-1040, 942, 500)
		},
		{
		name                   = "Bairro Gole de Skol",
		from                   = Vector(-9, 424, -200),
		to                     = Vector(1510, 4223, 500)
		},
		{
		name                   = "Bairro do Vazio",
		from                   = Vector( 1786, 2528, -200),
		to                     = Vector( 4600, 4194, 500 )
		},
		{ 
		name                   = "Área do Spawn",
		from                   = Vector(3647, 1959, -200),
		to                     = Vector(2016, 128, 500)
		}
				
	}

}
function ALERT:Create(tt, bt, ic, t, ply)
    if (CLIENT) then
        table.insert(self.Items, {
            title = tt,
            bottom = bt,
            icon = ic,
            time = t
        })
    else
        net.Start("AddToast")
        net.WriteString(tt)
        net.WriteString(bt)
        net.WriteString(ic)
        net.WriteFloat(t)
        
        if (ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end
end

--LocalPlayer().zone = 0
hook.Add("Think", "CheckToastInside", function(ply)
    if (CLIENT and tblZones[game.GetMap()] and #tblZones[game.GetMap()] > 0) then
        local ply = LocalPlayer()
        ply.NoZone = true
        
        for k, v in pairs(tblZones[game.GetMap()]) do
            if (ply:GetPos():WithinAABox(v.from - Vector(0, 0, 70), v.to)) then
                ply.NoZone = false
                
                if ((ply.zone or 0) ~= k and (ply.zonename or "") ~= v.name) then
                    ply.zone = k
                    ply.zonename = v.name
                    ALERT:Create("ENTRANDO EM", "" .. v.name, "materials/vgui/elements/coordinates.png", 3)
                end
                
                if (ply.zone == k and not ply:GetPos():WithinAABox(v.from - Vector(0, 0, 60), v.to)) then
                    ply.zone = 0
                end
            end
        end
        
        if (ply.NoZone) then
            ply.zone = 0
            ply.zonename = ""
        end
    end
end)

net.Receive("AddToast", function()
    ALERT:Create(net.ReadString(), net.ReadString(), net.ReadString(), net.ReadFloat())
end)

if CLIENT then
    local blur = Material("pp/blurscreen")
    
    local function DrawBlurRect(x, y, w, h)
        local X, Y = 0, 0
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
        
        for i = 1, 3 do
            blur:SetFloat("$blur", (i / 2) * (3))
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            render.SetScissorRect(x, y, x + w, y + h, true)
            surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
            render.SetScissorRect(0, 0, 0, 0, false)
        end
        
        draw.RoundedBox(0, x, y, w, h, Color(0, 0, 0, 175))
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(x, y, w, h)
    end
    
    surface.CreateFont("Oswald", {
        font = "Montserrat Regular",
        size = 32,
        weight = 100
    })
    
    surface.CreateFont("OswaldBold", {
        font = "Montserrat Bold",
        size = 48,
        weight = 600
    })
    
    local toast = nil
    local tx, bx = 0, 0
    
    hook.Add("HUDPaint", "ShowToastsOnScreen", function()
        -- if IsValid(Monolith.HUD.IntroScreen) then 
            -- 	return
            -- end
            
            if (#ALERT.Items > 0) then
                toast = ALERT.Items[1]
                
                if (not toast.on) then
                    toast.on = true
                    toast.h = 40
                    toast.prg = 0
                end
                
                if toast and toast.time > 0 then
                    toast.prg = Lerp(FrameTime() * 8, toast.prg, 1)
                else
                    toast.prg = Lerp(FrameTime() * 8, toast.prg, -1)
                    
                    if (toast.prg < -0.05) then
                        table.RemoveByValue(ALERT.Items, ALERT.Items[1])
                    end
                end
                
                
                toast.time = toast.time - FrameTime()
                
                BSHADOWS.BeginShadow()
                draw.RoundedBox(8, ScrW() / 2 - ((tx > bx and tx or bx) + 64) / 2 - 32 , toast.h - 8, (tx > bx and tx or bx) + 112, (64 + 16) * toast.prg, Color(26,26,26))
                BSHADOWS.EndShadow(1, 1, 2, 200)
                tx, _ = draw.SimpleText(toast.title, "OswaldBold", ScrW() / 2 + 32, toast.h + 16, Color(235, 235, 235, 255 * toast.prg), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                bx, _ = draw.SimpleText(toast.bottom, "HUD::0.2vw", ScrW() / 2 + 16, toast.h + 16 - (1 - toast.prg * 36), Color(235, 235, 235, 255 * toast.prg), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                surface.SetMaterial(Material(toast.icon))
                surface.SetDrawColor(255, 255, 255, 255 * toast.prg)
                surface.DrawTexturedRect(ScrW() / 2 - ((tx > bx and tx or bx) + 32) / 2 - (29 + 16) + 10, toast.h, 64, (64) * toast.prg)
            end
        end)
    end
    