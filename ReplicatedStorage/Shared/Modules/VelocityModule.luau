local velocity = {}

function velocity:ApplyForce(part, distance, direction, duration)
	if not part or not part:IsA("BasePart") then return end
	if not distance then return end
	if not duration then duration = 0.5 end
	if not direction then direction = "Forward" end

	local look = part.CFrame.LookVector
	local right = part.CFrame.RightVector
	local dirVector

	if direction == "Forward" then
		dirVector = look
	elseif direction == "Back" or direction == "Backward" then
		dirVector = -look
	elseif direction == "Left" then
		dirVector = -right
	elseif direction == "Right" then
		dirVector = right
	elseif typeof(direction) == "Vector3" then
		dirVector = direction.Unit
	else
		return
	end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	if part.Parent:IsA("Model") then
		params.FilterDescendantsInstances = {part.Parent}
	else
		params.FilterDescendantsInstances = {part}
	end
	
	local function rayCast(origin, remainingDistance)
		local result = workspace:Raycast(origin, dirVector * remainingDistance, params)

		if result then
			if result.Instance.CanCollide then
				return math.max((result.Position - part.Position).Magnitude - 2, 0)
			else
				table.insert(params.FilterDescendantsInstances, result.Instance)
				return rayCast(result.Position + dirVector * 0.05, remainingDistance)
			end
		end

		return remainingDistance
	end

	distance = rayCast(part.Position, distance)
	
	if distance <= 0 then return end

	local targetPos = part.Position + dirVector * distance

	local att0 = part:FindFirstChild("DashAttachment") :: Attachment
	if not att0 then
		att0 = Instance.new("Attachment")
		att0.Name = "DashAttachment"
		att0.Parent = part
	end

	local align = Instance.new("AlignPosition")
	align.Name = "DashForce"
	align.Mode = Enum.PositionAlignmentMode.OneAttachment
	align.Attachment0 = att0
	align.Position = targetPos
	align.ApplyAtCenterOfMass = true
	align.RigidityEnabled = false
	align.MaxForce = math.huge
	align.MaxVelocity = math.huge
	align.Responsiveness = math.max(50, distance / duration * 2)
	align.Parent = part
	part.AssemblyLinearVelocity = Vector3.new(0, part.AssemblyLinearVelocity.Y, 0)
	
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		if (part.Position - targetPos).Magnitude < 1 then
			if align then align:Destroy() end
			if connection then connection:Disconnect() end
		end
	end)
	
	task.delay(duration + 0.1, function()
		if align then align:Destroy() end
		if connection then connection:Disconnect() end
	end)
	
end

return velocity
