local GlobalVoice = false
function GAMEMODE:PlayerCanHearPlayersVoice(listener, speaker)

  if (not speaker:Alive()) and (not listener:Alive()) then
     return true, false
  end

  if speaker:KeyDown(IN_SPEED) and speaker:Team() == listener:Team() then
       return true, false
  end

   if (not IsValid(speaker)) or (not IsValid(listener)) or (listener == speaker) then
      return false, false
   end

   if (not speaker:Alive()) then
      return false, false
   end


   if listener:GetPos():DistToSqr( speaker:GetPos() ) > 250000 then
     return false
   end


   if GlobalVoice then
     return true, false
   else
     return true, true
   end
end
