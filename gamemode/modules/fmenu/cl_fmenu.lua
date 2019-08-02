local WindowW = ScrW()
local WindowH = ScrH()

local frame
local navbar

function F4GUI()
    if (frame == nil) then
        local pPlayer = LocalPlayer()
        
        frame = vgui.Create("F4::Frame")
        frame:SetSize(WindowW * 0.8, WindowH * 0.8)
        frame:Center()
        -- frame:MakePopup()

        navbar = frame:Add("F4::Navbar")
        navbar:Dock(TOP)
        navbar:SetTall( ScrH() * 0.1)
        navbar:SetNavBody( frame )
        navbar:AddMenu( "Empregos", "F4::JobPanel")
        navbar:AddMenu( "Entidades", "F4::EntPanel")
        navbar:AddMenu( "Ajuda", "DPanel")
        navbar:AddMenu( "Comandos", "DPanel")
        navbar:SetActive( 1 )

        gui.EnableScreenClicker(true)
    else
        if frame:IsVisible() then
            frame:SetVisible(false)
            gui.EnableScreenClicker(false)
        else
            frame:SetVisible(true)
            gui.EnableScreenClicker(true)
        end
    end

end

-- concommand.Add("f4test", F4GUI)
concommand.Add("open_f4_menu", F4GUI)