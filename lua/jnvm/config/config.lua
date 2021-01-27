

JNVoiceMod.Config.Language = "PL-pl"


JNVoiceMod.Config.WhisperDistance = 100
JNVoiceMod.Config.WhisperColor = Color(50,170,255)

JNVoiceMod.Config.TalkDistance = 250
JNVoiceMod.Config.TalkColor = Color(50,255,50)

JNVoiceMod.Config.YellDistance = 500
JNVoiceMod.Config.YellColor = Color(255,50,50)


if not file.Exists( "jnvm/lang/"..JNVoiceMod.Config.Language..".lua", "LUA" ) then JNVoiceMod.Config.Language = "EN-en" end
if SERVER then AddCSLuaFile("jnvm/lang/"..JNVoiceMod.Config.Language..".lua") end
include("jnvm/lang/"..JNVoiceMod.Config.Language..".lua")
