local SS = game:GetService("ServerStorage")

local swordStats = require(SS.Shared.Stats.SwordStats)

local animationEvents = {
	
	["Equip"] = function(player, char, data)
		local equippedSword = data.Weapon.Value
		local weaponModel = char:FindFirstChild("Sword")
		if swordStats[equippedSword].dual then
			local trail = weaponModel:FindFirstChild("Trail")
			local trail2 = weaponModel:FindFirstChild("Trail2")
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local eWeld2 = weaponModel:FindFirstChild("equippedWeld2")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			local ueWeld2 = weaponModel:FindFirstChild("inSheatheWeld2")
			
			trail.Enabled = true
			trail2.Enabled = true
			
			eWeld.Enabled = true 
			ueWeld.Enabled = false

			eWeld2.Enabled = true 
			ueWeld2.Enabled = false
		else
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			local trail = weaponModel:FindFirstChild("Trail")
			
			trail.Enabled = true
			eWeld.Enabled = true 
			ueWeld.Enabled = false 
		end
		char:SetAttribute("canDash", true)
		data:SetAttribute("Equipped", true)
	end,
	
	["Unequip"] = function(player, char, data)
		local equippedSword = data.Weapon.Value
		local weaponModel = char:FindFirstChild("Sword")
		if swordStats[equippedSword].dual then
			local trail = weaponModel:FindFirstChild("Trail")
			local trail2 = weaponModel:FindFirstChild("Trail2")
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local eWeld2 = weaponModel:FindFirstChild("equippedWeld2")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			local ueWeld2 = weaponModel:FindFirstChild("inSheatheWeld2")
			
			trail.Enabled = false
			trail2.Enabled = false
			
			eWeld.Enabled = false 
			ueWeld.Enabled = true 

			eWeld2.Enabled = false
			ueWeld2.Enabled = true
		else
			local trail = weaponModel:FindFirstChild("Trail")
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			
			trail.Enabled = false
			eWeld.Enabled = false 
			ueWeld.Enabled = true
		end
		data:SetAttribute("canDash", true)
		data:SetAttribute("Equipped", false)
	end,
	
}

return animationEvents
