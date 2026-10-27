local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local camera = workspace.CurrentCamera

local Networking = require(ReplicatedStorage.Packages.Networking)
local SkillServiceClient = require("../SystemPackage/SkillServiceClient")

local SkillClient = {}

function SkillClient:Init()
	self.player = Players.LocalPlayer
	self.char = self.player.Character or self.player.CharacterAdded:Wait()
	self.keybinds = Networking:GetEvent("GetKeybinds"):InvokeServer()
	self.skillKeys = {
		self.keybinds.SkillKey1,
		self.keybinds.SkillKey2,
		self.keybinds.SkillKey3,
		self.keybinds.SkillKey4,
		self.keybinds.SkillKey5,
	}
end

function SkillClient:Start()
	UIS.InputBegan:Connect(function(key, gameProcessed)
		if gameProcessed then
			return
		end
		
		if key.UserInputType == Enum.UserInputType.MouseButton1 then
			SkillServiceClient:RequestSkill(self.char, key.UserInputType)
		end
		
		for _, keyBind in self.skillKeys do
			if key.KeyCode == Enum.KeyCode[keyBind] then
				SkillServiceClient:RequestSkill(self.char, key.KeyCode)
			end
		end
	end)
end

return SkillClient
