local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local assets = SS.Assets
local VFX = assets.VFX

local vfx = {}
vfx.__index = vfx

function vfx.new(vfxPart, location, parent)
	if not vfxPart or not parent then return end
	
	local self = setmetatable({}, vfx)
	self.parent = parent
	
	-- Update Location
	if typeof(location) == "Instance" and location:IsA("BasePart") then
		self.location = location -- Put it on the same location as a part
	elseif typeof(location) == "CFrame" then
		self.location = location -- Incase you wanna put it anywhere
	else
		self.location = nil -- Incase the VFX part is in a part, then it doesn't need a location
	end
	
	-- Clone part and put it in wherever
	local clonedPart = vfxPart:Clone()
	if self.location then
		clonedPart.CFrame = self.location
	end
	clonedPart.Parent = self.parent
	self.vfx = clonedPart
	
	return self
end

function vfx:EmitAll()
	if not self.vfx then return end
	
	if not self._cachedEmitters then
		self._cachedEmitters = {}
		if self.vfx:IsA("ParticleEmitter") then
			table.insert(self._cachedEmitters, self.vfx)
		elseif self.vfx:IsA("BasePart") or self.vfx:IsA("Attachment") then
			for _, obj in ipairs(self.vfx:GetDescendants()) do
				if obj and obj:IsA("ParticleEmitter") or obj:IsA("Beam") then
					table.insert(self._cachedEmitters, obj)
				end
			end
		end
	end
	
	for _, emitter in ipairs(self._cachedEmitters) do
		if emitter and emitter.Parent then
			if emitter:IsA("ParticleEmitter") then
				local count = emitter:GetAttribute("EmitCount")
				if count then
					emitter:Emit(count)
				else
					warn(emitter.Name.." has no EmitCount")
				end
			elseif emitter:IsA("Beam") then
				emitter.Enabled = true
			end
		end
	end
	
end

function vfx:Destroy()
	if self.vfx then
		self.vfx:Destroy()
		self.vfx = nil
	end
end

return vfx
