-----------------------------
---@ Awesome Derma/Client LIB
---@ Author: Nodge
---@ Função de tempo removida da lib MRP
-----------------------------
function AWDrawTimeCountdown( Initial, Final, Colour)
    hook.Add("HUDPaint", "AWESOME::TimeCountdown", function()
        local start, finish = Initial, Final
        local curTime = CurTime()
        local scrW, scrH = ScrW(), ScrH()

        if finish > curTime then
            local fraction = 1 - math.TimeFraction(start, finish, curTime)
            local alpha = fraction * 255

            if alpha > 0 then
                local w, h = scrW * 0.35, 28
                local x, y = (scrW * 0.5) - (w * 0.5), (scrH * 0.725) - (h * 0.5)

                surface.SetDrawColor(35, 35, 35, 100)
                -- surface.DrawRect(x, y, w, h)
                draw.RoundedBox(8, x, y, w, h, Color(35, 35, 35, 100) )

                surface.SetDrawColor(0, 0, 0, 120)
                -- surface.DrawOutlinedRect(x, y, w, h)
                draw.RoundedBox(8, x, y, w, h, Color(0, 0, 0, 120) )

                surface.SetDrawColor( 0, 0, 0, 100 )
                -- surface.DrawRect(x + 4, y + 4, (w * fraction) - 8, h - 8)
                draw.RoundedBox(8, x+4, y+4,  (w * fraction) - 8, h - 8, Color( 0, 0, 0, 100 ) )

                -- surface.SetDrawColor( Color.r, Color.g, Color.b, Color.a )
                -- surface.DrawRect(x + 4, y + 4, (w * fraction) - 8, h - 8)
                draw.RoundedBox(8, x + 4,y  + 4,  (w * fraction) - 8, h - 8, Colour)

                surface.SetFont("MRP_ActionText")
                local boxX, boxY = scrW / 2, scrH * 0.1


                -- draw.SimpleText("Tempo Restante", "PropProtectFont", x + 2, y - 22, color_black)
                draw.SimpleText("Tempo Restante", "PropProtectFont", x, y - 24, color_white)

                local remainingTime = string.FormattedTime(math.max(finish - curTime, 0), "%02i:%02i:%02i")
                -- draw.SimpleText(remainingTime, "PropProtectFont", x + w, y - 22, color_black, TEXT_ALIGN_RIGHT)
                draw.SimpleText(remainingTime, "PropProtectFont", x + w, y - 24, color_white, TEXT_ALIGN_RIGHT)
            end
        end
    end)
end
