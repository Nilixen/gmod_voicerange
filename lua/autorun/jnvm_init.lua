if SERVER then
    util.AddNetworkString("jnvm_network")

    AddCSLuaFile("jnvm/shared.lua")
    AddCSLuaFile("jnvm/config/defconfig.lua")
    AddCSLuaFile("jnvm/config/cldefconfig.lua")
    AddCSLuaFile("jnvm/config/clguiconfig.lua")
    AddCSLuaFile("jnvm/cl_init.lua")
    AddCSLuaFile("jnvm/cl_gui.lua")
    AddCSLuaFile("jnvm/cl_fonts.lua")

    include("jnvm/shared.lua")
    include("jnvm/config/defconfig.lua")
    include("jnvm/sv_network.lua")
    include("jnvm/sv_init.lua")
else
    include("jnvm/shared.lua")
    include("jnvm/config/defconfig.lua")
    include("jnvm/config/cldefconfig.lua")
    include("jnvm/config/clguiconfig.lua")
    include("jnvm/cl_init.lua")
    include("jnvm/cl_gui.lua")
    include("jnvm/cl_fonts.lua")

end
