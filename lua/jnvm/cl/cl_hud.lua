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
JNVoiceMod:CreateFont("hudradio",10)

local alpha = 255 
local color = JNVoiceMod.ClConfig.GuiColor
local colorWhisper = table.Copy(color)
	colorWhisper.a = 255
local colorTalk = table.Copy(color)
	colorTalk.a = 255
local colorYell = table.Copy(color)
	colorYell.a = 255
local colorRadio = table.Copy(JNVoiceMod.clgui.colors.primary)
	colorRadio.a = 255
local colorText = table.Copy(JNVoiceMod.clgui.text.primary)
	colorText.a = 255
local hasRadioLerp = 0

local time = CurTime()
local lastMode = nil
local lastRadioToggle = nil

hook.Add( "HUDPaint", "JNVMHud", function()
	if !JNVoiceMod.Config.GlobalVoice and JNVoiceMod.ClConfig.HudEnabled then


		local scrW,scrH = ScrW(),ScrH()
		local ply = LocalPlayer()

		local mode = ply:GetNWInt("JNVoiceModDist")
		// alpha
		if (lastMode != mode) or ply:IsSpeaking() or lastRadioToggle != ply:GetNWBool("JNVoiceModRadioEnabled") then
			time = CurTime() + 2
			lastMode = mode
			lastRadioToggle = ply:GetNWBool("JNVoiceModRadioEnabled")
		end

		alpha = Lerp(5*FrameTime(),alpha,(time >= CurTime() and ply:IsSpeaking()) and JNVoiceMod.ClConfig.TalkAlpha*255 or (time >= CurTime()) and JNVoiceMod.ClConfig.ChngAlpha*255 or JNVoiceMod.ClConfig.IdleAlpha*255)


		color.a = alpha

		local bgColor = table.Copy(JNVoiceMod.clgui.colors.primary)
		bgColor.a = alpha*1.2
		local blendColor = table.Copy(JNVoiceMod.clgui.colors.secondary)
		blendColor.a = alpha

		local w,h = 150,50
		local margin = 20,0
		local relX,relY = (scrW/2)-(w/2), scrH*0.90

		// radios hud
		if tobool(JNVoiceMod:WhichRadio(ply)) then
			hasRadioLerp = Lerp(5*FrameTime(),hasRadioLerp,1)
		else
			hasRadioLerp = Lerp(5*FrameTime(),hasRadioLerp,0)
		end
		colorRadio.a = alpha*hasRadioLerp

		draw.RoundedBox(16,relX,relY,w+37*hasRadioLerp,h,bgColor)
		draw.RoundedBoxEx(16,relX+w,relY,37*hasRadioLerp,h,color,false,true,false,true)

		local iconSize = h*0.65
		surface.SetDrawColor(colorRadio)
		surface.SetMaterial( Material("jnvm/radio.png") )
		surface.DrawTexturedRect(relX+(w*hasRadioLerp),relY+(h-iconSize)/2,iconSize,iconSize)

		colorText.a = alpha
		draw.SimpleText((ply:GetNWBool("JNVoiceModRadioEnabled") and "ON" or "OFF"),"JNVoiceMod.hudradio",relX+(w*hasRadioLerp)+17,relY+(h*0.95),colorText,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)


		// modes hud
			// shadow for whisper
			surface.SetDrawColor(blendColor)
			surface.SetMaterial( Material("jnvm/whisper.png") )
			surface.DrawTexturedRect(relX+(margin/2)+((w-margin)/3)-((w-margin)/6)-h/2,relY,h,h)
			// whisper
			colorWhisper.a = Lerp(25*FrameTime(),colorWhisper.a,(mode == 1 and alpha or 0))
			surface.SetDrawColor(colorWhisper)
			surface.SetMaterial( Material("jnvm/whisper.png") )
			surface.DrawTexturedRect(relX+(margin/2)+((w-margin)/3)-((w-margin)/6)-h/2,relY,h,h)

			// shadow for talk
			surface.SetDrawColor(blendColor)
			surface.SetMaterial( Material("jnvm/talk.png") )
			surface.DrawTexturedRect(relX+(margin/2)+((w-margin)/3)*2-((w-margin)/6)-h/2,relY,h,h)

			// talk
			colorTalk.a = Lerp(25*FrameTime(),colorTalk.a,(mode == 2 and alpha or 0))
			surface.SetDrawColor(colorTalk)
			surface.SetMaterial( Material("jnvm/talk.png") )
			surface.DrawTexturedRect(relX+(margin/2)+((w-margin)/3)*2-((w-margin)/6)-h/2,relY,h,h)

			//shadow for yell
			surface.SetDrawColor(blendColor)
			surface.SetMaterial( Material("jnvm/shout.png") )
			surface.DrawTexturedRect(relX+(margin/2)+((w-margin)/3)*3-((w-margin)/6)-h/2,relY,h,h)

			// yell
			colorYell.a = Lerp(25*FrameTime(),colorYell.a,(mode == 3 and alpha or 0))
			surface.SetDrawColor(colorYell)
			surface.SetMaterial( Material("jnvm/shout.png") )
			surface.DrawTexturedRect(relX+(margin/2)+((w-margin)/3)*3-((w-margin)/6)-h/2,relY,h,h)


	end
end )

