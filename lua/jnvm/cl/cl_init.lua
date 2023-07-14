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

local t = CurTime() + 0.1
hook.Add("Think","JNVoiceMod_ClVolume",function()

	if t >= CurTime() then return end
	t = CurTime() + 0.1
	if !JNVoiceMod.Config.GlobalVoice then
		for k,v in pairs(player.GetAll()) do

			if v == LocalPlayer() then continue end

			// sound fading
			if not tobool(v:GetNWInt("JNVoiceModRadio",0)) then
				local plyMode
				if v:IsBot() then return end
				plyMode = v:GetNWInt("JNVoiceModDist",2)
				local dist = JNVoiceMod.Config.Ranges[plyMode].rng
				v:SetVoiceVolumeScale( math.Clamp((dist*1.5 - LocalPlayer():GetPos():Distance(v:GetPos()))/(dist),0,1) )
			else
				local radioType = v:GetNWInt("JNVoiceModRadio")
				local freqs = util.JSONToTable(v:GetNWString("JNVoiceModFreq","[]"))
				local freq = (radioType == 1 and (freqs.main.freq or freqs.main.channel) or radioType == 2 and (freqs.add.freq or freqs.add.channel))	// frequency player is talking on to
				
				local LocalPlayerFreqs = util.JSONToTable(LocalPlayer():GetNWString("JNVoiceModFreq","[]"))
				for k2,v2 in pairs(LocalPlayerFreqs) do
					if v2.freq == freq or v2.channel == freq then
						if k2 == "main" then
							v:SetVoiceVolumeScale( JNVoiceMod.ClConfig.RadioVCMain )
						elseif k2 == "add" then
							v:SetVoiceVolumeScale( JNVoiceMod.ClConfig.RadioVCAdd )
						end
					end
				end

			end
			
		end
	else
		v:SetVoiceVolumeScale( 1 )
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

	LocalPlayer():SetNWBool("JNVoiceModRadioEnabled",not LocalPlayer():GetNWBool("JNVoiceModRadioEnabled",false)) // force set cuz might be networking lag and without it it will result in flipped sounds
	JNVoiceMod:ToggleRadioSound(ply)

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

// open client menu
concommand.Add("jnvmconfig", function( ply, cmd, args )
	if IsValid(ply) then
		JNVoiceMod:OpenClConfig()
	end
end )


// fix gui by closing jnvm frame
concommand.Add("jnvmfixgui", function( ply, cmd, args )
	if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
end)

// check keybinds

local function radioTX(channel,bool)
	JNVoiceMod:playTXRXSound(LocalPlayer())
	net.Start("jnvm_network")
		net.WriteInt(3,5)
		net.WriteBool(bool)
		net.WriteBool(channel)
	net.SendToServer()
end

local pressedMode,onRadio,toggleRadio = false,false,false
hook.Add("Think","JNVMBindCheck",function()
	if LocalPlayer():IsTyping() then return end

	local vcRangeBind = input.IsButtonDown( JNVoiceMod.ClConfig.Bind )
	if vcRangeBind and pressedMode then
		LocalPlayer():ConCommand("voicerange")
	end
	pressedMode = not vcRangeBind
	
	// detect radio bind and play sounds

	local hasRadio = JNVoiceMod:WhichRadio(LocalPlayer())
	local radioMainBindPressed = (input.IsButtonDown(JNVoiceMod.ClConfig.BindRadioMain) and hasRadio > 0)
	local radioAddBindPressed = (input.IsButtonDown(JNVoiceMod.ClConfig.BindRadioAdd) and hasRadio == 1)	// hasRadio == 1 due to checking process... please look at JNVM:HasRadio(ply) function in sh_init.lua file
	
	local radioChannel = false	// false = main, true = additional
	if radioMainBindPressed then radioChannel = false elseif radioAddBindPressed then radioChannel = true end

	if (radioMainBindPressed or radioAddBindPressed) and onRadio == false and LocalPlayer():GetNWBool("JNVoiceModRadioEnabled",false) then
		onRadio = true

		permissions.EnableVoiceChat( true )
		LocalPlayer():SetNWInt("JNVoiceModRadio",(not radioChannel and 1 or 2))	// force set cuz there might be networking lag and without it it will result in flipped sounds
		radioTX(radioChannel,true)
	elseif (not (radioMainBindPressed or radioAddBindPressed) and onRadio) or (not LocalPlayer():GetNWBool("JNVoiceModRadioEnabled",false) and onRadio) then 
		onRadio = false

		permissions.EnableVoiceChat( false )
		LocalPlayer():SetNWInt("JNVoiceModRadio",0)	// force set cuz there might be networking lag and without it it will result in flipped sounds
		radioTX(radioChannel,false)
	end

	// toggle radio bind and play sound
	if tobool(JNVoiceMod:WhichRadio(LocalPlayer())) then
		local radioToggleBindPressed = input.IsButtonDown(JNVoiceMod.ClConfig.BindToggleRadio)
		if radioToggleBindPressed and toggleRadio then
			LocalPlayer():ConCommand("jnvmradiotoggle")
		end
		toggleRadio = not radioToggleBindPressed
	end
end)

JNVoiceMod.radioUsers = {}

hook.Add("PlayerStartVoice", "JNVoiceModRadioUsersHUD", function(ply)
	if tobool(ply:GetNWInt("JNVoiceModRadio",0)) then
		table.insert(JNVoiceMod.radioUsers,1,{sid = ply:SteamID64(), radio = ply:GetNWInt("JNVoiceModRadio",0)})
		JNVoiceMod:playTXRXSound(ply)
	end	
end)

hook.Add("PlayerEndVoice", "JNVoiceModRadioUsersHUD", function(ply)
	for k,v in pairs(JNVoiceMod.radioUsers) do
		if v.sid == ply:SteamID64() then
			JNVoiceMod.radioUsers[k] = nil
			JNVoiceMod:playTXRXSound(ply)
		end
	end
end)

