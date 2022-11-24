function JNVoiceMod:isColor(val)

	if isnumber(tonumber(val)) then
		return (tonumber(val) >=0 and tonumber(val) <=255)
	end

end

// --------------------------- CUSTOM DIV --------------------------- \\
local PANEL = {}

function PANEL:Init()
	self.drawLine = true
	self.Paint = function(s,w,h)
		if s.drawLine then
			draw.RoundedBox(6,0+w*.025,0,w*.95,h,JNVoiceMod.ClConfig.GuiColor)
			draw.RoundedBox(6,0+w*.025,0,w*.95,h,JNVoiceMod.clgui.colors.blended)
		end
	end
end

function PANEL:PerformLayout() 
	self:DockMargin(0,16,0,8)
	self:SetTall(2)
end

function PANEL:DrawLine(bool)
	self.drawLine = bool
end

vgui.Register("JNVoiceMod.div",PANEL)
// --------------------------- CUSTOM FREQ VIEW --------------------------- \\
local PANEL = {}

JNVoiceMod:CreateFont("freqviewName",25)
JNVoiceMod:CreateFont("freqviewID",15)

function PANEL:Init()

	self.lines = {}
	self.selected = nil

	self.Paint = function(s,w,h)
		draw.RoundedBoxEx(6,0,0,w,h,JNVoiceMod.clgui.colors.blended,true,true,false,false)
	end
	local vbar = self:GetVBar()
	vbar.Paint = function(s,w,h) end
	vbar:SetHideButtons(true)

	vbar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.ClConfig.GuiColor)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.clgui.colors.blended)
	end


end

function PANEL:AddPanel(id,data)

	local panel = self:Add("DButton")
	panel:Dock(TOP)
	panel:DockMargin(4,4,4,4)
	panel:SetTall(48)
	panel.fill = 0
	panel.tempo = 5
	panel.Paint = function(s,w,h)
		local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
		color.a = 20

		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.primary)
		
		if s:IsHovered() or self.lines[self.selected] == s then
			s.fill = Lerp(s.tempo*FrameTime(),s.fill,1)
		else
			s.fill = Lerp(s.tempo*FrameTime(),s.fill,0)
		end
		draw.RoundedBox(6,0,0,w*s.fill,h,JNVoiceMod.clgui.colors.blended)

		draw.RoundedBox(6,0,0,w,h,color)
		draw.SimpleText("ID: "..data.id,"JNVoiceMod.freqviewID",4,h-4,JNVoiceMod.clgui.text.primary,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

	end
	panel:SetFont("JNVoiceMod.freqviewName")
	panel:SetTextColor(JNVoiceMod.clgui.text.primary)
	panel:SetText(data.name)
	panel:SetContentAlignment(7)
	panel:SetTextInset(4,4)

	panel.DoClick = function(s)
		self.selected = s.id
		self:GetParent():GetParent().frequenciesEditor:DrawSelected(id)
	end

	// add panel to self.lines so it can be accesible
	panel.id = table.insert(self.lines,panel)



end


vgui.Register("JNVoiceMod.definedFreq",PANEL,"DScrollPanel")
// --------------------------- CUSTOM SLIDER --------------------------- \\
local PANEL = {}

JNVoiceMod:CreateFont("slider",25)

function PANEL:Init()
	self.percentage = false

	self.Paint = function(s,w,h) end

	self.Scratch:SetVisible( false )
	self.Label:SetVisible( false )
	self:SetDecimals( 0 )
	local textArea = self.TextArea
	textArea:Dock(LEFT)
	textArea:DockMargin(0,0,4,0)
	textArea:SetFont("JNVoiceMod.slider")
	textArea:SetTextColor(JNVoiceMod.clgui.text.primary)
	textArea.PaintOver = function(s,w,h)
		if self.percentage then
			surface.SetFont(s:GetFont())
			local x,_ = surface.GetTextSize(tostring(math.Round(self:GetValue())))
			draw.SimpleText("%",s:GetFont(),4+x,h*.5,s:GetTextColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	local slider = self.Slider
	slider.PaintOver = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	slider.Knob.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.ClConfig.GuiColor)
	end
end

function PANEL:PerformLayout()

	local decimals = self:GetDecimals()
	local str = (decimals > 0 and "." or "")
	str = str .. (self.percentage and "%" or "")
	for i = 1, decimals do 
		str = str.."0"
	end
	surface.SetFont("JNVoiceMod.slider")
	local x,_ = surface.GetTextSize(tostring(self:GetMax())..str)
	self.TextArea:SetWide(x+8)

end

function PANEL:Percentage(bool)
	self.percentage = bool
	if bool then
		self:SetMinMax(0,100)
		self:InvalidateLayout()
	end
end


vgui.Register("JNVoiceMod.slider",PANEL,"DNumSlider")


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
			local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
			color.a = 5
			
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
	redPicker:DockMargin(0,0,0,0)
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
		local x,y = colorFrame.parent:LocalToScreen()
		colorFrame:SetPos(x+5+colorFrame.parent:GetWide(),y)
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
			local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
			color.a = 15
			
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
		local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
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
		local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
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

JNVoiceMod:CreateFont("selectFreq",25)

function PANEL:Init()
	
	self.Paint = function(s,w,h)
		local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
		color.a = 5
		
		draw.RoundedBox(0,0,0,w,h,JNVoiceMod.clgui.colors.secondary)
		draw.RoundedBox(0,0,0,w,h,color)
	end
	local vbar = self:GetVBar()
	vbar.Paint = function(s,w,h) end
	vbar:SetHideButtons(true)

	vbar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.ClConfig.GuiColor)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.clgui.colors.blended)
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

	self.radioSoundsLabel = self:Add("DLabel")
	local radioSoundsLabel = self.radioSoundsLabel
	radioSoundsLabel:Dock(TOP)
	radioSoundsLabel:DockMargin(8,8,8,0)
	radioSoundsLabel:SetText(JNVoiceMod:GetPhrase("radioSoundsEnabled"))
	radioSoundsLabel:SetFont("JNVoiceMod.header")

	self.radioSoundsCheckbox = self:Add("JNVoiceMod.checkBox")
	local checkbox = self.radioSoundsCheckbox
	checkbox:SetText(JNVoiceMod:GetPhrase("radioSoundsToggle"))
	checkbox:Dock(TOP)
	checkbox:DockMargin(8,0,8,8)
	checkbox:SetFont("JNVoiceMod.header")
	checkbox:SetValue( JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers )

	// custom frequencies

	self.definedFrequencies = table.Copy(JNVoiceMod.Config.DefinedFreq) // copy freqs to local value to work on

	self.frequenciesLabel = self:Add("DLabel")
	local frequenciesLabel = self.frequenciesLabel
	frequenciesLabel:Dock(TOP)
	frequenciesLabel:DockMargin(8,8,8,4)
	frequenciesLabel:SetText(JNVoiceMod:GetPhrase("freqLabel"))
	frequenciesLabel:SetFont("JNVoiceMod.header")


	self.frequencies = self:Add( "JNVoiceMod.definedFreq" )
	local freqs = self.frequencies
	freqs:Dock(TOP)
	freqs:DockMargin(8,0,8,0)

	// frequencies editor
	self.frequenciesEditor = self:Add("DPanel")
	local frequenciesEditor = self.frequenciesEditor
	frequenciesEditor:Dock(TOP)
	frequenciesEditor:DockMargin(8,0,8,4)
	frequenciesEditor.Paint = function(s,w,h)
		local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
		color.a = 20

		draw.RoundedBoxEx(6,0,0,w,h,JNVoiceMod.clgui.colors.primary,false,false,true,true)
		draw.RoundedBoxEx(6,0,0,w,h,color,false,false,true,true)

		if self.frequencies.selected == nil then
			draw.SimpleText(JNVoiceMod:GetPhrase("selectFreqFirst"),"JNVoiceMod.selectFreq",4,h*.5,JNVoiceMod.clgui.text.blended,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
	end
	frequenciesEditor.DrawSelected = function(s,id)
		s.addNewBtn:SetVisible(false)
		s.deleteBtn:SetVisible(true)
		s.saveSelectedBtn:SetVisible(true)
		s.nameEntry:SetVisible(true)
		s.nameEntry:SetText(self.definedFrequencies[id].name)
		s.idEntry:SetVisible(true)
		s.idEntry:SetText(self.definedFrequencies[id].id)
	end
	// add new button
	self.frequenciesEditor.addNewBtn = self.frequenciesEditor:Add("DButton")
	local addNewBtn = self.frequenciesEditor.addNewBtn
	addNewBtn.fill = 0
	addNewBtn.tempo = 5
	addNewBtn:Dock(RIGHT)
	addNewBtn:DockMargin(0,8,8,8)
	addNewBtn:SetText(JNVoiceMod:GetPhrase("addNew"))
	addNewBtn:SetFont("JNVoiceMod.selectFreq")
	addNewBtn:SetTextColor(JNVoiceMod.clgui.text.primary)
	addNewBtn.Paint = function(s,w,h)

		if s:IsHovered() then
			s.fill = Lerp(s.tempo*FrameTime(),s.fill,1)
		else
			s.fill = Lerp(s.tempo*FrameTime(),s.fill,0)
		end

		draw.RoundedBox(6,0,0,w*s.fill,h,JNVoiceMod.ClConfig.GuiColor)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	addNewBtn.DoClick = function(s)
		local freqs = self.definedFrequencies
		local tbl = {
			id = ("new_frequency"..#freqs),
			name = "Placeholder",
		}
		table.insert(freqs,tbl)
		self:InvalidateLayout()
	end

	// cancel editing
	self.frequenciesEditor.deleteBtn = self.frequenciesEditor:Add("DButton")
	local deleteBtn = self.frequenciesEditor.deleteBtn
	deleteBtn.fill = 0
	deleteBtn.tempo = 5
	deleteBtn.posx,deleteBtn.posy = 0,0
	deleteBtn:Dock(RIGHT)
	deleteBtn:DockMargin(0,8,8,8)
	deleteBtn:SetText(JNVoiceMod:GetPhrase("delete"))
	deleteBtn:SetFont("JNVoiceMod.selectFreq")
	deleteBtn:SetTextColor(JNVoiceMod.clgui.text.primary)
	deleteBtn.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.red)
		if s:IsHovered() then
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,1.1)
			s.posx,s.posy = s:CursorPos()
		else
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,0)
		end
		draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,JNVoiceMod.clgui.colors.blended)

	end
	deleteBtn.DoClick = function(s,w,h)
		local freqs = self.definedFrequencies
		// todo
		
		local selected = freqs[self.frequencies.selected]
		if selected then
			table.RemoveByValue(freqs, selected)
		end
		self:InvalidateLayout()
	end

	// save selected button
	self.frequenciesEditor.saveSelectedBtn = self.frequenciesEditor:Add("DButton")
	local saveSelectedBtn = self.frequenciesEditor.saveSelectedBtn
	saveSelectedBtn.fill = 0
	saveSelectedBtn.tempo = 5
	saveSelectedBtn:Dock(RIGHT)
	saveSelectedBtn:DockMargin(0,8,4,8)
	saveSelectedBtn:SetText(JNVoiceMod:GetPhrase("saveSelected"))
	saveSelectedBtn:SetFont("JNVoiceMod.selectFreq")
	saveSelectedBtn:SetTextColor(JNVoiceMod.clgui.text.primary)
	saveSelectedBtn.Paint = function(s,w,h)

		if s:IsHovered() then
			s.fill = Lerp(s.tempo*FrameTime(),s.fill,1)
		else
			s.fill = Lerp(s.tempo*FrameTime(),s.fill,0)
		end

		draw.RoundedBox(6,0,0,w*s.fill,h,JNVoiceMod.ClConfig.GuiColor)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end
	saveSelectedBtn.DoClick = function(s)
		// check if values are correct and id's doesnt overlap with other freqs
		for k,v in pairs(self.definedFrequencies) do
			if k == self.frequencies.selected then continue end
			if v.id == self.frequenciesEditor.idEntry:GetValue() then
				return
			end
		end

		local selected = self.frequencies.selected
		self.definedFrequencies[selected].id = self.frequenciesEditor.idEntry:GetValue()
		self.definedFrequencies[selected].name = self.frequenciesEditor.nameEntry:GetValue()

		self.frequencies.selected = nil
		self:InvalidateLayout()
	end

	self.frequenciesEditor.nameEntry = self.frequenciesEditor:Add("DTextEntry")
	local nameEntry = self.frequenciesEditor.nameEntry
	nameEntry:Dock(RIGHT)
	nameEntry:DockMargin(0,8,8,8)	
	nameEntry:SetPlaceholderText(JNVoiceMod:GetPhrase("freqName"))
	nameEntry:SetPaintBorderEnabled(false)
	nameEntry:SetPaintBackground(false)
	nameEntry:SetFont("JNVoiceMod.header")
	nameEntry.color = JNVoiceMod.clgui.text.primary
	nameEntry:SetTextColor(nameEntry.color)
	nameEntry.PaintOver = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
	end

	self.frequenciesEditor.idEntry = self.frequenciesEditor:Add("DTextEntry")
	local idEntry = self.frequenciesEditor.idEntry
	idEntry:Dock(FILL)
	idEntry:DockMargin(8,8,8,8)
	idEntry:SetPlaceholderText(JNVoiceMod:GetPhrase("freqID"))
	idEntry:SetPaintBorderEnabled(false)
	idEntry:SetPaintBackground(false)
	idEntry:SetFont("JNVoiceMod.header")
	idEntry.color = JNVoiceMod.clgui.text.primary
	idEntry:SetTextColor(idEntry.color)
	idEntry.PaintOver = function(s,w,h)
		
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)

		for k,v in pairs(self.definedFrequencies) do
			if k == self.frequencies.selected then continue end
			if v.id == self.frequenciesEditor.idEntry:GetValue() then
				idEntry:SetTextColor(JNVoiceMod.clgui.colors.red)
			else
				idEntry:SetTextColor(idEntry.color)
			end
		end
	end

	
end

function PANEL:PerformLayout()

	self.frequencies:SetTall(170)
	self.frequenciesEditor:SetTall(40)
	self.frequenciesEditor.addNewBtn:SizeToContentsX(48)
	self.frequenciesEditor.saveSelectedBtn:SizeToContentsX(48)
	self.frequenciesEditor.deleteBtn:SizeToContentsX(6)
	self.frequenciesEditor.nameEntry:SetWide(220)
	self.frequencies.selected = nil
	self.frequenciesEditor.addNewBtn:SetVisible(true)
	self.frequenciesEditor.deleteBtn:SetVisible(false)
	self.frequenciesEditor.saveSelectedBtn:SetVisible(false)
	self.frequenciesEditor.nameEntry:SetVisible(false)
	self.frequenciesEditor.idEntry:SetVisible(false)


	self.frequencies:Clear()
	self.frequencies.lines = {}
	for k,v in pairs(self.definedFrequencies) do
		self.frequencies:AddPanel(k,v)
	end

end

vgui.Register("JNVoiceMod.adminBody",PANEL,"DScrollPanel")

// --------------------------- CLIENT BODY --------------------------- \\
local PANEL = {}

JNVoiceMod:CreateFont("binder",30)

function PANEL:Init()
	self.Paint = function(s,w,h)
		local color = table.Copy(JNVoiceMod.ClConfig.GuiColor)
		color.a = 5
		
		draw.RoundedBox(0,0,0,w,h,JNVoiceMod.clgui.colors.secondary)
		draw.RoundedBox(0,0,0,w,h,color)
	end
	local vbar = self:GetVBar()
	vbar.Paint = function(s,w,h) end
	vbar:SetHideButtons(true)

	vbar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.ClConfig.GuiColor)
		draw.RoundedBox(6,0,0,w*.5,h,JNVoiceMod.clgui.colors.blended)
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
	langComboBox:DockMargin(8,4,8,0)
	langComboBox:SetFont("JNVoiceMod.header")

	local i = 1
	for k,v in pairs(JNVoiceMod.Lang) do
		langComboBox:AddChoice(v.lang,k)
		if JNVoiceMod.ClConfig.Lang == k then langComboBox:ChooseOptionID(i)
		end
		i = i + 1
	end

	self.hudEnabledLabel = self:Add("DLabel")
	local hudEnabledLabel = self.hudEnabledLabel
	hudEnabledLabel:Dock(TOP)
	hudEnabledLabel:DockMargin(8,8,8,0)
	hudEnabledLabel:SetText(JNVoiceMod:GetPhrase("hudenabled"))
	hudEnabledLabel:SetFont("JNVoiceMod.header")

	self.hudEnabledCheckbox = self:Add("JNVoiceMod.checkBox")
	local checkbox = self.hudEnabledCheckbox
	checkbox:SetText(JNVoiceMod:GetPhrase("ishudenabled"))
	checkbox:Dock(TOP)
	checkbox:DockMargin(8,4,8,8)
	checkbox:SetFont("JNVoiceMod.header")
	checkbox:SetValue( JNVoiceMod.ClConfig.HudEnabled )


	self.hudAlphaIdleLabel = self:Add("DLabel")
	local hudAlphaIdleLabel = self.hudAlphaIdleLabel
	hudAlphaIdleLabel:Dock(TOP)
	hudAlphaIdleLabel:DockMargin(8,8,8,0)
	hudAlphaIdleLabel:SetText(JNVoiceMod:GetPhrase("hudAlphaIdle"))
	hudAlphaIdleLabel:SetFont("JNVoiceMod.header")

	self.hudAlphaIdle = self:Add("JNVoiceMod.slider")
	local hudAlphaIdle = self.hudAlphaIdle
	hudAlphaIdle:Dock(TOP)
	hudAlphaIdle:DockMargin(8,4,8,0)
	hudAlphaIdle:Percentage(true)
	hudAlphaIdle:SetValue(JNVoiceMod.ClConfig.IdleAlpha*100)
	hudAlphaIdle:SetDefaultValue(JNVoiceMod.ClConfig.IdleAlpha*100)

	self.hudAlphaTalkLabel = self:Add("DLabel")
	local hudAlphaTalkLabel = self.hudAlphaTalkLabel
	hudAlphaTalkLabel:Dock(TOP)
	hudAlphaTalkLabel:DockMargin(8,8,8,0)
	hudAlphaTalkLabel:SetText(JNVoiceMod:GetPhrase("hudAlphaTalk"))
	hudAlphaTalkLabel:SetFont("JNVoiceMod.header")

	self.hudAlphaTalk = self:Add("JNVoiceMod.slider")
	local hudAlphaTalk = self.hudAlphaTalk
	hudAlphaTalk:Dock(TOP)
	hudAlphaTalk:DockMargin(8,4,8,0)
	hudAlphaTalk:Percentage(true)
	hudAlphaTalk:SetValue(JNVoiceMod.ClConfig.TalkAlpha*100)
	hudAlphaTalk:SetDefaultValue(JNVoiceMod.ClConfig.TalkAlpha*100)

	self.hudAlphaModeLabel = self:Add("DLabel")
	local hudAlphaModeLabel = self.hudAlphaModeLabel
	hudAlphaModeLabel:Dock(TOP)
	hudAlphaModeLabel:DockMargin(8,8,8,0)
	hudAlphaModeLabel:SetText(JNVoiceMod:GetPhrase("hudAlphaMode"))
	hudAlphaModeLabel:SetFont("JNVoiceMod.header")

	self.hudAlphaMode = self:Add("JNVoiceMod.slider")
	local hudAlphaMode = self.hudAlphaMode
	hudAlphaMode:Dock(TOP)
	hudAlphaMode:DockMargin(8,4,8,0)
	hudAlphaMode:Percentage(true)
	hudAlphaMode:SetValue(JNVoiceMod.ClConfig.ChngAlpha*100)
	hudAlphaMode:SetDefaultValue(JNVoiceMod.ClConfig.ChngAlpha*100)
	
	// TALK SPHERE ENABLED

	local div = self:Add("JNVoiceMod.div")
	div:Dock(TOP)

	self.sphereEnabledLabel = self:Add("DLabel")
	local sphereEnabledLabel = self.sphereEnabledLabel
	sphereEnabledLabel:Dock(TOP)
	sphereEnabledLabel:DockMargin(8,8,8,0)
	sphereEnabledLabel:SetText(JNVoiceMod:GetPhrase("sphereenabled"))
	sphereEnabledLabel:SetFont("JNVoiceMod.header")

	self.sphereEnabledCheckbox = self:Add("JNVoiceMod.checkBox")
	local checkbox = self.sphereEnabledCheckbox
	checkbox:SetText(JNVoiceMod:GetPhrase("issphereenabled"))
	checkbox:Dock(TOP)
	checkbox:DockMargin(8,4,8,8)
	checkbox:SetFont("JNVoiceMod.header")
	checkbox:SetValue( JNVoiceMod.ClConfig.SphereEnabled )


	self.sphereLabel = self:Add("DLabel")
	local sphereLabel = self.sphereLabel
	sphereLabel:Dock(TOP)
	sphereLabel:DockMargin(8,8,8,0)
	sphereLabel:SetText(JNVoiceMod:GetPhrase("sphereAlpha"))
	sphereLabel:SetFont("JNVoiceMod.header")

	self.sphereAlpha = self:Add("JNVoiceMod.slider")
	local sphereAlpha = self.sphereAlpha
	sphereAlpha:Dock(TOP)
	sphereAlpha:DockMargin(8,4,8,0)
	sphereAlpha:Percentage(true)
	sphereAlpha:SetValue(JNVoiceMod.ClConfig.SphereAlpha*100)
	sphereAlpha:SetDefaultValue(JNVoiceMod.ClConfig.SphereAlpha*100)

	// binds


	self.talkBindLabel = self:Add("DLabel")
	local bindLabel = self.talkBindLabel
	bindLabel:Dock(TOP)
	bindLabel:DockMargin(8,8,8,0)
	bindLabel:SetText(JNVoiceMod:GetPhrase("bindChanger"))
	bindLabel:SetFont("JNVoiceMod.header")

	self.talkBindChanger =  self:Add("DBinder")
	local bindChanger = self.talkBindChanger
	bindChanger.color = JNVoiceMod.clgui.text.combobox
	bindChanger.color2 = JNVoiceMod.clgui.text.primary
	bindChanger:Dock(TOP)
	bindChanger:DockMargin(8,4,8,0)
	bindChanger:SetSelectedNumber(JNVoiceMod.ClConfig.Bind)
	bindChanger:SetFont("JNVoiceMod.binder")
	bindChanger:SetTextColor(bindChanger.color)
	bindChanger.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:IsHovered() then
			bindChanger:SetTextColor(bindChanger.color2)
		else
			bindChanger:SetTextColor(bindChanger.color)
		end
	end	


	// radio main channel

	local div = self:Add("JNVoiceMod.div")
	div:Dock(TOP)

	self.radioBindLabel = self:Add("DLabel")
	local bindLabel = self.radioBindLabel
	bindLabel:Dock(TOP)
	bindLabel:DockMargin(8,8,8,0)
	bindLabel:SetText(JNVoiceMod:GetPhrase("radioBindChangerMain"))
	bindLabel:SetFont("JNVoiceMod.header")

	self.radioBindChangerMain =  self:Add("DBinder")
	local bindChanger = self.radioBindChangerMain
	bindChanger.color = JNVoiceMod.clgui.text.combobox
	bindChanger.color2 = JNVoiceMod.clgui.text.primary
	bindChanger:Dock(TOP)
	bindChanger:DockMargin(8,4,8,0)
	bindChanger:SetSelectedNumber(JNVoiceMod.ClConfig.BindRadioMain)
	bindChanger:SetFont("JNVoiceMod.binder")
	bindChanger:SetTextColor(bindChanger.color)
	bindChanger.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:IsHovered() then
			bindChanger:SetTextColor(bindChanger.color2)
		else
			bindChanger:SetTextColor(bindChanger.color)
		end
	end	
	self.radioVCMainLabel = self:Add("DLabel")
	local radioLoudnessLabel = self.radioVCMainLabel
	radioLoudnessLabel:Dock(TOP)
	radioLoudnessLabel:DockMargin(8,8,8,0)
	radioLoudnessLabel:SetText(JNVoiceMod:GetPhrase("radioLoudnessMain"))
	radioLoudnessLabel:SetFont("JNVoiceMod.header")

	self.radioVCMain = self:Add("JNVoiceMod.slider")
	local radioLoudness = self.radioVCMain
	radioLoudness:Dock(TOP)
	radioLoudness:DockMargin(8,4,8,0)
	radioLoudness:Percentage(true)
	radioLoudness:SetValue(JNVoiceMod.ClConfig.RadioVCMain*100)
	radioLoudness:SetDefaultValue(JNVoiceMod.ClConfig.RadioVCMain*100)

	// radio additional channel
	
	local div = self:Add("JNVoiceMod.div")
	div:Dock(TOP)

	self.radioBindLabel = self:Add("DLabel")
	local bindLabel = self.radioBindLabel
	bindLabel:Dock(TOP)
	bindLabel:DockMargin(8,8,8,0)
	bindLabel:SetText(JNVoiceMod:GetPhrase("radioBindChangerAdd"))
	bindLabel:SetFont("JNVoiceMod.header")

	self.radioBindChangerAdd = self:Add("DBinder")
	local bindChanger = self.radioBindChangerAdd
	bindChanger.color = JNVoiceMod.clgui.text.combobox
	bindChanger.color2 = JNVoiceMod.clgui.text.primary
	bindChanger:Dock(TOP)
	bindChanger:DockMargin(8,4,8,0)
	bindChanger:SetSelectedNumber(JNVoiceMod.ClConfig.BindRadioAdd)
	bindChanger:SetFont("JNVoiceMod.binder")
	bindChanger:SetTextColor(bindChanger.color)
	bindChanger.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:IsHovered() then
			bindChanger:SetTextColor(bindChanger.color2)
		else
			bindChanger:SetTextColor(bindChanger.color)
		end
	end	

	self.radioVCAddLabel = self:Add("DLabel")
	local radioLoudnessLabel = self.radioVCAddLabel
	radioLoudnessLabel:Dock(TOP)
	radioLoudnessLabel:DockMargin(8,8,8,0)
	radioLoudnessLabel:SetText(JNVoiceMod:GetPhrase("radioLoudnessAdd"))
	radioLoudnessLabel:SetFont("JNVoiceMod.header")

	self.radioVCAdd = self:Add("JNVoiceMod.slider")
	local radioLoudness = self.radioVCAdd
	radioLoudness:Dock(TOP)
	radioLoudness:DockMargin(8,4,8,0)
	radioLoudness:Percentage(true)
	radioLoudness:SetValue(JNVoiceMod.ClConfig.RadioVCAdd*100)
	radioLoudness:SetDefaultValue(JNVoiceMod.ClConfig.RadioVCAdd*100)


	// toggle radio
	
	local div = self:Add("JNVoiceMod.div")
	div:Dock(TOP)

	self.radioBindLabel = self:Add("DLabel")
	local bindLabel = self.radioBindLabel
	bindLabel:Dock(TOP)
	bindLabel:DockMargin(8,8,8,0)
	bindLabel:SetText(JNVoiceMod:GetPhrase("radioToggle"))
	bindLabel:SetFont("JNVoiceMod.header")

	self.radioBindChangerToggle = self:Add("DBinder")
	local bindChanger = self.radioBindChangerToggle
	bindChanger.color = JNVoiceMod.clgui.text.combobox
	bindChanger.color2 = JNVoiceMod.clgui.text.primary
	bindChanger:Dock(TOP)
	bindChanger:DockMargin(8,4,8,0)
	bindChanger:SetSelectedNumber(JNVoiceMod.ClConfig.BindToggleRadio)
	bindChanger:SetFont("JNVoiceMod.binder")
	bindChanger:SetTextColor(bindChanger.color)
	bindChanger.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,JNVoiceMod.clgui.colors.blended)
		if s:IsHovered() then
			bindChanger:SetTextColor(bindChanger.color2)
		else
			bindChanger:SetTextColor(bindChanger.color)
		end
	end	

	self.radioSoundsLabel = self:Add("DLabel")
	local radioSoundsLabel = self.radioSoundsLabel
	radioSoundsLabel:Dock(TOP)
	radioSoundsLabel:DockMargin(8,8,8,0)
	radioSoundsLabel:SetText(JNVoiceMod:GetPhrase("radioSounds"))
	radioSoundsLabel:SetFont("JNVoiceMod.header")

	self.radioSounds = self:Add("JNVoiceMod.slider")
	local radioSounds = self.radioSounds
	radioSounds:Dock(TOP)
	radioSounds:DockMargin(8,4,8,0)
	radioSounds:Percentage(true)
	radioSounds:SetValue(JNVoiceMod.ClConfig.RadioSounds*100)
	radioSounds:SetDefaultValue(JNVoiceMod.ClConfig.RadioSounds*100)

	local div = self:Add("JNVoiceMod.div")
	div:Dock(TOP)
	div:DrawLine(false)


end

function PANEL:PerformLayout()

	self.colorPicker:SetTall(30)
	self.hudAlphaIdle:SetTall(30)
	self.hudAlphaTalk:SetTall(30)
	self.hudAlphaMode:SetTall(30)
	self.talkBindChanger:SetTall(30)


end

vgui.Register("JNVoiceMod.clientBody",PANEL,"DScrollPanel")

// Admin config menu, accesible via jnvmconfigmenu 
function JNVoiceMod:OpenConfigMenu()
    if IsValid(JNVoiceMod.ClConfig.frame) then JNVoiceMod.ClConfig.frame:Remove() end
	
    JNVoiceMod.ClConfig.frame = vgui.Create("JNVoiceMod.frame")
    local frame = JNVoiceMod.ClConfig.frame
    frame:SetSize(600,800)
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
		local body = s:GetParent().body
		return (tonumber(body.whisperSlider:GetValue()) <= 0 or
		tonumber(body.talkSlider:GetValue()) <= 0 or 
		tonumber(body.yellSlider:GetValue()) <= 0 ) 
	end
	footer.submitBtn.DoClick = function(s)
		local _lang,data = s:GetParent().body.langComboBox:GetSelected()
		local body = s:GetParent().body
		net.Start("jnvm_network")
			net.WriteInt(1,5)
			net.WriteInt(body.whisperSlider:GetValue(),16)
			net.WriteInt(body.talkSlider:GetValue(),16)
			net.WriteInt(body.yellSlider:GetValue(),16)
			net.WriteString(data)
			net.WriteBool(body.globalVoiceCheckbox:GetChecked())
			net.WriteBool(body.radioSoundsCheckbox:GetChecked())
			PrintTable(body.DefinedFrequencies) // todo nil

			net.WriteTable(body.DefinedFrequencies)
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
		local body = s:GetParent().body
		JNVoiceMod.ClConfig.Lang = ((JNVoiceMod.Lang[data] and data) or "EN-en")

		JNVoiceMod.ClConfig.IdleAlpha = body.hudAlphaIdle:GetValue()/100
		JNVoiceMod.ClConfig.TalkAlpha = body.hudAlphaTalk:GetValue()/100
		JNVoiceMod.ClConfig.ChngAlpha = body.hudAlphaMode:GetValue()/100
		
		JNVoiceMod.ClConfig.HudEnabled = body.hudEnabledCheckbox:GetChecked()

		JNVoiceMod.ClConfig.SphereEnabled = body.sphereEnabledCheckbox:GetChecked()
		JNVoiceMod.ClConfig.SphereAlpha = body.sphereAlpha:GetValue()/100

		JNVoiceMod.ClConfig.Bind = body.talkBindChanger:GetValue()
		JNVoiceMod.ClConfig.BindRadioMain = body.radioBindChangerMain:GetValue()
		JNVoiceMod.ClConfig.BindRadioAdd = body.radioBindChangerAdd:GetValue()
		JNVoiceMod.ClConfig.BindToggleRadio = body.radioBindChangerToggle:GetValue()

		JNVoiceMod.ClConfig.RadioVCMain = body.radioVCMain:GetValue()/100
		JNVoiceMod.ClConfig.RadioVCAdd = body.radioVCAdd:GetValue()/100

		JNVoiceMod.ClConfig.RadioSounds = body.radioSounds:GetValue()/100


		JNVoiceMod:ClConfigSave()
		JNVoiceMod.ClConfig.frame:Remove() 
	end
	
	// main body
	frame.body = frame:Add("JNVoiceMod.clientBody")
	local body = frame.body
	body:Dock(FILL)
	frame.footer.body = body


	
end


// Radio's gui
