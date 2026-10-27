local PlayersService = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local TS = game:GetService("TweenService")

local VFX = SS.Assets.VFX
local animations = SS.Assets.Animations

local VFXModule = require(RS.Shared.Modules.VFXModule)
local AnimationModule = require(RS.Shared.Modules.AnimationModule)
local VelocityModule = require(RS.Shared.Modules.VelocityModule)

function checkIfHumanoid(target)
	if not target:FindFirstAncestorOfClass("Model") then
		return false
	end
	
	local model = target:FindFirstAncestorOfClass("Model")
	if not model:FindFirstChildOfClass("Humanoid") then
		return false
	end
	
	return true, model
end

local module = {

	["Thunderclap"] = {
		Keybind = Enum.KeyCode.E,
		Cooldown = 10,
		func = function(player, data)

			local distance = 69
			local hitboxAmount = 6
			local chargeDuration = 0.8
			local timeToDash = 0.2

			local char = player.Character
			local hrp = char.HumanoidRootPart
			local hum = char.Humanoid

			if data:GetAttribute("CombatDisable") then return end

			hum.AutoRotate = false
			hum.WalkSpeed = 0
			--stateManager:SetState(char, "Attacking")

			-- Play the animation
			--local anim = animModule.new(hum, animations.Skills.Thundercharge.Charge)
			--anim:Play()

			-- Spawn in the effect
			local chargeCFrame = hrp.CFrame - Vector3.new(0, 5, 0)
			local thunderChargePart = VFXModule.new(VFX.Thunder.ThunderForm1.Thundercharge.ThunderChargePart, chargeCFrame, char)
			task.wait(chargeDuration)

			-- Cleanup
			thunderChargePart:Destroy()

			-- Spawn dash trail
			local trailCFrame = hrp.CFrame * CFrame.new(0, 0, -30)
			local thunderChargeTrail = VFXModule.new(VFX.Thunder.ThunderForm1.Thundercharge.ThunderChargeTrail, trailCFrame, char)

			VelocityModule:ApplyForce(hrp, distance, "Forward")

			task.delay(0.03, function()
				thunderChargeTrail:EmitAll() -- Emits the trail
			end)

			task.wait(0.7)
			--stateManager:SetState(char, "Idle")

			-- Clean up the trail
			task.delay(1, function()
				thunderChargeTrail:Destroy()
			end)
			hum.WalkSpeed = data:GetAttribute("WalkSpeed")
			hum.AutoRotate = true

		end,
	},
	["Skill2"] = {
		Keybind = Enum.KeyCode.R,
		Cooldown = 5,
		func = function(player, data)
			print("skill2")
		end,
	}

}

return module
