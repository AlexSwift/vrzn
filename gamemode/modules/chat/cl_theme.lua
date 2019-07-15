// Create a shell if it doesnt exist
// Failsafe to be able to work independent
Vrzn = Vrzn or {}

// If no theme has been initialized, do this
Vrzn.theme = Vrzn.theme or {}

// DEFAULT THEME
Vrzn.theme.loadDefault = function()
	Vrzn.theme.rem = 16
	Vrzn.theme.round = 8

	Vrzn.theme.bg = Color(26, 26, 26)
	Vrzn.theme.bgAlternative = Color(19,19,19)
	Vrzn.theme.txt = Color(255, 255, 255)
	Vrzn.theme.txtAlternative = Color(98, 106, 122)
	Vrzn.theme.red = Color(230, 93, 80)
	Vrzn.theme.green = Color(0, 255, 78)
	Vrzn.theme.blue = Color(80, 180, 230)
	Vrzn.theme.yellow = Color(135, 94, 46)
end
Vrzn.theme.loadDefault();

// Read custom theme
local fileName = "Vrzn/theme.txt"
if file.Exists(fileName, "DATA") then
	table.Merge(Vrzn.theme, util.JSONToTable(file.Read(fileName, "DATA")))
end

// Create transparency function
function Vrzn.theme:Transparency(colour, opacity)
	return Color(colour.r, colour.g, colour.b, opacity*255)
end

// Overwrite global fonts for Vrzn
if CLIENT then
	// hud description font tags
	surface.CreateFont("Description", {
		font = "Open Sans",
		size = .9*Vrzn.theme.rem,
		weight = 400,
		antialias = true,
	})

	// chat font
	surface.CreateFont("ChatFont", {
		font = "Open Sans",
		size = 1.25*Vrzn.theme.rem,
		weight = 700,
		antialias = true,
	})

	surface.CreateFont("FontTitle", {
		font = "Open Sans",
		size = 2.25*Vrzn.theme.rem,
		weight = 300,
		antialias = true,
	})

	surface.CreateFont("FontHeader", {
		font = "Open Sans",
		size = 1.375*Vrzn.theme.rem,
		weight = 300,
		antialias = true,
	})

	surface.CreateFont("FontSub", {
		font = "Open Sans",
		size = Vrzn.theme.rem,
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("FontSubBold", {
		font = "Open Sans",
		size = Vrzn.theme.rem,
		weight = 700,
		antialias = true,
	})
end

print("Vrzn theme initialization complete");