file.CreateDir(JNVoiceMod.FileDir)


function JNVoiceMod:SaveConfig()
    file.Write( self.FileDir.."settings.txt", util.TableToJSON(self.Config) )

end

function JNVoiceMod:SynchronizeConfig(num,ply)
    if not num then num = 0 end
    net.Start("jnvm_network")
        net.WriteInt(1,16)
        net.WriteTable(self.Config)
    if num == 0 then
        net.Broadcast()
    elseif num == 1 then
        if not ply then return end
        net.Send(ply)
    end
end

function JNVoiceMod:LoadConfig()
    if not file.Exists( self.FileDir.."settings.txt", "DATA" ) then
        file.Write( self.FileDir.."settings.txt", util.TableToJSON(self.Config) )
    else
        local data = util.JSONToTable(file.Read( self.FileDir.."settings.txt", "DATA" ))
        self.Config = data
        JNVoiceMod:SynchronizeConfig()
    end
end

JNVoiceMod:LoadConfig()

hook.Add( "PlayerInitialSpawn", "JNVoiceModSynchro", function( ply )
    JNVoiceMod:SynchronizeConfig(1,ply)
    JNVoiceMod:SyncPlayersData(2,ply)
    ply:SetNWInt("JNVoiceModDist",1)
end )

for k,v in pairs(player.GetAll()) do

    JNVoiceMod:SyncPlayersData(2,v)

end

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
