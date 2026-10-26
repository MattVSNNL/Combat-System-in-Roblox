local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local SSS = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")

local playerData = SS.PlayerData

local TemplateData = require(script.TemplateData)
local StateData = require(script.StateData)
local TypeChecker = require(RS.Shared.Modules.TypeChecker)
local SwordStats = require(SS.Shared.Stats.SwordStats)
local Owners = require(SS.Shared.Modules.Owners)
local CONFIG = require(SS.Shared.Modules.CONFIG)

local DataManager = {}

-- Store profiles from ProfileStore
DataManager.Profiles = {}

local TYPES = {
	NumberValue = TypeChecker.number,
	StringValue = TypeChecker.string,
	BoolValue = TypeChecker.boolean,
	Vector3Value = TypeChecker.Vector3,
	CFrameValue = TypeChecker.CFrame,
	Color3Value = TypeChecker.Color3,
	BrickColorValue = TypeChecker.BrickColor,
	InstanceValue = TypeChecker.Instance,
}

local function GetClassByType(data)
	for class, func in pairs(TYPES) do
		local success = func(data)
		if success then
			return class
		end
	end
	return nil
end

function DataManager:GetEquippedSword(player)
	return DataManager:GetData(player).Progression.Weapon.Value
end

function DataManager:GetRace(player)
	return DataManager:GetData(player).Race.Race.Value
end

function DataManager:GetBreathingStyle(player)
	return DataManager:GetData(player).Progression.Breathing.Value
end

function DataManager:GetData(player)
	local data = playerData:WaitForChild(player.Name, 10)
	if data then
		return data
	else
		warn(player.Name.."'s data is not found.")
	end
end

function DataManager:CheckIfBlacklisted(player, blacklist)
	--local state = StateManager:GetState(player.Character)
	--return blacklist[state]
	return true
end

function DataManager:SetBlocking(entity, val)
	if not entity then return end
	local player = Players:GetPlayerFromCharacter(entity)

	if player then
		local data = DataManager:GetData(player)
		if data then
			data:SetAttribute("Blocking", val)
		end
	else
		entity:SetAttribute("Blocking", val)
	end
end

function DataManager:CheckIfOwner(player)
	if not player then return false end
	for _, id in ipairs(Owners) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

function DataManager:GetKeybinds(player)
	if not player then return end
	
	local data = DataManager:GetData(player)
	if not data then return end
	
	local keybinds = {}
	
	for _, keybind in ipairs(data.Keybinds:GetChildren()) do
		if keybind:IsA("StringValue") then
			keybinds[keybind.Name] = keybind.Value
		end
	end
	
	return keybinds
end

function DataManager.Setup(player : Player, profile)
	
	-- Create folder for player data
	local data = Instance.new("Folder")
	data.Name = player.Name
	data.Parent = playerData
	
	-- Load in player data
	for name, tab in pairs(TemplateData) do
		if type(tab) == "table" then
			local folder = Instance.new("Folder")
			folder.Name = name
			folder.Parent = data
			for dataName, _ in pairs(tab) do
				local value = profile.Data[name][dataName]
				local class = GetClassByType(value)
				local nv = Instance.new(class)
				nv.Name = dataName
				nv.Value = value
				nv.Parent = folder
				nv:GetPropertyChangedSignal("Value"):Connect(function()
					profile.Data[name][dataName] = nv.Value
				end)
			end
		else
			local value = profile.Data[name]
			local class = GetClassByType(value)
			local nv = Instance.new(class)
			nv.Name = name
			nv.Value = value
			nv.Parent = data
			nv:GetPropertyChangedSignal("Value"):Connect(function()
				profile.Data[name] = nv.Value
			end)
		end
	end
	
	-- Load in temporary attributes
	for name, val in pairs(StateData) do
		data:SetAttribute(name, val)
	end
	
end

return DataManager
