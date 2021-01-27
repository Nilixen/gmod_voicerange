list.Set( "DesktopWindows", "JNVoiceModConfig", {

	title		= "JNVoiceMod",
	icon		= "icon64/jnvm.png",
	width		= 200,
	height		= 100,
	onewindow	= true,
	init		= function( icon, window )
		window:Close()
		JNVoiceMod:OpenConfigMenu()
	end
})

local blur = Material( "pp/blurscreen" )
function JNVoiceMod:Blur( panel, layers, density, alpha, type )
	if not type then type = 0 end
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		if type == 0 then
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		else
			JNVoiceMod:Circle(panel:GetWide()/2,panel:GetTall()/2 , panel:GetWide()/2, 100 )
		end
	end
end


function JNVoiceMod:OpenConfigMenu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(400,210)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(true)
	frame:ShowCloseButton(false)
	frame:MakePopup()

	local fw = frame:GetWide()
	local fh = frame:GetTall()

	frame.Paint = function(s,w,h)
		JNVoiceMod:Blur(s, 255, 150, 255)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(0,220,120)
		surface.DrawOutlinedRect(0,0,w,h,1)
		surface.DrawRect(0,0,w,25)
	end
	frame.PaintOver = function(self,w,h)
		draw.SimpleText("CONFIG EDITOR","GModNotify",w/2,12,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	local whisperSlider = vgui.Create( "DNumSlider", frame )
	whisperSlider:SetWide( fw )
	whisperSlider:Dock(TOP)
	whisperSlider:DockMargin(10,10,10,0)
	whisperSlider:SetText( "Whisper Range" )
	whisperSlider:SetMin( 0 )
	whisperSlider:SetMax( 1000 )
	whisperSlider:SetDecimals( 0 )
	whisperSlider:SetValue( self.Config.WhisperDistance )

	local talkSlider = vgui.Create( "DNumSlider", frame )
	talkSlider:SetWide( fw )
	talkSlider:Dock(TOP)
	talkSlider:DockMargin(10,10,10,0)
	talkSlider:SetText( "Talk Range" )
	talkSlider:SetMin( 0 )
	talkSlider:SetMax( 1000 )
	talkSlider:SetDecimals( 0 )
	talkSlider:SetValue( self.Config.TalkDistance )

	local yellSlider = vgui.Create( "DNumSlider", frame )
	yellSlider:SetWide( fw )
	yellSlider:Dock(TOP)
	yellSlider:DockMargin(10,10,10,0)
	yellSlider:SetText( "Yell Range" )
	yellSlider:SetMin( 0 )
	yellSlider:SetMax( 1000 )
	yellSlider:SetDecimals( 0 )
	yellSlider:SetValue( self.Config.YellDistance )

	local buttonsPanel = vgui.Create("DPanel",frame)
	buttonsPanel:Dock(FILL)
	buttonsPanel:DockMargin(10,10,10,10)
	buttonsPanel.Paint = function(s,w,h) end

	local confirmButton = vgui.Create("DButton",buttonsPanel)
	confirmButton:Dock(LEFT)
	confirmButton:SetText("")
	confirmButton:SetWide(fw/2-20)
	confirmButton.Paint = function(s,w,h)
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(0,220,120)
		surface.DrawOutlinedRect(0,0,w,h,1)
		draw.SimpleText("CONFIRM","GModNotify",w/2,h/2,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	function confirmButton:OnCursorEntered()
		confirmButton.Paint = function( s,w,h )
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,220,120)
			surface.DrawOutlinedRect(0,0,w,h,1)
			draw.SimpleText("CONFIRM","GModNotify",w/2,h/2,Color( 0,220,120 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	function confirmButton:OnCursorExited()
		confirmButton.Paint = function( s,w,h )
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,220,120)
			surface.DrawOutlinedRect(0,0,w,h,1)
			draw.SimpleText("CONFIRM","GModNotify",w/2,h/2,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	confirmButton.DoClick = function(s)
		net.Start("jnvm_network")
			net.WriteInt(1,16)
			net.WriteInt(whisperSlider:GetValue(),16)
			net.WriteInt(talkSlider:GetValue(),16)
			net.WriteInt(yellSlider:GetValue(),16)
		net.SendToServer()
		frame:Remove()
	end


	local cancelButton = vgui.Create("DButton",buttonsPanel)
	cancelButton:Dock(RIGHT)
	cancelButton:SetText("")
	cancelButton:SetWide(fw/2-20)
	cancelButton.Paint = function(s,w,h)
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(0,220,120)
		surface.DrawOutlinedRect(0,0,w,h,1)
		draw.SimpleText("CANCEL","GModNotify",w/2,h/2,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	function cancelButton:OnCursorEntered()
		cancelButton.Paint = function( s,w,h )
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,220,120)
			surface.DrawOutlinedRect(0,0,w,h,1)
			draw.SimpleText("CANCEL","GModNotify",w/2,h/2,Color( 255,50,50 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	function cancelButton:OnCursorExited()
		cancelButton.Paint = function( s,w,h )
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,220,120)
			surface.DrawOutlinedRect(0,0,w,h,1)
			draw.SimpleText("CANCEL","GModNotify",w/2,h/2,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	cancelButton.DoClick = function(s)
		frame:Remove()
	end



end

function JNVoiceMod:OpenSelectionMenu()

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrH()*0.4,ScrH()*0.4)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()

	local fw = frame:GetWide()
	local fh = frame:GetTall()



	frame.Paint = function(s,w,h)

		local background = Material( "materials/sel/selection.png")
		surface.SetMaterial( background )
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect(0,0,w,h)

		surface.SetDrawColor(0,220,120)
		local x,y = s:CursorPos()
		surface.DrawLine(w/2,h/2,x,y)

		draw.SimpleText(JNVoiceMod.Lang.Yell,"GModNotify",w*0.75,h*0.4,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(JNVoiceMod.Lang.Whisper,"GModNotify",w*0.25,h*0.4,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(JNVoiceMod.Lang.Talk,"GModNotify",w*.5,h*0.8,Color( 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)


	end
	local curtime = CurTime()
	frame.Think = function(s)
		local x,y = s:CursorPos()

		angle = math.atan2(y - fh/2, x - fw/2 )
		angle = angle * (180/math.pi)
		local dst = math.Distance(fw/2,fh/2,x,y)
		if dst > fw/4 and curtime+0.1 < CurTime() then
			local val
			if angle >= -90 and angle < 45 then
				val = "yell"
				frame:Remove()
			elseif angle >= 45 and angle < 135 then
				val = "talk"
				frame:Remove()
			elseif angle <= -90 and angle > -180 or angle >= 135 and angle < 180 then
				val = "whisper"
				frame:Remove()
			end
			if val then print(val) end
		end
	end


end

net.Receive("jnvm_network",function()
	local num = net.ReadInt(16)
	if num == 1 then
		local tbl = net.ReadTable()
		JNVoiceMod.Config = tbl
	end
end)

concommand.Add("voicemenu", function( ply, cmd, args )
  if IsValid(ply) then
	  JNVoiceMod:OpenSelectionMenu()
  end
end )
