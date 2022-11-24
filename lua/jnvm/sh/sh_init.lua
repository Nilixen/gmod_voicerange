JNVoiceMod = JNVoiceMod or {}
JNVoiceMod.Config = JNVoiceMod.Config or {}
JNVoiceMod.Lang = JNVoiceMod.Lang or {}

function JNVoiceMod:GetPhrase(name,ply,...) // language

	if CLIENT then
		if JNVoiceMod.Lang[JNVoiceMod.ClConfig.Lang or "EN-en"][name] then
    		return string.format(JNVoiceMod.Lang[JNVoiceMod.ClConfig.Lang or "EN-en"][name],...) 
		else
			return name
		end
	else
		if JNVoiceMod.Lang[JNVoiceMod.Config.Language or "EN-en"][name] then
			return string.format(JNVoiceMod.Lang[JNVoiceMod.Config.Language or "EN-en"][name],...) 
		else
			return name
		end
	end
end

function JNVoiceMod:WhichRadio(ply)
    if not ply:IsValid() then return 0 end
    if not ply:IsPlayer() then return 0 end
    local radios = {"jnvm_radioadvanced","jnvm_radiobasic"}
    for k,v in pairs(radios) do
        if ply:HasWeapon(v) then return k end
    end
    return 0
end


local function playToggleSound(ply,volume,ent,filter)       // radio toggle sound
    local bool = ply:GetNWBool("JNVoiceModRadioEnabled") 
    local radioSoundEffect = nil
    local sound = ""
    if bool then sound = "jnvm/local_start.wav" else sound = "jnvm/local_end.wav" end
    if filter then radioSoundEffect = CreateSound(ent,sound,filter) else radioSoundEffect = CreateSound(ent,sound) end
    radioSoundEffect:PlayEx(volume,100)
end
function JNVoiceMod:ToggleRadioSound(ply,ent)       
    local target = ent or ply

    if JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers then
        if SERVER then
            local filter = RecipientFilter()
            filter:AddPAS(target:GetPos())
            filter:RemovePlayer(ply)
            playToggleSound(ply,0.2,target,filter)
        end
    end
    if CLIENT then
        playToggleSound(ply,JNVoiceMod.ClConfig.RadioSounds,target)
    end
end

local function playTalkSound(ply,volume,ent,filter)   // ply is what sound to play, ent where to play it, filter ( only serverside! )...

    local num = ply:GetNWInt("JNVoiceModRadio",0)
    local radioSoundEffect = nil
    local sound = ""
    if num > 0 then sound = "jnvm/remote_start.wav" else sound = "jnvm/remote_end.wav" end
    if filter then radioSoundEffect = CreateSound(ent,sound,filter) else radioSoundEffect = CreateSound(ent,sound) end
    radioSoundEffect:PlayEx(volume,100)
end
function JNVoiceMod:playTXRXSound(ply,ent)
    local target = ent or ply
    if JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers then
        if SERVER then
            local filter = RecipientFilter()
            filter:AddPAS(target:GetPos())
            filter:RemovePlayer(ply)
            playTalkSound(ply,0.1,target,filter)

        end
    end
    if CLIENT then
        playTalkSound(ply,JNVoiceMod.ClConfig.RadioSounds,target)
    end
end


// todo
// jammer?
// hud
// add a function to give a frequency to certain person (option to be permanent even death)
// remove custom frequencies on death
// create value for selected freqs (main and add)
// main function 
// get/set functions for external use
// cleanup
// language...