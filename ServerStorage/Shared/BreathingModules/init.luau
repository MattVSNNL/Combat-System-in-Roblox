local BreathingModules = {}

for _, race in ipairs(script:GetChildren()) do
	if race:IsA("ModuleScript") then
		BreathingModules[race.Name] = {}
		for _, module in ipairs(race:GetChildren()) do
			if module:IsA("ModuleScript") then
				BreathingModules[race.Name][module.Name] = require(module)
			end
		end
	end
end

return BreathingModules