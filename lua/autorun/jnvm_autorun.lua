if SERVER or game.SinglePlayer() then
    util.AddNetworkString("jnvm_network")
	// sh
		AddCSLuaFile("jnvm/sh/sh_init.lua")
		include("jnvm/sh/sh_init.lua")
		AddCSLuaFile("jnvm/sh/sh_config.lua")
		include("jnvm/sh/sh_config.lua")
	// sv
		include("jnvm/sv/sv_init.lua")
		include("jnvm/sv/sv_network.lua")
	// cl
		AddCSLuaFile("jnvm/cl/cl_defconfig.lua")
		AddCSLuaFile("jnvm/cl/cl_init.lua")
		AddCSLuaFile("jnvm/cl/cl_guiconfig.lua")
		AddCSLuaFile("jnvm/cl/cl_fonts.lua")
		AddCSLuaFile("jnvm/cl/cl_gui.lua")
end
if CLIENT then
	// sh
		include("jnvm/sh/sh_init.lua")
		include("jnvm/sh/sh_config.lua")
	//cl
		include("jnvm/cl/cl_defconfig.lua")
		include("jnvm/cl/cl_init.lua")
		include("jnvm/cl/cl_guiconfig.lua")
		include("jnvm/cl/cl_fonts.lua")
		include("jnvm/cl/cl_gui.lua")
end


// language
for _, v in pairs(file.Find("jnvm/lang/*", "LUA")) do
	include("jnvm/lang/" .. v)
	if SERVER then AddCSLuaFile("jnvm/lang/" .. v) end
end

