

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
