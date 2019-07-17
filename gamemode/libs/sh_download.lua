-- /*---------------------------------------------------------------------------
-- 	Attempts to download a file into the data folder, or retrieve it
-- 	if it does not exist already. Used for icons and stuff.
-- ---------------------------------------------------------------------------*/
-- AwDownload = function(filename, url, callback, errorCallback)
-- 	local path = "threebow/downloads/"..filename
-- 	local dPath = "data/"..path

-- 	if(file.Exists(path, "DATA")) then return callback(dPath) end
-- 	if(!file.IsDir(string.GetPathFromFilename(path), "DATA")) then file.CreateDir(string.GetPathFromFilename(path)) end

-- 	errorCallback = errorCallback || function(reason)
-- 		error("Threebow Lib: File download failed ("..url..") ("..reason..")")
-- 	end
       
-- 	http.Fetch(url, function(body, size, headers, code)
-- 		if(code != 200) then return errorCallback(code) end
-- 		file.Write(path, body)
-- 		callback(dPath)
-- 	end, errorCallback)
-- end