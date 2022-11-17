list.Set( "DesktopWindows", "JNVoiceModConfig", {

	title		= "JNVoiceMod",
	icon		= "icon64/jnvm.png",
	width		= 200,
	height		= 100,
	onewindow	= true,
	init		= function( icon, window )
		window:Close()
		JNVoiceMod:OpenClConfig()
	end
})

JNVoiceMod.ClData = {}


local t = CurTime() + 0.2
hook.Add("Think","JNVoiceMod_ClVolume",function()
	if t >= CurTime() then return end
	t = CurTime() + 0.2
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		local plyMode = 2
		if not v:IsBot() then plyMode = JNVoiceMod.ClData[v:SteamID64()] or 2 end
		local dist = JNVoiceMod.Config.Ranges[plyMode].rng
		//print(math.Clamp((dist*1.5 - LocalPlayer():GetPos():Distance(v:GetPos()))/(dist),0,1))
		v:SetVoiceVolumeScale( math.Clamp((dist*1.5 - LocalPlayer():GetPos():Distance(v:GetPos()))/(dist),0,1) )
		//print(JNVoiceMod.ClData[v:SteamID64()])
	end

end)


//loading cl config
file.CreateDir("jnvm")
if !file.Exists("jnvm/cl_config.txt", "DATA") then
	file.Write( "jnvm/cl_config.txt", util.TableToJSON(JNVoiceMod.ClConfig) )
else
	local conf = util.JSONToTable(file.Read("jnvm/cl_config.txt","DATA"))
	for k,v in pairs(JNVoiceMod.ClConfig) do
		if not conf[k] then
			conf[k] = v
		end
	end
	JNVoiceMod.ClConfig = conf
end

function JNVoiceMod:ClConfigSave()
	file.Write( "jnvm/cl_config.txt", util.TableToJSON(JNVoiceMod.ClConfig) )
end

net.Receive("jnvm_network",function(len)
	local num = net.ReadInt(16)
	if num == 1 then
		local tbl = net.ReadTable()
		JNVoiceMod.Config = tbl
	elseif num == 2 then
		local tbl = net.ReadTable()
		//PrintTable(tbl)
		for k,v in pairs(tbl) do
			JNVoiceMod.ClData[k] = v
		end
	end
end)
concommand.Add("voicerange", function( ply, cmd, args )
	if IsValid(ply) then
		net.Start("jnvm_network")
	  		net.WriteInt(2,16)
		net.SendToServer()
  	end
end )
concommand.Add("jnvmconfigmenu", function( ply, cmd, args )
  if IsValid(ply) then
	 JNVoiceMod:OpenConfigMenu()
  end
end )
concommand.Add("jnvmfixgui", function( ply, cmd, args )
	if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
  end )

// check keybinds
local pressed = false
hook.Add("Think","JNVMBindCheck",function()

	local cache = input.IsButtonDown( JNVoiceMod.ClConfig.Bind )
	if cache and pressed and not LocalPlayer():IsTyping() then
		LocalPlayer():ConCommand("voicerange")
	end
	pressed = not cache
end)
