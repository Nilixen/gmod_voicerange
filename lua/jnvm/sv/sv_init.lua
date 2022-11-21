
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
    JNVoiceMod:SynchronizeConfig(1,ply)
    ply:SetNWInt("JNVoiceModDist",1)
    ply:SetNWString("JNVoiceModFreq",tostring(JNVoiceMod.Config.FreqRange.min))
end )


// force player to enable or disable his radio if he owns one

function JNVoiceMod:ForceRadio(ply,bool)

    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:HasWeapon("jnvm_radio") then return end

    if isbool(bool) then
        ply:SetNWBool("JNVoiceModRadioEnabled",bool)
    else
        ply:SetNWBool("JNVoiceModRadioEnabled",not ply:GetNWBool("JNVoiceModRadioEnabled",false))
    end
    JNVoiceMod:ToggleRadioSound(ply)

end


// MAIN 

hook.Add("PlayerCanHearPlayersVoice","JNVoiceModHook", function(listener, speaker)
    if listener != speaker then
        local dist = listener:GetPos():Distance(speaker:GetPos()) <= JNVoiceMod.Config.Ranges[speaker:GetNWInt("JNVoiceModDist")].rng

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
                if dist then
                    return true,true
                end
            else

                return true,false

            end
        end
    end
end)
