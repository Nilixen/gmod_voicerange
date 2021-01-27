// I DO APOLOGISE FOR MY ENGLISH. IT is not my primary language
local c = JNVoiceMod.Config

c.Language = "EN-en"

-- IN GMOD UNITS.
c.WhisperDistance = 100
c.WhisperColor = Color(50,170,255)
-- IN GMOD UNITS.
c.TalkDistance = 250
c.TalkColor = Color(50,255,50)
-- IN GMOD UNITS.
c.YellDistance = 500
c.YellColor = Color(255,50,50)


if not file.Exists( "jnvm/lang/"..JNVoiceMod.Config.Language..".lua", "LUA" ) then c.Language = "EN-en" end --default to English
if SERVER then AddCSLuaFile("jnvm/lang/"..JNVoiceMod.Config.Language..".lua") end
include("jnvm/lang/"..JNVoiceMod.Config.Language..".lua")
