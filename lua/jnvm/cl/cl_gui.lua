function JNVoiceMod:isColor(val)

	if isnumber(tonumber(val)) then
		return (tonumber(val) >=0 and tonumber(val) <=255)
	end

end

// --------------------------- CUSTOM CHECKBOX --------------------------- \\

local PANEL = {}

JNVoiceMod:CreateFont("checkbox",8)

function PANEL:Init()
	self.font = "Default"

	self.button = self:Add("DCheckBox")
	local button = self.button
	button.xSwitch = 0
	button.tempo = 10
	button:Dock(LEFT)
	button:SetWide(self:GetTall()*2)
	button.Paint = function(s,w,h)
		draw.RoundedBox(h,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		s.xSwitch = math.Clamp(Lerp(s.tempo*FrameTime(),s.xSwitch,(s:GetChecked() and 1.1) or -0.1),0,1)
		local red = JNVoiceMod.clgui.colors.red
		local green = JNVoiceMod.clgui.colors.green
		draw.RoundedBox(h,2+h*s.xSwitch,2,h-4,h-4,(s.xSwitch <=.5 and red) or green)
		draw.SimpleText((s.xSwitch <=.5 and "OFF") or "ON","JNVoiceMod.checkbox",h/2+h*s.xSwitch,h/2,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.RoundedBox(h,2+h*s.xSwitch,2,h-4,h-4,JNVoiceMod.clgui.colors.blended)
	end

	self.label = self:Add("DLabel")
	local label = self.label
	label:Dock(FILL)
	label:DockMargin(8,0,0,0)
	label:SetFont(self.font)
	label:SetText("DLabel")

end

function PANEL:SetFont(font)
	self.font = font
	self.label:SetFont(self.font)
end

function PANEL:SetText(text)
	self.text = text
	self.label:SetText(text or "DLabel")
end

function PANEL:SetValue(bool)
	self.button:SetValue(bool)
	self.button.xSwitch = (bool and 1 or 0)
end

function PANEL:GetChecked()
	return self.button:GetChecked()
end

vgui.Register("JNVoiceMod.checkBox",PANEL)


// --------------------------- CUSTOM COMBOBOX --------------------------- \\
local PANEL = {}

JNVoiceMod:CreateFont("combobox",15)

function PANEL:Init()
	self:SetTextColor(JNVoiceMod.clgui.text.primary)
	self.Paint = function(s,w,h)
		//draw.SimpleText(JNVoiceMod:GetPhrase("lang"),"JNVoiceMod.header",5,h,yellSlider.color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
 		if s:IsMenuOpen() then
			draw.RoundedBoxEx(6,0,0,w,h,JNVoiceMod.clgui.colors.blended,true,true,false,false)
		else
			draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		end
		if s:IsHovered() then
			s:SetTextColor(JNVoiceMod.clgui.text.primary)
		else
			s:SetTextColor(JNVoiceMod.clgui.text.combobox)
		end
	end
	local once = true
	self.Think = function(s)
		if s:IsMenuOpen() and once then
			local color = JNVoiceMod.ClConfig.GuiColor
			color.a = 20
			
			s.Menu:SetPaintBackground(false)
			s.Menu:SetDrawBorder( false )
			local count = s.Menu:ChildCount()
			for i = 1, count do
				local child = s.Menu:GetChild(i)
				s.Menu:GetCanvas().Paint = function() end
				child:SetFont("JNVoiceMod.combobox")
				child:SetTextColor(JNVoiceMod.clgui.text.primary)
				child.Paint = function(s,w,h)
					
					if s:IsHovered() then
						s:SetTextColor(JNVoiceMod.clgui.text.primary)
					else
						s:SetTextColor(JNVoiceMod.clgui.text.combobox)
					end
					draw.RoundedBoxEx((i == count and 6 or 0),0,0,w,h,JNVoiceMod.clgui.colors.secondary,false,false,true,true)
					draw.RoundedBox(0,0,0,w,h,color)
					draw.RoundedBoxEx((i == count and 6 or 0),0,0,w,h,JNVoiceMod.clgui.colors.blended,false,false,true,true)
				end
			end
		else
			once = true
		end
	end

end

vgui.Register("NJVoiceMod.ComboBox",PANEL,"DComboBox")

// --------------------------- CUSTOM COLOR PICKER --------------------------- \\
local PANEL = {}

JNVoiceMod:CreateFont("colorpicker",25)
JNVoiceMod:CreateFont("colorpickerplaceholder",12,2000)

function PANEL:Init()
	self.redPicker = self:Add("DTextEntry")
	local redPicker = self.redPicker
	redPicker:Dock(LEFT)
	redPicker:DockMargin(8,0,0,0)
	redPicker:SetText(JNVoiceMod.ClConfig.GuiColor.r)	
	redPicker:SetNumeric(true)
	redPicker:SetPaintBorderEnabled(false)
	redPicker:SetPaintBackground(false)
	redPicker.color = JNVoiceMod.clgui.text.primary
	redPicker:SetTextColor(redPicker.color)
	redPicker:SetFont("JNVoiceMod.colorpicker")
	redPicker.PaintOver = function(s,w,h)
		surface.SetFont("JNVoiceMod.header")
		local x,y = surface.GetTextSize(s:GetValue())
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:GetValue() == "" then
			draw.SimpleText(JNVoiceMod:GetPhrase("red"),"JNVoiceMod.colorpickerplaceholder",w*.5,h*.5,JNVoiceMod.clgui.text.combobox,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	redPicker.Think = function(s)
		local val = tonumber(s:GetValue())
		if (JNVoiceMod:isColor(val)) then
			s.color = JNVoiceMod.clgui.text.primary
		else
			s.color = JNVoiceMod.clgui.text.red
		end
		redPicker:SetTextColor(redPicker.color)
	end

	self.greenPicker = self:Add("DTextEntry")
	local greenPicker = self.greenPicker
	greenPicker:Dock(LEFT)
	greenPicker:DockMargin(8,0,0,0)	
	greenPicker:SetText(JNVoiceMod.ClConfig.GuiColor.g)	
	greenPicker:SetNumeric(true)
	greenPicker:SetPaintBorderEnabled(false)
	greenPicker:SetPaintBackground(false)
	greenPicker.color = JNVoiceMod.clgui.text.primary
	greenPicker:SetTextColor(greenPicker.color)
	greenPicker:SetFont("JNVoiceMod.colorpicker")
	greenPicker.PaintOver = function(s,w,h)
		surface.SetFont("JNVoiceMod.header")
		local x,y = surface.GetTextSize(s:GetValue())
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:GetValue() == "" then
			draw.SimpleText(JNVoiceMod:GetPhrase("green"),"JNVoiceMod.colorpickerplaceholder",w*.5,h*.5,JNVoiceMod.clgui.text.combobox,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	greenPicker.Think = function(s)
		local val = tonumber(s:GetValue())
		if (JNVoiceMod:isColor(val)) then
			s.color = JNVoiceMod.clgui.text.primary
		else
			s.color = JNVoiceMod.clgui.text.red
		end
		greenPicker:SetTextColor(greenPicker.color)
	end

	self.bluePicker = self:Add("DTextEntry")
	local bluePicker = self.bluePicker
	bluePicker:Dock(LEFT)
	bluePicker:DockMargin(8,0,0,0)	
	bluePicker:SetText(JNVoiceMod.ClConfig.GuiColor.b)	
	bluePicker:SetNumeric(true)
	bluePicker:SetPaintBorderEnabled(false)
	bluePicker:SetPaintBackground(false)
	bluePicker.color = JNVoiceMod.clgui.text.primary
	bluePicker:SetTextColor(bluePicker.color)
	bluePicker:SetFont("JNVoiceMod.colorpicker")
	bluePicker.PaintOver = function(s,w,h)
		surface.SetFont("JNVoiceMod.header")
		local x,y = surface.GetTextSize(s:GetValue())
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:GetValue() == "" then
			draw.SimpleText(JNVoiceMod:GetPhrase("blue"),"JNVoiceMod.colorpickerplaceholder",w*.5,h*.5,JNVoiceMod.clgui.text.combobox,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	bluePicker.Think = function(s)
		local val = tonumber(s:GetValue())
		if (JNVoiceMod:isColor(val)) then
			s.color = JNVoiceMod.clgui.text.primary
		else
			s.color = JNVoiceMod.clgui.text.red
		end
		bluePicker:SetTextColor(bluePicker.color)
	end

	self.newColorPanel = self:Add("DButton")
	local newColorPanel = self.newColorPanel
	newColorPanel:SetText("")
	newColorPanel:Dock(LEFT)
	newColorPanel:DockMargin(8,0,0,0)	
	newColorPanel.fill = 0
	newColorPanel.tempo = 5
	newColorPanel.color = JNVoiceMod.ClConfig.GuiColor
	
	newColorPanel.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if (isnumber(tonumber(self.redPicker:GetValue())) and isnumber(tonumber(self.greenPicker:GetValue())) and isnumber(tonumber(self.bluePicker:GetValue()))) then
			s.color = {
				r=tonumber(self.redPicker:GetValue()),
				g=tonumber(self.greenPicker:GetValue()),
				b=tonumber(self.bluePicker:GetValue()),
			}
		end
		draw.RoundedBox(6,3,3,w-6,h-6,s.color)
		
		if s:IsHovered() then
			s.fill = math.Clamp(Lerp(s.tempo*FrameTime(),s.fill,1.1),0,1)
		else
			s.fill = math.Clamp(Lerp(s.tempo*FrameTime(),s.fill,-0.1),0,1)
		end
		local color = table.Copy(JNVoiceMod.clgui.text.primary)	// copy the table with color to prevent from changing the color everywhere
		color.a = s.fill*255
		draw.SimpleText(JNVoiceMod:GetPhrase("clickcolor"),"JNVoiceMod.colorpicker",w*.5,h*.5,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	newColorPanel.DoClick = function(s)
		JNVoiceMod.ClConfig.frame:SetMouseInputEnabled(false)
		JNVoiceMod.ClConfig.frame:SetKeyboardInputEnabled(false)
		
		s.colorFrame = vgui.Create("JNVoiceMod.frame")
		local colorFrame = s.colorFrame
		colorFrame.parent = s	// have to use that cuz' im creating a frame without a default parent look 2 lines up
		colorFrame:SetSize(200,200)
		colorFrame:MakePopup()
		colorFrame:Center()
		colorFrame:SetTitle(JNVoiceMod:GetPhrase("guiColor"))
		colorFrame.Think = function(s)
			if not IsValid(s.parent) then s:Remove() end	// remove this frame when parent dissapears eg. after using jnvmfixgui 
		end
		colorFrame.header.closeBtn.DoClick = function(s)
			JNVoiceMod.ClConfig.frame:SetMouseInputEnabled(true)
			JNVoiceMod.ClConfig.frame:SetKeyboardInputEnabled(true)
			colorFrame:Remove()
		end

		colorFrame.body = colorFrame:Add("DPanel")
		local body = colorFrame.body
		body:Dock(FILL)
		body.Paint = function(s,w,h)
			local color = JNVoiceMod.ClConfig.GuiColor
			color.a = 15	// todo 5
			
			draw.RoundedBoxEx(6,0,0,w,h,JNVoiceMod.clgui.colors.secondary,false,false,true,true)
			draw.RoundedBoxEx(6,0,0,w,h,color,false,false,true,true)
		end
		
		local color = {
			r = tonumber(colorFrame.parent:GetParent().redPicker:GetValue()),
			g = tonumber(colorFrame.parent:GetParent().greenPicker:GetValue()),
			b = tonumber(colorFrame.parent:GetParent().bluePicker:GetValue()),
			a = 255,
		}
		
		colorFrame.body.ColorMixer = colorFrame.body:Add("DColorMixer")
		local colorMixer = colorFrame.body.ColorMixer
		colorMixer:Dock(FILL)
		colorMixer:DockMargin(8,8,8,8)
		colorMixer:SetPalette(false)
		colorMixer:SetAlphaBar(false)
		colorMixer:SetWangs(true)
		colorMixer:SetColor(color)
		colorMixer.ValueChanged = function(s,color)
			colorFrame.parent:GetParent().redPicker:SetValue(tostring(color.r))
			colorFrame.parent:GetParent().greenPicker:SetValue(tostring(color.g))
			colorFrame.parent:GetParent().bluePicker:SetValue(tostring(color.b))
		end


	end

end

function PANEL:PerformLayout()

	self.redPicker:SetWide(45)
	self.greenPicker:SetWide(45)
	self.bluePicker:SetWide(45)
	self.newColorPanel:SetWide(135)

end

vgui.Register("JNVoiceMod.colorPicker",PANEL)

// --------------------------- FRAME --------------------------- \\

local PANEL = {}
JNVoiceMod:CreateFont("header",20)
JNVoiceMod:CreateFont("error",15)
JNVoiceMod:CreateFont("close",20,1500)

function PANEL:Init()

	// header
	self.header = self:Add("Panel")
	local header = self.header
    header:Dock(TOP)
    header.Paint = function (panel,w,h)
		local color = JNVoiceMod.ClConfig.GuiColor
		color.a = 20
        draw.RoundedBoxEx(6,0,0,w,h,JNVoiceMod.clgui.colors.primary,true,true,false,false)
		draw.RoundedBox(0,0,0,w,h,color)
		draw.RoundedBox(0,0,h-3,w,3,JNVoiceMod.clgui.colors.blended)
    end

	// close button
	self.header.closeBtn = self.header:Add("DButton")
	local closeBtn = self.header.closeBtn
	closeBtn:DockMargin(2,2,2,6)
	closeBtn:Dock(RIGHT)
	closeBtn.DoClick = function(s)
		self:Remove()
	end
	closeBtn:SetText("")
	closeBtn.fill = 0
	closeBtn.tempo = 5
	closeBtn.posx,closeBtn.posy = 0,0
	closeBtn.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.red)
		draw.SimpleText(JNVoiceMod:GetPhrase("close"),"JNVoiceMod.close",w/2,h/2,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		if s:IsHovered() then
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,1.1)
			s.posx,s.posy = s:CursorPos()
		else
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,0)
		end
		draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,JNVoiceMod.clgui.colors.blended)

	end

	// title
	self.header.title = self.header:Add("DLabel")
	local label = self.header.title
	label:DockMargin(2,0,0,6)
	label:Dock(LEFT)
	label:SetFont("JNVoiceMod.header")
	label:SetTextColor(JNVoiceMod.clgui.text.header)

end

function PANEL:PerformLayout(w,h)

	self.header:SetTall(28)
    self.header.title:SizeToContentsX(8)

end

function PANEL:SetTitle(title)

	local label = self.header.title
	if IsValid(label) then
		label:SetText(title or "Nil")
	end

	self:InvalidateLayout()

end

vgui.Register("JNVoiceMod.frame",PANEL,"EditablePanel")

// --------------------------- FOOTER --------------------------- \\

local PANEL = {}
JNVoiceMod:CreateFont("submit",35)

function PANEL:Init()

	self.Paint = function(s,w,h)
		local color = JNVoiceMod.ClConfig.GuiColor
		color.a = 20
		
		draw.RoundedBoxEx(6,0,0,w,h,JNVoiceMod.clgui.colors.primary,false,false,true,true)
		draw.RoundedBox(0,0,0,w,h,color)
		draw.RoundedBox(0,0,0,w,3,JNVoiceMod.clgui.colors.blended)

	end

	self.submitBtn = self:Add("DButton")
	local submitBtn = self.submitBtn
	submitBtn:Dock(RIGHT)
	submitBtn:DockMargin(0,20,20,20)
	submitBtn:SetText("")
	submitBtn:SetEnabled(false)
	submitBtn.text = "Save"
	submitBtn.text2 = "Submit"
	submitBtn.xOffset,submitBtn.yOffset,submitBtn.xOffsetTarget,submitBtn.yOffsetTarget = 0,0,0,0
	submitBtn.tick = 0
	submitBtn.tempo = 1
	submitBtn.speed = 1
	submitBtn.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:IsHovered() then
			s.tick = math.Clamp(s.tick + 10*FrameTime()*s.speed,0,40)
		else
			s.tick = math.Clamp(s.tick - 40*FrameTime()*s.speed,0,40)
		end

		s.xOffset = Lerp(s.tempo*5*FrameTime(),s.xOffset,s.xOffsetTarget)
		s.yOffset = Lerp(s.tempo*5*FrameTime(),s.yOffset,s.yOffsetTarget)
		
		if s.tick < 1 then
			s.xOffsetTarget = 0
			s.yOffsetTarget = 0
		// check if values are valid
		
		elseif s.tick <=40 and s.check(s) then
			s.yOffsetTarget = -w
		elseif s.tick < 10 then
			s.xOffsetTarget = h
		elseif s.tick < 20 then
			s.xOffsetTarget = h*2
		elseif s.tick < 30 then
			s.xOffsetTarget = h*3
			s.yOffsetTarget = 0
			s:SetEnabled(false)
		elseif s.tick <= 40 then
			s.xOffsetTarget = h*3
			s.yOffsetTarget = w
			s:SetEnabled(true)
		end
		draw.SimpleText(s.text,"JNVoiceMod.submit",(w/2)+s.yOffset,(h/2)-s.xOffset,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("ERROR IN VALUES ","JNVoiceMod.error",w+(w/2)+s.yOffset,(h/2)-s.xOffset,JNVoiceMod.clgui.text.red,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("3...","JNVoiceMod.submit",(w/2)+s.yOffset,(h/2)-s.xOffset+h,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("2...","JNVoiceMod.submit",(w/2)+s.yOffset,(h/2)-s.xOffset+h*2,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("1...","JNVoiceMod.submit",(w/2)+s.yOffset,(h/2)-s.xOffset+h*3,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.RoundedBox(6,-w+s.yOffset,-s.xOffset+h*3,w,h,JNVoiceMod.clgui.colors.green)
		draw.SimpleText(s.text2,"JNVoiceMod.submit",-w+(w/2)+s.yOffset,(h/2)-s.xOffset+h*3,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	end
	
	submitBtn.DoClick = function(s)
		chat.AddText("Boom! Nothing happend... HAHA fool!")
	end

	self.wastedspace = self:Add("DLabel")
	local wastedspace = self.wastedspace
	wastedspace:DockMargin(8,8,8,8)
	wastedspace:Dock(LEFT)
	wastedspace:SetText(JNVoiceMod:GetPhrase("suprise!"))
	wastedspace:SetFont("JNVoiceMod.submit")
	wastedspace:SetTextColor(JNVoiceMod.clgui.text.blended)

end

function PANEL:PerformLayout(w,h)
	self:SetTall(96)
	self.wastedspace:SizeToContentsX(32)
	self.submitBtn:SetWide(128)
end

vgui.Register("JNVoiceMod.footer",PANEL)


// --------------------------- ADMIN BODY --------------------------- \\

local PANEL = {}

function PANEL:Init()
	
	self.Paint = function(s,w,h)
		local color = JNVoiceMod.ClConfig.GuiColor
		color.a = 5
		
		draw.RoundedBox(0,0,0,w,h,JNVoiceMod.clgui.colors.secondary)
		draw.RoundedBox(0,0,0,w,h,color)
	end

	self.whisperLabel = self:Add("DLabel")
	local whisperLabel = self.whisperLabel
	whisperLabel:Dock(TOP)
	whisperLabel:DockMargin(8,8,8,0)
	whisperLabel:SetText(JNVoiceMod:GetPhrase("whisperRng"))
	whisperLabel:SetFont("JNVoiceMod.header")


	self.whisperSlider = self:Add("DTextEntry")
	local whisperSlider = self.whisperSlider
	whisperSlider:Dock(TOP)
	whisperSlider:DockMargin(8,0,8,8)
	whisperSlider:SetText(JNVoiceMod.Config.Ranges[1].rng)	
	whisperSlider:SetNumeric(true)
	whisperSlider:SetPaintBorderEnabled(false)
	whisperSlider:SetPaintBackground(false)
	whisperSlider:SetFont("JNVoiceMod.header")
	whisperSlider.color = JNVoiceMod.clgui.text.primary
	whisperSlider:SetTextColor(whisperSlider.color)
	whisperSlider.PaintOver = function(s,w,h)
		surface.SetFont("JNVoiceMod.header")
		local x,y = surface.GetTextSize(s:GetValue())
		draw.SimpleText(JNVoiceMod:GetPhrase("units"),"JNVoiceMod.header",5+x,h,whisperSlider.color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	whisperSlider.Think = function(s)
		local val = tonumber(s:GetValue())
		if (isnumber(val) and val or 0) <= 0 then
			s.color = JNVoiceMod.clgui.text.red
		else
			s.color = JNVoiceMod.clgui.text.primary
		end
		whisperSlider:SetTextColor(whisperSlider.color)
	end

	self.talkLabel = self:Add("DLabel")
	local talkLabel = self.talkLabel
	talkLabel:Dock(TOP)
	talkLabel:DockMargin(8,8,8,0)
	talkLabel:SetText(JNVoiceMod:GetPhrase("talkRng"))
	talkLabel:SetFont("JNVoiceMod.header")


	self.talkSlider = self:Add("DTextEntry")
	local talkSlider = self.talkSlider
	talkSlider:Dock(TOP)
	talkSlider:DockMargin(8,0,8,8)
	talkSlider:SetText(JNVoiceMod.Config.Ranges[2].rng)	
	talkSlider:SetNumeric(true)
	talkSlider:SetPaintBorderEnabled(false)
	talkSlider:SetPaintBackground(false)
	talkSlider:SetFont("JNVoiceMod.header")
	talkSlider.color = JNVoiceMod.clgui.text.primary
	talkSlider:SetTextColor(talkSlider.color)
	talkSlider.PaintOver = function(s,w,h)
		surface.SetFont("JNVoiceMod.header")
		local x,y = surface.GetTextSize(s:GetValue())
		draw.SimpleText(JNVoiceMod:GetPhrase("units"),"JNVoiceMod.header",5+x,h,talkSlider.color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	talkSlider.Think = function(s)
		local val = tonumber(s:GetValue())
		if (isnumber(val) and val or 0) <= 0 then
			s.color = JNVoiceMod.clgui.text.red
		else
			s.color = JNVoiceMod.clgui.text.primary
		end
		talkSlider:SetTextColor(talkSlider.color)
	end
	self.yellLabel = self:Add("DLabel")
	local yellLabel = self.yellLabel
	yellLabel:Dock(TOP)
	yellLabel:DockMargin(8,8,8,0)
	yellLabel:SetText(JNVoiceMod:GetPhrase("yellRng"))
	yellLabel:SetFont("JNVoiceMod.header")


	self.yellSlider = self:Add("DTextEntry")
	local yellSlider = self.yellSlider
	yellSlider:Dock(TOP)
	yellSlider:DockMargin(8,0,8,8)
	yellSlider:SetText(JNVoiceMod.Config.Ranges[3].rng)	
	yellSlider:SetNumeric(true)
	yellSlider:SetPaintBorderEnabled(false)
	yellSlider:SetPaintBackground(false)
	yellSlider:SetFont("JNVoiceMod.header")
	yellSlider.color = JNVoiceMod.clgui.text.primary
	yellSlider:SetTextColor(yellSlider.color)
	yellSlider.PaintOver = function(s,w,h)
		surface.SetFont("JNVoiceMod.header")
		local x,y = surface.GetTextSize(s:GetValue())
		draw.SimpleText(JNVoiceMod:GetPhrase("units"),"JNVoiceMod.header",5+x,h,yellSlider.color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	yellSlider.Think = function(s)
		local val = tonumber(s:GetValue())
		if (isnumber(val) and val or 0) <= 0 then
			s.color = JNVoiceMod.clgui.text.red
		else
			s.color = JNVoiceMod.clgui.text.primary
		end
		yellSlider:SetTextColor(yellSlider.color)
	end

	self.globalvoiceLabel = self:Add("DLabel")
	local globalvoiceLabel = self.globalvoiceLabel
	globalvoiceLabel:Dock(TOP)
	globalvoiceLabel:DockMargin(8,8,8,0)
	globalvoiceLabel:SetText(JNVoiceMod:GetPhrase("globalvoice"))
	globalvoiceLabel:SetFont("JNVoiceMod.header")

	self.globalVoiceCheckbox = self:Add("JNVoiceMod.checkBox")
	local checkbox = self.globalVoiceCheckbox
	checkbox:SetText(JNVoiceMod:GetPhrase("onlyTTT"))
	checkbox:Dock(TOP)
	checkbox:DockMargin(8,0,8,8)
	checkbox:SetFont("JNVoiceMod.header")
	checkbox:SetValue( JNVoiceMod.Config.GlobalVoice )

	self.langLabel = self:Add("DLabel")
	local langLabel = self.langLabel
	langLabel:Dock(TOP)
	langLabel:DockMargin(8,8,8,0)
	langLabel:SetText(JNVoiceMod:GetPhrase("serverLanguage"))
	langLabel:SetFont("JNVoiceMod.header")

	self.langComboBox = self:Add("NJVoiceMod.ComboBox")
	local langComboBox = self.langComboBox
	langComboBox:Dock(TOP)
	langComboBox:DockMargin(8,0,8,8)
	langComboBox:SetFont("JNVoiceMod.header")

	local i = 1
	for k,v in pairs(JNVoiceMod.Lang) do
		langComboBox:AddChoice(v.lang,k)
		if JNVoiceMod.Config.Language == k then langComboBox:ChooseOptionID(i)
		end
		i = i + 1
	end



end

vgui.Register("JNVoiceMod.adminBody",PANEL)

// --------------------------- CLIENT BODY --------------------------- \\
local PANEL = {}
function PANEL:Init()
	self.Paint = function(s,w,h)
		local color = JNVoiceMod.ClConfig.GuiColor
		color.a = 5
		
		draw.RoundedBox(0,0,0,w,h,JNVoiceMod.clgui.colors.secondary)
		draw.RoundedBox(0,0,0,w,h,color)
	end

	// color picker
	self.guiColorLabel = self:Add("DLabel")
	local guiColorLabel = self.guiColorLabel
	guiColorLabel:Dock(TOP)
	guiColorLabel:DockMargin(8,8,8,0)
	guiColorLabel:SetText(JNVoiceMod:GetPhrase("guiColor"))
	guiColorLabel:SetFont("JNVoiceMod.header")

	self.colorPicker = self:Add("JNVoiceMod.colorPicker")
	local colorPicker = self.colorPicker 
	colorPicker:Dock(TOP)
	colorPicker:DockMargin(8,4,8,0)

	self.langLabel = self:Add("DLabel")
	local langLabel = self.langLabel
	langLabel:Dock(TOP)
	langLabel:DockMargin(8,8,8,0)
	langLabel:SetText(JNVoiceMod:GetPhrase("clientLanguage"))
	langLabel:SetFont("JNVoiceMod.header")

	self.langComboBox = self:Add("NJVoiceMod.ComboBox")
	local langComboBox = self.langComboBox
	langComboBox:Dock(TOP)
	langComboBox:DockMargin(8,0,8,8)
	langComboBox:SetFont("JNVoiceMod.header")

	local i = 1
	for k,v in pairs(JNVoiceMod.Lang) do
		langComboBox:AddChoice(v.lang,k)
		if JNVoiceMod.ClConfig.Lang == k then langComboBox:ChooseOptionID(i)
		end
		i = i + 1
	end


end

function PANEL:PerformLayout()

	self.colorPicker:SetTall(30)

end

vgui.Register("JNVoiceMod.clientBody",PANEL)

// Admin config menu, accesible via jnvmconfigmenu 
function JNVoiceMod:OpenConfigMenu()
    if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
	
    JNVoiceMod.ClConfig.frame = vgui.Create("JNVoiceMod.frame")
    local frame = JNVoiceMod.ClConfig.frame
    frame:SetSize(600,420)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(JNVoiceMod:GetPhrase("admConfigGUI"))

	// bottom toolbox
	frame.footer = frame:Add("JNVoiceMod.footer")
	local footer = frame.footer 
	footer:Dock(BOTTOM)
	footer.submitBtn.text = JNVoiceMod:GetPhrase("save")
	footer.submitBtn.text2 = JNVoiceMod:GetPhrase("submit")

	footer.submitBtn.check = function(s)
		return (tonumber(s:GetParent().body.whisperSlider:GetValue()) <= 0 or
		tonumber(s:GetParent().body.talkSlider:GetValue()) <= 0 or 
		tonumber(s:GetParent().body.yellSlider:GetValue()) <= 0 ) 
	end
	footer.submitBtn.DoClick = function(s)
		local _lang,data = s:GetParent().body.langComboBox:GetSelected()
		net.Start("jnvm_network")
			net.WriteInt(1,16)
			net.WriteInt(s:GetParent().body.whisperSlider:GetValue(),16)
			net.WriteInt(s:GetParent().body.talkSlider:GetValue(),16)
			net.WriteInt(s:GetParent().body.yellSlider:GetValue(),16)
			net.WriteString(data)
			net.WriteBool(s:GetParent().body.globalVoiceCheckbox:GetChecked())
		net.SendToServer()
		if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
	end

	// main body
	frame.body = frame:Add("JNVoiceMod.adminBody")
	local body = frame.body
	body:Dock(FILL)
	frame.footer.body = body

end


// Client config menu, accesible via C menu

function JNVoiceMod:OpenClConfig()
    if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
	
    JNVoiceMod.ClConfig.frame = vgui.Create("JNVoiceMod.frame")
    local frame = JNVoiceMod.ClConfig.frame
    frame:SetSize(600, 800)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(JNVoiceMod:GetPhrase("clConfigGUI"))

	// bottom toolbox
	frame.footer = frame:Add("JNVoiceMod.footer")
	local footer = frame.footer
	footer:Dock(BOTTOM)
	footer.submitBtn.text = JNVoiceMod:GetPhrase("save")
	footer.submitBtn.text2 = JNVoiceMod:GetPhrase("submit")
	footer.submitBtn.speed = 3
	footer.submitBtn.check = function(s)
		local colorPicker = s:GetParent().body.colorPicker
		local redPicker = colorPicker.redPicker
		local greenPicker = colorPicker.greenPicker
		local bluePicker = colorPicker.bluePicker
		if  JNVoiceMod:isColor(redPicker:GetValue()) and JNVoiceMod:isColor(greenPicker:GetValue()) and JNVoiceMod:isColor(bluePicker:GetValue()) then
			return false
		end
		return true
	end
	footer.submitBtn.DoClick = function(s)
		local colorPicker = s:GetParent().body.colorPicker
		local color = {
			r=tonumber(colorPicker.redPicker:GetValue()),
			g=tonumber(colorPicker.greenPicker:GetValue()),
			b=tonumber(colorPicker.bluePicker:GetValue()),
		}
		JNVoiceMod.ClConfig.GuiColor = color
		local _lang,data = s:GetParent().body.langComboBox:GetSelected()
		JNVoiceMod.ClConfig.Lang = ((JNVoiceMod.Lang[data] and data) or "EN-en")
		JNVoiceMod:ClConfigSave()
		JNVoiceMod.ClConfig.frame:Remove() 
	end
	
	// main body
	frame.body = frame:Add("JNVoiceMod.clientBody")
	local body = frame.body
	body:Dock(FILL)
	frame.footer.body = body


	
end




--[[
function JNVoiceMod:OpenClConfig()
	local frame = vgui.Create("DFrame")
	frame:SetSize(600,440)
	frame:Center()
	frame:SetTitle("CONFIG")
	frame:SetDraggable(true)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	JNVoiceMod:FramePaint(frame)

	local fw,fh = frame:GetWide(),frame:GetTall()
	local color = JNVoiceMod.ClConfig.GuiColor
	local talkAlphaVal = JNVoiceMod.ClConfig.TalkAlpha
	local idleAlphaVal = JNVoiceMod.ClConfig.IdleAlpha
	local changeAlphaVal = JNVoiceMod.ClConfig.ChngAlpha
	local bind = JNVoiceMod.ClConfig.Bind
	local hudenabled= JNVoiceMod.ClConfig.HudEnabled
	local sphereenabled = JNVoiceMod.ClConfig.SphereEnabled
	local spherealpha = JNVoiceMod.ClConfig.SphereAlpha
	local guiColor = Color(color.r,color.g,color.b)


	optionPanel = vgui.Create("DPanel",frame)
	optionPanel:SetTall(60)
	optionPanel:Dock(BOTTOM)
	optionPanel:DockMargin(5,5,5,5)
	optionPanel.Paint = function(s,w,h)
	end

	local confirmButton = vgui.Create("DButton",optionPanel)
	confirmButton:SetWide(fw/3)
	confirmButton:Dock(LEFT)
	confirmButton:DockMargin(20,5,10,5)
	confirmButton:SetText("CONFIRM")
	JNVoiceMod:ButtonPaint(confirmButton,Color(255,255,255),Color(0,200,120))

	confirmButton.DoClick = function(s)
		JNVoiceMod.ClConfig.Bind = bind
		JNVoiceMod.ClConfig.GuiColor = guiColor
		JNVoiceMod.ClConfig.TalkAlpha = talkAlphaVal
		JNVoiceMod.ClConfig.IdleAlpha = idleAlphaVal
		JNVoiceMod.ClConfig.ChngAlpha = changeAlphaVal
		JNVoiceMod.ClConfig.HudEnabled = hudenabled
		JNVoiceMod.ClConfig.SphereEnabled = sphereenabled 
		JNVoiceMod.ClConfig.SphereAlpha = spherealpha
		JNVoiceMod:ClConfigSave()
		frame:Remove()
	end

	local cancelButton = vgui.Create("DButton",optionPanel)
	cancelButton:SetWide(fw/3)
	cancelButton:Dock(RIGHT)
	cancelButton:SetText("CANCEL")
	cancelButton:DockMargin(10,5,20,5)
	JNVoiceMod:ButtonPaint(cancelButton,Color(255,255,255),Color(255,50,50))
	cancelButton.DoClick = function(s)
		frame:Remove()
	end


	scroll = vgui.Create("DScrollPanel",frame)
	scroll:Dock(FILL)
	scroll:DockMargin(0,0,0,0)
	JNVoiceMod:ScrollPaint(scroll,guiColor)

	// config default color

	guiColorPanel = vgui.Create("DPanel",scroll)
	guiColorPanel:SetTall(125)
	guiColorPanel:Dock(TOP)
	guiColorPanel:DockMargin(5,5,5,5)
	JNVoiceMod:ConfigPanelPaint(guiColorPanel,"GUI COLOR")
	guiColorPanel.PaintOver = function(s,w,h)
		surface.SetDrawColor(guiColor)
		surface.DrawRect(w-h,h/4,h/2,h/2)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawOutlinedRect(w-h-1,h/4-1,h/2+2,h/2+2)
	end


	local guicolorRslider = vgui.Create( "DNumSlider", guiColorPanel )
	guicolorRslider:Dock(TOP)
	guicolorRslider:DockMargin(-250,20,200,0)
	guicolorRslider:SetMin( 0 )
	guicolorRslider:SetMax( 255 )
	guicolorRslider:SetDecimals( 0 )
	guicolorRslider:SetValue( JNVoiceMod.ClConfig.GuiColor.r )
	JNVoiceMod:SliderPaint(guicolorRslider,Color(255,50,50))
	guicolorRslider.OnValueChanged = function(s,v)
		guiColor.r = v
	end

	local guicolorGslider = vgui.Create( "DNumSlider", guiColorPanel )
	guicolorGslider:Dock(TOP)
	guicolorGslider:DockMargin(-250,0,200,0)
	guicolorGslider:SetMin( 0 )
	guicolorGslider:SetMax( 255 )
	guicolorGslider:SetDecimals( 0 )
	guicolorGslider:SetValue( JNVoiceMod.ClConfig.GuiColor.g )
	JNVoiceMod:SliderPaint(guicolorGslider,Color(50,255,50))
	guicolorGslider.OnValueChanged = function(s,v)
		guiColor.g = v
	end

	local guicolorBslider = vgui.Create( "DNumSlider", guiColorPanel )
	guicolorBslider:Dock(TOP)
	guicolorBslider:DockMargin(-250,0,200,0)
	guicolorBslider:SetMin( 0 )
	guicolorBslider:SetMax( 255 )
	guicolorBslider:SetDecimals( 0 )
	guicolorBslider:SetValue( JNVoiceMod.ClConfig.GuiColor.b )
	JNVoiceMod:SliderPaint(guicolorBslider,Color(50,50,255))
	guicolorBslider.OnValueChanged = function(s,v)
		guiColor.b = v
	end

	alphaPanel = vgui.Create("DPanel",scroll)
	alphaPanel:SetTall(150)
	alphaPanel:Dock(TOP)
	alphaPanel:DockMargin(5,5,5,5)
	JNVoiceMod:ConfigPanelPaint(alphaPanel,"HUD ALPHA")

	local idleAlpha = vgui.Create( "DNumSlider", alphaPanel )
	idleAlpha:Dock(TOP)
	idleAlpha:DockMargin(-100,20,50,0)
	idleAlpha:SetText("Idle")
	idleAlpha:SetMin( 0 )
	idleAlpha:SetMax( 1 )
	idleAlpha:SetDecimals( 2 )
	idleAlpha:SetValue( JNVoiceMod.ClConfig.IdleAlpha )
	JNVoiceMod:SliderPaint(idleAlpha,Color(50,50,50))
	idleAlpha.OnValueChanged = function(s,v)
		idleAlphaVal = v
	end


	local talkAlpha = vgui.Create( "DNumSlider", alphaPanel )
	talkAlpha:Dock(TOP)
	talkAlpha:DockMargin(-100,0,50,0)
	talkAlpha:SetText("Talk")
	talkAlpha:SetMin( 0 )
	talkAlpha:SetMax( 1 )
	talkAlpha:SetDecimals( 2 )
	talkAlpha:SetValue( JNVoiceMod.ClConfig.TalkAlpha )
	JNVoiceMod:SliderPaint(talkAlpha,Color(50,50,50))
	talkAlpha.OnValueChanged = function(s,v)
		talkAlphaVal = v
	end

	local chngAlpha = vgui.Create( "DNumSlider", alphaPanel )
	chngAlpha:Dock(TOP)
	chngAlpha:DockMargin(-100,0,50,0)
	chngAlpha:SetText("Change mode")
	chngAlpha:SetMin( 0 )
	chngAlpha:SetMax( 1 )
	chngAlpha:SetDecimals( 2 )
	chngAlpha:SetValue( JNVoiceMod.ClConfig.ChngAlpha )
	JNVoiceMod:SliderPaint(chngAlpha,Color(50,50,50))
	chngAlpha.OnValueChanged = function(s,v)
		changeAlphaVal = v
	end

	local text = "Enabled"
	local hudEnabled = vgui.Create ("DLabel",alphaPanel)
	hudEnabled:Dock(TOP)
	hudEnabled:DockMargin(0,5,0,0)
	hudEnabled:SetToggle(hudenabled)
	hudEnabled:SetTall(25)
	hudEnabled:SetText("")
	hudEnabled:SetMouseInputEnabled(true)
	hudEnabled.Paint = function(s,w,h)
		draw.SimpleText(text,"GModNotify",w*0.255,h/2,Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		draw.RoundedBox(h/2,w*0.275,2,40,h-4,Color(30,30,30,200))
		if hudenabled then
			draw.RoundedBox(h/2,w*0.275,3,h-6,h-6,Color(150,255,150,255))
		else
			draw.RoundedBox(h/2,w*0.275+40-h+5,3,h-6,h-6,Color(255,150,150,255))
		end
	end
	hudEnabled.DoClick = function()
		hudenabled = not hudenabled
	end

	spherePanel = vgui.Create("DPanel",scroll)
	spherePanel:SetTall(85)
	spherePanel:Dock(TOP)
	spherePanel:DockMargin(5,5,5,5)
	JNVoiceMod:ConfigPanelPaint(spherePanel,"TALK SPHERE")

	local sphereAlpha = vgui.Create( "DNumSlider", spherePanel )
	sphereAlpha:Dock(TOP)
	sphereAlpha:DockMargin(-100,20,50,0)
	sphereAlpha:SetText("Sphere Alpha")
	sphereAlpha:SetMin( 0 )
	sphereAlpha:SetMax( 1 )
	sphereAlpha:SetDecimals( 2 )
	sphereAlpha:SetValue( spherealpha )
	JNVoiceMod:SliderPaint(sphereAlpha,Color(50,50,50))
	sphereAlpha.OnValueChanged = function(s,v)
		spherealpha = v
	end

	local text = "Enabled"
	local sphereEnabled = vgui.Create ("DLabel",spherePanel)
	sphereEnabled:Dock(TOP)
	sphereEnabled:DockMargin(0,5,0,0)
	sphereEnabled:SetToggle(sphereenabled)
	sphereEnabled:SetTall(25)
	sphereEnabled:SetText("")
	sphereEnabled:SetMouseInputEnabled(true)
	sphereEnabled.Paint = function(s,w,h)
		draw.SimpleText(text,"GModNotify",w*0.255,h/2,Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		draw.RoundedBox(h/2,w*0.275,2,40,h-4,Color(30,30,30,200))
		if sphereenabled then
			draw.RoundedBox(h/2,w*0.275,3,h-6,h-6,Color(150,255,150,255))
		else
			draw.RoundedBox(h/2,w*0.275+40-h+5,3,h-6,h-6,Color(255,150,150,255))
		end
	end
	sphereEnabled.DoClick = function()
		sphereenabled = not sphereenabled
	end


	bindPanel = vgui.Create("DPanel",scroll)
	bindPanel:SetTall(80)
	bindPanel:Dock(TOP)
	bindPanel:DockMargin(5,5,5,5)
	JNVoiceMod:ConfigPanelPaint(bindPanel,"CHANGE TALKING MODE (BIND)")

	local binder = vgui.Create( "DBinder", bindPanel )
	binder:SetSize( 50, 50 )
	binder:Dock(FILL)
	binder:DockMargin(200,25,200,5)
	binder:SetSelectedNumber(bind)
	binder.OnChange = function(s,v)
		bind = v
	end

end
]]

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
		surface.SetMaterial( Material("jnvoice/whisper.png") )
		surface.DrawTexturedRect(w*.5-bwt*.5-bw*.27,h*.9,bwt,bht)

		surface.SetDrawColor(id == 2 and Color(clr.r,clr.g,clr.b,lerp2*255) or Color(200,200,200,lerp2*25))
		surface.SetMaterial( Material("jnvoice/talk.png") )
		surface.DrawTexturedRect(w*.5-bwt*.5,h*.9,bwt,bht)

		surface.SetDrawColor(id == 3 and Color(clr.r,clr.g,clr.b,lerp2*255) or Color(200,200,200,lerp2*25))
		surface.SetMaterial( Material("jnvoice/shout.png") )
		surface.DrawTexturedRect(w*.5-bwt*.5+bw*.27,h*.9,bwt,bht)
	end
end )



JNVoiceMod:OpenClConfig()