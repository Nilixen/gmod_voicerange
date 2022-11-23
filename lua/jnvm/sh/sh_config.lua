// default config used only once when setting up the data. Can be edited ingame or in servers data(GarrysMod/garrysmod/data/<FileDir>/settings.txt) folder

JNVoiceMod.FileDir = "jnvm/"

JNVoiceMod.Config.Ranges = {
	[1] = {rng = 150},
	[2] = {rng = 250},
	[3] = {rng = 500},

}
JNVoiceMod.Config.Language = "EN-en"

// purely cosmetic, can be changed to whatever, but this will increase an amount of radio channels. 520-400 * 10 cuz, 1 decimal
JNVoiceMod.Config.FreqRange = {
	min = 400, //MHz
	max = 520, //MHz
}
// you can create and give access to these custom freqs eg. police radio encoded for police.
JNVoiceMod.Config.DefinedFreq = {
	["pd"] = {
		name = "Police"
	},
	["ems"] = {
		name = "EMS"
	},
	["gov"] = {
		name = "Government"
	},
}

// When player enables radio or talks on it or toggles it these sounds will be heareable by other nearby...
JNVoiceMod.Config.RadioSoundEffectsHeareableForOthers = true

// WHEN USING GAMEMODE OTHER THAN Terrortown (TTT) it will make that you can talk with somone close to you
JNVoiceMod.Config.GlobalVoice = false
