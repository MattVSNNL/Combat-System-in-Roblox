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
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local ignore = {}
	if char then table.insert(ignore, char) end
	if camera then table.insert(ignore, camera) end
	params.FilterDescendantsInstances = ignore
	params.IgnoreWater = true
	return params
end

FunctionsUtil.getMouseHit = function(mousePos, maxStudDistance : number, char)
	local v2 = FunctionsUtil.getViewportMouse()
	local ray = camera:ViewportPointToRay(v2.X, v2.Y)
	local params = FunctionsUtil.rayCastParams(char)
	local result = workspace:Raycast(ray.Origin, ray.Direction * maxStudDistance, params)
	if result then
		return CFrame.new(result.Position)
	end
	return nil
end

FunctionsUtil.getMouseTarget = function(mousePos, maxStudDistance : number, char)
	local v2 = FunctionsUtil.getViewportMouse()
	local ray = camera:ViewportPointToRay(v2.X, v2.Y)
	local params = FunctionsUtil.rayCastParams(char)
	local result = workspace:Raycast(ray.Origin, ray.Direction * maxStudDistance, params)
	if result then
		return result.Instance
	end
	return nil
end

return FunctionsUtil
