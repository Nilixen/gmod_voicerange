JNVoiceMod = {}
JNVoiceMod.Config = JNVoiceMod.Config or {}
JNVoiceMod.Config.Lang = JNVoiceMod.Config.Lang or {}


if SERVER then
  print("╔════════════════════════╗")
  print(" JimNil VoiceMod LOADED! ")
  print("╚════════════════════════╝")
  include("jnvm/config/config.lua")
  include("jnvm/config/"..JNVoiceMod.Config.Language..".lua")
  include("jnvm/sv_voice.lua")

  AddCSLuaFile("jnvm/config/config.lua")
  AddCSLuaFile("jnvm/config/"..JNVoiceMod.Config.Language..".lua")
  AddCSLuaFile("jnvm/cl_voice.lua")

end
if CLIENT then
  print("╔════════════════════════╗")
  print(" JimNil VoiceMod LOADED! ")
  print("╚════════════════════════╝")
  include("jnvm/config/config.lua")
  include("jnvm/config/"..JNVoiceMod.Config.Language..".lua")
  include("jnvm/cl_voice.lua")

end
