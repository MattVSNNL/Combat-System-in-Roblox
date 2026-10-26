local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local Networking = require(ReplicatedStorage.Packages.Networking)
local FunctionsUtil = require(ReplicatedStorage.Shared.Utilities.FunctionsUtil)

local maxStudDistance = 1000

local SkillServiceClient = {}

function SkillServiceClient:Init()
	self.useSkillRE = Networking:GetEvent("UseSkill")
end

function SkillServiceClient:RequestSkill(char, keyCode)
	local mouseHitPos = FunctionsUtil.getMouseHit(UIS:GetMouseLocation(), maxStudDistance, char)
	local mouseTarget = FunctionsUtil.getMouseTarget(UIS:GetMouseLocation(), maxStudDistance, char)
	self.useSkillRE:FireServer(keyCode, {Pos = mouseHitPos, Target = mouseTarget})
end

return SkillServiceClient
