
// create config directory
file.CreateDir(JNVoiceMod.FileDir)

// create function to load shared config, load it and sync with players
    // save config
function JNVoiceMod:SaveConfig()
    file.Write( self.FileDir.."settings.txt", util.TableToJSON(self.Config) )
end

    // load config
function JNVoiceMod:LoadConfig()
    if not file.Exists( self.FileDir.."settings.txt", "DATA" ) then
        file.Write( self.FileDir.."settings.txt", util.TableToJSON(self.Config) )
    else
        local data = util.JSONToTable(file.Read( self.FileDir.."settings.txt", "DATA" ))
        local saveConfig = false
        for k,v in pairs(self.Config) do
            if data[k] then continue end
            data[k] = v
            saveConfig = true
        end
        if saveConfig then JNVoiceMod:SaveConfig() end
        self.Config = data
        JNVoiceMod:SynchronizeConfig()
    end
end
    // sync config
function JNVoiceMod:SynchronizeConfig(num,ply)
    if not num then num = 0 end
    net.Start("jnvm_network")
        net.WriteInt(1,5)
        net.WriteTable(self.Config)
    if num == 0 then
        net.Broadcast()
    elseif num == 1 then
        if not ply then return end
        net.Send(ply)
    end
end

// execute config load on server start
JNVoiceMod:LoadConfig()

// new player connected to server, so we have to give him current server config and basic values
hook.Add( "PlayerInitialSpawn", "JNVoiceModSynchro", function( ply )
    local tbl = {main = {freq = JNVoiceMod.Config.FreqRange.min, channel = nil},add = {freq = JNVoiceMod.Config.FreqRange.min+1, channel = nil}}
    JNVoiceMod:SynchronizeConfig(1,ply)
    ply:SetNWInt("JNVoiceModDist",1)
    ply:SetNWString("JNVoiceModFreq",util.TableToJSON(tbl))
    ply:SetNWString("JNVoiceModChannels","[]")
    JNVoiceMod.playerFreqs[ply:SteamID64()] = tbl
end )
// disable radio on player death
hook.Add("PlayerDeath","JNVoiceModResetRadio",function(ply)
    JNVoiceMod:ForceRadio(ply,false)
    JNVoiceMod:ResetChannels(ply)
    JNVoiceMod.playerFreqs[ply:SteamID64()] = util.JSONToTable(ply:GetNWString("JNVoiceModFreq","[]"))
end)


// force player to enable or disable his radio if he owns one

function JNVoiceMod:ForceRadio(ply,bool)

    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not tobool(JNVoiceMod:WhichRadio(ply)) then ply:SetNWBool("JNVoiceModRadioEnabled",false) end    // when he tries to toggle it when he doesnt own one will result in turning it off

    if isbool(bool) then
        ply:SetNWBool("JNVoiceModRadioEnabled",bool)
    else
        ply:SetNWBool("JNVoiceModRadioEnabled",not ply:GetNWBool("JNVoiceModRadioEnabled",false))
    end
    JNVoiceMod:ToggleRadioSound(ply)

end

function JNVoiceMod:GiveChannel(ply,id,permament)
    local plyChannels = util.JSONToTable(ply:GetNWString("JNVoiceModChannels")) or {}


    for k,v in pairs(plyChannels) do
        if v.id == id then return false end
    end
    for k,v in pairs(JNVoiceMod.Config.DefinedFreq) do
        if v.id == id then
            table.insert(plyChannels,{id = v.id,perm = permament})
            ply:SetNWString("JNVoiceModChannels",util.TableToJSON(plyChannels))
            return true
        end
    end

    return false

end

function JNVoiceMod:RemoveChannel(ply,id)
    local plyChannels = util.JSONToTable(ply:GetNWString("JNVoiceModChannels"))
    local freqs = util.JSONToTable(ply:GetNWString("JNVoiceModFreq","[]"))
    for k,v in pairs(plyChannels) do
        if v.id == id then 
            table.remove(plyChannels,k)
            ply:SetNWString("JNVoiceModChannels",util.TableToJSON(plyChannels))
            for k2,v2 in pairs(freqs) do
                if v2.channel == v.id then
                    v2.channel = nil
                    v2.freq = JNVoiceMod.Config.FreqRange.min
                    ply:SetNWString("JNVoiceModFreq",util.TableToJSON(freqs))
                    break
                end
            end
            return true
        end
    end

    return false
end

function JNVoiceMod:ResetChannels(ply)
    local plyChannels = util.JSONToTable(ply:GetNWString("JNVoiceModChannels"))
    for k,v in pairs(plyChannels) do
        if v.perm then continue end
        self:RemoveChannel(ply,v.id)
    end
end


JNVoiceMod.playerFreqs = JNVoiceMod.playerFreqs or {}

// MAIN 
hook.Add("PlayerCanHearPlayersVoice","JNVoiceModHook", function(listener, speaker)
    if listener != speaker then
        local max_falloff_distance = 100
        local dist = listener:GetPos():Distance(speaker:GetPos()) <= JNVoiceMod.Config.Ranges[speaker:GetNWInt("JNVoiceModDist")].rng + max_falloff_distance

        if engine.ActiveGamemode() == "terrortown" then
            if GetRoundState() != ROUND_ACTIVE then
                return true, false
            end
            if speaker:IsSpec() and not listener:IsSpec() then
                return false, false
            elseif speaker:IsSpec() and listener:IsSpec() then
                return true, false
            end

            if speaker:IsActiveTraitor() then
                if !speaker.traitor_gvoice then
                    if listener:IsActiveTraitor() then
                        return true, false
                    end
                    return false, false
                end
            end
            if dist then
                return true, true
                
            end

            return false
        else
            if !JNVoiceMod.Config.GlobalVoice then
                // todo using JNVoiceMod.playerFreqs
                local speakerUsingRadio = speaker:GetNWInt("JNVoiceModRadio",0)
                local speakerFreq = (speakerUsingRadio == 1 and JNVoiceMod.playerFreqs[speaker:SteamID64()].main or speakerUsingRadio == 2 and JNVoiceMod.playerFreqs[speaker:SteamID64()].add)
                local listenerEnabledRadio = listener:GetNWBool("JNVoiceModRadioEnabled",false)
                if tobool(speakerUsingRadio) and listenerEnabledRadio then 
                    for kL,vL in pairs(JNVoiceMod.playerFreqs[listener:SteamID64()]) do
                        if speakerFreq.freq and vL.freq then 
                            if speakerFreq.freq == vL.freq then
                                return true,false
                            end
                        elseif speakerFreq.channel and vL.channel then
                            if speakerFreq.channel == vL.channel then
                                return true,false
                            end
                        end
                    end
                end
                if dist then
                    return true,true
                end
                return false,false
            else
                return true,false
            end
        end
    end
end)
