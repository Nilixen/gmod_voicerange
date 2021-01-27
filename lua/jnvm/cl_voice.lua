if CLIENT then
	surface.CreateFont( "voiceMenuFont", {
		font = "Bahnschrift Light", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 35,
		weight = 500,
		blursize = 0,
		scanlines = 1,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	net.Receive("VoiceMenu",function()

	end)
end
