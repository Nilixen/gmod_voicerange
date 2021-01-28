if SERVER then
    util.AddNetworkString("jnvm_network")

    AddCSLuaFile("jnvm/shared.lua")
    AddCSLuaFile("jnvm/config/config.lua")
    AddCSLuaFile("jnvm/cl_gui.lua")
    AddCSLuaFile("jnvm/cl_fonts.lua")

    include("jnvm/shared.lua")
    include("jnvm/config/config.lua")
    include("jnvm/sv_network.lua")
    include("jnvm/sv_init.lua")

else
    include("jnvm/shared.lua")
    include("jnvm/config/config.lua")
    include("jnvm/cl_gui.lua")
    include("jnvm/cl_fonts.lua")

end
