// it's only default config for client, if the client doesn't have one, it will create a local file in his pc with this preset
JNVoiceMod.ClConfig = JNVoiceMod.ClConfig or {}

JNVoiceMod.ClConfig.TalkAlpha = 0.9
JNVoiceMod.ClConfig.IdleAlpha = 0.15
JNVoiceMod.ClConfig.ChngAlpha = 1
JNVoiceMod.ClConfig.HudEnabled = true
JNVoiceMod.ClConfig.SphereEnabled = true
JNVoiceMod.ClConfig.SphereAlpha = 0.2
JNVoiceMod.ClConfig.Bind = 17 // def G key - https://wiki.facepunch.com/gmod/Enums/KEY
JNVoiceMod.ClConfig.BindRadioMain = 58 // def COMMA key - https://wiki.facepunch.com/gmod/Enums/KEY 
JNVoiceMod.ClConfig.BindRadioAdd = 59 // def PERIOD key - https://wiki.facepunch.com/gmod/Enums/KEY
JNVoiceMod.ClConfig.BindToggleRadio = 60 // def COMMA key - https://wiki.facepunch.com/gmod/Enums/KEY
JNVoiceMod.ClConfig.RadioVCMain = 0.75
JNVoiceMod.ClConfig.RadioVCAdd = 0.75
JNVoiceMod.ClConfig.RadioSounds = 0.2
JNVoiceMod.ClConfig.Lang = "EN-en"
JNVoiceMod.ClConfig.MaxMainPlayersTalking = 5	
JNVoiceMod.ClConfig.MaxAddPlayersTalking = 2

JNVoiceMod.ClConfig.GuiColor = Color(0,200,120)

JNVoiceMod.ClConfig.Ranges = {
	[1] = {color = Color(40,40,40)},
	[2] = {color = Color(40,40,40)},
	[3] = {color = Color(40,40,40)},
}
