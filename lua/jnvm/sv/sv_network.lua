net.Receive("jnvm_network",function(len, ply)
    local num = net.ReadInt(5)
    if num == 1 then
        if not ply:IsSuperAdmin() then ply:ChatPrint("YOU'RE NOT AUTHORIZED TO DO THAT!") return end
        local whisper = net.ReadInt(16)
        local talk = net.ReadInt(16)
        local yell = net.ReadInt(16)
        local lang = net.ReadString()
        local globalvoice = net.ReadBool()

        JNVoiceMod.Config.Ranges[1].rng = whisper
        JNVoiceMod.Config.Ranges[2].rng = talk
        JNVoiceMod.Config.Ranges[3].rng = yell
        JNVoiceMod.Config.Language = ((JNVoiceMod.Lang[lang] and lang) or "EN-en")
        JNVoiceMod.Config.GlobalVoice = globalvoice

        JNVoiceMod:SaveConfig()
        JNVoiceMod:SynchronizeConfig()
        ply:ChatPrint("Config saved!")
    elseif num == 2 then
        ply:SetNWInt("JNVoiceModDist",ply:GetNWInt("JNVoiceModDist",0)+1)
        if ply:GetNWInt("JNVoiceModDist") > 3 then
            ply:SetNWInt("JNVoiceModDist",1)
        end
        
    elseif num == 3 then    // talking on radio
        local bool = net.ReadBool()
        if not ply:HasWeapon("jnvm_radio") then return end
        if bool then
            ply.JNVMLastMode = ply:GetNWInt("JNVoiceModDist")
            ply:SetNWInt("JNVoiceModDist",1)
        else
            local lastMode = ply.JNVMLastMode or 2
            ply:SetNWInt("JNVoiceModDist",lastMode)
        end
        ply:SetNWBool("JNVoiceModRadio",bool)
    elseif num == 4 then
        local config = JNVoiceMod.Config
        local freq = net.ReadFloat()
        freq = math.Round(freq,1)
        if freq >= config.FreqRange.min and freq <= config.FreqRange.max then
            ply:SetNWString("JNVoiceModFreq", tostring(freq))
        end
    end
end)


--[[
    networked values:
        string JNVoiceModFreq - players current frequency or earlier defined channel
        int JNVoiceModDist - id from config.ranges defines distance
        bool JNVoiceModRadio - if ply is using radio in that moment
]]--