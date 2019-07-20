-- /*---------------------------------------------------------------------------
-- 	Fetches the persons avatar URL from steam api and materializes it so
-- 	we can draw it without using AvatarImage.
-- ---------------------------------------------------------------------------*/
-- hook.Add("InitPostEntity", "SpectreHUD", function()
-- 	if LocalPlayer():SteamID64() == "1234567890" then 
-- 		steamid = "76561198119350635" 
-- 	else
-- 		steamid = LocalPlayer():SteamID64()
-- 	end
-- 	http.Fetch("https://licensing.threebow.com/api/avatar/"..steamid, function(body)
-- 		local response = util.JSONToTable(body)

-- 		if(response.success) then
-- 			AwDownload("spectre/avatar"..util.CRC(response.data).."."..string.GetExtensionFromFilename(response.data), response.data, function(path)												// 76561198091747423
-- 				AwMaterialAvatar = Material(path, "unlitgeneric")
-- 			end)
-- 		else
-- 			error("[Spectre HUD] "..response.error.." - Please contact support.")
-- 		end
-- 	end, function()
-- 		error("[Spectre HUD] Avatar server is down. Please contact support.")
-- 	end)
-- end)
awcache = {}
awcache.ImageLoader = {}
awcache.AvatarLoader = {}
awcache.ImageLoader.CachedMaterials = {}
awcache.AvatarLoader.CachedMaterials = {}
awcache.UI = {}
awcache.UI.Elements = {}
awcache.UI.Materials = {
	refresh = Material("error"),
	loading = Material("error")
}
function awcache.ImageLoader.GetMaterial(id, callback)
	--First check if the ID is cached
	if awcache.ImageLoader.CachedMaterials[id] ~= nil then
		print("Image already loaded, returning material")
		callback(awcache.ImageLoader.CachedMaterials[id])
	else
		--Now check if we have that material file, if so load it as a material and return it
		if file.Exists("awcache/"..id..".png", "DATA") then
			print("File found, loading material then returning")
			--It does exists, so we create the material
			awcache.ImageLoader.CachedMaterials[id] = Material("data/awcache/"..id..".png", "noclamp smooth")
			callback(awcache.ImageLoader.CachedMaterials[id])
		else
			print("Failed to find image, attempting to load")
			--So the file does not exist, so we need to load it, cache it then return the callback
				http.Fetch("https://i.imgur.com/"..id..".png",function(body)
					print("Loaded Imgur Image : "..id..",png")
					file.Write("awcache/"..id..".png", body)
					awcache.ImageLoader.CachedMaterials[id] = Material("data/awcache/"..id..".png", "noclamp smooth")
					callback(awcache.ImageLoader.CachedMaterials[id])
				end, function()
					callback(false)
				end) -- do fetch
		end
	end
end

function awcache.AvatarLoader.GetMaterial(id, callback)
	--First check if the ID is cached
	if awcache.AvatarLoader.CachedMaterials[id] ~= nil then
		-- print("Avatar already loaded, returning material")
		callback(awcache.AvatarLoader.CachedMaterials[id])
	else
		--Now check if we have that material file, if so load it as a material and return it
		if file.Exists("awavatar/"..id..".jpg", "DATA") then
			-- print("File found, loading material then returning")
			--It does exists, so we create the material
			awcache.AvatarLoader.CachedMaterials[id] = Material("data/awavatar/"..id..".jpg", "noclamp smooth")
			callback(awcache.AvatarLoader.CachedMaterials[id])
		else
			-- print("Failed to find Avatar, attempting to load")
			--So the file does not exist, so we need to load it, cache it then return the callback
				http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=7B8469B0AB74264A698A6A9F7C75A6E4&steamids=".. id ,function(body)
					-- print("API FETCHED : "..id..",jpg")
					-- print("FetchedURL = http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=7B8469B0AB74264A698A6A9F7C75A6E4&steamids=".. id )
					local json = util.JSONToTable(body)
					local player = json.response.players[1]

					if not player.steamid then error("[Avatar Download] Wrong SteamID", 1 ) end

					http.Fetch( player.avatarfull, function(body)
						-- print("Loaded Avatar Image : ".. player.avatarfull)
						file.Write("awavatar/"..id..".jpg", body)
						awcache.AvatarLoader.CachedMaterials[id] = Material("data/awavatar/"..id..".jpg", "noclamp smooth")
						callback(awcache.AvatarLoader.CachedMaterials[id])
					end, function()
						callback(false)
					end) -- do fetch

				end, function()
					error("[Avatar Download] API Offline", 1 ) 
				end) -- do fetch
		end
	end
end


awcache.ImageLoader.GetMaterial("VToHU94", function(mat)
	awcache.UI.Materials.ruby = mat
end)

awcache.ImageLoader.GetMaterial("k2HOhi3", function(mat)
	awcache.UI.Materials.safira = mat
end)

awcache.ImageLoader.GetMaterial("YKAINuo", function(mat)
	awcache.UI.Materials.ametista = mat
end)

awcache.ImageLoader.GetMaterial("U9mYfWV", function(mat)
	awcache.UI.Materials.topazio = mat
end)

awcache.ImageLoader.GetMaterial("rGOfzhd", function(mat)
	awcache.UI.Materials.aim = mat
end)

awcache.ImageLoader.GetMaterial("zCx6wL5", function(mat)
	awcache.UI.Materials.gunlicense = mat
end)

