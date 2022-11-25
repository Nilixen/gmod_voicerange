SWEP.PrintName = "Advanced Radio"
SWEP.Author = "Nilixen"
SWEP.Contact = "/nilixen"
SWEP.Instructions = "Press R to open radio's interface\nLLM to toggle on/off"
SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 5
SWEP.SlotPos = 10
SWEP.ViewModel = "models/radio/c_radio.mdl"
SWEP.WorldModel = "models/radio/w_radio.mdl"

SWEP.Primary = {
    Ammo = "none",
    Automatic = false,
    ClipSize = -1,
    DefaultClip = -1,
}

SWEP.Secondary = {
    Ammo = "none",
    Automatic = false,
    ClipSize = -1,
    DefaultClip = -1,
}

function SWEP:Initialize()
    self:GetOwner():SetNWBool("JNVoiceModRadioEnabled",false)
end


function SWEP:PrimaryAttack()

    self:GetOwner():SetNWBool("JNVoiceModRadioEnabled",!self:GetOwner():GetNWBool("JNVoiceModRadioEnabled",false))
    JNVoiceMod:ToggleRadioSound(self:GetOwner())

end

function SWEP:SecondaryAttack()
    
end

function SWEP:Reload()
    if CLIENT then
        JNVoiceMod:OpenRadioGui(1)
    end
end