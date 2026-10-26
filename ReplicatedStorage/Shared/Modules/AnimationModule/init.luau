local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")

local animationsFolderSS = SS:WaitForChild("Assets"):WaitForChild("Animations")

local animation = {}
animation.__index = animation

local animatorCache = {}
local preloadedHumanoids: {[Humanoid]: boolean} = {}

local function getAnimator(humanoid : Humanoid): Animator
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	return animator
end

function animation.new(humanoid, anim : Animation, waitTillFinished)
	if not humanoid or not anim then return end
	if anim.AnimationId == "" then return end
	
	local self = setmetatable({}, animation)
	self.humanoid = humanoid
	self.anim = anim
	self.waitsTillFinished = waitTillFinished or false
	
	local id = self.anim.AnimationId
	local animator = getAnimator(humanoid)
	
	animatorCache[humanoid] = animatorCache[humanoid] or {}
	
	local success, errorMsg = pcall(function()
		if animatorCache[humanoid][id] then
			self.track = animatorCache[humanoid][id]
		else
			local track = animator:LoadAnimation(anim)
			animatorCache[humanoid][id] = track
			self.track = track
		end
	end)
	
	if not success then warn(errorMsg) end
	
	return self
end

function animation:Play(keyframeCallback: ((string) -> ())?)
	if not self.track then return end
	
	if keyframeCallback then
		if self._keyframeConn then
			self._keyframeConn:Disconnect()
		end
		self._keyframeConn = self.track.KeyframeReached:Connect(keyframeCallback)
	end
	
	if self.track.IsPlaying then
		self.track:Stop()
	end
	
	self.track:Play()
	
	if self.waitsTillFinished then
		self.track.Stopped:Wait()
	end
end

function animation:Stop()
	if self.track and self.track.IsPlaying then
		self.track:Stop()
	end
end

function animation:Destroy()
	if self._keyframeConn then
		self._keyframeConn:Disconnect()
		self._keyframeConn = nil
	end
	table.clear(self)
end

function animation.ClearPlayerCache(char)
	if not char then return end
	
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	if animatorCache[humanoid] then
		animatorCache[humanoid] = nil
	end
	if preloadedHumanoids[humanoid] then
		preloadedHumanoids[humanoid] = nil
	end
end

function animation.PreloadAnimations(humanoid)
	local success, errorMsg = pcall(function()
		if not humanoid then return end
		if preloadedHumanoids[humanoid] then return end
		preloadedHumanoids[humanoid] = true

		local animator = getAnimator(humanoid)
		if not animator then return end

		animatorCache[humanoid] = animatorCache[humanoid] or {}

		local function loadFolder(folder)
			for _, anim in ipairs(folder:GetDescendants()) do
				if anim and anim:IsA("Animation") then
					local id = anim.AnimationId
					if id ~= "" and not animatorCache[humanoid][id] then
						local track = animator:LoadAnimation(anim)
						animatorCache[humanoid][anim.AnimationId] = track
						track:Play()
						track:Stop()
					end
				end
			end
		end

		task.defer(function()
			loadFolder(animationsFolderSS)
		end)
	end)
	if not success then warn(errorMsg) end
end

return animation
