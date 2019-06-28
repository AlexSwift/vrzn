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
                running = true
                local w, h = scrW * 0.35, 28
                local x, y = (scrW * 0.5) - (w * 0.5), (scrH * 0.725) - (h * 0.5)

                surface.SetDrawColor(35, 35, 35, 255)
                -- surface.DrawRect(x, y, w, h)
                draw.RoundedBox(8, x, y, w, h, Color(35, 35, 35, 255) )

                surface.SetDrawColor(0, 0, 0, 120)
                -- surface.DrawOutlinedRect(x, y, w, h)
                draw.RoundedBox(8, x, y, w, h, Color(0, 0, 0, 255) )

                surface.SetDrawColor( 0, 0, 0, 255 )
                -- surface.DrawRect(x + 4, y + 4, (w * fraction) - 8, h - 8)
                draw.RoundedBox(8, x+4, y+4,  (w * fraction) - 8, h - 8, Color( 26,26,26,255 ) )

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
function AWRemoveTimeCountdown()
    hook.Remove("HUDPaint", "AWESOME::TimeCountdown")
    LocalPlayer():ChatPrint("Removido")
end
-----------------------------
---@ Awesome Derma/Client LIB
---@ Author: Nodge
---@ Desenha um arco vazado, baseado na hud do DayZ
-----------------------------

function drawArc( x, y, radius, thickness, start, endp )
	local outcir = {}
	local incir = {}

	local start = math.floor(start)
	local endp = math.floor(endp)


	if (start>endp) then
		local swap = endp
		endp = start
		start = swap
	end

	local inr = radius - thickness
	for i = start, endp do
		local a = math.rad(i)
		table.insert(incir, {x = x+(math.cos(a))*inr, y = y+(-math.sin(a))*inr})
	end

	for i = start, endp do
		local a = math.rad(i)
		table.insert(outcir, {x = x+(math.cos(a))*radius, y = y+(-math.sin(a))*radius})
	end
	
	local comcir = {}
	for i=0,#incir*2 do
		local p,q,r
		p = outcir[math.floor(i/2)+1]
		r = incir[math.floor((i+1)/2)+1]
		if (i%2) == 0 then
			q = outcir[math.floor((i+1)/2)]
		else
			q = incir[math.floor((i+1)/2)]
		end
		table.insert(comcir, {p,q,r})
	end

	for k,v in ipairs(comcir) do
		surface.DrawPoly(v)
	end

end

function ToNumber(arg, arg2, max)
	finished = arg/max*arg2
	return finished
end
function drawCircle( x, y, radius )
	local cir = {}
	local seg = 100
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end
