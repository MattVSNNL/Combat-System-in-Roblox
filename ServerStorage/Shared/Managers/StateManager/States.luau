function setAttribute(data, name, val)
	data:SetAttribute(name, val)
end

local states = {
	["Idle"] = function(data)
		setAttribute(data, "canDash", true)
		setAttribute(data, "canRun", true)
		setAttribute(data, "canBreath", true)
		--setAttribute(data, "Blocking", false)
		setAttribute(data, "Running", false)
		setAttribute(data, "CombatDisabled", false)
		setAttribute(data, "Stunned", false)
		setAttribute(data, "PureStun", false)
		setAttribute(data, "WalkSpeed", 16 * data.Speed.Value)
	end,
	["Attacking"] = function(data)
		setAttribute(data, "canDash", false)
		setAttribute(data, "canRun", false)
		setAttribute(data, "canBreath", false)
		setAttribute(data, "CombatDisabled", true)
		setAttribute(data, "Running", false)
		setAttribute(data, "Blocking", false)
	end,
	["Running"] = function(data)
		setAttribute(data, "Running", true)
		setAttribute(data, "canDash", true)
		setAttribute(data, "canRun", true)
		setAttribute(data, "WalkSpeed", data:GetAttribute("WalkSpeed") * 1.25)
	end,
	["Blocking"] = function(data)
		setAttribute(data, "Blocking", true)
		setAttribute(data, "canDash", false)
		setAttribute(data, "canRun", false)
		setAttribute(data, "canBreath", false)
		setAttribute(data, "CombatDisabled", false)
		setAttribute(data, "WalkSpeed", data:GetAttribute("WalkSpeed") * 0.5)
	end,
	["Stunned"] = function(data)
		setAttribute(data, "canDash", false)
		setAttribute(data, "canRun", false)
		setAttribute(data, "canBreath", false)
		setAttribute(data, "CombatDisabled", true)
		setAttribute(data, "Running", false)
		setAttribute(data, "Blocking", false)
		setAttribute(data, "Stunned", true)
		setAttribute(data, "PureStun", true)
		setAttribute(data, "WalkSpeed", 0)
	end,
	["Dashing"] = function(data)
		setAttribute(data, "canDash", false)
		setAttribute(data, "canRun", false)
		setAttribute(data, "canBreath", false)
		setAttribute(data, "CombatDisabled", false)
		setAttribute(data, "WalkSpeed", data:GetAttribute("WalkSpeed") * 0.25)
	end,
	["Parrying"] = function(data)
		setAttribute(data, "canDash", false)
		setAttribute(data, "canRun", false)
		setAttribute(data, "canBreath", false)
		setAttribute(data, "CombatDisabled", false)
		setAttribute(data, "WalkSpeed", data:GetAttribute("WalkSpeed") * 0.25)
	end,
}

return states
