--[[
	Name: cl_properties.lua
	For: SantosRP
	By: Ultra
]]--

GM.Property = (GAMEMODE or GM).Property or {}
GM.Property.DOOR_SEARCH_RANGE = 50
GM.Property.NET_BUY = 0
GM.Property.NET_SELL = 1
GM.Property.NET_SET_TITLE = 2
GM.Property.NET_ADD_FRIEND = 3
GM.Property.NET_REMOVE_FRIEND = 4
GM.Property.NET_SINGLE_UPDATE = 5
GM.Property.NET_FULL_UPDATE = 6
GM.Property.NET_REQUEST_UPD = 7
GM.Property.NET_OPEN_DOOR_MENU = 8

GM.Property.m_colTextColor = Color( 255, 255, 255, 255 )
GM.Property.m_tblProperties = (GAMEMODE or GM).Property.m_tblProperties or {}
GM.Property.m_tblDoorCache = (GAMEMODE or GM).Property.m_tblDoorCache or {}

surface.CreateFont( "SRP_DoorFont", {size = 142, weight = 400, font = "Montserrat Bold"} )
surface.CreateFont( "SRP_DoorSubFont", {size = 96, weight = 400, font = "Montserrat Regular"} )

function GM.Property:LoadProperties()
	GM:PrintDebug( 0, "->LOADING PROPERTIES" )

	local map = game.GetMap():gsub(".bsp", "")
	local path = GM.Config.GAMEMODE_PATH.. "maps/".. map.. "/properties/"

	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
	end

	GM:PrintDebug( 0, "->PROPERTIES LOADED" )
end

function GM.Property:Register( tblProp )
	tblProp.ID = table.Count( self.m_tblProperties ) +1
	self.m_tblProperties[tblProp.Name] = tblProp
end

function GM.Property:GetProperties()
	return self.m_tblProperties
end

function GM.Property:GetPropertyByName( strName )
	return self.m_tblProperties[strName]
end

function GM.Property:GetPropertyByDoor( entDoor )
	if not IsValid( entDoor ) then return end
	return self.m_tblDoorCache[entDoor:EntIndex()]
end

function GM.Property:IsPropertyOwned( strName )
	return IsValid( self:GetPropertyByName(strName).Owner )
end

function GM.Property:GetOwner( strName )
	return self:GetPropertyByName( strName ).Owner
end

function GM.Property:GetPropertiesByOwner( pPlayer )
	local ret = {}
	for name, data in pairs( self.m_tblProperties ) do
		if data.Owner == pPlayer then
			ret[#ret +1] = name
		end
	end

	return ret
end

function GM.Property:ValidProperty( strName )
	return self:GetPropertyByName( strName ) ~= nil
end

function GM.Property:CalculateDoorPositioning( entDoor, bBack )
	local obbCenter = entDoor:OBBCenter()
	local obbMaxs 	= entDoor:OBBMaxs()
	local obbMins 	= entDoor:OBBMins()
	local data 		= {}
	data.endpos 	= entDoor:LocalToWorld( obbCenter )
	data.filter 	= ents.FindInSphere( data.endpos, 20 )
	
	for k, v in pairs( data.filter ) do
		if v == entDoor then
			data.filter[k] = Entity( 0 )
		end
	end
	
	local width = 0
	local length = 0
	
	local size = obbMins -obbMaxs
	size.x = math.abs( size.x )
	size.y = math.abs( size.y )
	size.z = math.abs( size.z )
	
	if size.z < size.x and size.z < size.y then
		width = size.y
		length = size.z
		
		if bBack then
			data.start = data.endpos -entDoor:GetUp() *length
		else
			data.start = data.endpos +entDoor:GetUp() *length
		end
	elseif size.x < size.y then
		width = size.y
		length = size.x
		
		if bBack then
			data.start = data.endpos -entDoor:GetForward() *length
		else
			data.start = data.endpos +entDoor:GetForward() *length
		end
	elseif size.y < size.x then
		width = size.x
		length = size.y
		
		if bBack then
			data.start = data.endpos -entDoor:GetRight() *length
		else
			data.start = data.endpos +entDoor:GetRight() *length
		end
	end
	
    width = math.abs( width )
    local trace = util.TraceLine( data )
     
    if trace.HitWorld and not bBack then
        return self:CalculateDoorPositioning( entDoor, true )
    end
	
	local ang = trace.HitNormal:Angle()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
	
	local pos = trace.HitPos -( (data.endpos -trace.HitPos):Length() *2 ) *trace.HitNormal
	local angBack = trace.HitNormal:Angle()
	
	angBack:RotateAroundAxis( angBack:Forward(), 90 )
	angBack:RotateAroundAxis( angBack:Right(), -90 )
	
	local posBack = trace.HitPos
	return pos, ang, posBack, angBack, width, trace.HitWorld
end

function GM.Property:PaintDoorCard( vecCamPos, entDoor, strModel, bBack )
	local x, y, x2 = 0, 0, 0
	local BOX_WIDTH = 100

	if strModel:find( "double" ) then
		if not bBack then
			x = 390
		else
			x = -390
		end
	end
	if bBack then
		x2 = -BOX_WIDTH
	end
	
	if x2 ~= 0 then x2 = x2 /2 end
	local tw, th = 2048, 1024

	local data = self.m_tblDoorCache[entDoor:EntIndex()]
	local doorName = data.Name
	local doorTitle = entDoor:GetNWString( "title" )
	local ownerName
	if self.m_tblProperties[data.Name].Government then
		doorTitle = "Propriedade do Governo"
	elseif not IsValid( self:GetOwner(doorName) ) then
		doorTitle = "VAGO"
	else
		if doorTitle == "" then doorTitle = "VAGO" end
		ownerName = self:GetOwner( doorName ):Nick()
	end

	surface.SetFont( "SRP_DoorFont" )


	draw.SimpleText(
		doorName,
		"SRP_DoorFont",
		x,
		y,
		self.m_colTextColor,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
	y = y +150
	draw.SimpleText(
		doorTitle,
		"SRP_DoorFont",
		x,
		y,
		Color_White,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
	y = y +150
	if ownerName then
		draw.SimpleText(
			"STAFF: ".. ownerName,
			"SRP_DoorFont",
			x,
			y,
			Color_White,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
end

function GM.Property:PaintDoorText()
	local door = LocalPlayer():GetEyeTrace().Entity
	if not IsValid( door ) or not self.m_tblDoorCache[door:EntIndex()] then return end
	if LocalPlayer():GetPos():DistToSqr( door:GetPos() ) > 16384 then return end

	local pos, ang, posBack, angBack, width, hitWorld = self:CalculateDoorPositioning( door )
	render.SuppressEngineLighting( true )
	cam.Start3D2D( pos, ang, 0.02 )
		self:PaintDoorCard( pos, door, door:GetModel() )
	cam.End3D2D()
	
	cam.Start3D2D( posBack, angBack, 0.02 )
		self:PaintDoorCard( pos, door, door:GetModel(), true )
	cam.End3D2D()
	render.SuppressEngineLighting( false )
end
