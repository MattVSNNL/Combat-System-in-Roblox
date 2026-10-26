local SwordServerService = {}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local Assets = SS.Assets
local Animations = Assets.Animations

local Networking = require(RS.Packages.Networking)
local Signal = require(RS.Packages.Signal)
local DataManager = require(SS.Shared.Managers.DataManager)
local SwordStats = require(SS.Shared.Stats.SwordStats)

local AnimationModule = require(RS.Shared.Modules.AnimationModule)
local VelocityModule = require(RS.Shared.Modules.VelocityModule)

local CombatUtil = require(SS.Shared.Utilities.CombatUtil)
local SwordServer = require(RS.Shared.Systems.SwordSystem.Implementation.SwordServer)
local SwordConfig = require(RS.Shared.Systems.SwordSystem.SystemPackage.Config)

function SwordServerService:Init()
	self.equipRemote = Networking.Server:RegisterEvent("EquipSword", "RemoteEvent")
	self.m1 = Networking.Server:RegisterEvent("M1", "RemoteEvent")
end

function SwordServerService:Start()
	self.equipRemote.OnServerEvent:Connect(function(player)
		SwordServerService:HandleEquipRequest(player)
	end)
	self.m1.OnServerEvent:Connect(function(player)
		SwordServerService:HandleM1Request(player)
	end)
end

function SwordServerService:HandleEquipRequest(player)
	if not player then return end

	local char = player.Character
	if not char then return end

	local data = DataManager:GetData(player)
	if not data then return end

	local equippedSword = DataManager:GetEquippedSword(player)
	if not equippedSword then return end

	local swordData = SwordStats[equippedSword]
	if not swordData then return end
	
	if data:GetAttribute("IsEquipping") == true then return end
	if CombatUtil:CanEquip(player) then
		if not CombatUtil:IsEquipped(player) then
			SwordServerService:Equip(player, char)
		else
			SwordServerService:Unequip(player, char)
		end
	end
end

function SwordServerService:HandleM1Request(player)
	if not player then return end
	if not CombatUtil:CanAttack(player) then return end

	local char = player.Character
	if not char then return end

	local data = DataManager:GetData(player)
	if not data then return end

	local equippedSword = DataManager:GetEquippedSword(player)
	if not equippedSword or not CombatUtil:IsEquipped(player) then return end

	local swordData = SwordStats[equippedSword]
	if not swordData then return end

	if data:GetAttribute("Swinging") == true then return end
	if SwordStats[equippedSword] then
		SwordServerService:M1(player, char)
	end
end

function SwordServerService:Equip(player : Player, char : Model)
	if not player then return end
	if not char then return end

	local data = DataManager:GetData(player)
	if not data then return end

	local humanoid : Humanoid = char:FindFirstChild("Humanoid")

	local weaponModel = char:FindFirstChild("Sword")
	local equippedSword = DataManager:GetEquippedSword(player)

	if not SwordStats[equippedSword] or not weaponModel then return end

	local CurrentWeapon = weaponModel["Type"].Value
	local DualWeapon = weaponModel["Dual"].Value

	local anim = Animations[equippedSword].Equip
	local Track = AnimationModule.new(humanoid, anim)
	local marker = Track.track:GetMarkerReachedSignal("Equip")
	data:SetAttribute("canDash", false)
	
	data:SetAttribute("IsEquipping", true)
	Track.track.Looped = false
	Track:Play()
	marker:Once(function()
		if DualWeapon then
			local trail = weaponModel:FindFirstChild("Trail")
			local trail2 = weaponModel:FindFirstChild("Trail2")
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local eWeld2 = weaponModel:FindFirstChild("equippedWeld2")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			local ueWeld2 = weaponModel:FindFirstChild("inSheatheWeld2")
			trail.Enabled = true
			trail2.Enabled = true
			eWeld.Enabled = true 
			ueWeld.Enabled = false
			eWeld2.Enabled = true 
			ueWeld2.Enabled = false
		else
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			local trail = weaponModel:FindFirstChild("Trail")

			trail.Enabled = true
			eWeld.Enabled = true 
			ueWeld.Enabled = false 
		end
	end)
	Track.track.Ended:Once(function()
		data:SetAttribute("IsEquipping", false)
		char:SetAttribute("canDash", true)
		data:SetAttribute("Equipped", true)
	end)
	
end

function SwordServerService:Unequip(player : Player, char : Model)
	if not player then return end
	if not char then return end

	local data = DataManager:GetData(player)
	if not data then return end

	local humanoid : Humanoid = char:FindFirstChild("Humanoid")

	local weaponModel = char:FindFirstChild("Sword")
	local equippedSword = DataManager:GetEquippedSword(player)
	
	if not SwordStats[equippedSword] or not weaponModel then return end

	local CurrentWeapon = weaponModel["Type"].Value
	local DualWeapon = weaponModel["Dual"].Value

	local anim = Animations[equippedSword].UnEquip
	local Track = AnimationModule.new(humanoid, anim)
	local marker = Track.track:GetMarkerReachedSignal("Un-Equip")
	data:SetAttribute("canDash", false)

	data:SetAttribute("IsEquipping", true)
	Track.track.Looped = false
	Track:Play()
	marker:Once(function()
		if DualWeapon then
			local trail = weaponModel:FindFirstChild("Trail")
			local trail2 = weaponModel:FindFirstChild("Trail2")
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local eWeld2 = weaponModel:FindFirstChild("equippedWeld2")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")
			local ueWeld2 = weaponModel:FindFirstChild("inSheatheWeld2")

			trail.Enabled = false
			trail2.Enabled = false

			eWeld.Enabled = false 
			ueWeld.Enabled = true 

			eWeld2.Enabled = false
			ueWeld2.Enabled = true
		else
			local trail = weaponModel:FindFirstChild("Trail")
			local eWeld = weaponModel:FindFirstChild("equippedWeld")
			local ueWeld = weaponModel:FindFirstChild("inSheatheWeld")

			trail.Enabled = false
			eWeld.Enabled = false 
			ueWeld.Enabled = true
		end
	end)
	Track.track.Ended:Once(function()
		data:SetAttribute("IsEquipping", false)
		char:SetAttribute("canDash", true)
		data:SetAttribute("Equipped", false)
	end)

end

function SwordServerService:M1(player : Player, char : Model)
	print("M1")
	
	local data = DataManager:GetData(player)
	if not data then return end
	
	data:SetAttribute("Swinging", true)
	
	local equippedSword = DataManager:GetEquippedSword(player)
	local combo = data:GetAttribute("Combo")
	local range = data:GetAttribute("Range")
	
	local maxCombos = SwordConfig.MAX_COMBOS
	local comboResetTime = SwordStats[equippedSword].speed + 1
	
	local enemy = CombatUtil:GetClosestRig(player, range)
	
	combo += 1
	
	if enemy then
		print("Enemy found")
		local isBlocking = CombatUtil:IsBlocking(enemy)
		local isBehind = CombatUtil:IsBehind(char, enemy)
		if not isBlocking or isBehind then
			if isBehind then
				DataManager:SetBlocking(enemy, false)
			end
			enemy.Humanoid:TakeDamage(SwordStats[equippedSword].dmg)
			if combo >= maxCombos then
				VelocityModule:ApplyForce(enemy.HumanoidRootPart, 10, char.HumanoidRootPart.CFrame.LookVector)
			end
		end
	end
	
	if combo >= maxCombos then
		data:SetAttribute("Combo", 0)
	else
		data:SetAttribute("Combo", combo)
	end
	
	local name = "LightSlice"..tostring(combo)
	local anim = Animations[equippedSword][name]
	local Track:AnimationTrack = AnimationModule.new(char:FindFirstChild("Humanoid"), anim)
	Track:Play()
	
	local currentCombo = combo
	task.delay(comboResetTime, function()
		if data:GetAttribute("Combo") == currentCombo then
			data:SetAttribute("Combo", 0)
		end
	end)
	
	task.delay(0.4, function()
		data:SetAttribute("Swinging", false)
		--State manager set char to idle
	end)
	
end

return SwordServerService
