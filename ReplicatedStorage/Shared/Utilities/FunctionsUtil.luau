local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local camera = workspace.CurrentCamera

local FunctionsUtil = {}

FunctionsUtil.getViewportMouse = function()
	local mouse = UIS:GetMouseLocation()
	local inset = GuiService:GetGuiInset()
	
	return Vector2.new(mouse.X - inset.X, mouse.Y - inset.Y)
end

FunctionsUtil.rayCastParams = function(char : Model)
	if not char then
		return
	end
	
	if not camera then
		return
	end
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local ignore = {}
	table.insert(ignore, char)
	table.insert(ignore, camera)
	params.FilterDescendantsInstances = ignore
	params.IgnoreWater = true
	
	return params
end

FunctionsUtil.getMouseHit = function(mousePos, maxStudDistance : number, char)
	local v2 = FunctionsUtil.getViewportMouse()
	local ray = camera:ViewportPointToRay(v2.X, v2.Y)
	local params = FunctionsUtil.rayCastParams(char)
	local result = workspace:Raycast(ray.Origin, ray.Direction * maxStudDistance, params)
	if not result then
		return nil
	end
	
	return CFrame.new(result.Position)
end

FunctionsUtil.getMouseTarget = function(mousePos, maxStudDistance : number, char)
	local v2 = FunctionsUtil.getViewportMouse()
	local ray = camera:ViewportPointToRay(v2.X, v2.Y)
	local params = FunctionsUtil.rayCastParams(char)
	local result = workspace:Raycast(ray.Origin, ray.Direction * maxStudDistance, params)
	if not result then
		return nil
	end

	return result.Instance
end

return FunctionsUtil
