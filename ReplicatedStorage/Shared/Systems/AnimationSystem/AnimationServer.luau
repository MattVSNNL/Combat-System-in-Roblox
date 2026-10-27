local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimationModule = require(ReplicatedStorage.Shared.Modules.AnimationModule)

local AnimationServer = {}

local function preloadAnimations(char : Model)
	if not char then
		return
	end
	
	AnimationModule.PreloadAnimations(char:WaitForChild("Humanoid"))
	print("Loaded Animations!")
end

local function clearAnimations(char: Model)
	local humanoid = char:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end
	
	AnimationModule.ClearPlayerCache(humanoid)
end

local function setup(player : Player)
	if not player then
		return
	end

	player.CharacterAdded:Connect(preloadAnimations)
	player.CharacterRemoving:Connect(clearAnimations)
	
	if not player.Character then
		return
	end
	
	preloadAnimations(player.Character)
end

function AnimationServer:Start()
	Players.PlayerAdded:Connect(setup)
	
	for _, player in ipairs(Players:GetPlayers()) do
		setup(player)
	end
end

return AnimationServer
