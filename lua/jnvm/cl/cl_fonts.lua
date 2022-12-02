function JNVoiceMod:CreateFont(name, size, weight)
    surface.CreateFont("JNVoiceMod."..name,{
        font = JNVoiceMod.clgui.font,
        size = size or 16,
        weight = weight or 500,
    })

end