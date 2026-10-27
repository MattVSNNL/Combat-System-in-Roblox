local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

local DataManager = require(ServerStorage.Shared.Managers.DataManager)
local CONFIG = require(ServerStorage.Shared.Modules.CONFIG)

local CombatUtil = {}

function CombatUtil:IsEquipped(player)
	return DataManager:GetData(player):GetAttribute("Equipped")
end

function CombatUtil:CanEquip(player)
	if not player then
		return true
	end
	
	return DataManager:CheckIfBlacklisted(player, {
		Attacking = true,
		Blocking = true,
		Parrying = true,
		Stunned = true,
	})
end

function CombatUtil:CanAttack(player)
	if not player then
		return true
	end
	
	return DataManager:CheckIfBlacklisted(player, {
		Attacking = true,
		Blocking = true,
		Parrying = true,
		Dashing = true,
		Stunned = true,
	})
end

function CombatUtil:GetClosestRig(player, range)
	local char = player.Character
	if not player or not char then
		return
	end

	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return
	end

	local closestRig = nil
	local closestDistance = range

	-- a table of all potential targets
	local targets = {}

	-- Add all players in the table
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr and plr ~= player and plr.Character then
			table.insert(targets, plr.Character)
		end
	end

	-- Add all NPCS in the table
	local npcs = CollectionService:GetTagged(CONFIG.NPC_TAG)
	if npcs then
		for _, npc in ipairs(npcs) do
			if not npc:IsA("Model") then
				continue
			end
			
			if not npc:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if not npc:FindFirstChild("Humanoid") then
				continue
			end
			
			if npc:GetAttribute("CanDamage") ~= true then
				continue
			end
			
			table.insert(targets, npc)
		end
	end

	-- Loop through the targets table to see who's the closest
	for _, rig in ipairs(targets) do
		local hrp = rig:FindFirstChild("HumanoidRootPart")
		if not hrp then
			continue
		end
		
		local distance = (hrp.Position - rootPart.Position).Magnitude
		if distance <= range and distance < closestDistance then
			closestRig = rig
			closestDistance = distance
		end
	end

	return closestRig
end

function CombatUtil:IsBlocking(entity)
	if not entity then return end
	local player = Players:GetPlayerFromCharacter(entity)

	if player then
		local data = DataManager:GetData(player)
		if data then
			return data:GetAttribute("Blocking")
		end
	else
		return entity:GetAttribute("Blocking")
	end
end

function CombatUtil:IsBehind(char: Model, entity : Model)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local entityHRP = entity:FindFirstChild("HumanoidRootPart")
	if not hrp or not entityHRP then return end

	local entityLook = entityHRP.CFrame.LookVector
	local dirToChar = (entityHRP.Position - hrp.Position).Unit

	return entityLook:Dot(dirToChar) > 0
end

function CombatUtil:CanHit(char, enemy, range : number, limit : number)
	if not char or not enemy then return end

	local rootPart = char:FindFirstChild("HumanoidRootPart")
	local rigRootPart = enemy:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rigRootPart then return end

	local lookVector = rootPart.CFrame.LookVector
	local directionToEnemy = rigRootPart.Position - rootPart.Position

	local distance = directionToEnemy.Magnitude
	if distance > range then
		return false
	end
	-- Safe guard against zero-length vectors, otherwise if two players almost have the same position, it'll basically divide by 0, which'll error.
	if distance < 0.001 then
		return true
	end

	local normalized = directionToEnemy.Unit
	local dot = lookVector:Dot(normalized)
	local angle = math.deg(math.acos(dot))

	return angle <= limit
end

return CombatUtil
