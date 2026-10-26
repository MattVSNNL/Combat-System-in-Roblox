local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimationModule = require(ReplicatedStorage.Shared.Modules.AnimationModule)

local AnimationServer = {}

local function preloadAnimations(char)
	AnimationModule.PreloadAnimations(char:WaitForChild("Humanoid"))
	print("Loaded Animations!")
end

local function clearAnimations(char: Model)
	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid then
		AnimationModule.ClearPlayerCache(humanoid)
	end
end

function AnimationServer:Start()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(char)
			preloadAnimations(char)
		end)
		
		player.CharacterRemoving:Connect(function(char)
			clearAnimations(char)
		end)
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			preloadAnimations(player.Character)
		end

		player.CharacterAdded:Connect(function(char)
			preloadAnimations(char)
		end)
		
		player.CharacterRemoving:Connect(function(char)
			clearAnimations(char)
		end)
	end
end

return AnimationServer
