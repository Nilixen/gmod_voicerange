net.Receive("jnvm_network",function(len, ply)
    local num = net.ReadInt(5)
    if num == 1 then
        if not ply:IsSuperAdmin() then ply:ChatPrint("YOU'RE NOT AUTHORIZED TO DO THAT!") return end
        local whisper = net.ReadInt(16)
        local talk = net.ReadInt(16)
        local yell = net.ReadInt(16)
        local lang = net.ReadString()
        local globalvoice = net.ReadBool()
        local radioSounds = net.ReadBool()
        local freqs = net.ReadTable()

        JNVoiceMod.Config.Ranges[1].rng = whisper
        JNVoiceMod.Config.Ranges[2].rng = talk
        JNVoiceMod.Config.Ranges[3].rng = yell
        JNVoiceMod.Config.Language = ((JNVoiceMod.Lang[lang] and lang) or "EN-en")
        JNVoiceMod.Config.GlobalVoice = globalvoice
        JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers = radioSounds
        JNVoiceMod.Config.DefinedFreq = freqs

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
        local channel = net.ReadBool()
        if not tobool(JNVoiceMod:WhichRadio(ply)) and not ply:GetNWBool("JNVoiceModRadioEnabled",false) then return end
        if bool then
            ply.JNVMLastMode = ply:GetNWInt("JNVoiceModDist")
            ply:SetNWInt("JNVoiceModDist",1)
            ply:SetNWInt("JNVoiceModRadio",(not channel and 1 or 2))
            JNVoiceMod:playTXRXSound(ply)
        else
            local lastMode = ply.JNVMLastMode or 2
            ply:SetNWInt("JNVoiceModDist",lastMode)
            ply:SetNWInt("JNVoiceModRadio",0)
            JNVoiceMod:playTXRXSound(ply)
        end
    elseif num == 4 then    // toggle radio on/off
        
        JNVoiceMod:ForceRadio(ply)
        
    elseif num == 5 then    // select frequency todo new freq is json table string
        local tbl = net.ReadTable()
        for k,v in pairs(tbl) do
            if v.freq then
                v.freq = math.Clamp(math.Round(v.freq,1),JNVoiceMod.Config.FreqRange.min,JNVoiceMod.Config.FreqRange.max)
            end
        end
        ply:SetNWString("JNVoiceModFreq",util.TableToJSON(tbl))
    end
end)


--[[
    networked values:
        string json JNVoiceModFreq - players current frequency or earlier defined channel
        string json JNVoiceModChannels - available channels
        int JNVoiceModDist - id from config.ranges defines distance
        int JNVoiceModRadio - is equal to radio channel (0 = off; 1 = main channel; 2 = additional channel)
        bool JNVoiceModRadioEnabled - radio enabled on/off
    hooks:
        todo if needed 
]]--