JNVoiceMod = JNVoiceMod or {}
JNVoiceMod.Config = JNVoiceMod.Config or {}
JNVoiceMod.Lang = JNVoiceMod.Lang or {}

function JNVoiceMod:GetPhrase(name,ply,...)

	if CLIENT then
		if JNVoiceMod.Lang[JNVoiceMod.ClConfig.Lang or "EN-en"][name] then
    		return string.format(JNVoiceMod.Lang[JNVoiceMod.ClConfig.Lang or "EN-en"][name],...) 
		else
			return name
		end
	else
		if JNVoiceMod.Lang[JNVoiceMod.Config.Language or "EN-en"][name] then
			return string.format(JNVoiceMod.Lang[JNVoiceMod.Config.Language or "EN-en"][name],...) 
		else
			return name
		end
	end
end

local function playSound(ply)

    local bool = ply:GetNWBool("JNVoiceModRadioEnabled") 
    if bool then
        local radioSoundEffect = CreateSound(ply,"jnvm/local_start.wav")
        radioSoundEffect:PlayEx(1,100)
    else
        local radioSoundEffect = CreateSound(ply,"jnvm/local_end.wav")
        radioSoundEffect:PlayEx(1,100)
    end

end

function JNVoiceMod:ToggleRadioSound(ply)

    if JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers then
        if SERVER then
            playSound(ply)
        end
    else
        if CLIENT then
            playSound(ply)
        end
    end

end


// todo
// finish gui for creating new frequencies
// add a function to give a frequency to certain person (option to be permanent even death)
// remove custom frequencies on death
// create value for selected freqs (main and add)
// create keybind in gui for toggle radio shortcut
// language...