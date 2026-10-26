local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local Networking = require(RS.Packages.Networking)
local Signal = require(RS.Packages.Signal)

local SwordClientService = require("../SystemPackage/SwordClientService")

local SwordClient = {}

function SwordClient:Init()
	print(script.Name.." has initialized")
end

function SwordClient:Start()
	UIS.InputBegan:Connect(function(key, gameProcessed)
		if gameProcessed then return end
		if key.KeyCode == Enum.KeyCode.V then
			SwordClientService:RequestToggleEquip()
		end
	end)
	UIS.InputBegan:Connect(function(key, gameProcessed)
		if gameProcessed then return end
		if key.UserInputType == Enum.UserInputType.MouseButton1 then
			SwordClientService:RequestM1()
		end
	end)
end

return SwordClient
