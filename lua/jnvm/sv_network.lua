file.CreateDir("jnvm")

JNVoiceMod.FileDir = "jnvm/"

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
end )

net.Receive("jnvm_network",function(len, ply)
    local num = net.ReadInt(16)
    if num == 1 then
        if not ply:IsAdmin() then ply:ChatPrint("YOU CAN'T DO THAT!") return end
        local whisper = net.ReadInt(16)
        local talk = net.ReadInt(16)
        local yell = net.ReadInt(16)

        JNVoiceMod.Config.WhisperDistance = whisper
        JNVoiceMod.Config.TalkDistance =  talk
        JNVoiceMod.Config.YellDistance =  yell

        JNVoiceMod:SaveConfig()
        JNVoiceMod:SynchronizeConfig()
        ply:ChatPrint("Config saved!")
    end
end)
