
hook.Add( "PlayerCanHearPlayersVoice", "JNVM_VOICE", function( listener, talker )
  -- 250000 = 500 unit
  if listener:GetPos():DistToSqr( talker:GetPos() ) > 250000 and talker:Alive() != listener:Alive()
  or talker:Team() != 1 and talker:KeyDown(IN_SPEED) and talker:Team() != listener:Team() then
      print("Not")
      return false
  end
end )
