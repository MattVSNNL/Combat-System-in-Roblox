local Networking = {}
Networking.Server = {}
Networking.Client = {}

local eventLocation = script

-------------------------------------------------
--// CLIENT METHODS
-------------------------------------------------

-- RemoteFunction Client → Server
function Networking.Client:Invoke(name, ...)
	local r = eventLocation:WaitForChild(name, 5)
	if r and r:IsA("RemoteFunction") then
		return r:InvokeServer(...)
	end
end

-- BindableFunction Local → Local
function Networking.Client:InvokeBindable(name, ...)
	local r = eventLocation:WaitForChild(name, 5)
	if r and r:IsA("BindableFunction") then
		return r:Invoke(...)
	end
end

-- RemoteEvent Client → Server
function Networking.Client:Fire(name, ...)
	local r = eventLocation:WaitForChild(name, 5)
	if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
		r:FireServer(...)
	end
end

-- RemoteEvent Server → Client
function Networking.Client:OnEvent(name, callback)
	local r = eventLocation:WaitForChild(name, 5)
	if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
		r.OnClientEvent:Connect(callback)
	end
end

-------------------------------------------------
--// SERVER METHODS
-------------------------------------------------

function Networking.Server:RegisterEvent(name, eventType, callback)
	eventType = eventType or "RemoteEvent"

	local constructors = {
		RemoteEvent = function() return Instance.new("RemoteEvent") end,
		RemoteFunction = function() return Instance.new("RemoteFunction") end,
		UnreliableRemoteEvent = function() return Instance.new("UnreliableRemoteEvent") end,
	}

	local create = constructors[eventType]
	if not create then
		warn("Unknown eventType "..eventType.." for "..name)
		return nil
	end

	local event = create()
	event.Name = name

	if eventType == "RemoteFunction" then
		event.OnServerInvoke = callback or function() end
	end

	event.Parent = eventLocation
	return Networking:GetEvent(name)
	
end

-- RemoteFunction Server → Client
function Networking.Server:InvokeClient(name, plr, ...)
	local r = eventLocation:WaitForChild(name, 5)
	if r and r:IsA("RemoteFunction") then
		return r:InvokeClient(plr, ...)
	end
end

-- RemoteEvent Server → Client
function Networking.Server:FireClient(name, plr, ...)
	local r = eventLocation:WaitForChild(name, 5)
	if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
		r:FireClient(plr, ...)
	end
end

-- RemoteEvent Server → All Clients
function Networking.Server:FireAllClients(name, ...)
	local r = eventLocation:WaitForChild(name, 5)
	if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
		r:FireAllClients(...)
	end
end

function Networking:GetEvent(name)
	local r = eventLocation:WaitForChild(name, 5)
	if not r then
		return
	end
	return r
end

return Networking
