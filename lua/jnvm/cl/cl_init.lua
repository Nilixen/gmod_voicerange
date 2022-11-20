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

local t = CurTime() + 0.2
hook.Add("Think","JNVoiceMod_ClVolume",function()

	if t >= CurTime() then return end
	t = CurTime() + 0.2

	for k,v in pairs(player.GetAll()) do

		if v == LocalPlayer() then continue end

		// sound fading
		if not v:GetNWBool("JNVoiceModRadio") then
			local plyMode
			if not v:IsBot() then plyMode = v:GetNWInt("JNVoiceModDist",2) end
			local dist = JNVoiceMod.Config.Ranges[plyMode].rng
			v:SetVoiceVolumeScale( math.Clamp((dist*1.5 - LocalPlayer():GetPos():Distance(v:GetPos()))/(dist),0,1) )
		else
			v:SetVoiceVolumeScale( JNVoiceMod.ClConfig.RadioLoudness )
		end
		
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

// client networking
net.Receive("jnvm_network",function(len)
	local num = net.ReadInt(5)
	if num == 1 then
		local tbl = net.ReadTable()
		JNVoiceMod.Config = tbl
	end
end)

// Switch voice range
concommand.Add("voicerange", function( ply, cmd, args )
	if IsValid(ply) then
		net.Start("jnvm_network")
	  		net.WriteInt(2,5)
		net.SendToServer()
  	end
end )

// open admin config menu
concommand.Add("jnvmconfigmenu", function( ply, cmd, args )
	if IsValid(ply) then
		JNVoiceMod:OpenConfigMenu()
	end
end )


// fix gui by closing jnvm frame
concommand.Add("jnvmfixgui", function( ply, cmd, args )
	if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
end)


// check keybinds
local pressedMode,pressedRadio = false,false
hook.Add("Think","JNVMBindCheck",function()
	local cache = input.IsButtonDown( JNVoiceMod.ClConfig.Bind )
	if cache and pressedMode and not LocalPlayer():IsTyping() then
		LocalPlayer():ConCommand("voicerange")
	end
	pressedMode = not cache
	
	// detect radio bind and play sounds
	local radioBindPressed = input.IsButtonDown(JNVoiceMod.ClConfig.BindRadio)
	if radioBindPressed and pressedRadio == false then
		pressedRadio = true
		permissions.EnableVoiceChat( true )
		// change sound.play to csoundpatch todo
		sound.Play("items/ammopickup.wav",LocalPlayer():GetPos(),100,100,JNVoiceMod.ClConfig.RadioSounds)		//todo fix those sounds...
		net.Start("jnvm_network")
			net.WriteInt(3,5)
			net.WriteBool(true)
		net.SendToServer()
	elseif not radioBindPressed and pressedRadio then 
		permissions.EnableVoiceChat( false )
		pressedRadio = false
		sound.Play("jnvm/remote_end.wav",LocalPlayer():GetPos(),1,1,JNVoiceMod.ClConfig.RadioSounds)
		net.Start("jnvm_network")
			net.WriteInt(3,5)
			net.WriteBool(false)
		net.SendToServer()
	end



end)
