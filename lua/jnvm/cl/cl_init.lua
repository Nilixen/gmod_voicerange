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
			if v:IsBot() then return end
			plyMode = v:GetNWInt("JNVoiceModDist",2)
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
	if not IsValid(ply) or not ply:IsPlayer() then return end
	net.Start("jnvm_network")
		net.WriteInt(2,5)
	net.SendToServer()
  	
end )

// Toggle radio on/off
concommand.Add("jnvmradiotoggle",function(ply, cmd, args)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	net.Start("jnvm_network")
		net.WriteInt(4,5)
	net.SendToServer()
end)


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

local function radioTX(channel,bool)
	net.Start("jnvm_network")
		net.WriteInt(3,5)
		net.WriteBool(bool)
		net.WriteBool(channel)
	net.SendToServer()
end

local function playSound(bool)
	if JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers then return end	// check if sound is only client side. Serverside is in sv_network.lua
	if bool then
		local radioSoundEffect = CreateSound(LocalPlayer(),"jnvm/remote_start.wav")
		radioSoundEffect:PlayEx(JNVoiceMod.ClConfig.RadioSounds,100)
	else
		local radioSoundEffect = CreateSound(LocalPlayer(),"jnvm/remote_end.wav")
		radioSoundEffect:PlayEx(JNVoiceMod.ClConfig.RadioSounds,100)
	end
end


local pressedMode,pressedRadio,toggleRadio = false,false,false
hook.Add("Think","JNVMBindCheck",function()
	if LocalPlayer():IsTyping() then return end

	local cache = input.IsButtonDown( JNVoiceMod.ClConfig.Bind )
	if cache and pressedMode then
		LocalPlayer():ConCommand("voicerange")
	end
	pressedMode = not cache
	
	// detect radio bind and play sounds
	if LocalPlayer():HasWeapon("jnvm_radio") and LocalPlayer():GetNWBool("JNVoiceModRadioEnabled",false) then // works only if player has radio and its enabled

		local radioMainBindPressed = input.IsButtonDown(JNVoiceMod.ClConfig.BindRadioMain)
		local radioAddBindPressed = input.IsButtonDown(JNVoiceMod.ClConfig.BindRadioAdd)

		local which = false
		if radioMainBindPressed then
			which = false
		elseif radioAddBindPressed then
			which = true
		end

		if (radioMainBindPressed or radioAddBindPressed) and pressedRadio == false then
			pressedRadio = true
			permissions.EnableVoiceChat( true )
			playSound(true)
			radioTX(which,true)
		elseif not (radioMainBindPressed or radioAddBindPressed) and pressedRadio then 
			permissions.EnableVoiceChat( false )
			pressedRadio = false
			playSound(false)
			radioTX(which,false)
		end
	end

	// toggle radio bind and play sound

	if LocalPlayer():HasWeapon("jnvm_radio") then
		local radioToggleBindPressed = input.IsButtonDown(JNVoiceMod.ClConfig.BindToggleRadio)
		if radioToggleBindPressed and toggleRadio then
			LocalPlayer():ConCommand("jnvmradiotoggle")
		end
		toggleRadio = not radioToggleBindPressed
	end


end)
