local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local DataManager = require(ServerStorage.Shared.Managers.DataManager)
local Networking = require(ReplicatedStorage.Packages.Networking)

local SkillServer = {}

function SkillServer:Init()
	self.keybinds = Networking.Server:RegisterEvent("GetKeybinds", "RemoteFunction")
end

function SkillServer:Start()
	self.keybinds.OnServerInvoke = function(player)
		return DataManager:GetKeybinds(player)
	end
end

return SkillServer
