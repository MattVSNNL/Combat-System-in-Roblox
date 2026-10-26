local SwordClientService = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networking = require(ReplicatedStorage.Packages.Networking)

function SwordClientService:Init()
	self.equipRemote = Networking:GetEvent("EquipSword")
	self.m1 = Networking:GetEvent("M1")
end

function SwordClientService:RequestToggleEquip()
	self.equipRemote:FireServer()
end

function SwordClientService:RequestM1()
	self.m1:FireServer()
end

return SwordClientService
