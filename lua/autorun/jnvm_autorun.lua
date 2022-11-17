if SERVER then
    util.AddNetworkString("jnvm_network")
end

// shared
for _, v in pairs(file.Find("jnvm/sh/*", "LUA")) do
	include("jnvm/sh/" .. v)
	if SERVER then AddCSLuaFile("jnvm/sh/" .. v) end
end

// client
for _, v in pairs(file.Find("jnvm/cl/*", "LUA")) do
	if CLIENT then include("jnvm/cl/" .. v) else AddCSLuaFile("jnvm/cl/" .. v) end
end

// server
if SERVER or game.SinglePlayer() then
	for _, v in pairs(file.Find("jnvm/sv/*", "LUA")) do
		include("jnvm/sv/" .. v)
	end
end

// language
for _, v in pairs(file.Find("jnvm/lang/*", "LUA")) do
	include("jnvm/lang/" .. v)
	if SERVER then AddCSLuaFile("jnvm/lang/" .. v) end
end

