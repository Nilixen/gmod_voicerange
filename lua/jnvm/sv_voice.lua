if SERVER then
  gameevent.Listen( "player_connect" )
  hook.Add("player_connect", "VoiceDataMod", function( data )
    if Player(data.userid):GetNWInt("VoiceMod") == 0 then
      Player(data.userid):SetNWInt("VoiceMod",JNVoiceMod.Config.TalkDistance)
    end
  end)
    util.AddNetworkString("voicemenu")

    local GlobalVoice = true
    concommand.Add("voicemenu", function( ply, cmd, args )

      if IsValid(ply) then
        net.Start("voicemenu")
        net.Send(ply)
        ply:SetNWBool("VoiceMenuOpened",true)
      end
    end )

    net.Receive("voicemenu",function(ln,ply)
      local data = net.ReadInt(32)
      if data == 1 then
        ply:SetNWInt("VoiceMod",JNVoiceMod.Config.WhisperDistance)
      end
      if data == 2 then
        ply:SetNWInt("VoiceMod",JNVoiceMod.Config.TalkDistance)
      end
      if data == 3 then
        ply:SetNWInt("VoiceMod",JNVoiceMod.Config.YellDistance)
      end
    end)
    hook.Add("PlayerCanHearPlayersVoice", "VoiceRange", function(listener, talker)
      if engine.ActiveGamemode() == "terrortown" and !GlobalVoice then
        if talker:KeyDown(IN_SPEED) and talker:GetRole() == 1 and talker:GetRole() != listener:GetRole() or talker:KeyDown(IN_SPEED) and talker:GetRole() != 1 then return false end
        if !talker:KeyDown(IN_SPEED) then
          if listener:GetPos():Distance(talker:GetPos()) > talker:GetNWInt("VoiceMod") then return false end

        end
      end
    end)

    hook.Add("TTTBeginRound","GlobalMicOFF",function()
     GlobalVoice = false
     end)

     hook.Add("TTTEndRound","GlobalMicON",function(result)
      GlobalVoice = true
    end)

end
