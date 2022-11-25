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
JNVoiceMod:CreateFont("hudradio",13)

local alpha = 255 
local offsetX,offXT = 0,0		//XT - xTarget,
local color,guicolor,colorText,plyWasTalking,colorRadio,colorYell,colorTalk,colorWhisper,colorFreq
local hasRadioLerp = 0

local time = CurTime()
local lastMode = nil
local lastRadioToggle = nil

hook.Add( "HUDPaint", "JNVMHud", function()
	if !JNVoiceMod.Config.GlobalVoice and JNVoiceMod.ClConfig.HudEnabled then

		if table.ToString(guicolor or {}) != table.ToString(JNVoiceMod.ClConfig.GuiColor) then
			
			guicolor = table.Copy(JNVoiceMod.ClConfig.GuiColor)
			color = table.Copy(guicolor)
			colorWhisper = table.Copy(color)
				colorWhisper.a = 255
			colorTalk = table.Copy(color)
				colorTalk.a = 255
			colorYell = table.Copy(color)
				colorYell.a = 255
			colorRadio = table.Copy(JNVoiceMod.clgui.colors.primary)
				colorRadio.a = 255
			colorFreq = table.Copy(JNVoiceMod.clgui.colors.primary)
				colorFreq.a = 255
		end

		
		local scrW,scrH = ScrW(),ScrH()
		local ply = LocalPlayer()
		

		local mode = ply:GetNWInt("JNVoiceModDist")
		// alpha
		if (lastMode != mode) or ply:IsSpeaking() or lastRadioToggle != ply:GetNWBool("JNVoiceModRadioEnabled") then
			time = CurTime() + 2
			lastMode = mode
			lastRadioToggle = ply:GetNWBool("JNVoiceModRadioEnabled")
			if ply:IsSpeaking() then
			plyWasTalking = true
			else
				plyWasTalking = false
			end
		end

		alpha = Lerp(5*FrameTime(),alpha,(time >= CurTime() and plyWasTalking) and JNVoiceMod.ClConfig.TalkAlpha*255 or (time >= CurTime()) and JNVoiceMod.ClConfig.ChngAlpha*255 or JNVoiceMod.ClConfig.IdleAlpha*255)


		color.a = alpha

		local bgColor = table.Copy(JNVoiceMod.clgui.colors.primary)
		bgColor.a = alpha*1.2
		local blendColor = table.Copy(JNVoiceMod.clgui.colors.secondary)
		blendColor.a = alpha

		local w,h = 150,50
		local margin = 20
		local relX,relY = (scrW/2)-(w/2)-(offsetX/2), scrH*0.90

		// offset

			offsetX = Lerp(5*FrameTime(),offsetX,offXT)

		// radios hud
		local freqs = util.JSONToTable(ply:GetNWString("JNVoiceModFreq"))
		local whichRadio = JNVoiceMod:WhichRadio(ply)

		if tobool(whichRadio) then
			hasRadioLerp = Lerp(5*FrameTime(),hasRadioLerp,1)
			if ply:GetNWBool("JNVoiceModRadioEnabled",false) then
				offXT = JNVoiceMod.clgui.sizes.hud.radioOffset
			else
				offXT = 37
			end
			
		else
			hasRadioLerp = Lerp(5*FrameTime(),hasRadioLerp,0)
			offXT = 0
		end
		colorRadio.a = alpha*hasRadioLerp

		local radioEnabled = ply:GetNWBool("JNVoiceModRadioEnabled")
		colorFreq.a = Lerp(5*FrameTime(),colorFreq.a,alpha*(radioEnabled and 1 or 0))


		draw.RoundedBox(16,relX,relY,w+offsetX*hasRadioLerp,h,bgColor)
		draw.RoundedBoxEx(16,relX+w,relY,offsetX*hasRadioLerp,h,color,false,true,false,true)

		local iconSize = h*0.65
		surface.SetDrawColor(colorRadio)
		surface.SetMaterial( Material("jnvm/radio.png") )
		surface.DrawTexturedRect(relX+(w*hasRadioLerp),relY+(h-iconSize)/2,iconSize,iconSize)
		draw.SimpleText((radioEnabled and "ON" or "OFF"),"JNVoiceMod.hudradio",relX+(w+17)*hasRadioLerp,relY+(h*0.95),colorRadio,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
		
		// todo rework to be able to handle custom channels
		draw.SimpleText(JNVoiceMod:GetPhrase("mainChannelHUD",ply,(JNVoiceMod:FindFreqName(freqs.main.channel) or freqs.main.freq.." MHz")),"JNVoiceMod.hudradio",relX+(w+37)*hasRadioLerp,relY+(h*0.5),colorFreq,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
		if whichRadio == 1 then
			draw.SimpleText(JNVoiceMod:GetPhrase("addChannelHUD",ply,(JNVoiceMod:FindFreqName(freqs.add.channel) or freqs.add.freq.." MHz")),"JNVoiceMod.hudradio",relX+(w+37)*hasRadioLerp,relY+(h*0.5),colorFreq,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end
		
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

