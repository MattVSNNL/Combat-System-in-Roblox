-- Services
local PlayersService = game:GetService("Players")
local SS = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

-- ProfileStore
local DataManager = require(SS.Shared.Managers.DataManager)
local ProfileStore = require(SS.Shared.Managers.DataManager.ProfileStore)
local TemplateData = require(SS.Shared.Managers.DataManager.TemplateData)
local CONFIG = require(SS.Shared.Modules.CONFIG)

local function GetStoreName()
	return RunService:IsStudio() and "Test" or "Live"
end

-- Access profile store
local PlayerStore = ProfileStore.New(GetStoreName(), TemplateData)

-- Creates and stores a profile
local function PlayerAdded(player : Player)
	
	-- Start a new profile session
	local profile = PlayerStore:StartSessionAsync("Player_"..player.UserId, {
		Cancel = function()
			return player.Parent ~= PlayersService
		end,
	})
	
	-- Sanity check to ensure profile exists
	if profile then
		profile:AddUserId(player.UserId) -- GDPR Compliance
		profile:Reconcile() -- Fill in missing data variables from the template
		
		-- Handles session-locking
		profile.OnSessionEnd:Connect(function()
			DataManager.Profiles[player] = nil
			player:Kick(CONFIG.ERROR_MSG)
		end)
		
		-- Save profile for later use
		if player.Parent == PlayersService then
			DataManager.Profiles[player] = profile
			DataManager.Setup(player, profile)
		else
			profile:EndSession()
		end
		
	else
		player:Kick(CONFIG.ERROR_MSG)
	end
	
end

-- Early joiners
for _, player in PlayersService:GetPlayers() do
	task.spawn(PlayerAdded, player)
end
PlayersService.PlayerAdded:Connect(PlayerAdded)
PlayersService.PlayerRemoving:Connect(function(player)
	local profile = DataManager.Profiles[player]
	if not profile then return end
	profile:EndSession()
	DataManager.Profiles[player] = nil
end)