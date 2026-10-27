local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local DataManager = require(SS.Shared.Managers.DataManager)
local SwordStats = require(SS.Shared.Stats.SwordStats)

local SwordServer = {}

local function SetupSword(player, char)
	
	task.wait() -- Wait for the game to load
	if not player then
		return
	end
	
	local data = DataManager:GetData(player)
	if not data then
		return
	end
	
	if not char then
		return
	end
	
	local playerSword = SS.Assets.Swords[DataManager:GetEquippedSword(player)]
	if not playerSword then
		return
	end

	if char:FindFirstChild("Sword") then
		return
	end

	local sword = playerSword:Clone()
	sword.Name = "Sword"
	sword.Parent = char

	local eWeld:Motor6D = sword.equippedWeld
	local ueWeld:Weld = sword.inSheatheWeld
	local tWeld:Motor6D = sword.torsoWeld

	local isDual = SwordStats[data.Progression.Weapon.Value].dual

	if isDual then
		-- Enable dual wield
		local eWeld2:Motor6D = sword.equippedWeld2
		local ueWeld2:Weld = sword.inSheatheWeld2
		
		eWeld2.Part0 = char:FindFirstChild("Right Arm")
		eWeld2.Enabled = false
		ueWeld2.Enabled = true
		
		eWeld.Part0 = char:FindFirstChild("Left Arm")
		eWeld.Enabled = false
		ueWeld.Enabled = true
	else
		-- Just regular sword
		eWeld.Part0 = char:FindFirstChild("Right Arm")
		eWeld.Enabled = false
		ueWeld.Enabled = true
	end
	tWeld.Part0 = char:FindFirstChild("Torso")
	tWeld.Enabled = true
end

local function setup(player : Player)
	if not player then
		return
	end

	player.CharacterAdded:Connect(SetupSword(player, player.Character))
	if not player.Character then
		return
	end

	SetupSword(player, player.Character)
end

function SwordServer:Init()
	
end

function SwordServer:Start()
	Players.PlayerAdded:Connect(setup)
	
	for _, player in ipairs(Players:GetPlayers()) do
		setup(player)
	end
end

return SwordServer
