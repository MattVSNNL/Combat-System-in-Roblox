local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local RF = game:GetService("ReplicatedFirst")
local RS = game:GetService("ReplicatedStorage")
local CP = game:GetService("ContentProvider")

RF:RemoveDefaultLoadingScreen()

local plrgui = plr:WaitForChild("PlayerGui")
--local menuMain = plrgui:WaitForChild("MainMenu")
local loadingScreen = script:WaitForChild("LoadingScreen"):Clone()
loadingScreen.Parent = plrgui
local frame = loadingScreen:WaitForChild("Frame")
local LoadingText = frame:WaitForChild("LoadingText")
local skip = loadingScreen:WaitForChild("Skip")

task.delay(15, function()
	skip.Visible = true
	skip.MouseButton1Click:Connect(function()
		loadingScreen:Destroy()
	end)
end)

local assets = game:GetChildren()

for i, asset in ipairs(assets) do
	LoadingText.Text = "Loading " .. asset.Name
	CP:PreloadAsync({asset})
end

LoadingText.Text = "Loading Complete"
task.wait(1.5)
loadingScreen:Destroy()