
function AwArc(x, y, ang, p, rad, color, seg, CircleName)
    seg = seg or 80
    ang = (-ang) + 180
    local circle = {}

    table.insert(circle, {x = x, y = y})
    for i = 0, seg do
        local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {x = x + math.sin(a) * rad, y = y + math.cos(a) * rad})
	end
	Circle = {}
	Circle[CircleName] = circle[#circle]
	-- print(  )
    surface.SetDrawColor(color)
    draw.NoTexture()
	surface.DrawPoly(circle)
	
end












































