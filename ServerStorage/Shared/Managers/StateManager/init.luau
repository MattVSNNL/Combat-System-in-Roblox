local StateManager = {}
local Players = game:GetService("Players")
local SS = game:GetService("ServerStorage")

local playerData = SS:WaitForChild("PlayerData")

local states = require(script.States)

function StateManager:SetState(entity, stateName)
	if not entity or not stateName then
		return
	end

	local data
	if Players:GetPlayerFromCharacter(entity) then
		data = playerData:FindFirstChild(entity.Name)
	else
		data = entity
	end
	
	if not data then
		return
	end

	data:SetAttribute("CurrentState", stateName)
	states[stateName](data)
end

function StateManager:GetState(entity)
	if not entity then
		return
	end

	local data
	if Players:GetPlayerFromCharacter(entity) then
		data = playerData:FindFirstChild(entity.Name)
	else
		data = entity
	end

	if data then
		return data:GetAttribute("CurrentState")
	end

	return nil
end

return StateManager
