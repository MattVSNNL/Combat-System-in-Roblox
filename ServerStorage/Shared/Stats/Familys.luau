local module = {}

module.familyValues = {
	-- Secret Families
	["Tsugikuni"] = {
		Name = "Tsugikuni",
		rarity = "Secret",
		SwordDmg = 1.5,
		Health = 125,
		Speed = 10,
		Strength = 10,
		Breathing = 10,
		BloodDemonArt = 10,
		SunLightImmunity = false
	},
	["Kamado"] = {
		Name = "Kamado",
		rarity = "Secret",
		SwordDmg = 1.45,
		Health = 120,
		Speed = 9,
		Strength = 9,
		Breathing = 9,
		BloodDemonArt = 8,
		SunLightImmunity = true
	},

	-- Mythical Families (Hashira)
	["Rengoku"] = {
		Name = "Rengoku",
		rarity = "Mythical",
		SwordDmg = 1.35,
		Health = 115,
		Speed = 8,
		Strength = 9,
		Breathing = 9,
		BloodDemonArt = 5,
		SunLightImmunity = false
	},
	["Tokito"] = {
		Name = "Tokito",
		rarity = "Mythical",
		SwordDmg = 1.35,
		Health = 110,
		Speed = 9,
		Strength = 8,
		Breathing = 9,
		BloodDemonArt = 4,
		SunLightImmunity = false
	},
	["Uzui"] = {
		Name = "Uzui",
		rarity = "Mythical",
		SwordDmg = 1.35,
		Health = 110,
		Speed = 9,
		Strength = 8,
		Breathing = 8,
		BloodDemonArt = 4,
		SunLightImmunity = false
	},
	["Himejima"] = {
		Name = "Himejima",
		rarity = "Mythical",
		SwordDmg = 1.35,
		Health = 120,
		Speed = 7,
		Strength = 10,
		Breathing = 9,
		BloodDemonArt = 5,
		SunLightImmunity = false
	},

	-- Legendary Families
	["Agatsuma"] = {
		Name = "Agatsuma",
		rarity = "Legendary",
		SwordDmg = 1.25,
		Health = 105,
		Speed = 9,
		Strength = 7,
		Breathing = 8,
		BloodDemonArt = 3,
		SunLightImmunity = false
	},
	["Hashibira"] = {
		Name = "Hashibira",
		rarity = "Legendary",
		SwordDmg = 1.25,
		Health = 110,
		Speed = 8,
		Strength = 9,
		Breathing = 7,
		BloodDemonArt = 2,
		SunLightImmunity = false
	},

	-- Epic Families
	["Kuwajima"] = {
		Name = "Kuwajima",
		rarity = "Epic",
		SwordDmg = 1.15,
		Health = 100,
		Speed = 7,
		Strength = 7,
		Breathing = 7,
		BloodDemonArt = 2,
		SunLightImmunity = false
	},

	-- Uncommon Families
	["Kanzaki"] = {
		Name = "Kanzaki",
		rarity = "Uncommon",
		SwordDmg = 1.1,
		Health = 95,
		Speed = 6,
		Strength = 6,
		Breathing = 6,
		BloodDemonArt = 1,
		SunLightImmunity = false
	},

	-- Common Families
	["Haganezuka"] = {
		Name = "Haganezuka",
		rarity = "Common",
		SwordDmg = 1.0,
		Health = 90,
		Speed = 5,
		Strength = 5,
		Breathing = 0,
		BloodDemonArt = 0,
		SunLightImmunity = false
	},
	["Takada"] = {
		Name = "Takada",
		rarity = "Common",
		SwordDmg = 1.0,
		Health = 90,
		Speed = 4,
		Strength = 4,
		Breathing = 0,
		BloodDemonArt = 0,
		SunLightImmunity = false
	},
}


module.raritiesFamily = {
	["Tsugikuni"] = 0.1,
	["Kamado"] = 0.2,

	-- Elite Hashira families
	["Rengoku"] = 0.5,
	["Tokito"] = 0.5,
	["Tomioka"] = 0.5,
	["Uzui"] = 0.5,
	["Kanroji"] = 0.5,
	["Kocho"] = 0.5,
	["Iguro"] = 0.5,
	["Shinazugawa"] = 0.5,
	["Himejima"] = 0.5,

	-- Strong side characters
	["Hashibira"] = 1,
	["Agatsuma"] = 1,
	["Tsuyuri"] = 1,

	-- Mentors & common
	["Kuwajima"] = 8,
	["Kanzaki"] = 10,
	["Haganezuka"] = 15,
	["Takada"] = 34.7,
}

module.RandomFamily = function()
	local RandomN = math.random(1, 100)
	local counter = 0

	for Name, Rarity in pairs(module.raritiesFamily) do
		counter = counter + Rarity
		if RandomN <= counter then
			return tostring(Name), module.familyValues[Name]
		end
	end
end

return module
