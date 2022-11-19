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
