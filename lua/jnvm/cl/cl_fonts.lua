function JNVoiceMod:CreateFont(name, size, light, weight)
    
    if not light then
        surface.CreateFont("JNVoiceMod."..name,{
            font = JNVoiceMod.clgui.font,
            size = size or 16,
            weight = weight or 500,

        })
    else
        surface.CreateFont("JNVoiceMod."..name,{
            font = JNVoiceMod.clgui.fontlight,
            size = size or 16,
            weight = weight or 500,

        })
    end

end