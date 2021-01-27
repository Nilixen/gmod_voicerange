file.CreateDir("jnvm")



function JNVoiceMod:SaveData()
    file.Write( self.FileDir.."settings.txt", util.TableToJSON(self.config) )
end

function JNVoiceMod:LoadData()
    if not file.Exists( self.FileDir.."properties_"..game.GetMap()..".txt", "DATA" ) then
        file.Write( self.FileDir.."properties_"..game.GetMap()..".txt", util.TableToJSON(self.Properties) )
    else
        local data = util.JSONToTable(file.Read( self.FileDir.."properties_"..game.GetMap()..".txt", "DATA" ))
        for _, v in pairs(data) do
            v.Doors = {}
        end
        self.Properties = data
    end

    if not file.Exists( self.FileDir.."doorsid_"..game.GetMap()..".txt", "DATA" ) then
        file.Write( self.FileDir.."doorsid_"..game.GetMap()..".txt", util.TableToJSON(self.DoorsMID) )
    else
        self.DoorsMID = util.JSONToTable(file.Read( self.FileDir.."doorsid_"..game.GetMap()..".txt", "DATA" ))
    end
end

YNP:LoadData()
