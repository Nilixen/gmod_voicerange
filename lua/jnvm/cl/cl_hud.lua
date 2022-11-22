// Speak Sphere
local lerp1 = 0
local dst = LocalPlayer():GetNWInt("JNVoiceModDist")
hook.Add("PostDrawOpaqueRenderables", "JNVMSphere", function()
	if !JNVoiceMod.Config.GlobalVoice and JNVoiceMod.ClConfig.SphereEnabled then
		local ply = LocalPlayer()
	    if engine.ActiveGamemode() == "terrortown" then
			if ply:IsActiveTraitor() and !ply.traitor_gvoice or ply:IsSpec() or GetRoundState() != ROUND_ACTIVE then
				return
			else
				dst = Lerp(4*FrameTime(),dst,ply:GetNWInt("JNVoiceModDist"))
				lerp1 = Lerp(4*FrameTime(),lerp1,(ply:IsSpeaking() and JNVoiceMod.ClConfig.SphereAlpha*255 or 0))
				render.SetColorMaterial()
				render.DrawSphere( ply:GetPos(), -dst, 50, 50, Color( 0, 0, 0, lerp1 ) )
			end
		else
			dst = Lerp(4*FrameTime(),dst,JNVoiceMod.Config.Ranges[ply:GetNWInt("JNVoiceModDist")].rng)
			lerp1 = Lerp(4*FrameTime(),lerp1,(ply:IsSpeaking() and JNVoiceMod.ClConfig.SphereAlpha*255 or 0))
			local color = JNVoiceMod.ClConfig.Ranges[ply:GetNWInt("JNVoiceModDist")].color
			render.SetColorMaterial()
			render.DrawSphere( ply:GetPos(), -dst, 50, 50, Color( color.r, color.g, color.b, lerp1 ) )
		end
	end
end )

//	HUD
local lerp2 = 0
local t = CurTime()
local lid = 0
hook.Add( "HUDPaint", "JNVMHud", function()
	if !JNVoiceMod.Config.GlobalVoice and JNVoiceMod.ClConfig.HudEnabled then
		local w,h = ScrW(),ScrH()
		local ply = LocalPlayer()
		local clr = JNVoiceMod.ClConfig.GuiColor
		local id = ply:GetNWInt("JNVoiceModDist")
		if id != lid then
			lid = id
			t = CurTime()
		end

		lerp2 = Lerp((t+3<CurTime() and 2 or 16)*FrameTime(),ply:IsSpeaking() and t+3<CurTime() and JNVoiceMod.ClConfig.TalkAlpha or lerp2,t+3<CurTime() and JNVoiceMod.ClConfig.IdleAlpha or JNVoiceMod.ClConfig.ChngAlpha)

		local bw,bh = 175,50
		draw.RoundedBox(10,w*.5-bw*.5,h*.9,bw,bh,Color(40,40,40,lerp2*255))
		local bwt,bht = 50,50
		surface.SetDrawColor(id == 1 and Color(clr.r,clr.g,clr.b,lerp2*255) or Color(200,200,200,lerp2*25))
		surface.SetMaterial( Material("jnvm/whisper.png") )
		surface.DrawTexturedRect(w*.5-bwt*.5-bw*.27,h*.9,bwt,bht)

		surface.SetDrawColor(id == 2 and Color(clr.r,clr.g,clr.b,lerp2*255) or Color(200,200,200,lerp2*25))
		surface.SetMaterial( Material("jnvm/talk.png") )
		surface.DrawTexturedRect(w*.5-bwt*.5,h*.9,bwt,bht)

		surface.SetDrawColor(id == 3 and Color(clr.r,clr.g,clr.b,lerp2*255) or Color(200,200,200,lerp2*25))
		surface.SetMaterial( Material("jnvm/shout.png") )
		surface.DrawTexturedRect(w*.5-bwt*.5+bw*.27,h*.9,bwt,bht)
	end
end )

