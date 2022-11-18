net.Receive("jnvm_network",function(len, ply)
    local num = net.ReadInt(16)
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
        JNVoiceMod:SyncPlayersData(1,ply)
    end
end)

function JNVoiceMod:SyncPlayersData(num,ply)
     
    if num == 1 then
        local tbl = {}
        tbl[ply:SteamID64()] = ply:GetNWInt("JNVoiceModDist",1)
        net.Start("jnvm_network")
            net.WriteInt(2,16)
            net.WriteTable(tbl)
        net.Broadcast()
        //print(ply:Name().." broadcasted")
    elseif num == 2 then
        local tbl = {}
        for k,v in pairs(player.GetAll()) do
            tbl[v:SteamID64()] = v:GetNWInt("JNVoiceModDist",1)
        end
        net.Start("jnvm_network")
            net.WriteInt(2,16)
            net.WriteTable(tbl)
        net.Send(ply)
        //print("sent to "..ply:Name())
    end

end


