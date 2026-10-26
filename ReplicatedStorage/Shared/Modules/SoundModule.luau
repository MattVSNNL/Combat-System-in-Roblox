local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local soundsFolder = SoundService.Sounds

local sounds = {}
sounds.__index = sounds

function sounds:Play(soundToPlay : Sound, parent, autoDestroy)
	if not soundToPlay then return end
	
	local sound: Sound
	if parent then
		sound = soundToPlay:Clone()
		sound.Parent = parent
	else
		sound = soundToPlay
	end
	sound:Play()
	
	if parent and autoDestroy == true then
		local duration = sound.TimeLength > 0 and sound.TimeLength or 5
		Debris:AddItem(sound, duration + 0.1)
	end
	
	return sound
end

function sounds:Stop(sound : Sound)
	if not sound then return end
	sound:Stop()
end

return sounds
