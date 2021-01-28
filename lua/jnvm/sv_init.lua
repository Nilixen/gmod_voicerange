
hook.Add("PlayerCanHearPlayersVoice","JNVoiceModHook", function(listener, speaker)
    if listener != speaker then
        local dist = listener:GetPos():Distance(speaker:GetPos()) <= speaker:GetNWInt("JNVoiceModDist")

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
            if JNVoiceMod.Config.GlobalVoice then
                if dist then
                    return true,true
                end
            else
                return true,false
            end
        end
    end
end)
