local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Networking = require(ReplicatedStorage.Packages.Networking)
local DataManager = require(ServerStorage.Shared.Managers.DataManager)
local BreathingModules = require(ServerStorage.Shared.BreathingModules)

local SkillServiceServer = {}

function SkillServiceServer:Init()
	self.useSkillRE = Networking.Server:RegisterEvent("UseSkill", "RemoteEvent")
end

function SkillServiceServer:Start()
	self.useSkillRE.OnServerEvent:Connect(function(player, keyCode, mouseData)
		SkillServiceServer:RequestSkillUsage(player, keyCode, mouseData)
	end)
end 

function SkillServiceServer:RequestSkillUsage(player, keyCode, mouseData)
	if not player then return end
	if not keyCode then return end
	
	local data = DataManager:GetData(player)
	local race = DataManager:GetRace(player)
	local breathing = DataManager:GetBreathingStyle(player)
	
	local breathingMod = BreathingModules[race][breathing]
	
	for skill, tab in breathingMod do
		if keyCode == tab.Keybind then
			if data:GetAttribute("CurrentAttack") == "" and not data:GetAttribute(skill) then
				data:SetAttribute("CurrentAttack", skill)
				if tab.Cooldown then
					data:SetAttribute("Cooldown", true)
					data:SetAttribute(skill, true)
					task.delay(tab.Cooldown, function()
						data:SetAttribute("Cooldown", false)
						data:SetAttribute(skill, nil)
					end)
				end
				tab.func(player, data, mouseData)
				data:SetAttribute("CurrentAttack", "")
			end
		end
	end
	
end

return SkillServiceServer
